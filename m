Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023799;
	b=mk3tOWA0dmHYRxNwBo9xugHjLgikprHcPFCyDX7UblEr4ZPU+wQo1X5K0tPd9fhDnllg
	 A5++SOtlzvXQtOSBJ95XMRfn/GIRSN9gv7zwjacESbeIApOb/j654nwcLBn7NnNNCzdyL
	 y/Cir89d3cgBrAS/3gYJCM8JJnvjfGDQ2OPNoypzka4btfZejc6PwXJCySespmODyN/Jk
	 CytA479B7naHNBIm436+PzzDNoR1+n6Nxc+J7XLEO3cpUFQ0DEDhPZiSCToxMLSBxCVyG
	 Y2bQ2ff05eU1/u6H7I3yTeYNKJHu9aq/FPHEJwemJ+PwqQIMpsVIhTT+EVEbQoJKCbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BhTxWAFoIaIbI4/BxeWAWU4DmXy+TDR4c4RbE3QgAVk=;
	b=mhYOggP5UphnDEPyYW8tW9/V+d87Tgc29LQ0JPDomZTVhpFcAQBlHEgxMLNt4HETuH/3
	 npOBzZPRBTNDcSTf21wTCRdZ9BJlz/fyb9YLVGimC4lWGDtlhbbAMAukzsIwRB/GgHKQo
	 4/WDizS3FOfoQbgexNnsAfkIl8xAh4iXRg+aXu1NvfEsxcnCT4ujlup8i3cME1OBdYFfY
	 Bvv0wYHhxq5xbEdkF5hyH6vOQpQkOZ8LEjD9VZVVKplQqCEroE04tN3bukHWlw9OfrN53
	 Zn7xliHTFMkJBGgVgVMOK8bDgPTTPtHDvljJKJk3wgVLz4/1YJodP/SMQm4DpdBS7zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAAhRvRM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05890606A31C;
	Wed, 18 Nov 2026 17:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bAAhRvRM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5BC1F000C4;
	Wed, 18 Nov 2026 17:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023798;
	bh=BhTxWAFoIaIbI4/BxeWAWU4DmXy+TDR4c4RbE3QgAVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bAAhRvRMDuUyeec2h/Qh5l30r1KHcY8EWn8UEInYrfgbEJtgSm1cRUhICUI4NvtBU
	 iG0IYseAfi1ftEcvHqws9kRyDoh6JmBLpKP2iuigUtDAKOFZ1qtAw8UO94Z3FpcIlf
	 V8vHxYT7IEhWiq6ss6KUwak4bta2WnIpxb0Jw3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Mishal <harimishal1@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0498/2151] drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters
Date: Wed, 18 Nov 2026 15:37:13 +0100
Message-ID: <20261118150140.193821751@linuxfoundation.org>
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
index 0d5be17959721..a4ebb817f3cbf 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1405,6 +1405,11 @@ static void atom_get_vbios_date(struct atom_context *ctx)
 
 	p_rom = ctx->bios;
 
+	if (ctx->bios_size < OFFSET_TO_VBIOS_DATE + 14) {
+		ctx->date[0] = '\0';
+		return;
+	}
+
 	date_in_rom = p_rom + OFFSET_TO_VBIOS_DATE;
 
 	ctx->date[0] = '2';
@@ -1468,10 +1473,15 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
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
@@ -1479,7 +1489,9 @@ static void atom_get_vbios_pn(struct atom_context *ctx)
 
 	if (vbios_str != NULL) {
 		count = 0;
-		while ((count < BIOS_STRING_LENGTH) && vbios_str[count] >= ' ' &&
+		while ((count < BIOS_STRING_LENGTH) &&
+		       vbios_str + count < p_rom + ctx->bios_size &&
+		       vbios_str[count] >= ' ' &&
 		       vbios_str[count] <= 'z') {
 			ctx->vbios_pn[count] = vbios_str[count];
 			count++;
@@ -1512,9 +1524,10 @@ static void atom_get_vbios_version(struct atom_context *ctx)
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
@@ -1530,7 +1543,13 @@ static void atom_get_vbios_build(struct atom_context *ctx)
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



