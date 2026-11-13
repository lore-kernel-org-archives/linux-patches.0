Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590552;
	b=CWOy+6TaBBt947HLtQnAOBTvSbfgnIL/URvErpasXZ4+v6VXhjww7+9DkAaWBapgDay3
	 J9SY4D9ck2/9SIj2V/TOK5s3bkkRLxtWe8/UUCS4cJtAy2fW1OT2cqUTPeQ3xMD6hSv1c
	 5xAWy9I/HKKDHTvgnO57CmXAX46L6g/3Humps8rpHEqJxABgtKGqGB2VvuvhuU307SeSG
	 nBzsSRCSJI5zgYqYu378Jjtc9qQGIH5a+STthiaUkQGOhxqa7tprQwB6JvTMK6o6Z5IYv
	 8bnPrHPBvSpGNyCDqdVaM+JXadsaLKwL22o9zVxKpBr+oxiq5nY0JJTCXcdm33u+c6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDMss3ueW6yc78YuqfPM9RAHjFwq9YdM/j8Vh3bi9MY=;
	b=oau4hfs+XN2hjucKx+C6uCffKVZjYi/JlU+k/NQknrCza5cfcvghjRK8uwtwZD8DwhZV
	 LdWQTQbEZXwkbVZ0pCnH2DrRB4Xgc+gF11r/GmSvQIEmS9PndoLnCkYu9cewTRf2ALZ9E
	 xQhhqJbEijJUOGoCNmAe0fw3y0nuZFVCKwNCm/zWZCAxWfBXif8ySE02QnttzSAN3YMi/
	 VeIS6s/bw8VcaQhYNGuzB/hV5sZs9KtgpEgsFKq/uzY1NIpw7u7cDSdUoRoMNahr+53iW
	 AWNqRAVKQVm4dFHnTbX5wCZ3qdaGruGWbKKCEKNHNG2+HUUmgshSJOBHYJc4DxrksuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcvJID4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BBC606B37D;
	Fri, 13 Nov 2026 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NcvJID4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90AC1F000CA;
	Fri, 13 Nov 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590552;
	bh=dDMss3ueW6yc78YuqfPM9RAHjFwq9YdM/j8Vh3bi9MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcvJID4tSOQy6NvUve7O7S7G1nCHhTMB/miv3Lffgoh2TR3Drb6yBF8Ug0CJl3j+k
	 M7rthj+MkVyVjY3//FVDitca/0/2zXKMB3DZzmDtFfoMeLdM33sHyyH2HVvM68ifr7
	 u/hMIBSsj9bUvQ4mxblBRA8yqmtAssN6z1a3Mhzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Tarang Raval <tarang.raval@siliconsignals.io>,
	Kate Hsuan <hpa@redhat.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 489/686] platform: int3472: discrete: Support multiple HIDs per GPIO map entry
Date: Fri, 13 Nov 2026 10:50:22 -0500
Message-ID: <20261113153837.515572708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Tarang Raval <tarang.raval@siliconsignals.io>

[ Upstream commit edd0dd59aca038b7f32cf893170928d4a3b2297e ]

Each int3472_gpio_map entry currently maps exactly one ACPI HID to a
GPIO quirk. As more sensors needing the same quirk are identified, this
means adding a full duplicate table entry per HID, differing only in
the HID string, which does not scale.

Change int3472_gpio_map::hid to a NULL-terminated hids array so a
single entry can match any number of ACPI HIDs, letting new HIDs be
added to the relevant array instead of duplicating quirk entries.

Cc: linux-media@vger.kernel.org
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Tarang Raval <tarang.raval@siliconsignals.io>
Tested-by: Kate Hsuan <hpa@redhat.com>
Reviewed-by: Kate Hsuan <hpa@redhat.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Keep the consolidated vana mapping for SONY471A and TBE20A0, which
were not previously listed, so the subsequent handshake-delay fix applies
unchanged. Perform the HID scan in the existing GPIO mapping routine
instead of introducing a separate matching helper.

