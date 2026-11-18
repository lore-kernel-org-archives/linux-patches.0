Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029706;
	b=sUndMVSiy5gxNjx6EJ6KmKaDwDPCvMdA8hqfcLuV6TztqNRB/ZZb8tYD1zxtiZPd+XV+
	 HCUooF9PsXI+nCzDyVZVc2Qzzsr1mwSIK0OKRrMoxWU7G7lKVchAdROT3jakVKFfoQFN4
	 4OgpvFnsz47c/4Io9boa0X52YJfInl0OetIa5kc9Nkcb49i13zYH7DL8+N66H/FU6bCGB
	 iWFFdi1ytujpduOZB13TNyygYtqmcPiKjvuNncngeI1KE60992JLk3nqBGP6Iion56Q3L
	 ePMttwPbhrhsqAEpZTsf2/jzXG+z6713Z0mbKArP8cGc+xRNv8y/YGOZwewHXydm16g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+CQ/IgZ+R8oWVRuEAK+zTePMrkzY+28ToSpTXly6Iwg=;
	b=xHXa8tMHguZrbOGweO58xpMijR5qV2wptNudVRVEu0SKHxwNyOV5mychRJNc/0/A+oxw
	 qK5Y9AFSQ7aKIBelvq4gxqhg9fx9YvYgCm2wGiPRxmiVk9rRgGeCBsyOmsJfEtwIGSkLK
	 8Bd9e7Js1zLtclpsUGkEIEjzMtm6s1mae7O0Rddg+UyrhzWi5ufw6T06TCPjVmMV4KQRo
	 70Q0K/CWtqvxzlTN0D1yX6Uupknr5mfr139USTLanHFJmcNertAn9fJworP5Nnvqjo3P2
	 AnzUw5hnHnv6+30EDwDG3Z0ziIGUez8ZNnAv3I6BqrFNK59MqwLW83nDOTP8ena6S8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQQC28rE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6423606A31C;
	Wed, 18 Nov 2026 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pQQC28rE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227791F000C4;
	Wed, 18 Nov 2026 19:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029706;
	bh=+CQ/IgZ+R8oWVRuEAK+zTePMrkzY+28ToSpTXly6Iwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQQC28rE/WNr/G0+n6/jTyhVHyYA+2OtKjd1VwwiGRUZYQNbixc3uc5K87nUKt7Rm
	 J4g4h+hqP+vSllKsAoXDaqB0iNbOSS06OuOdWGAUW+n/w0bQrYmVOOeFDpo6IaSWAH
	 8NaKpTE+AvBLnJVwzbokP+M+jmVlvz++FnJVoqe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0445/1756] drm/amdgpu: Print full vbios info
Date: Wed, 18 Nov 2026 15:42:52 +0100
Message-ID: <20261118150026.437946102@linuxfoundation.org>
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
index cb7bce00ee283..d232074692ff3 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1461,8 +1461,6 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
 
 		ctx->vbios_pn[count] = 0;
 	}
-
-	drm_info(ctx->card->dev, "ATOM BIOS: %s\n", ctx->vbios_pn);
 }
 
 static void atom_get_vbios_version(struct atom_context *ctx)
@@ -1518,6 +1516,30 @@ static void atom_get_vbios_build(struct atom_context *ctx)
 		strscpy(ctx->build_num, str, STRLEN_NORMAL);
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
@@ -1580,6 +1602,8 @@ struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 	atom_get_vbios_version(ctx);
 	atom_get_vbios_build(ctx);
 
+	atom_print_vbios_info(ctx);
+
 	return ctx;
 }
 
-- 
2.53.0



