Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618793;
	b=WW58BJD5ERpI9o/xIgkoHwN1EAy6+dFIPgy3JczMk+Fz7GL5v0D6CqJgYMCnWhOytCHR
	 YXIDU+lABp+OIZQWOeICmS+G0eX9QGsTI0H42WE96wz8dCD2OGU8BXaMNWP0wkIk20FDJ
	 WU9uADXbG1qqsEtI3ZL0yqkEtqPxlzKlaE5DOeaCex/ubMi2ic5R3U81iIFhAeGygdLZ2
	 jV9XHqOPz3ewcrIk7Q8DAR7uy/RJAso6Uqw10aUzcME78Io0to9nqBNQo/SGq97juoj+M
	 b6UB9mvgoBSerP3/Xd20q9BCLsAK9Ob6NsMPpOcMvZ/R96TDjTo3EmNIszc1fchuDTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=r0WARS31nuTXbgF1GTjX9E+uSvgsA2p6m9kQ3b/UEwk=;
	b=QesZJfmwLPy3n5GjlA8XPiPK2CP+82J3kAHMTg/AkIhP54RF7zPtQLMSuIH7ObchtnUi
	 +0JgCsve/D4ZSLSKW6L+zL2AWb6iHe2NAbtzH1w36yVGROGgFNG+HgrAG7aSbopHuU5ng
	 mzSu6WRaRDUuRjNS4Y6eCw7NKvGZ2JKmxx488HdjK4ycPIz8wvnxvGDLdXHggQNlEX00L
	 i3OrSrg5VP8CH6XyOF2zild4+H75C9kkyY96cjW1/hazlxojnlYKaKdNjk95T/A2Zppxb
	 bzxiN15zbe1bCXrRsmde5M3ntqVEYSMhUMfH08y73lmu7/UInsupxIBWr+Pq9CqZcyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHEu04ym;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A1C606A323;
	Wed, 25 Nov 2026 14:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hHEu04ym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749CF1F000D4;
	Wed, 25 Nov 2026 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618793;
	bh=r0WARS31nuTXbgF1GTjX9E+uSvgsA2p6m9kQ3b/UEwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hHEu04ymI16BJ9QDlO9+dCkWM4inKLNkUTpb9IOOv6+yNnqaUaHXohH0j7phItmzU
	 wtXBbviS1lpCCQJ217A3eabxTkfqiLBY/7QVy4lRWfI6E0gpRtsGEaBH9taJLz+uV2
	 nlso/pL2aafAjDjB9e+5lPG2Tb2AmdFCqDP9Z2QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0390/1005] drm/xe/hwmon: Add helpers to validate thermal sensor readings
Date: Wed, 25 Nov 2026 15:28:48 +0100
Message-ID: <20261125143830.880341265@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Poosa <karthik.poosa@intel.com>

[ Upstream commit f2a144e9891b397aebcfc0e88906c29bc079322d ]

Add mmio_temp_valid() and mbx_temp_valid() to check whether a temperature
sensor reading is valid. An MMIO value of 0xFFFFFFFF or a mailbox value of
0xFF indicates the sensor is unavailable.

