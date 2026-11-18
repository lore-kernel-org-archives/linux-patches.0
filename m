Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023793;
	b=ntr1wuT+qlAKXPc1aB3rqigkebGcSIp4w511UoHwt2uAapxgdN7I9xJ9CTQYPun6AYTb
	 mltea8KLBdl/Y66wqHnK/vziYUnU++AgBEhz/nDzteMdhi5ZjL2yASdNgLV5Py3dHG6rp
	 xA8HZrjV8JnSYA1LSBZKOZ9+PB0A77KedZ4c5KhiqVHQgW0K7VBwK6K2mb3uh8kPWo9Th
	 FIIctcQoctHN22xU9ojw3zaM1EgBFnJDB7fqDHhXafqp4gfkZXtUNDj4IOogRN/Azlika
	 sJ2mLy3+BEasvfx8szRiTghjR6t8kkqJb3fualamti84X9tFJ1c5dSBIEexz7iCK6Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvGqyz76cBiSD2aR/AdZUW4hpvfCj70R9J+CCKbbOgk=;
	b=k0hNmwglZ1yufjUbBU/cZG52MiwKTGn39end7OlnRv5unXippW0sURx6m9tyew8rTsSE
	 JUbpCAaxwUYC4s6XS/DR+8IY8mJn1GSmRDmYxxcHcUQcC5fBS6+z6sZ4oYC0gLk03D4EF
	 zUjI5Lqpp5ypqcvBvjc6Zuxb9oNQ7G5dDR4B1WFL3xOhCVbysGFkj0mMoQRpp8GeSakMK
	 sF/LUj4LNfyaT4IWOrEEetzn1gPR3IAuSZirEfwfeUVTziXSexaPBCNkotEoOlxNCE4o2
	 xGUtIoaw5GKTa4RfwOH2RjIs6GEjWcXE8zL+FcS4i9njuC/BnwVmmgPfo6rKqXx9Tbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ip9APUqy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FDF606A31C;
	Wed, 18 Nov 2026 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ip9APUqy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CF91F000C4;
	Wed, 18 Nov 2026 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023793;
	bh=PvGqyz76cBiSD2aR/AdZUW4hpvfCj70R9J+CCKbbOgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ip9APUqy396cftZOMw284Rviq2CGKGY/34qTRudqTX6EA4NwQPV67eU6tjL2FNmJH
	 RNxvWVm2jliYPGu6oktkE4MswQDX7z31u29bGb1mDZmdqSnNXS6LE7WWNTi8xSXlXE
	 mmv+nOF1ALpqARiXHGpRNCU6OGc13tCvIj/MyUtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0496/2151] drm/amdgpu: Print full vbios info
Date: Wed, 18 Nov 2026 15:37:11 +0100
Message-ID: <20261118150140.122771781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 4fd7b724a87a4051401ee2ed64c26c9249582040 ]

Add build number, version and date to the existing part number print.

Example:

[drm] ATOM BIOS: 113-PN000108-103, build: 00159017, ver: 022.040.003.043.000001, 2025/07/27

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: aee05c455ad3 ("drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 92ba327f476d6..a40ce7555f287 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1473,8 +1473,6 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
 
 		ctx->vbios_pn[count] = 0;
 	}
-
-	drm_info(ctx->card->dev, "ATOM BIOS: %s\n", ctx->vbios_pn);
 }
 
 static void atom_get_vbios_version(struct atom_context *ctx)
@@ -1531,6 +1529,30 @@ static void atom_get_vbios_build(struct atom_context *ctx)
 		strscpy(ctx->build_num, str, len);
 }
 
+static inline void atom_print_vbios_info(struct atom_context *ctx)
+{
+	char vbios_info[256];
+	int off = 0;
+
+	if (ctx->vbios_pn[0])
+		off += scnprintf(vbios_info + off, sizeof(vbios_info) - off,
+				 "%s", ctx->vbios_pn);
+	if (ctx->build_num[0])
+		off += scnprintf(vbios_info + off, sizeof(vbios_info) - off,
+				 "%sbuild: %s", off ? ", " : "",
+				 ctx->build_num);
+	if (ctx->vbios_ver_str[0])
+		off += scnprintf(vbios_info + off, sizeof(vbios_info) - off,
+				 "%sver: %s", off ? ", " : "",
+				 ctx->vbios_ver_str);
+	if (ctx->date[0])
+		off += scnprintf(vbios_info + off, sizeof(vbios_info) - off,
+				 "%s%.10s", off ? ", " : "",
+				 ctx->date);
+	if (off)
+		drm_info(ctx->card->dev, "ATOM BIOS: %s\n", vbios_info);
+}
+
 struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 {
 	int base;
@@ -1593,6 +1615,8 @@ struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 	atom_get_vbios_version(ctx);
 	atom_get_vbios_build(ctx);
 
+	atom_print_vbios_info(ctx);
+
 	return ctx;
 }
 
-- 
2.53.0



