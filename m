Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28186251795;
	Wed, 25 Feb 2026 01:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983105; cv=none; b=JX7aaS1+2XBANuh+e2XGDJUcVtQlgFSVKZ9smD9+jUh9N5B3VtNfZYInkueeO4BPlHRAb9CvwDbe5Jp+r8fCPCgQN7cfm2LJhG6bWfuYySP9P/zmxy7gAUTetuwx+k00vh1yl01sjtq254+gaEZUPpXPSt3b0kel4yyLH2D4yNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983105; c=relaxed/simple;
	bh=vthRJy+FZ9jkZxsLB97AGJJt2EgXlkzchoHUHTP5wm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNXfzOOrZakoHNZeo1bRH5zXXKNM4criHdBiC5GFBfwSgzzgsYZY58oci9GwwL20IE3vAJ5m2nl/WzxFHsOHHEa60QtHAKJgC4uyiAxuQ5cgZddRr4rOD6UYPw/5CSFuvOSfULyKv6VShOrbT83EgJWIo0nwdW8BNcCqJxlorN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYX9Ia99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYX9Ia99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9D7C116D0;
	Wed, 25 Feb 2026 01:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983104;
	bh=vthRJy+FZ9jkZxsLB97AGJJt2EgXlkzchoHUHTP5wm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYX9Ia99HR7VwzfLKELjb2Vv2fTSrKnNxxIVQTvupcBJp5ThxfRssBcv8t4tJqq8j
	 DnPqc7Zk4A9E+0hwjYx9aXmd5bA6MwjjQxtrdCAX4ytaxvCbdzikfchN1oc4SOXAP8
	 lEdFwCYHpLALoT05ffWp8KNR6oJhP471cpD1Kmhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 266/781] drm/msm: Fix x2-85 TPL1_DBG_ECO_CNTL1
Date: Tue, 24 Feb 2026 17:16:15 -0800
Message-ID: <20260225012406.222009560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 56cd8adff8cbe82a13a1db998f1353d68ed84305 ]

We actually need to set b26, just claiming to do so is not enough :-)

Fixes: 01ff3bf27215 ("drm/msm/a8xx: Add support for Adreno X2-85 GPU")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/697778/
Message-ID: <20260109153730.130462-2-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
index 4c042133261c9..550a53a7865eb 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1689,7 +1689,7 @@ static const struct adreno_reglist_pipe x285_nonctxt_regs[] = {
 	{ REG_A7XX_SP_READ_SEL, 0x0001ff00, BIT(PIPE_NONE) },
 	{ REG_A6XX_TPL1_DBG_ECO_CNTL, 0x10000000, BIT(PIPE_NONE) },
 	/* BIT(26): Disable final clamp for bicubic filtering */
-	{ REG_A6XX_TPL1_DBG_ECO_CNTL1, 0x00000720, BIT(PIPE_NONE) },
+	{ REG_A6XX_TPL1_DBG_ECO_CNTL1, 0x04000720, BIT(PIPE_NONE) },
 	{ REG_A6XX_UCHE_MODE_CNTL, 0x80080000, BIT(PIPE_NONE) },
 	{ REG_A8XX_UCHE_CCHE_MODE_CNTL, 0x00001000, BIT(PIPE_NONE) },
 	{ REG_A8XX_UCHE_CCHE_CACHE_WAYS, 0x00000800, BIT(PIPE_NONE) },
-- 
2.51.0



