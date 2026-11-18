Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029701;
	b=ZaxHwp1fXwMtCkwSBN3sukIzzlZM4Po8TR8Xwfu14+yjnhRl+fsmMowJ5Qdx3oK9NqI6
	 iKt2PUFUvmopZseKvLgjqBk+63G5+KI8D67KsHQppC48OpwE/H8QjxEi0Jnv4U+SSNFjB
	 UFYbnLIfwUMKBtzliOvzELLjw2bLg3AJwaBp9zmP2x9JOHqTp2cv8OfojBYc90dWRQlnp
	 WoOZpaXGeCw4+rbgdvmI8t73ubXnuerlzA+Bda9pgJvD29wLwavN1yGKbFBILZeL9U4pY
	 JyYAJ01CpiU2al3xE9NGVjb9KnazzoQ95RTM97jTz6toQKm9Etz0RUJlq5D0ZqwT67g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029701;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lWBQffbTpYuNCKMNkNWbNbKiWHyp7DkK+61O9l/w7RM=;
	b=Ym/D4Hq1cPSd5y6Y/CvH2/9O/BLhcWAyB4etGaRiIyU8cJeG56GgDnwQPY3cc4InXFHB
	 nJy60bv1tK1Q7jkbjZ5WOSYfOahIuO7QGfzALYkNXwzaNHSxVy+5LLuKn0FT5912Bju1W
	 un3NeY8VcEChUjHbrKt1ql/NwRaTQIHFNEZn9bBn5ajOFswULhCDZUYWInWXrUtDY5iWo
	 MBl+LWaKI8YeOHyrzPyn1gy+gBko6349+YgczRdrFOwxCbaGaotrqaX4fWfYVVe6SWiOU
	 MMZlLyoR8gNwFo6YHQiqGDWY042SlxkaaeREM79vAr+HJ9YomMPV3vN1OwL6EYvjlug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzTlQNTG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A665606A320;
	Wed, 18 Nov 2026 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzTlQNTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55171F000C4;
	Wed, 18 Nov 2026 19:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029701;
	bh=lWBQffbTpYuNCKMNkNWbNbKiWHyp7DkK+61O9l/w7RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzTlQNTGgh+KFGNchxThW03M0RkbOrJL8g4yJ0tOVgKazJc2nlXyObp4povn47EAt
	 F0Uor4ffKV/8JByhxoudYRfzdrdeFonpFExYoSuUEMRrsvf+Jzl0DM169f79m3QV+i
	 UQIAdAWe/RLhualvyuMVEwbWMQKjiTwX3CABFYt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0443/1756] drm/amdgpu: Add vbios build number interface
Date: Wed, 18 Nov 2026 15:42:50 +0100
Message-ID: <20261118150026.365296462@linuxfoundation.org>
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

[ Upstream commit d6fa8026617896c23cb165f09f1c1d32fe22a3df ]

Fetch VBIOS build number from atom rom image. Add a sysfs interface to
read the build number.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: aee05c455ad3 ("drm/amdgpu/atom: bound the VBIOS date, part number, version and build getters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c | 33 ++++++++++++++++++--
 drivers/gpu/drm/amd/amdgpu/atom.c            | 22 +++++++++++++
 drivers/gpu/drm/amd/amdgpu/atom.h            |  2 ++
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
index 9254b85d4e70d..ee843869246fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atombios.c
@@ -1797,16 +1797,43 @@ static ssize_t amdgpu_atombios_get_vbios_version(struct device *dev,
 	return sysfs_emit(buf, "%s\n", ctx->vbios_pn);
 }
 
+static ssize_t amdgpu_atombios_get_vbios_build(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct drm_device *ddev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(ddev);
+	struct atom_context *ctx = adev->mode_info.atom_context;
+
+	return sysfs_emit(buf, "%s\n", ctx->build_num);
+}
+
 static DEVICE_ATTR(vbios_version, 0444, amdgpu_atombios_get_vbios_version,
 		   NULL);
+static DEVICE_ATTR(vbios_build, 0444, amdgpu_atombios_get_vbios_build, NULL);
 
 static struct attribute *amdgpu_vbios_version_attrs[] = {
-	&dev_attr_vbios_version.attr,
-	NULL
+	&dev_attr_vbios_version.attr, &dev_attr_vbios_build.attr, NULL
 };
 
+static umode_t amdgpu_vbios_version_attrs_is_visible(struct kobject *kobj,
+						     struct attribute *attr,
+						     int index)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	struct drm_device *ddev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(ddev);
+	struct atom_context *ctx = adev->mode_info.atom_context;
+
+	if (attr == &dev_attr_vbios_build.attr && !strlen(ctx->build_num))
+		return 0;
+
+	return attr->mode;
+}
+
 const struct attribute_group amdgpu_vbios_version_attr_group = {
-	.attrs = amdgpu_vbios_version_attrs
+	.attrs = amdgpu_vbios_version_attrs,
+	.is_visible = amdgpu_vbios_version_attrs_is_visible,
 };
 
 int amdgpu_atombios_sysfs_init(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index bed3083f317b8..286ba13f7e34c 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1497,6 +1497,27 @@ static void atom_get_vbios_version(struct atom_context *ctx)
 	}
 }
 
+static void atom_get_vbios_build(struct atom_context *ctx)
+{
+	unsigned char *atom_rom_hdr;
+	unsigned char *str;
+	uint16_t base;
+
+	base = CU16(ATOM_ROM_TABLE_PTR);
+	atom_rom_hdr = CSTR(base);
+
+	str = CSTR(CU16(base + ATOM_ROM_CFG_PTR));
+	/* Skip config string */
+	while (str < atom_rom_hdr && *str++)
+		;
+	/* Skip change list string */
+	while (str < atom_rom_hdr && *str++)
+		;
+
+	if ((str + STRLEN_NORMAL) < atom_rom_hdr)
+		strscpy(ctx->build_num, str, STRLEN_NORMAL);
+}
+
 struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 {
 	int base;
@@ -1557,6 +1578,7 @@ struct atom_context *amdgpu_atom_parse(struct card_info *card, void *bios)
 	atom_get_vbios_pn(ctx);
 	atom_get_vbios_date(ctx);
 	atom_get_vbios_version(ctx);
+	atom_get_vbios_build(ctx);
 
 	return ctx;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/atom.h b/drivers/gpu/drm/amd/amdgpu/atom.h
index b807f6639a4c6..825ff28731f52 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.h
+++ b/drivers/gpu/drm/amd/amdgpu/atom.h
@@ -37,6 +37,7 @@ struct drm_device;
 #define ATOM_ROM_MAGIC		"ATOM"
 #define ATOM_ROM_MAGIC_PTR	4
 
+#define ATOM_ROM_CFG_PTR 0xC
 #define ATOM_ROM_MSG_PTR	0x10
 #define ATOM_ROM_CMD_PTR	0x1E
 #define ATOM_ROM_DATA_PTR	0x20
@@ -151,6 +152,7 @@ struct atom_context {
 	uint32_t version;
 	uint8_t vbios_ver_str[STRLEN_NORMAL];
 	uint8_t date[STRLEN_NORMAL];
+	uint8_t build_num[STRLEN_NORMAL];
 };
 
 extern int amdgpu_atom_debug;
-- 
2.53.0



