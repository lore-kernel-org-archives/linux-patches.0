Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618790;
	b=pDeLNOpnyfKjJrBhfT654TVOfsxj/VTWNUftC+3lflpiNa9JTe3sdTYOGSjPLcDG+658
	 XvIQ95UMlCwizmR9zKZvhW8pPatzaCVFb9GW8c9KNepoRq1nw9BFvZPvkpWAek9KS2JBH
	 MXXuLEkaIKYZT3gwizs4ltoT2m/hYHhOLvZ/XaNk5TlhTznA9EtgAwCUOBGlij8XLBUOk
	 fkX/5kRB8OGMaxy5e5Av4paj0fibdTwgkd/y/lHGjMBvsXhYK4QjGh19amB+5F6OQz9Sl
	 kBsgrzFC/YIzXnG2QN7pFEFKZA2mgC3Oom03cO5ZXjzoz+e/0e1r3UR0Hb0V/zIbMBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=epVExBwV1+8Rlnp4YAhfw0/z/33OMpOM4klgvSPmn+Y=;
	b=5q2wX8uri0wYtzasp0Y9mXk8GI9q7TSLrfIXaTznH8JjLUWEBJWYw/BxgIzgRgsMtVp3
	 Ds0IAG6m64hVopotfNkwmDtDo0CUtTqHY4UeuC4nWZhoOzuQos1T7aF3K3kDdtx418vso
	 pr8kKiOy4f2QbNepdtmv6jhGgZv5nrRJPU4R24LNMLKrI38am7uvTyqP0cOBprJpc1edw
	 W+jC4p61WP1va2WreN3twAGKlWMw7yMA5todp883NcDW5u9N2YkEnKUIiZHh9mDeQq3Zk
	 dk56nCijDTYfrjRonCCY+4dGKwaJjfC63ChSb9jdTUeZEnCgeucNcTzF34EOOoZTuMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcyEUgqm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B706606A321;
	Wed, 25 Nov 2026 14:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcyEUgqm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488601F000C4;
	Wed, 25 Nov 2026 14:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618789;
	bh=epVExBwV1+8Rlnp4YAhfw0/z/33OMpOM4klgvSPmn+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcyEUgqm/xDuCAHzQ55uzZfMi8BvK8egMotc5/ZazKeFqwjXdsNpM2AbTxp9msCU3
	 yH78xWOoWcXUHMzzi6UugQQeN+hb2D9TGtVWHwDRNvqcFo/gQDFGgQURvCHgrWgSSv
	 OssyKH+Dz0u3/Kd6D5VyEKR1O5TXNR9sHW/0dczA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0389/1005] drm/xe/hwmon: Fix thermal sensor data handling
Date: Wed, 25 Nov 2026 15:28:47 +0100
Message-ID: <20261125143830.856196519@linuxfoundation.org>
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

[ Upstream commit d37dcdaa99b18995d74c2381b103e308f21e2565 ]

Read all required thermal groups in get_mc_temp() and store them in a
dword-aligned buffer, avoiding unaligned pcode accesses and ensuring
correct memory controller temperature reporting.

Store the pcode thermal data and thermal limit words as little-endian,
so their per-byte views match the hardware layout on big-endian hosts.

Fixes: 3a0cb885e111 ("drm/xe/hwmon: Expose memory controller temperature")
Fixes: c332fba805d6 ("drm/xe/hwmon: Expose temperature limits")
Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20261015071434.1063785-4-karthik.poosa@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit ca6e33701de8676118f1d039e0c00839d7de13c6)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index 123aef35aaacd..89e4a8c842d26 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -138,13 +138,17 @@ struct xe_hwmon_thermal_info {
 	union {
 		/** @limit: temperatures limits */
 		u8 limit[TEMP_LIMIT_MAX];
-		/** @data: temperature limits in dwords */
-		u32 data[DIV_ROUND_UP(TEMP_LIMIT_MAX, sizeof(u32))];
+		/** @data: temperature limits as little-endian dwords */
+		__le32 data[DIV_ROUND_UP(TEMP_LIMIT_MAX, sizeof(u32))];
 	};
 	/** @count: no of temperature sensors available for the platform */
 	u8 count;
-	/** @value: per-sensor raw mailbox temperature; bit7=sign, bits6:0=magnitude */
-	u8 value[U8_MAX];
+	union {
+		/** @value: per-sensor raw mailbox temperature; bit7=sign, bits6:0=magnitude */
+		u8 value[U8_MAX + 1];
+		/** @dword: sensor values as little-endian dwords, u32-aligned for pcode reads */
+		__le32 dword[DIV_ROUND_UP(U8_MAX + 1, sizeof(u32))];
+	};
 	/** @vram_label: vram label names */
 	char vram_label[MAX_VRAM_CHANNELS][MAX_LABEL_SIZE];
 };
@@ -803,16 +807,17 @@ static const struct hwmon_channel_info * const hwmon_info[] = {
 static int xe_hwmon_pcode_read_thermal_info(struct xe_hwmon *hwmon)
 {
 	struct xe_tile *root_tile = xe_device_get_root_tile(hwmon->xe);
-	u32 config = 0;
+	u32 config = 0, data0 = 0, data1 = 0;
 	int ret;
 
 	ret = xe_pcode_read(root_tile, PCODE_MBOX(PCODE_THERMAL_INFO, READ_THERMAL_LIMITS, 0),
-			    &hwmon->temp.data[0], &hwmon->temp.data[1]);
+			    &data0, &data1);
 	if (ret)
 		return ret;
 
-	drm_dbg(&hwmon->xe->drm, "thermal info read val 0x%x val1 0x%x\n",
-		hwmon->temp.data[0], hwmon->temp.data[1]);
+	drm_dbg(&hwmon->xe->drm, "thermal info read val 0x%x val1 0x%x\n", data0, data1);
+	hwmon->temp.data[0] = cpu_to_le32(data0);
+	hwmon->temp.data[1] = cpu_to_le32(data1);
 
 	ret = xe_pcode_read(root_tile, PCODE_MBOX(PCODE_THERMAL_INFO, READ_THERMAL_CONFIG, 0),
 			    &config, NULL);
@@ -836,16 +841,20 @@ static int mbx_temp_decode(u8 value)
 static int get_mc_temp(struct xe_hwmon *hwmon, long *val)
 {
 	struct xe_tile *root_tile = xe_device_get_root_tile(hwmon->xe);
-	u32 *dword = (u32 *)hwmon->temp.value;
 	s32 average = 0;
 	int ret, i;
 
-	for (i = 0; i < DIV_ROUND_UP(TEMP_LIMIT_MAX, sizeof(u32)); i++) {
+	guard(mutex)(&hwmon->hwmon_lock);
+
+	for (i = 0; i < DIV_ROUND_UP(hwmon->temp.count, sizeof(u32)); i++) {
+		u32 data = 0;
+
 		ret = xe_pcode_read(root_tile, PCODE_MBOX(PCODE_THERMAL_INFO, READ_THERMAL_DATA, i),
-				    (dword + i), NULL);
+				    &data, NULL);
 		if (ret)
 			return ret;
-		drm_dbg(&hwmon->xe->drm, "thermal data for group %d val 0x%x\n", i, dword[i]);
+		drm_dbg(&hwmon->xe->drm, "thermal data for group %d val 0x%x\n", i, data);
+		hwmon->temp.dword[i] = cpu_to_le32(data);
 	}
 
 	for (i = TEMP_INDEX_MCTRL; i < hwmon->temp.count - 1; i++)
-- 
2.53.0



