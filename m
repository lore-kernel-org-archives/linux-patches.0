Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054016;
	b=dvjH3cD6uStzWNVmAXDl7kf+jPULpHl8djstcgaUzWm/Awwl8Aa9H97tBVsBJ/4XT28M
	 oUSiQkytRK9hdeKMDH0kqySubPNc1ly/QkTKlDBuKvz56qbiw9bHmo9BHPu6DAtTDM9Ul
	 s3T4EYynMKxavzkwS2/aBVC6I7iQuGcH4geWlUOrS/YeXJQzb7KRPqOzszADtUJ5C74kl
	 5yvbSNadXpnlDt8bL3mghhvRFBZckGFdo0y8GJext5VXxxqt/ypdJL4mQotBi2H/x5e+t
	 rqyggTHlJ687qm4lOg7P0POh145t/pIxeYTyMbyp9ipcsc/vieXrzmB0UeleOKnSyjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YhpBQc6dNVPvrRc0NJLtd9kas4jcb/ui1FxN26KwEPM=;
	b=lR3ms9khpGIOx/6ExK+MXEati8rfaqACSvmpBFcorsjE213c+8K7K+O7cx4DLGh+7io/
	 lZrGrgRr4HAKWwEkdWDvT06FT3A5VHgb8g8lHpcaYLHVa7nrUMN/96OSsbomms9b4Gw75
	 79xnldtr8CV4Ct2m0+OgQjc/UdytVnTHFSzVvD2+fwo5j+XSdCj5rwE0W59TKbg6+SokD
	 8Bhi6mFEkZ4G/jGkJLLzv6p+FZikdxsxnni0Jn0uz5WqV62QXPh/lXOm4shM4G2274WCz
	 BwOpPI1Mya9/sr/aFoN7445CFPPa9GF29TAFdp+8z/Aj8WovrfFkYXm7emhYmDrEU1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wf+i2UGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F7B606A325;
	Thu, 19 Nov 2026 02:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wf+i2UGD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740CD1F000C9;
	Thu, 19 Nov 2026 02:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054016;
	bh=YhpBQc6dNVPvrRc0NJLtd9kas4jcb/ui1FxN26KwEPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wf+i2UGDNoiutcVfWOaCqG+hRi4OgPdoQxonvdWkWJEsmvzRuh4cc99SASs/jWUAw
	 xkRqJrcd2TpIbyLSd1D6Ut3KZzrMX3IC6gCcB7U9YEi7l7mbCzbniJtK3AcxFmi2oj
	 1sjjPr3cMOHPyepdYV11qVbWOk56igZtsccw8Irw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1126/2214] media: camss: vfe: Decrease priority of of VFE HW version to dbg
Date: Wed, 18 Nov 2026 15:46:42 +0100
Message-ID: <20261118150057.119991418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit 2fa698e3da84edc6b7a2d670f8bd5035891a744e ]

The HW Version can in no case represent an error, so change the print
priority to 'dbg'.

Signed-off-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: e5d4b0e69a40 ("media: qcom: camss: vfe: Fix VFE reset while another line is streaming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe-170.c | 2 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c | 2 +-
 drivers/media/platform/qcom/camss/camss-vfe-4-8.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index 44223c08b87af..9a1f2a6bf3fa7 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -184,7 +184,7 @@ static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
 	u32 rev = (hw_version >> 16) & 0xFFF;
 	u32 step = hw_version & 0xFFFF;
 
-	dev_err(dev, "VFE HW Version = %u.%u.%u\n", gen, rev, step);
+	dev_dbg(dev, "VFE HW Version = %u.%u.%u\n", gen, rev, step);
 }
 
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
index a596352177583..13f0fa6a7d60c 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
@@ -258,7 +258,7 @@ static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
-	dev_err(dev, "VFE HW Version = 0x%08x\n", hw_version);
+	dev_dbg(dev, "VFE HW Version = 0x%08x\n", hw_version);
 }
 
 static u16 vfe_get_ub_size(u8 vfe_id)
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-8.c b/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
index 998429dbb65cd..03f92a6737b0f 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
@@ -251,7 +251,7 @@ static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
-	dev_err(dev, "VFE HW Version = 0x%08x\n", hw_version);
+	dev_dbg(dev, "VFE HW Version = 0x%08x\n", hw_version);
 }
 
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
-- 
2.53.0



