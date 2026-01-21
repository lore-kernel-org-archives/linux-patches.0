Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA1238B986;
	Wed, 21 Jan 2026 18:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019601; cv=none; b=sIG4WnbMzQsqsREF/Jl0EHLIZjMolr5DHwniC/B9oI5SluA0a0P7FbwP9/WgCygIWIK7YZk7bI+8kmdzChMQvfUqSqLJbrpIwiXUwZFmQ9qMIIYa+dEHtgHoTc9xxUVXbHj9WyCQwH2OCTPXMmaXSNrVYTaq6tShpMPhRAGLIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019601; c=relaxed/simple;
	bh=Ou7mtw9MKv2lzUfGPM2J5eb83EYih2ZH4Osnx9l1zuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kv1DnFwlqBYdS94TcWj1CnaUGp7vY4Z1YgTXQ5KN1WhFNHiTOxbkuGK47mjBPFKgS2q/ecEQp/mMfgtLwULMaVS/oZ7j/zuqHdQIEEcJ7kjNe1r9t5UYDLbiTLcEcx/SdwAuhJ4eOnZaG/rgDIw9sH3CbE60mQDRU8sIVUSUyY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j66eYJ3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j66eYJ3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8B9C19422;
	Wed, 21 Jan 2026 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019599;
	bh=Ou7mtw9MKv2lzUfGPM2J5eb83EYih2ZH4Osnx9l1zuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j66eYJ3rzR4By0fxfYN7w70vArigcuJlMH1Z19nxvpXyK3VIlKsFQnoBnfb0XBSKQ
	 u9kXKqTUFO5Q3koNwmu5yL3ja6Ui9QoskWS3IsIYPvayu0G0xsDl3aWUIQ0HbV07Eg
	 uxeViDFhtcI4rUuzUCuR7+Z2fQnLfsLMwR3IE8Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/139] phy: stm32-usphyc: Fix off by one in probe()
Date: Wed, 21 Jan 2026 19:14:59 +0100
Message-ID: <20260121181413.293377053@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dbf23ae38255a..797d45747406d 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -712,7 +712,7 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		}
 
 		ret = of_property_read_u32(child, "reg", &index);
-		if (ret || index > usbphyc->nphys) {
+		if (ret || index >= usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
 			if (!ret)
 				ret = -EINVAL;
-- 
2.51.0



