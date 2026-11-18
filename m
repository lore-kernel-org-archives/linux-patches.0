Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016275;
	b=TCe8rnu+qsKPnc/X0dQpc+ZIrWEDLdd1dPNiyU/6vWvVCTcd5YqRgW2Fwve4p4ZiRG7p
	 /hMkd/T4IvLHU0fy8oHnTGBMYqZp/ekt8SApxJJWed7lPz9nlHLh1Jt7+jLSrC9RtpWqP
	 MndO228sJaMGUG96Smx9XzLopLizlGtX/1FTYxWdolwBdqRiaHfrjFTf7FgZP4tIRcwGA
	 BL13xfwoQYB/ms09zA4duf9Zj0NQ7bbeOYZhjlQ1zVPsI2vCqQXAOZOC9nLRvDm1KoyGA
	 dPWa0ovdwIKo797kd3WMY3p85cj7TirhtXGlfbIhQA5EX0WGg1nsnNhqfe2X9UkvUew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7aQ/o7VvHPXyoubkl5G2CdJNf7QT3Fq07OTiLHpr/DQ=;
	b=jd9A+uAYt03IjwcB3RB/DiGElkO0tMON2opMOGKS4aWZhNpYXr7JcHr8Io2RDjrylVvn
	 b3Rt6TGsxUVjQj9YtIl9eAdaVivSrKC9p9V3FHILAffdpmWQVmwSsLMIFuB9oeIyb5TYi
	 57Bqr4v9yuk7fgJxy65jpFGEAlNVW2HSBmgGw44KDt9axB4z70NPXT/XmZ/8M5EWW8ChG
	 wCCBgFN7STkNvP3AsoXWsNWmIxm+ke6e4Qw3sDr62psGcxUah1H9EKi3D3stQnkX6qAcn
	 wicESGN4+xpatH4QXmKm8TnRcYiNlWlilpVHuPspYnSF4x0Qef2bIaQa1L9lQsY1GDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYUrwy44;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ED260A3819;
	Wed, 18 Nov 2026 15:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AYUrwy44
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0493D1F000CC;
	Wed, 18 Nov 2026 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016275;
	bh=7aQ/o7VvHPXyoubkl5G2CdJNf7QT3Fq07OTiLHpr/DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYUrwy44AD2YJIi0Q0vzXWPlKLvVPB/q/aK3+bGkUvx8U5nDm6VoGPzJqrKPE8043
	 7IQABImtZU9+Gf7wMl+swai7D6ulRjDQjWPB/bu+W5EdUF79M4/Dd/yrXFW/YcW/xm
	 JdgSjHl5dvDsdVc7pPoZHM/1gjjHOr8jIPjm81zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0430/2651] clk: mediatek: reset: Fix device registration kernel-doc
Date: Wed, 18 Nov 2026 15:27:50 +0100
Message-ID: <20261118150303.307813299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8d5fa37307ac1f0612cf17ac0ccabcc258cc1526 ]

The comment for mtk_register_reset_controller_with_dev() names the
older helper and documents np rather than dev. The new helper takes
a struct device and obtains its device node internally.

Use the actual function and parameter names and clarify that failures
return negative error codes.

Fixes: 761bc64003e3 ("clk: mediatek: reset: Add new register reset function with device")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/reset.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mediatek/reset.h b/drivers/clk/mediatek/reset.h
index 562ffd290a224..b09cdcab0c4ba 100644
--- a/drivers/clk/mediatek/reset.h
+++ b/drivers/clk/mediatek/reset.h
@@ -60,11 +60,11 @@ struct mtk_clk_rst_data {
 };
 
 /**
- * mtk_register_reset_controller - Register mediatek clock reset controller with device
- * @np: Pointer to device.
+ * mtk_register_reset_controller_with_dev - Register a MediaTek reset controller
+ * @dev: Device used to manage the reset controller resources.
  * @desc: Constant pointer to description of clock reset.
  *
- * Return: 0 on success and errorno otherwise.
+ * Return: 0 on success, negative errno otherwise.
  */
 int mtk_register_reset_controller_with_dev(struct device *dev,
 					   const struct mtk_clk_rst_desc *desc);
-- 
2.53.0



