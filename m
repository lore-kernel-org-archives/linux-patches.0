Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023796;
	b=K2qL92qU+Ul470vOPZNS2QJj0sMJwMLuQYSgYwA4h3Vw76NgqqCzQmlM+8m0rHNVn+S/
	 4FIowziRt9bEK4HXEgLYEu8qFv5INLOuhvNQeiCxwuTb7IX5oidtH4YQdMSMYajgZnRkk
	 Y4asPDNozUoDp22zfz9gqzIcxOpb+3gO3g0xiOfcqIf2LjEN2wka3jmK1RCgpZyiD8NP0
	 e7vh3npTRNDunya6PRTZs7nQhwpqUsSfYd0NfrBD3qhQSJZiKiMXMa7KGYBRjyw7q31la
	 iNguPsS0cw9uPmZqhPqJhmL+30f3rF2jvvuuuKaa01wER3e66m6cwc4b/YGnryB5WWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YnrwUL18jY+EjY2CQjoGXVunzj01rF7IAzckVc2k0z0=;
	b=22VR6JmY7NApIXuZzoAZdcOwvy/KARAboFC3oc9Tf/+Y8Wz0tMWV3Hp//bWlwiXYKm1/
	 kfV4KCSWN6lHsip6n6Vfh3AnAKR0UqQNZPuxgAc+r52SXBQIutOzmB5YZf1FSo4yRnK17
	 p0K7tB1P2ofYoYs5Y8fQQuQKCfGXMyUzxqLMc3baLFDcsnjLQMMSlwNRBdIi7gnm3/nLP
	 ugI5BD1RjrLH7ntKJTnTsWtodm2qxC245hmukO9YbXynDteL4bP+n5jkdWcnbLOzKcRnd
	 TRSXVZXdvwq8HxZOktMuFeK6YacTYGeQ0jWW3yERJMxLOUrDJhhZaW8NVA75044SLqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hf6FgQTA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FFC606A32A;
	Wed, 18 Nov 2026 17:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hf6FgQTA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F79C1F000C4;
	Wed, 18 Nov 2026 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023796;
	bh=YnrwUL18jY+EjY2CQjoGXVunzj01rF7IAzckVc2k0z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hf6FgQTAC/HqOQUh27eRkVfJRUyfoO8YkyLPoGGrKXdejXZqOZZL0H7KZqCFeSzbL
	 pL3+vyKn8uPmA4L4zy8X8LJA5wObrMZ9AjY1+zXGGiUzCaGxLF9PvNvcMid+etRcwm
	 L3H2lcr0FWhY5lDBKUrQQM4DtxvYKL2FIbgAeOeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0497/2151] drm/amdgpu: bounds check ATOM IIO table parsing
Date: Wed, 18 Nov 2026 15:37:12 +0100
Message-ID: <20261118150140.160279590@linuxfoundation.org>
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
index b8f7e3a18d324..8d79d98f35391 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1923,7 +1923,7 @@ int amdgpu_atombios_init(struct amdgpu_device *adev)
 	atom_card_info->pll_read = cail_pll_read;
 	atom_card_info->pll_write = cail_pll_write;
 
-	adev->mode_info.atom_context = amdgpu_atom_parse(atom_card_info, adev->bios);
+	adev->mode_info.atom_context = amdgpu_atom_parse(atom_card_info, adev->bios, adev->bios_size);
 	if (!adev->mode_info.atom_context) {
 		amdgpu_atombios_fini(adev);
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index a40ce7555f287..0d5be17959721 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1327,11 +1327,25 @@ static void atom_index_iio(struct atom_context *ctx, int base)
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
@@ -1553,7 +1567,7 @@ static inline void atom_print_vbios_info(struct atom_context *ctx)
 		drm_info(ctx->card->dev, "ATOM BIOS: %s\n", vbios_info);
 }
 
-struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
+struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios, uint32_t bios_size)
 {
 	int base;
 	struct atom_context *ctx =
@@ -1567,6 +1581,7 @@ struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 
 	ctx->card = card;
 	ctx->bios = bios;
+	ctx->bios_size = bios_size;
 
 	if (CU16(0) != ATOM_BIOS_MAGIC) {
 		pr_info("Invalid BIOS magic\n");
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.h b/drivers/gpu/drm/amd/amdgpu/atom.h
index bb3d9eb7eb6b5..4687c019cbe30 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.h
+++ b/drivers/gpu/drm/amd/amdgpu/atom.h
@@ -133,6 +133,7 @@ struct atom_context {
 	struct card_info *card;
 	struct mutex mutex;
 	void *bios;
+	uint32_t bios_size;
 	uint32_t cmd_table, data_table;
 	uint16_t *iio;
 
@@ -160,7 +161,7 @@ struct atom_context {
 
 extern int amdgpu_atom_debug;
 
-struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios);
+struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios, uint32_t bios_size);
 int amdgpu_atom_execute_table(struct atom_context *ctx, int index, uint32_t *params, int params_size);
 int amdgpu_atom_asic_init(struct atom_context *ctx);
 void amdgpu_atom_destroy(struct atom_context *ctx);
-- 
2.53.0



