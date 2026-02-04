Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96C42D879A;
	Wed,  4 Feb 2026 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217499; cv=none; b=Ye3zwVN+mmGnaQhkt32lUKAaNL8/+6q/Ef5vqiahSHL25a7+I0mKoZbhVspyeY/vqKyUGQsjxWSaQAt+Xl0vknpMppyLq5cEQ0VKYd8w8UijzDS8J/+zm2ht158FAjux63HSjERpbHNYzH73Vdxbe9oGClWvgF39LeVvZfOs9/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217499; c=relaxed/simple;
	bh=6O2jw+F0SBuQCZwC7DoXFc5AQaLPOdv44sn2bOudJvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKNG332y1s11b8XXXYD9UQSQONAEUPF8Z9PNNQWE9KkSePnR+Dj1XLYkyqGaFCXnbD0AYdoKKP/sP3bIKoxV7qJQz66dwfPkgTwl7hS3qUDWkd8KwfREfAW68Eb8m3CK01tRiZ55M3ttVUR3h7IcVCMxTHXoT2IiPJcsE5fvNVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNRJsV7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNRJsV7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F647C4CEF7;
	Wed,  4 Feb 2026 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217499;
	bh=6O2jw+F0SBuQCZwC7DoXFc5AQaLPOdv44sn2bOudJvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNRJsV7yoT+GFZVgsMT71Qd3ecqeHZAKZrZ2EV6SdwxEj5vtP0Wk9KGF9HCXJfvkw
	 DkZR7YKkJQhG/VZiGe7SP0TGnd3ojIQ5nIqy6VhoUI55eVkqCU/UVC5kwvimFfPvyT
	 uxQpN/bOWxsNr2W28dG70zRyHZ8jfjxKabM0MQ1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/280] phy: stm32-usphyc: Fix off by one in probe()
Date: Wed,  4 Feb 2026 15:36:47 +0100
Message-ID: <20260204143910.831019255@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cabd25b57216ddc132efbcc31f972baa03aad15a ]

The "index" variable is used as an index into the usbphyc->phys[] array
which has usbphyc->nphys elements.  So if it is equal to usbphyc->nphys
then it is one element out of bounds.  The "index" comes from the
device tree so it's data that we trust and it's unlikely to be wrong,
however it's obviously still worth fixing the bug.  Change the > to >=.

Fixes: 94c358da3a05 ("phy: stm32: add support for STM32 USB PHY Controller (USBPHYC)")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/aTfHcMJK1wFVnvEe@stanley.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/st/phy-stm32-usbphyc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 5bb9647b078f1..c2947159e8b41 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -708,7 +708,7 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		}
 
 		ret = of_property_read_u32(child, "reg", &index);
-		if (ret || index > usbphyc->nphys) {
+		if (ret || index >= usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
 			if (!ret)
 				ret = -EINVAL;
-- 
2.51.0



