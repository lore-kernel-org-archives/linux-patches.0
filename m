Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C1F1EA84;
	Wed,  4 Feb 2026 14:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216196; cv=none; b=bnQ8hyCgWG72s2mEnGfb3flYcZ4EMnrY11sKxqj5djRZxXjaiKSLmG3MBm3eEGRJlTi2Ge0Ta4rwFO2UXpmkQhadufmfZLQOqKQEc4orbF3MuHkwAHRSSI/Giv37YO/s1JaUWq04nmDM54Nk6xCTN7RGHg1V7AXzgqYctBN70tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216196; c=relaxed/simple;
	bh=m2ktMt47fVMyof6SBXrwkoWZ+Cu0+uhwjIWAlRYNlo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGiYrN+byAzjJDU18WaYFBh9xQuWMXSnQpKjeWg5X3wfxync7TwkVTLUsh7SooeASJPFbUXEKLxve0f1EOPyQ8cpYBObBNXt4yFmJXBB+tz8eny8kMShHD6XvouqL+utbesZTcaCYJRv8hFLr0mCAHtQkGgZZA7VZnCEykRqimI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKj5oLDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKj5oLDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CBFC4CEF7;
	Wed,  4 Feb 2026 14:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216195;
	bh=m2ktMt47fVMyof6SBXrwkoWZ+Cu0+uhwjIWAlRYNlo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKj5oLDS1O/O+4mpHH2+oII2MVb+2XybMztzPGvHFAbQJAEyY8ZWQHZT0NeVfAHD6
	 f/opaU5Q5ZinFdvQctHxBpSOgWqYuFzFKDmSleBv8AZGZoO87kJxXVB816TFVpcKFf
	 8QOxH1t2PyF1AEO5xlroNkVf54pXSsEojV5GTwiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/161] phy: stm32-usphyc: Fix off by one in probe()
Date: Wed,  4 Feb 2026 15:37:59 +0100
Message-ID: <20260204143852.349381259@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 03fc567e9f188..9b1b6e9d819ca 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -391,7 +391,7 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		}
 
 		ret = of_property_read_u32(child, "reg", &index);
-		if (ret || index > usbphyc->nphys) {
+		if (ret || index >= usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
 			if (!ret)
 				ret = -EINVAL;
-- 
2.51.0



