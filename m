Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029704;
	b=5RRIXo417qpYSQmLwrysUSeWTWM1mWYt8frbRmpRIT0j8l+97sIZWKI1RCeUtFuShDPP
	 lOdnsct7wBqcr5KAIOSy/CpDGIenE6YAjg/59NUq0PzIbp3uaVNLLusds9ih7T2ZOM3bq
	 BRGUBZINATH5BBSS+vnoA3q7GkqmcBGaB+DoasnRaVcVFBIX+AJ4A3JBsqDIhLqsX8tCI
	 HeHs9efOXPxaRspQ12Hg8HhpTOXtPO8XN0AizU1KPMhhkourKzNNZEL0B9b2fZgfOKE+8
	 YoDGcwsrxb3ZAk9k0XUMDBoNzgCXes6VA7UblkYpw/Tnca+7EJYOK7oFUP7yUTdEZNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u6ktR9ye6NcGp8kKJp9vJT2QwV0oC6jdqiPIJMXbOko=;
	b=rTfQ4t26PpExQcqmH6s3N/Q7WgZzvkAG+HEzJjmlAOOLN7fJNiAjlLIxJfpUDnEbSCfb
	 PH1R+HDNk0TsdiHfxvkbqW4e712u6ycGalYiPsSUlnxYuTvXm6fProlKiGvgufyKFRbOQ
	 MdR+OtQwlTmcZcEgVwMjeq/5zKKWAFR6W9HpbhL+llqk73AGAfLGzEh9Fiuhbbsa2YiKC
	 jxs/LfmxgGKeowDr3DXvCq4X4XL1zFnWB3aRzsPYQIDkIproj+s/KGLQSl2zhDNOLs99n
	 5Xetg65ro3kN4jGgYN8aQ7KlQn2yaRR5bnl2eUm0ium7K1syWORoc01ur0HLV7aH4MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rNegnOcS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA20606A320;
	Wed, 18 Nov 2026 19:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rNegnOcS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647831F000C4;
	Wed, 18 Nov 2026 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029703;
	bh=u6ktR9ye6NcGp8kKJp9vJT2QwV0oC6jdqiPIJMXbOko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rNegnOcSiptkmJCgUnX/LzNmpqy1QC4+eS5ogEdrNSWO9L9wM93i6fwskVq+MGfq+
	 7wshyS+6qCIcoDICGbWcy/596fW/1kTJCkRtSLs8t6Z7XLwCxBYk9AlfnxVM3CpOXZ
	 Z6qkc3lX6oiK0L/KgOWrYMAzvVCJDnWOpsmzbJDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0444/1756] drm/amd: Add correct prefix for VBIOS message
Date: Wed, 18 Nov 2026 15:42:51 +0100
Message-ID: <20261118150026.404063149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit e6c7ebeaba4080562e71a59a788ac90b41e09240 ]

It's not obvious which GPU the ATOM BIOS message goes with. Use
drm_info() to show the correct one.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: aee05c455ad3 ("drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 286ba13f7e34c..cb7bce00ee283 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1462,7 +1462,7 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
 		ctx->vbios_pn[count] = 0;
 	}
 
-	pr_info("ATOM BIOS: %s\n", ctx->vbios_pn);
+	drm_info(ctx->card->dev, "ATOM BIOS: %s\n", ctx->vbios_pn);
 }
 
 static void atom_get_vbios_version(struct atom_context *ctx)
-- 
2.53.0



