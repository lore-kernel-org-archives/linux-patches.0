Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618783;
	b=dxeUocO3N0oFf40UYpRiU6OxJ+pFE5tU6rXVt6+Tl6iakus+Rp/rFtM2pemApq95mhmx
	 BfpGadRo7OLo8YmqU59dSREbub0IX8pYNKZSpEDn1zZ3wrGOkXQ05wOmbNlhmR42iaTbF
	 s432KgzVA+tKtAgYh1kSwSHJda2g+HCNLXA4JiuZI7d1PQmilSjFJ7UbwKljH/QR3oxde
	 Lrl2+5IPOuv5rYX61wKJgAcWvJLiWfVQ0BYZbHNUy8IDfvw1afuIEH4PhSVEn5gDuEY5r
	 rUJiAyitO33THVEJQfQFySe3GEijITwYlhVYCHHBvZTK9HAqQqyClNI/wlIow3/Lhvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eZ5KT2k2B/pbmOn1HG17iBX145ZMjM6VoYEPBfoJ7mg=;
	b=Nmew/h3tpq5+V+sPzZvH9NoH3UzwbyUYxrq05NnRxXIDbaxH7hSQkLKtD0tA82+ErKJj
	 kOO3U6mZhMWAS28CipyovOIKTgV7+pRGuIbkqnYBjOAwnfIDWoDg9k9uhTS3Rg7Xh4Gtz
	 P6wr16Fynqxo6sG/FXyGYiIfNHl4j3d2lE2pUhT0xiDSfVerul/fUzXACtc7lAhSRZFsH
	 6wDLiIJ1dc2UTtuRr2zhqaZ73vN3/o/HY1E5jLsN+WmCMkhtAPI62ywUUg19b24ro7HJu
	 lZuaonsoibo+PDdr9YB/u1h1+aet7VWFNGD8bigVmPc5MbFru3JwJVQxHpRj6w66n2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfU6ckbX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA3F606A31E;
	Wed, 25 Nov 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pfU6ckbX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23541F000C6;
	Wed, 25 Nov 2026 14:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618783;
	bh=eZ5KT2k2B/pbmOn1HG17iBX145ZMjM6VoYEPBfoJ7mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pfU6ckbXtMogmAVRH63C1RB+p53v/fG+72geSkOcYHSPOWPz+IPdJhrWLjaA5FDAO
	 PnBHUlsGR2Lwcio6tcrqUIAXCIBYXFfIljPTbEGFdydCwkT6RBBIstyQyt6Sy4ISVv
	 egPxJuHDzdfpxVWaRSdMxa/376ElRIkUos0WOLx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0387/1005] drm/xe/hwmon: Fix pcode power limit handling
Date: Wed, 25 Nov 2026 15:28:45 +0100
Message-ID: <20261125143830.808767226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit 94099304b80e8c6e842c2626f603930577938f3a ]

Return early on pcode read failure in xe_hwmon_pcode_rmw_power_limit()
and propagate errors to callers.

Replace boot_power_limit_read with per-channel
read_power_limit_from_pcode[], set on the first successful pcode write,
so reads and writes stay consistent even if the default limit write at
boot fails.

Also return PWR_LIM_EN for power label so card label visibility works.

v2: Move default power limit writes to helper
    xe_hwmon_pcode_set_default_power_limits().

