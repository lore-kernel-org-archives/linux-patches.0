Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016483;
	b=488+G3kj8iy9fjZ311U0i97ZfO1+qTJexg2a8Anklvc4mCvYMREK8dahoCjVFiEYS09O
	 9if0lMjVD+Cqh7QhFSxkNQbcsBnU9j0XbAOd+s27zPYS6PLHB0R3ctcJfvzwEqoinJ3K8
	 nwU5avkq1F0/z8ge2i1jXictx5SYNnck71YWPx2DfMUwJ9ZzExNGE+4+Evi/VTSjh/Pi+
	 xeQasngx8EcgB9a7KushkQ3FidJiSma3vY+UZHhFVLZIvaHTYxcQsPr/+PLl3iD05KJh8
	 o7ae0VztwYSvQDIUTJs2zp/tMZhfzPTKG46EpuCd7n7a6BNUNS+JZt5cdLt/TmDeqKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gnWJqfxE4JV3kVFtfeaY9WFi804nHcLQarmiterjVEY=;
	b=JBL6Qse3IoVwlpwQv9dV3KkVHlRXheNBs0s6uvehmbTn/hA7voNddCTxMJGD185+GcOx
	 kcH5VE80ZG9NurzYoLmSLkLFY4d3PDkEB8bLxEAD/EoWCPBR5Q/0++Ch3ZvhJUpjCpzds
	 qPRu4kTQcwMFmU++MoEE8npbeSTEA+HSuj2BP32qfpXENFF9qFYEZiuRnrULzXpM1AEG4
	 4xDFdfFrDQUfQPDKDsBZhZ88G7zCgS4ijXWDf2w9JT5PAeTbjdNQOO+GuN8Ez+Ngk5PkL
	 WBeDjmSY/Bfl/ZfF9FYQi3YKIPsH3Wc3c472hUIUg46+EkDpm2uz0Ryte/NxW8ceXQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14uxUNRT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3C0606A31C;
	Wed, 18 Nov 2026 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=14uxUNRT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD211F000C4;
	Wed, 18 Nov 2026 15:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016483;
	bh=gnWJqfxE4JV3kVFtfeaY9WFi804nHcLQarmiterjVEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14uxUNRT7bJoh76fX1vJbKZuff+HWGJbRSW1GM/eqb1ip7R55T4xWdiQTQHEH5Taw
	 2qAOGKH+P2xGnf2YCTGZvxQ94E3j9nUSm/eZy5Wim2CgcATXIOUj2yd8U8czW9eZt2
	 aw8mmzTGERuUUp+OhBo4ZlVqQxrhqVN27VWy5d28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0544/2651] drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters
Date: Wed, 18 Nov 2026 15:29:44 +0100
Message-ID: <20261118150307.334119372@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit aee05c455ad3e72df9a0591baf0b60da518800f3 ]

atom_get_vbios_date(), atom_get_vbios_pn(), atom_get_vbios_version()
and atom_get_vbios_build() all walk the BIOS image using offsets and
counts taken from the image itself, checked only against each other
and never against ctx->bios_size:

 - atom_get_vbios_date() reads 14 bytes at a fixed offset that
   check_atom_bios()'s minimum size (0x49) does not cover.
 - atom_get_vbios_pn() dereferences an image-supplied u16 string
   offset unchecked, then walks and copies from it with only a length
   cap, not an image cap.
 - atom_get_vbios_version() takes its search bounds from image u16s;
   atom_find_str_in_rom() already clamps the search itself, but the
   match is then advanced by a fixed 18 bytes and STRLEN_NORMAL bytes
   are copied from there with no check that this still lands inside
   the image.
 - atom_get_vbios_build() walks from an image-supplied config-string
   offset toward the ROM header; a config offset at or past the
   header makes the pointer difference negative, wrapping through the
   u16 'len' and passing strscpy() a bound far larger than the
   32-byte destination.

Bound each getter's reads, walks and copies to ctx->bios_size, falling
back to an empty string on a malformed image.

Fixes: 29b4c589b43d ("drm/amdgpu: Add vbios info ioctl interface")
Fixes: d6fa80266178 ("drm/amdgpu: Add vbios build number interface")
Assisted-by: gkh_clanker_t1000
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/atom.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index e0e585f280e21..1a599d5cf6a5c 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1420,6 +1420,11 @@ static void atom_get_vbios_date(struct atom_context *ctx)
 
 	p_rom = ctx->bios;
 
+	if (ctx->bios_size < OFFSET_TO_VBIOS_DATE + 14) {
+		ctx->date[0] = '\0';
+		return;
+	}
+
 	date_in_rom = p_rom + OFFSET_TO_VBIOS_DATE;
 
 	ctx->date[0] = '2';
@@ -1483,10 +1488,15 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
 		vbios_str = p_rom + OFFSET_TO_VBIOS_PART_NUMBER;
 	}
 
-	if (*vbios_str == 0) {
+	if (vbios_str >= p_rom + ctx->bios_size)
+		vbios_str = NULL;
+
+	if (vbios_str == NULL || *vbios_str == 0) {
 		vbios_str = atom_find_str_in_rom(ctx, BIOS_ATOM_PREFIX, 3, 1024, 64);
 		if (vbios_str == NULL)
 			vbios_str += sizeof(BIOS_ATOM_PREFIX) - 1;
+		if (vbios_str >= p_rom + ctx->bios_size)
+			vbios_str = NULL;
 	}
 	OPTIMIZER_HIDE_VAR(vbios_str);
 	if (vbios_str != NULL && *vbios_str == 0)
@@ -1494,7 +1504,9 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
 
 	if (vbios_str != NULL) {
 		count = 0;
-		while ((count < BIOS_STRING_LENGTH) && vbios_str[count] >= ' ' &&
+		while ((count < BIOS_STRING_LENGTH) &&
+		       vbios_str + count < p_rom + ctx->bios_size &&
+		       vbios_str[count] >= ' ' &&
 		       vbios_str[count] <= 'z') {
 			ctx->vbios_pn[count] = vbios_str[count];
 			count++;
@@ -1527,9 +1539,10 @@ static void atom_get_vbios_version(struct atom_context *ctx)
 	/* find anchor ATOMBIOSBK-AMD */
 	vbios_ver =
 		atom_find_str_in_rom(ctx, BIOS_VERSION_PREFIX, start, end, 64);
-	if (vbios_ver != NULL) {
-		/* skip ATOMBIOSBK-AMD VER */
-		vbios_ver += 18;
+	if (vbios_ver != NULL)
+		vbios_ver += 18; /* skip ATOMBIOSBK-AMD VER */
+
+	if (vbios_ver != NULL && vbios_ver + STRLEN_NORMAL <= p_rom + ctx->bios_size) {
 		memcpy(ctx->vbios_ver_str, vbios_ver, STRLEN_NORMAL);
 	} else {
 		ctx->vbios_ver_str[0] = '\0';
@@ -1545,7 +1558,13 @@ static void atom_get_vbios_build(struct atom_context *ctx)
 	base = CU16(ATOM_ROM_TABLE_PTR);
 	atom_rom_hdr = CSTR(base);
 
+	if ((uint32_t)base + ATOM_ROM_CFG_PTR + sizeof(uint16_t) > ctx->bios_size)
+		return;
+
 	str = CSTR(CU16(base + ATOM_ROM_CFG_PTR));
+	if (str >= atom_rom_hdr)
+		return;
+
 	/* Skip config string */
 	while (str < atom_rom_hdr && *str++)
 		;
-- 
2.53.0



