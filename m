Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216788;
	b=0mH6pm/7gr3vc3m9DuBTH6K6IgKSNt+ALaEDvoPgGYD2wrZ0ZEbeAuDlJRMplWUph1ie
	 KxaqmAvtRlsplSisNqr2iCiI/WziKxPrshnA8EuxumvFA9rdH+0dDwqxyCa/yux6h4Qqm
	 ELnW4VQqIQzp7YxL76aDoS0aUd/QX26x3xND8Q5rnmbPmC5MKwSfKImzVZdUYYi+M0+Ab
	 /bhbG/kZgeHRk+dgXqf7eEUqtRAlMhhRdtjg7LaoAAi14l7U8JogIY3zifxZM8nBDc7xc
	 t9qiZ7gNjQPyu5/Brrjbtk4HE662VhHuupuZAn80t6xBfmdTz8Jjla2qHDiLEGnvqRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WJT+ceGqMuHrOXdjAj2uodi3nJvManGx3xAEIiQu+3w=;
	b=AgP4tidkQ+j8g9qrH/Zxo52b2YxHdL76bmMoaIl8VoYIQpfPVf67DjtveJYQqNcLnqmp
	 h5K3ULGpkc06w2l8dR/GDZJvXlSNIVcQinKPhB661SsEm8wwwYWTuX6Xg04BYYsPyKBzq
	 9CWQxgNhkf/1L/DdXowr4VlRrdFZRR8k4WLDgQHdS3fTr+/BH+n4iic3edE7yco+wHmX6
	 LW0MOFl4oU8FhUbTtBwOvwjOdYNFuaW1BbJFlNu93r48js0E/RkEOS0d/e3xJPlapBIAk
	 SiIEbcsNL+Xo7QUu2ccxT1IfuSdBKeRsTlYQaRUtXatPeYxftQzd8oL6kiyNNC7UjhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jsj2NL/4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BC8606A31A;
	Wed, 28 Oct 2026 19:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jsj2NL/4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81BB1F01825;
	Wed, 28 Oct 2026 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216788;
	bh=WJT+ceGqMuHrOXdjAj2uodi3nJvManGx3xAEIiQu+3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jsj2NL/4qLFg/dg7L4aMT0i+oFhlnCGDe9UZuubu91oRKdFHjdXhgn4/nFdbMP4xp
	 YSUfZD4D4+ISspreiIpeA2Curvp0n4Qb3ZGUlfy/tsAbNx4KnpsR7GOt4wGCp/ebG5
	 tTFpvW42rXACLjjXMlZu4jsPFOtAx+OqZqf+JM+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1678/1887] drm/amdgpu: Bound GPIO I2C table entry count from VBIOS
Date: Wed, 28 Oct 2026 18:02:54 +0100
Message-ID: <20261028170537.644440406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit a99cd231cd924b7160fecb9fb3a94b801522323b ]

Reject undersized tables and cap the derived entry count
to AMDGPU_MAX_I2C_BUS so we do not overrun adev->i2c_bus[]
or walk an absurd number of entries on corrupt size fields.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 21 ++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 6511ece584760..679473a48d996 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -43,6 +43,21 @@ static void amdgpu_atombios_lookup_i2c_gpio_quirks(struct amdgpu_device *adev,
 
 }
 
+/* VBIOS-reported table size is unchecked against the image; cap iterations and
+ * adev->i2c_bus[] indexing to AMDGPU_MAX_I2C_BUS.
+ */
+static int amdgpu_atombios_gpio_i2c_num_entries(uint16_t size)
+{
+	u32 bytes;
+
+	if (size < sizeof(ATOM_COMMON_TABLE_HEADER))
+		return 0;
+
+	bytes = size - sizeof(ATOM_COMMON_TABLE_HEADER);
+	return (int)min_t(u32, bytes / sizeof(ATOM_GPIO_I2C_ASSIGMENT),
+			  AMDGPU_MAX_I2C_BUS);
+}
+
 static struct amdgpu_i2c_bus_rec amdgpu_atombios_get_bus_rec_for_i2c_gpio(ATOM_GPIO_I2C_ASSIGMENT *gpio)
 {
 	struct amdgpu_i2c_bus_rec i2c;
@@ -103,8 +118,7 @@ struct amdgpu_i2c_bus_rec amdgpu_atombios_lookup_i2c_gpio(struct amdgpu_device *
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
@@ -137,8 +151,7 @@ void amdgpu_atombios_i2c_init(struct amdgpu_device *adev)
 	if (amdgpu_atom_parse_data_header(ctx, index, &size, NULL, NULL, &data_offset)) {
 		i2c_info = (struct _ATOM_GPIO_I2C_INFO *)(ctx->bios + data_offset);
 
-		num_indices = (size - sizeof(ATOM_COMMON_TABLE_HEADER)) /
-			sizeof(ATOM_GPIO_I2C_ASSIGMENT);
+		num_indices = amdgpu_atombios_gpio_i2c_num_entries(size);
 
 		gpio = &i2c_info->asGPIO_Info[0];
 		for (i = 0; i < num_indices; i++) {
-- 
2.53.0



