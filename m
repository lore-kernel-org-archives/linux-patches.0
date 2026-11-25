Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618787;
	b=SSk7dAzZ8qsZbB9H51rqLqskL0VIKKqXe6gKxonouqS04v/rkMdxJ8MwN4SPIDaVeISF
	 DLqPV3Nbf7+fFFlkuzcdtZNYbjOQJFFFzp/aa9gMJQyqdUvZfiObgDrYw66qOeKxzchDs
	 uXxmubjifqWG74cicujCpAwMsUxtVws1tkwHjoB9pokut2NCHCwwVlvvQ99ffuY27tFsq
	 mR1jO+e7M/ZdMIY5QwoG07es7BNkQcFslXSBHIFtlqUthvs7MbAPEwY3lxi4ijSvhaJOF
	 48alUHUr6W6CZBK/ih5wwnC0UltWsRcTr1l0sOeGFzbunRk4JZTmDhmqoV5V1MYoO+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WCEA1919lW1nmQpgR6y5ZtH6hwHdN5mOb1belgeynV8=;
	b=GGB+kVxZZ56LNJOw8clJODPy9Hf+nbrZT5Fdb852pwtYH97vJtM/Ct8czvRMZeeQRJ2g
	 k5M7x6ExqEqC53ivdWxdLcdtdO6nnM1fbqlf6ZwqdxDy77PJRT469tF0vMNQj3kCBhxtm
	 vpXyx/MjsizxA8fYFMNNOGS3pd9VnEEsVYU2IUVmLeO9U8G7Chf2QsDVwpUHY0npLPxe/
	 B/wM1X4UIUA2Q0FErjT+x4xXLO4Ogz9PMRmaEEZFdxPhQR1qSKuDpP2eCiaQMVIZa6hLG
	 +J5u0MV9UJAw4BojMVo0KIeBL3OEqqgFGFXuexVedJbY/RE7sqNBIBNdzreYhrYGMaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IObsPXBB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2022C606A321;
	Wed, 25 Nov 2026 14:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IObsPXBB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068151F000C4;
	Wed, 25 Nov 2026 14:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618786;
	bh=WCEA1919lW1nmQpgR6y5ZtH6hwHdN5mOb1belgeynV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IObsPXBB3rsPa7UwYW7CIwzv6TEjjG2Pub0vk7FN1TLdaIkC0ANRssHcHRhmoQ4u9
	 OtDvQ5lcNZLUDoGKlfOGf1C/vYTrYMWxLnxplO9n3dVpfQulKIK/9jBO68PiwOTBP1
	 V5xdeL8AELF8UddbRWj0z5GOdYAUDuXFA0RllnAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthik Poosa <karthik.poosa@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0388/1005] drm/xe/hwmon: Decode mailbox temperature as sign-magnitude
Date: Wed, 25 Nov 2026 15:28:46 +0100
Message-ID: <20261125143830.832147506@linuxfoundation.org>
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

[ Upstream commit c9d8ef7f6835ddfca8259c322804038799be5641 ]

The mailbox temperature is an 8-bit sign-magnitude value (bit 7 sign,
bits 6:0 magnitude, range -127..127), not two's-complement. Casting the
raw byte to s8 decodes negative readings incorrectly.

Add mbx_temp_decode(), store the raw byte as u8, and use it in
get_mc_temp() and get_pcie_temp() so temperatures are decoded correctly.

Fixes: 3a0cb885e111 ("drm/xe/hwmon: Expose memory controller temperature")
Signed-off-by: Karthik Poosa <karthik.poosa@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20261015071434.1063785-3-karthik.poosa@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 1bbbd7d98fa588d5ace3d79ce56d8928f18768f5)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hwmon.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hwmon.c b/drivers/gpu/drm/xe/xe_hwmon.c
index 74d7faf85df04..123aef35aaacd 100644
--- a/drivers/gpu/drm/xe/xe_hwmon.c
+++ b/drivers/gpu/drm/xe/xe_hwmon.c
@@ -104,6 +104,10 @@ enum sensor_attr_power {
 /* Index of memory controller in READ_THERMAL_DATA output */
 #define TEMP_INDEX_MCTRL	2
 
+/* Mailbox temperature is sign-magnitude: bit 7 sign, bits 6:0 magnitude. */
+#define TEMP_MBX_SIGN		BIT(7)
+#define TEMP_MBX_MAG		GENMASK(6, 0)
+
 /* Maximum characters in hwmon label name */
 #define MAX_LABEL_SIZE		16
 
@@ -139,8 +143,8 @@ struct xe_hwmon_thermal_info {
 	};
 	/** @count: no of temperature sensors available for the platform */
 	u8 count;
-	/** @value: signed value from each sensor */
-	s8 value[U8_MAX];
+	/** @value: per-sensor raw mailbox temperature; bit7=sign, bits6:0=magnitude */
+	u8 value[U8_MAX];
 	/** @vram_label: vram label names */
 	char vram_label[MAX_VRAM_CHANNELS][MAX_LABEL_SIZE];
 };
@@ -821,6 +825,14 @@ static int xe_hwmon_pcode_read_thermal_info(struct xe_hwmon *hwmon)
 	return ret;
 }
 
+/* Decode an 8-bit sign-magnitude mailbox temperature to degrees Celsius. */
+static int mbx_temp_decode(u8 value)
+{
+	int temp = value & TEMP_MBX_MAG;
+
+	return (value & TEMP_MBX_SIGN) ? -temp : temp;
+}
+
 static int get_mc_temp(struct xe_hwmon *hwmon, long *val)
 {
 	struct xe_tile *root_tile = xe_device_get_root_tile(hwmon->xe);
@@ -837,7 +849,7 @@ static int get_mc_temp(struct xe_hwmon *hwmon, long *val)
 	}
 
 	for (i = TEMP_INDEX_MCTRL; i < hwmon->temp.count - 1; i++)
-		average += hwmon->temp.value[i];
+		average += mbx_temp_decode(hwmon->temp.value[i]);
 
 	average /= (hwmon->temp.count - TEMP_INDEX_MCTRL - 1);
 	*val = average * MILLIDEGREE_PER_DEGREE;
@@ -860,7 +872,7 @@ static int get_pcie_temp(struct xe_hwmon *hwmon, long *val)
 		data = REG_FIELD_GET(PCIE_SENSOR_MASK, data);
 
 	data = REG_FIELD_GET(TEMP_MASK, data);
-	*val = (s8)data * MILLIDEGREE_PER_DEGREE;
+	*val = mbx_temp_decode(data) * MILLIDEGREE_PER_DEGREE;
 
 	return 0;
 }
-- 
2.53.0



