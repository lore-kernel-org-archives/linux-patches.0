Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208799;
	b=A/us5EFb09dLTvT+pqe+Qbi7VPNOSTf7qxSain77NYFOpaxDHYmzrsZyChwErwEVzAce
	 APPl0t/ak/cDgm/dt/IknGWBxb+CIvZjnE6b57ufII2xFUh98uU+68Ueasl8zK/PT6jzG
	 BIx1wWYSLraUGRlvC4A3dh45ZJD3eOLw9lMAnWTBvt3WoZkiv9zlwS+BquKmNDv5MeALh
	 q3wPKw2nkuN7gGOT3SgTsEx64gw9oXG/tlgYbMobNb+cl2BEo/efILmdtR13GR7DfLdXv
	 An5B71yxlOARP2SLKVj5I02QHhKtiAGk8Y4AD9QlDkYI5CVyNxbl4xM0T/gP4VsczXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2QbEyFJ/q6bcsf9/WDPasOEomVaWhHX7qg+bQq2WDhM=;
	b=di2Mqco0CUMWUjMYXWPFeRmXDM4zxgGxwKH/HEQrZ0p1FeFw21JYgCb74VrMLmIg4LpU
	 BEtru1J6mkTUNk48Gdr/CI4h8DRer8ANUXbhRarbQ1Ks0AqaUalrsM/k+OQvmxZruy1Ix
	 t/LzrVWngYPjbcDf3ioKqZWygo8HFlDThr44O0Vl2u3Ir/TH4yYzyhjNoU/qjK6pTzXoE
	 RYU3h8UNfAll0ERopPt9mv8jT3uWFGqb3KZ0kF2UVG7guNBwQjPUxY1PoyKCr+RPjG4Rw
	 btjMcsCuvdLqKfTdbjVOAYs6DklkBomAzIUtkTKsO04xPlJSJPz+LeCgI+Ri59ZoMmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVzlxJqH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC27606A31A;
	Wed, 28 Oct 2026 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CVzlxJqH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DFC1F01825;
	Wed, 28 Oct 2026 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208798;
	bh=2QbEyFJ/q6bcsf9/WDPasOEomVaWhHX7qg+bQq2WDhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVzlxJqHVXr25JmfRdX0/QNKsvIu9NJdcCUlrVUzUDVv6095bgpHyI/DEdZLtfa78
	 9dz0Yml7fT3r4uM0ZheY+1bCbkN65renVi8dVeg0EgZMrRIRzshai4qDOOLkgxcOK0
	 6/RCR/MGJWWWnXkkAv3jEMLDhW+Ycj1LzcBDJK1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/516] drm/amd/powerplay: fix VoltageObjectInfo zero-stride loop and OOB read
Date: Wed, 28 Oct 2026 17:56:39 +0100
Message-ID: <20261028170009.349217439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 04dbd9f89a45d..0e9d33846114f 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -224,15 +224,21 @@ static const ATOM_VOLTAGE_OBJECT_V3 *atomctrl_lookup_voltage_type_v3(
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
index 615cf2c09e54e..26444c20e3cc8 100644
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