Fixes: 8aa7306631f0 ("drm/xe/hwmon: Fix xe_hwmon_power_max_write")
Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20261015071434.1063785-2-karthik.poosa@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit c5b502e43f7cd6456663d5bae495551646a5e125)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 84 +++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 29 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index 08cec511806fa..74d7faf85df04 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -165,8 +165,8 @@ struct xe_hwmon {
 	struct xe_hwmon_energy_info ei[CHANNEL_MAX];
 	/** @fi: Fan info for fanN_input */
 	struct xe_hwmon_fan_info fi[FAN_MAX];
-	/** @boot_power_limit_read: is boot power limits read */
-	bool boot_power_limit_read;
+	/** @read_power_limit_from_pcode: pcode accepted power limits write for the channel */
+	bool read_power_limit_from_pcode[CHANNEL_MAX];
 	/** @pl1_on_boot: power limit PL1 on boot */
 	u32 pl1_on_boot[CHANNEL_MAX];
 	/** @pl2_on_boot: power limit PL2 on boot */
@@ -175,9 +175,9 @@ struct xe_hwmon {
 	struct xe_hwmon_thermal_info temp;
 };
 
-static inline int prepare_power_limit_param2(const struct xe_hwmon *hwmon)
+static inline int prepare_power_limit_param2(const struct xe_hwmon *hwmon, int channel)
 {
-	if (hwmon->boot_power_limit_read) {
+	if (hwmon->read_power_limit_from_pcode[channel]) {
 		if (hwmon->xe->info.platform >= XE_CRESCENTISLAND)
 			return READ_PL_ACCEPTED;
 		else
@@ -198,7 +198,8 @@ static int xe_hwmon_pcode_read_power_limit(const struct xe_hwmon *hwmon, u32 att
 						  (channel == CHANNEL_CARD) ?
 						  READ_PSYSGPU_POWER_LIMIT :
 						  READ_PACKAGE_POWER_LIMIT,
-						  prepare_power_limit_param2(hwmon)), &val0, &val1);
+						  prepare_power_limit_param2(hwmon, channel)),
+			    &val0, &val1);
 
 	if (ret) {
 		drm_dbg(&hwmon->xe->drm, "read failed ch %d val0 0x%08x, val1 0x%08x, ret %d\n",
@@ -213,14 +214,14 @@ static int xe_hwmon_pcode_read_power_limit(const struct xe_hwmon *hwmon, u32 att
 	else if (attr == PL2_HWMON_ATTR)
 		*uval = (val1 & PWR_LIM_EN) ? val1 : 0;
 	else if (attr == hwmon_power_label)
-		*uval = (val0 & PWR_LIM_EN) ? 1 : (val1 & PWR_LIM_EN) ? 1 : 0;
+		*uval = (val0 | val1) & PWR_LIM_EN;
 	else
 		*uval = 0;
 
 	return ret;
 }
 
-static int xe_hwmon_pcode_rmw_power_limit(const struct xe_hwmon *hwmon, u32 attr, u8 channel,
+static int xe_hwmon_pcode_rmw_power_limit(struct xe_hwmon *hwmon, u32 attr, u8 channel,
 					  u32 clr, u32 set)
 {
 	struct xe_tile *root_tile = xe_device_get_root_tile(hwmon->xe);
@@ -231,10 +232,13 @@ static int xe_hwmon_pcode_rmw_power_limit(const struct xe_hwmon *hwmon, u32 attr
 						  (channel == CHANNEL_CARD) ?
 						  READ_PSYSGPU_POWER_LIMIT :
 						  READ_PACKAGE_POWER_LIMIT,
-						  prepare_power_limit_param2(hwmon)), &val0, &val1);
-	if (ret)
-		drm_dbg(&hwmon->xe->drm, "read failed ch %d val0 0x%08x, val1 0x%08x, ret %d\n",
+						  prepare_power_limit_param2(hwmon, channel)),
+			    &val0, &val1);
+	if (ret) {
+		drm_err(&hwmon->xe->drm, "read failed ch %d val0 0x%08x, val1 0x%08x, ret %d\n",
 			channel, val0, val1, ret);
+		return ret;
+	}
 
 	if (attr == PL1_HWMON_ATTR)
 		val0 = (val0 & ~clr) | set;
@@ -248,9 +252,36 @@ static int xe_hwmon_pcode_rmw_power_limit(const struct xe_hwmon *hwmon, u32 attr
 							     WRITE_PSYSGPU_POWER_LIMIT :
 							     WRITE_PACKAGE_POWER_LIMIT, 0),
 							     val0, val1, PCODE_DEFAULT_TIMEOUT_MS);
-	if (ret)
+	if (ret) {
 		drm_dbg(&hwmon->xe->drm, "write failed ch %d val0 0x%08x, val1 0x%08x, ret %d\n",
 			channel, val0, val1, ret);
+		return ret;
+	}
+
+	/* Read from pcode once it holds a driver-written limit */
+	if (!hwmon->read_power_limit_from_pcode[channel])
+		hwmon->read_power_limit_from_pcode[channel] = true;
+
+	return 0;
+}
+
+static int xe_hwmon_pcode_set_default_power_limits(struct xe_hwmon *hwmon)
+{
+	int ret = 0;
+
+	ret |= xe_hwmon_pcode_rmw_power_limit(hwmon, PL1_HWMON_ATTR, CHANNEL_CARD,
+						       PWR_LIM | PWR_LIM_TIME,
+						       hwmon->pl1_on_boot[CHANNEL_CARD]);
+	ret |= xe_hwmon_pcode_rmw_power_limit(hwmon, PL1_HWMON_ATTR, CHANNEL_PKG,
+						       PWR_LIM | PWR_LIM_TIME,
+						       hwmon->pl1_on_boot[CHANNEL_PKG]);
+	ret |= xe_hwmon_pcode_rmw_power_limit(hwmon, PL2_HWMON_ATTR, CHANNEL_CARD,
+						       PWR_LIM | PWR_LIM_TIME,
+						       hwmon->pl2_on_boot[CHANNEL_CARD]);
+	ret |= xe_hwmon_pcode_rmw_power_limit(hwmon, PL2_HWMON_ATTR, CHANNEL_PKG,
+						       PWR_LIM | PWR_LIM_TIME,
+						       hwmon->pl2_on_boot[CHANNEL_PKG]);
+
 	return ret;
 }
 
@@ -394,7 +425,9 @@ static int xe_hwmon_power_max_write(struct xe_hwmon *hwmon, u32 attr, int channe
 		if (hwmon->xe->info.has_mbx_power_limits) {
 			drm_dbg(&hwmon->xe->drm, "disabling %s on channel %d\n",
 				PWR_ATTR_TO_STR(attr), channel);
-			xe_hwmon_pcode_rmw_power_limit(hwmon, attr, channel, PWR_LIM_EN, 0);
+			ret = xe_hwmon_pcode_rmw_power_limit(hwmon, attr, channel, PWR_LIM_EN, 0);
+			if (ret)
+				goto unlock;
 			xe_hwmon_pcode_read_power_limit(hwmon, attr, channel, &reg_val);
 		} else {
 			reg_val = xe_mmio_rmw32(mmio, rapl_limit, PWR_LIM_EN, 0);
@@ -655,15 +688,19 @@ xe_hwmon_power_max_interval_store(struct device *dev, struct device_attribute *a
 
 	mutex_lock(&hwmon->hwmon_lock);
 
-	if (hwmon->xe->info.has_mbx_power_limits)
-		xe_hwmon_pcode_rmw_power_limit(hwmon, power_attr, channel, PWR_LIM_TIME, rxy);
-	else
+	ret = count;
+	if (hwmon->xe->info.has_mbx_power_limits) {
+		ret = xe_hwmon_pcode_rmw_power_limit(hwmon, power_attr, channel, PWR_LIM_TIME, rxy);
+		if (!ret)
+			ret = count;
+	} else {
 		r = xe_mmio_rmw32(mmio, xe_hwmon_get_reg(hwmon, REG_PKG_RAPL_LIMIT, channel),
 				  PWR_LIM_TIME, rxy);
+	}
 
 	mutex_unlock(&hwmon->hwmon_lock);
 
-	return count;
+	return ret;
 }
 
 /* PSYS PL1 */
@@ -1487,22 +1524,11 @@ xe_hwmon_get_preregistration_info(struct xe_hwmon *hwmon)
 		} else {
 			drm_info(&hwmon->xe->drm, "Using mailbox commands for power limits\n");
 			/* Write default limits to read from pcode from now on. */
-			xe_hwmon_pcode_rmw_power_limit(hwmon, PL1_HWMON_ATTR,
-						       CHANNEL_CARD, PWR_LIM | PWR_LIM_TIME,
-						       hwmon->pl1_on_boot[CHANNEL_CARD]);
-			xe_hwmon_pcode_rmw_power_limit(hwmon, PL1_HWMON_ATTR,
-						       CHANNEL_PKG, PWR_LIM | PWR_LIM_TIME,
-						       hwmon->pl1_on_boot[CHANNEL_PKG]);
-			xe_hwmon_pcode_rmw_power_limit(hwmon, PL2_HWMON_ATTR,
-						       CHANNEL_CARD, PWR_LIM | PWR_LIM_TIME,
-						       hwmon->pl2_on_boot[CHANNEL_CARD]);
-			xe_hwmon_pcode_rmw_power_limit(hwmon, PL2_HWMON_ATTR,
-						       CHANNEL_PKG, PWR_LIM | PWR_LIM_TIME,
-						       hwmon->pl2_on_boot[CHANNEL_PKG]);
+			if (xe_hwmon_pcode_set_default_power_limits(hwmon))
+				drm_warn(&hwmon->xe->drm, "Failed to set default power limits\n");
 			hwmon->scl_shift_power = PWR_UNIT;
 			hwmon->scl_shift_energy = ENERGY_UNIT;
 			hwmon->scl_shift_time = TIME_UNIT;
-			hwmon->boot_power_limit_read = true;
 		}
 	} else {
 		drm_info(&hwmon->xe->drm, "Using register for power limits\n");
-- 
2.53.0