Stable-dep-of: 844982d3b993 ("platform/x86: int3472: Increase handshake GPIO delay to 200 ms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/int3472/discrete.c | 45 ++++++++++++++++---
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel/int3472/discrete.c b/drivers/platform/x86/intel/int3472/discrete.c
index 96c33ba80002f..a4c24f1cd0a4d 100644
--- a/drivers/platform/x86/intel/int3472/discrete.c
+++ b/drivers/platform/x86/intel/int3472/discrete.c
@@ -123,10 +123,31 @@ skl_int3472_gpiod_get_from_temp_lookup(struct int3472_discrete_device *int3472,
 	return desc;
 }
 
+/*
+ * Other vana-supply users (e.g. ST, Toshiba, Sony sensors) can be added to
+ * this array instead of adding new quirk table entries.
+ */
+static const char * const power_enable_hids_vana[] = {
+	"SONY471A", /* imx471 on Lenovo X9-14 and X9-15 */
+	"TBE20A0", /* imx471 on Lenovo X1 Carbon G14 */
+	NULL
+};
+
+static const char * const power_enable_hids_vdd[] = {
+	"INT33F0", /* mt9m114 */
+	NULL
+};
+
+static const char * const power_enable_hids_enable[] = {
+	"INT347E", /* ov7251 */
+	NULL
+};
+
 /**
  * struct int3472_gpio_map - Map GPIOs to whatever is expected by the
  * sensor driver (as in DT bindings)
- * @hid: The ACPI HID of the device without the instance number e.g. INT347E
+ * @hids: NULL-terminated array of ACPI HIDs of the devices without the
+ * instance number e.g. INT347E
  * @type_from: The GPIO type from ACPI ?SDT
  * @type_to: The assigned GPIO type, typically same as @type_from
  * @enable_time_us: Enable time in usec for GPIOs mapped to regulators
@@ -135,7 +156,7 @@ skl_int3472_gpiod_get_from_temp_lookup(struct int3472_discrete_device *int3472,
  * GPIO_ACTIVE_HIGH otherwise
  */
 struct int3472_gpio_map {
-	const char *hid;
+	const char * const *hids;
 	u8 type_from;
 	u8 type_to;
 	bool polarity_low;
@@ -145,25 +166,32 @@ struct int3472_gpio_map {
 
 static const struct int3472_gpio_map int3472_gpio_map[] = {
 	{	/* mt9m114 designs declare a powerdown pin which controls the regulators */
-		.hid = "INT33F0",
+		.hids = power_enable_hids_vdd,
 		.type_from = INT3472_GPIO_TYPE_POWERDOWN,
 		.type_to = INT3472_GPIO_TYPE_POWER_ENABLE,
 		.con_id = "vdd",
 		.enable_time_us = GPIO_REGULATOR_ENABLE_TIME,
 	},
 	{	/* ov7251 driver / DT-bindings expect "enable" as con_id for reset */
-		.hid = "INT347E",
+		.hids = power_enable_hids_enable,
 		.type_from = INT3472_GPIO_TYPE_RESET,
 		.type_to = INT3472_GPIO_TYPE_RESET,
 		.con_id = "enable",
 	},
 	{	/* ov08x40's handshake pin needs a 45 ms delay on some HP laptops */
-		.hid = "OVTI08F4",
+		.hids = (const char * const[]) { "OVTI08F4", NULL },
 		.type_from = INT3472_GPIO_TYPE_HANDSHAKE,
 		.type_to = INT3472_GPIO_TYPE_HANDSHAKE,
 		.con_id = "dvdd",
 		.enable_time_us = 45 * USEC_PER_MSEC,
 	},
+	{	/* Sensors which expect "vana" as con_id for power enable */
+		.hids = power_enable_hids_vana,
+		.type_from = INT3472_GPIO_TYPE_POWER_ENABLE,
+		.type_to = INT3472_GPIO_TYPE_POWER_ENABLE,
+		.con_id = "vana",
+		.enable_time_us = GPIO_REGULATOR_ENABLE_TIME,
+	},
 };
 
 static void int3472_get_con_id_and_polarity(struct int3472_discrete_device *int3472, u8 *type,
@@ -171,6 +199,7 @@ static void int3472_get_con_id_and_polarity(struct int3472_discrete_device *int3
 					    unsigned int *enable_time_us)
 {
 	struct acpi_device *adev = int3472->sensor;
+	const char * const *hids;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(int3472_gpio_map); i++) {
@@ -182,7 +211,11 @@ static void int3472_get_con_id_and_polarity(struct int3472_discrete_device *int3
 		if (*type != int3472_gpio_map[i].type_from)
 			continue;
 
-		if (!acpi_dev_hid_uid_match(adev, int3472_gpio_map[i].hid, NULL))
+		for (hids = int3472_gpio_map[i].hids; *hids; hids++) {
+			if (acpi_dev_hid_uid_match(adev, *hids, NULL))
+				break;
+		}
+		if (!*hids)
 			continue;
 
 		dev_dbg(int3472->dev, "mapping type 0x%02x pin to 0x%02x %s\n",
-- 
2.53.0



