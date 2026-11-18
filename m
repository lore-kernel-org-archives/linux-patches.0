Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029709;
	b=FRreb/2rEZA1HsUg350fZmYxsojetRGlLeAJohfT5i46cm/ZUYycezeVS+Af7atAqCqF
	 JO9FmvWQSQmk1zWTB8un1WAwK2sXtR+isRhjI3DS4g+RSGxrc+TMElDHPqlaBXXF1NzwE
	 hnALneo6jA78GJ1dWjVBBXGhXO9y8wCx833B9nd+TaYOmAUgmFS9XKnoi2bzkpfMkHa35
	 bcJ8jyqHoPeeBhpSZu8prmqBeKO+e6tdzwdR7qLwoh35EfFh4ihbyeH5QaexEEA3DM/CV
	 MeO87NnF4pijesX1xa2VJpwHOSkyMZBOVoKuf6/6r4iA2QWNt9g6hkiERAVBLEzsf6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BJspj+3iy934tRzg3/Yr3+k1j5N0EALfmg25rDV85X8=;
	b=cOEGSG/aGgvEXhtCSRobMJX5YzUuJgV8kvttgqvBmlXzdIRnsrToM4Xr+d8B1QYr3C6e
	 g9nBOmMsaymjc/FrI80a5P9EEh/K0zLPVWJQ8Pi07i/4EsStgnRlDNGt54ZORXPfnurGT
	 6eJJFY7KLDs94M8FHgedUq2Ygh+MsVSWqlXG9SY/pZRR5sf52L5ZHBPGXxbqIlLUsbGSn
	 BQBZg35/oIiM9sRVIhpelYv2N1ZgMXZTGIaZB9WG6vJEK1yEVrbocAj3FmTmpNNQxFq3a
	 MnAXtTEQ7+MIr2J1SqyEor7ZuNNfkHd4lBQ1X3iq2kpfLDi9PVigyY6Cwg/YvaejxLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="uj/wCrGk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E276606A31C;
	Wed, 18 Nov 2026 19:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uj/wCrGk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60771F000C4;
	Wed, 18 Nov 2026 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029709;
	bh=BJspj+3iy934tRzg3/Yr3+k1j5N0EALfmg25rDV85X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uj/wCrGkXdABVYj2k0kLjmwPxvzWP3/e9r2sbPC5mq2NpYJe06W3zF+E44FHHPdG2
	 zxJcjx0knEXmR6SoPGf6r1ipmLR9N3uvtdZBoE6smsT5EP0v9HcqCNzmov9QUwWgIh
	 FmMZoPF43VGX01/SKXuFCFK/UGZALSGvV1EQ6skQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0446/1756] drm/amdgpu: bounds check ATOM IIO table parsing
Date: Wed, 18 Nov 2026 15:42:53 +0100
Message-ID: <20261118150026.474984157@linuxfoundation.org>
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

[ Upstream commit be88697602238c3dcb47bbc2db1eef923f63e78b ]

atom_index_iio() parsed the IIO bytecode without bounds checks, allowing
out-of-bounds reads on a malformed VBIOS. Pass the BIOS size into
amdgpu_atom_parse() and bound the parse loops by it.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Assisted-by: Claude Code
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: aee05c455ad3 ("drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/atom.c            | 25 ++++++++++++++++----
 drivers/gpu/drm/amd/amdgpu/atom.h            |  3 ++-
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index ee843869246fe..433757b8552f2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1893,7 +1893,7 @@ int amdgpu_atombios_init(struct amdgpu_device *adev)
 	atom_card_info->pll_read = cail_pll_read;
 	atom_card_info->pll_write = cail_pll_write;
 
-	adev->mode_info.atom_context = amdgpu_atom_parse(atom_card_info, adev->bios);
+	adev->mode_info.atom_context = amdgpu_atom_parse(atom_card_info, adev->bios, adev->bios_size);
 	if (!adev->mode_info.atom_context) {
 		amdgpu_atombios_fini(adev);
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index d232074692ff3..6405d6e9f1f36 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1316,11 +1316,25 @@ static void atom_index_iio(struct atom_context *ctx, int base)
 	ctx->iio = kzalloc(2 * 256, GFP_KERNEL);
 	if (!ctx->iio)
 		return;
-	while (CU8(base) == ATOM_IIO_START) {
-		ctx->iio[CU8(base + 1)] = base + 2;
+	while (base + 1 < ctx->bios_size && CU8(base) == ATOM_IIO_START) {
+		uint8_t index = CU8(base + 1);
+		int start = base + 2;
 		base += 2;
-		while (CU8(base) != ATOM_IIO_END)
-			base += atom_iio_len[CU8(base)];
+		while (base < ctx->bios_size && CU8(base) != ATOM_IIO_END) {
+			uint8_t op = CU8(base);
+
+			/*
+			 * Unknown opcode: its length is unknown so the byte
+			 * stream cannot be resynced reliably.
+			 */
+			if (op >= ARRAY_SIZE(atom_iio_len))
+				return;
+			base += atom_iio_len[op];
+		}
+		if (base >= ctx->bios_size)
+			return;
+		/* Only index well-formed methods, others stay 0 */
+		ctx->iio[index] = start;
 		base += 3;
 	}
 }
@@ -1540,7 +1554,7 @@ static inline void atom_print_vbios_info(struct atom_context *ctx)
 		drm_info(ctx->card->dev, "ATOM BIOS: %s\n", vbios_info);
 }
 
-struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
+struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios, uint32_t bios_size)
 {
 	int base;
 	struct atom_context *ctx =
@@ -1554,6 +1568,7 @@ struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 
 	ctx->card = card;
 	ctx->bios = bios;
+	ctx->bios_size = bios_size;
 
 	if (CU16(0) != ATOM_BIOS_MAGIC) {
 		pr_info("Invalid BIOS magic\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.h b/drivers/gpu/drm/amd/amdgpu/atom.h
index 825ff28731f52..5a3f55147c7ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.h
+++ b/drivers/gpu/drm/amd/amdgpu/atom.h
@@ -133,6 +133,7 @@ struct atom_context {
 	struct card_info *card;
 	struct mutex mutex;
 	void *bios;
+	uint32_t bios_size;
 	uint32_t cmd_table, data_table;
 	uint16_t *iio;
 
@@ -157,7 +158,7 @@ struct atom_context {
 
 extern int amdgpu_atom_debug;
 
-struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios);
+struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios, uint32_t bios_size);
 int amdgpu_atom_execute_table(struct atom_context *ctx, int index, uint32_t *params, int params_size);
 int amdgpu_atom_asic_init(struct atom_context *ctx);
 void amdgpu_atom_destroy(struct atom_context *ctx);
-- 
2.53.0



