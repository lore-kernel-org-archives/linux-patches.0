Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213121;
	b=cfmEIoZEFX2UX+FUK3JIrER7n84ZUAsi0Qo1QouZYujtn7RyaqKLIzplMlM4dR0RNs+f
	 BdAqPLeVsCSYz/G41WXu9ISpNr7DbU5bjAyG/UpYJPcL2YJad7q2Da8iLmWESTK2Nc9Wa
	 AtzevL20haGVvz2pb2XGQJKAaC849mxP717RtIukraSzFoKfDVCHcGvGEG0jmqmE0hQR3
	 cX8lbF1qjk+gYKQNewZ9LIrtp3F1dsVKqT29GlE6iwKrCoHVUN0CpftQuFSWpZlF5FrI+
	 KESTa78qW2KuqCqswy+mWwlyywhraqm2TpbBvGAibTqdkIKgIRIZRZsVFJTFsC36xSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GUNyshIph/9aJ6SQt0lXMe7sYt1c19M4KTGfRp/eRgQ=;
	b=NsSprgY8kASfQSF01en5L7Cd7GCAmBEtKGpMMhJSgYW9yOgd2Y+3Aq5RkxRyl0nkXyxl
	 y/r37SZPdLjLCXRcD2d8tfNablQkSVfOvONdyzu7suyXKby1MEnFFpH+BCg8Esu5Y0BSi
	 eVT59WXS2TUTekKioP7JYCbDhpUFmfB5IrjoTJhtl/KE+vgS8QfMc1EjmOEpu0AyecH4w
	 gEuyeGpYZAw5NlhE1fuo3azPkmBjqEeAOTXSHm6yrYaR1FXGLFfp0PEF2F2aXTQXD+9jb
	 eknWtjsGo9YeTzZwvkP2s/x3h3ZngZt2mgGAwSwcfnigvKyfDTllHlxxzmPO80ez+fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5mBWnhb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3802E606A31A;
	Wed, 28 Oct 2026 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5mBWnhb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC8E1F01825;
	Wed, 28 Oct 2026 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213121;
	bh=GUNyshIph/9aJ6SQt0lXMe7sYt1c19M4KTGfRp/eRgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5mBWnhbz9hZOR6TO7vFzOfVTipoqFf7b3Ie35pN2zDBM0rC1d4PJpwSRFJwh6uHM
	 mr3lINcu+RuRl6Ws3oGr0HD1auv9YufVnbQlYOrvHgfXzMwK7q3Rw3QkiWX0/vnziV
	 O4e5klH6EK6UXkx+WTwP8bUe2av/nBNP5gWt8dlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0350/1887] drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read
Date: Wed, 28 Oct 2026 17:40:46 +0100
Message-ID: <20261028170507.194309257@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 5d3cc8e388464f485d0944b87b8f9426e637d082 ]

Reject voltage objects whose usSize is smaller than the header or would
advance the cursor past the table end, preventing an infinite loop or
heap OOB read when the VBIOS supplies a malformed VoltageObjectInfo table.

Fixes: c82baa281843 ("drm/amd/powerplay: add Tonga dpm support (v3)")
Fixes: 0d2c7569e196 ("drm/amdgpu: add new atomfirmware based helpers for powerplay")
Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c   | 10 ++++++++--
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c | 11 ++++++++---
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 7e37354a03411..640350bbd9085 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -269,15 +269,21 @@ static const ATOM_VOLTAGE_OBJECT_V3 *atomctrl_lookup_voltage_type_v3(
 	unsigned int offset = offsetof(ATOM_VOLTAGE_OBJECT_INFO_V3_1, asVoltageObj[0]);
 	uint8_t *start = (uint8_t *)voltage_object_info_table;
 
-	while (offset < size) {
+	while (offset + sizeof(ATOM_VOLTAGE_OBJECT_HEADER_V3) <= size) {
 		const ATOM_VOLTAGE_OBJECT_V3 *voltage_object =
 			(const ATOM_VOLTAGE_OBJECT_V3 *)(start + offset);
+		u16 obj_size;
+
+		obj_size = le16_to_cpu(voltage_object->asGpioVoltageObj.sHeader.usSize);
+		if (obj_size < sizeof(voltage_object->asGpioVoltageObj.sHeader) ||
+		    offset + obj_size > size)
+			break;
 
 		if (voltage_type == voltage_object->asGpioVoltageObj.sHeader.ucVoltageType &&
 			voltage_mode == voltage_object->asGpioVoltageObj.sHeader.ucVoltageMode)
 			return voltage_object;
 
-		offset += le16_to_cpu(voltage_object->asGpioVoltageObj.sHeader.usSize);
+		offset += obj_size;
 	}
 
 	return NULL;
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c
index a47a47238e2b9..e5aa787182025 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomfwctrl.c
@@ -36,16 +36,21 @@ static const union atom_voltage_object_v4 *pp_atomfwctrl_lookup_voltage_type_v4(
 			offsetof(struct atom_voltage_objects_info_v4_1, voltage_object[0]);
 	unsigned long start = (unsigned long)voltage_object_info_table;
 
-	while (offset < size) {
+	while (offset + sizeof(struct atom_voltage_object_header_v4) <= size) {
 		const union atom_voltage_object_v4 *voltage_object =
 			(const union atom_voltage_object_v4 *)(start + offset);
+		u16 obj_size;
+
+		obj_size = le16_to_cpu(voltage_object->gpio_voltage_obj.header.object_size);
+		if (obj_size < sizeof(voltage_object->gpio_voltage_obj.header) ||
+		    offset + obj_size > size)
+			break;
 
 		if (voltage_type == voltage_object->gpio_voltage_obj.header.voltage_type &&
 		    voltage_mode == voltage_object->gpio_voltage_obj.header.voltage_mode)
 			return voltage_object;
 
-		offset += le16_to_cpu(voltage_object->gpio_voltage_obj.header.object_size);
-
+		offset += obj_size;
 	}
 
 	return NULL;
-- 
2.53.0