Gate these checks behind has_temp_sentinel, enabled on CRI currently.

Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20261015071434.1063785-5-karthik.poosa@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Stable-dep-of: dbd199c775cb ("drm/xe/hwmon: Handle unavailable memory controller sensors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device_types.h |  2 ++
 drivers/gpu/drm/xe/xe_hwmon.c        | 27 +++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_pci.c          |  2 ++
 drivers/gpu/drm/xe/xe_pci_types.h    |  1 +
 4 files changed, 32 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_device_types.h b/drivers/gpu/drm/xe/xe_device_types.h
index e4431f27d43c5..8daccb82ded79 100644
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -219,6 +219,8 @@ struct xe_device {
 		u8 has_sriov:1;
 		/** @info.has_sysctrl: Supports System Controller */
 		u8 has_sysctrl:1;
+		/** @info.has_temp_sentinel: Device has temperature-unavailable sentinels */
+		u8 has_temp_sentinel:1;
 		/** @info.has_usm: Device has unified shared memory support */
 		u8 has_usm:1;
 		/** @info.has_64bit_timestamp: Device supports 64-bit timestamps */
diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index 89e4a8c842d26..4b55a625affa2 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -104,6 +104,9 @@ enum sensor_attr_power {
 /* Index of memory controller in READ_THERMAL_DATA output */
 #define TEMP_INDEX_MCTRL	2
 
+/* Mailbox sentinel reported for an unavailable temperature sensor */
+#define TEMP_MBX_INVALID	0xFF
+
 /* Mailbox temperature is sign-magnitude: bit 7 sign, bits 6:0 magnitude. */
 #define TEMP_MBX_SIGN		BIT(7)
 #define TEMP_MBX_MAG		GENMASK(6, 0)
@@ -830,6 +833,30 @@ static int xe_hwmon_pcode_read_thermal_info(struct xe_hwmon *hwmon)
 	return ret;
 }
 
+static inline bool mmio_temp_valid(const struct xe_hwmon *hwmon, u32 value)
+{
+	/*
+	 * On platforms lacking temperature sentinel support, a value of 0 is treated
+	 * as invalid. While 0°C is theoretically possible, it is highly unlikely for
+	 * a discrete GPU in normal environments, making it a reasonable fallback
+	 * indicator for invalid or uninitialized temperature readings.
+	 * All-ones is returned when the device is off the bus, so reject it too.
+	 */
+	if (value == U32_MAX)
+		return false;
+
+	return hwmon->xe->info.has_temp_sentinel || value != 0;
+}
+
+/* Mailbox temperature is sign-magnitude (bit 7 sign, bits 6:0 magnitude). */
+static inline bool mbx_temp_valid(const struct xe_hwmon *hwmon, u8 value)
+{
+	if (value == TEMP_MBX_INVALID)
+		return false;
+
+	return hwmon->xe->info.has_temp_sentinel || value != 0;
+}
+
 /* Decode an 8-bit sign-magnitude mailbox temperature to degrees Celsius. */
 static int mbx_temp_decode(u8 value)
 {
diff --git a/drivers/gpu/drm/xe/xe_pci.c b/drivers/gpu/drm/xe/xe_pci.c
index 06e1062ec1705..5d7a0b403ac0d 100644
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -483,6 +483,7 @@ static const struct xe_device_desc cri_desc = {
 	.has_soc_remapper_telem = true,
 	.has_sriov = true,
 	.has_sysctrl = true,
+	.has_temp_sentinel = true,
 	.max_gt_per_tile = 2,
 	MULTI_LRC_MASK,
 	.require_force_probe = true,
@@ -814,6 +815,7 @@ static int xe_info_init_early(struct xe_device *xe,
 	xe->info.has_sriov = xe_configfs_primary_gt_allowed(to_pci_dev(xe->drm.dev)) &&
 		desc->has_sriov;
 	xe->info.has_sysctrl = desc->has_sysctrl;
+	xe->info.has_temp_sentinel = desc->has_temp_sentinel;
 	xe->info.skip_guc_pc = desc->skip_guc_pc;
 	xe->info.skip_pcode = desc->skip_pcode;
 	xe->info.needs_scratch = desc->needs_scratch;
diff --git a/drivers/gpu/drm/xe/xe_pci_types.h b/drivers/gpu/drm/xe/xe_pci_types.h
index fe327323a0be6..7cb372a832941 100644
--- a/drivers/gpu/drm/xe/xe_pci_types.h
+++ b/drivers/gpu/drm/xe/xe_pci_types.h
@@ -60,6 +60,7 @@ struct xe_device_desc {
 	u8 has_soc_remapper_telem:1;
 	u8 has_sriov:1;
 	u8 has_sysctrl:1;
+	u8 has_temp_sentinel:1;
 	u8 needs_scratch:1;
 	u8 skip_guc_pc:1;
 	u8 skip_pcode:1;
-- 
2.53.0



