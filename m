Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249805921FC;
	Mon, 31 Aug 2026 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184260; cv=none; b=GZuIgUgtZp+nS2tBC2MvtJGBxaN5iMJysghf8SOzPeZpUVXPZd+3aHxKaj6/UJ8gJUgHqNUc0OrKx0yM/zXjpuDelJHfjejrIvzxaCI20gP3U0H8HhGdZqniSOvxLifY/HE35MQmWTTSkOgO0s1oIpiucYXHLl7kRLPcoA+ePAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184260; c=relaxed/simple;
	bh=kUdUQCj2FbIsVsDmeIXnoKOSBOckzjh9N4rlF0xYr0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=akN4m3RNJ7Y4E9MdOXrGDroOtTrdl8CTjmuNr0woOf+5ApPBKjpRc/fs2N0xFsf5EJI2+iVof5BNvwmbNesGB3i7JznBGiJDlf/ujMm1pNwAZchit9Yr4aby6wUc915bKagkViAEdgXtl9aS68fzyuqPdaZkDSUGfpAKDjHka9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1art5+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1art5+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCA01F00A3D;
	Mon, 31 Aug 2026 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184259;
	bh=BHUptxBK+67yDtgnKZp0bf1L7jCzGKxagaar+rOrSqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1art5+o94Hik6ut/lQ0UYWx6CJFgSV9KA6AIAIaJGR3pFi9/utC44h8ii8UtifQB
	 VfLgvlgxrXRnU0Y0Kh+I3n4EHs8ftDkIL7yZ3g2dl2mEsqBQtCSZ/eVIyqwcUfNsA3
	 t/YnqE6yQCqVIMEZkRyKC4eRrxEd6W+NkZWyqmBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Oleg Makarenko <oleg@makarenk.ooo>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 45/99] HID: pidff: Use ARRAY_SIZE macro instead of sizeof
Date: Mon, 31 Aug 2026 15:34:14 +0200
Message-ID: <20260831133402.272671742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 8de2cef6d0de8cdddee8d653a18791525af26fad ]

Could lead to issues when arrays won't be 8 bit fields

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Oleg Makarenko <oleg@makarenk.ooo>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 67bb1074e3d2 ("HID: pidff: fix OOB write when hid->inputs is empty")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/usbhid/hid-pidff.c |   48 ++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -158,20 +158,20 @@ struct pidff_usage {
 struct pidff_device {
 	struct hid_device *hid;
 
-	struct hid_report *reports[sizeof(pidff_reports)];
+	struct hid_report *reports[ARRAY_SIZE(pidff_reports)];
 
-	struct pidff_usage set_effect[sizeof(pidff_set_effect)];
-	struct pidff_usage set_envelope[sizeof(pidff_set_envelope)];
-	struct pidff_usage set_condition[sizeof(pidff_set_condition)];
-	struct pidff_usage set_periodic[sizeof(pidff_set_periodic)];
-	struct pidff_usage set_constant[sizeof(pidff_set_constant)];
-	struct pidff_usage set_ramp[sizeof(pidff_set_ramp)];
-
-	struct pidff_usage device_gain[sizeof(pidff_device_gain)];
-	struct pidff_usage block_load[sizeof(pidff_block_load)];
-	struct pidff_usage pool[sizeof(pidff_pool)];
-	struct pidff_usage effect_operation[sizeof(pidff_effect_operation)];
-	struct pidff_usage block_free[sizeof(pidff_block_free)];
+	struct pidff_usage set_effect[ARRAY_SIZE(pidff_set_effect)];
+	struct pidff_usage set_envelope[ARRAY_SIZE(pidff_set_envelope)];
+	struct pidff_usage set_condition[ARRAY_SIZE(pidff_set_condition)];
+	struct pidff_usage set_periodic[ARRAY_SIZE(pidff_set_periodic)];
+	struct pidff_usage set_constant[ARRAY_SIZE(pidff_set_constant)];
+	struct pidff_usage set_ramp[ARRAY_SIZE(pidff_set_ramp)];
+
+	struct pidff_usage device_gain[ARRAY_SIZE(pidff_device_gain)];
+	struct pidff_usage block_load[ARRAY_SIZE(pidff_block_load)];
+	struct pidff_usage pool[ARRAY_SIZE(pidff_pool)];
+	struct pidff_usage effect_operation[ARRAY_SIZE(pidff_effect_operation)];
+	struct pidff_usage block_free[ARRAY_SIZE(pidff_block_free)];
 
 	/*
 	 * Special field is a field that is not composed of
@@ -194,10 +194,10 @@ struct pidff_device {
 	/* Special field in effect_operation */
 	struct hid_field *effect_operation_status;
 
-	int control_id[sizeof(pidff_device_control)];
-	int type_id[sizeof(pidff_effect_types)];
-	int status_id[sizeof(pidff_block_load_status)];
-	int operation_id[sizeof(pidff_effect_operation_status)];
+	int control_id[ARRAY_SIZE(pidff_device_control)];
+	int type_id[ARRAY_SIZE(pidff_effect_types)];
+	int status_id[ARRAY_SIZE(pidff_block_load_status)];
+	int operation_id[ARRAY_SIZE(pidff_effect_operation_status)];
 
 	int pid_id[PID_EFFECTS_MAX];
 
@@ -642,7 +642,7 @@ static void pidff_set_device_control(str
 		hid_dbg(pidff->hid, "DEVICE_CONTROL is a bitmask\n");
 
 		/* Clear current bitmask */
-		for (i = 0; i < sizeof(pidff_device_control); i++) {
+		for (i = 0; i < ARRAY_SIZE(pidff_device_control); i++) {
 			index = pidff->control_id[i];
 			if (index < 1)
 				continue;
@@ -1002,7 +1002,7 @@ static int pidff_check_usage(int usage)
 {
 	int i;
 
-	for (i = 0; i < sizeof(pidff_reports); i++)
+	for (i = 0; i < ARRAY_SIZE(pidff_reports); i++)
 		if (usage == (HID_UP_PID | pidff_reports[i]))
 			return i;
 
@@ -1121,7 +1121,7 @@ static int pidff_find_special_keys(int *
 
 #define PIDFF_FIND_SPECIAL_KEYS(keys, field, name) \
 	pidff_find_special_keys(pidff->keys, pidff->field, pidff_ ## name, \
-		sizeof(pidff_ ## name))
+		ARRAY_SIZE(pidff_ ## name))
 
 /*
  * Find and check the special fields
@@ -1196,7 +1196,7 @@ static int pidff_find_special_fields(str
 
 	if (PIDFF_FIND_SPECIAL_KEYS(status_id, block_load_status,
 				    block_load_status) !=
-			sizeof(pidff_block_load_status)) {
+			ARRAY_SIZE(pidff_block_load_status)) {
 		hid_err(pidff->hid,
 			"block load status identifiers not found\n");
 		return -1;
@@ -1204,7 +1204,7 @@ static int pidff_find_special_fields(str
 
 	if (PIDFF_FIND_SPECIAL_KEYS(operation_id, effect_operation_status,
 				    effect_operation_status) !=
-			sizeof(pidff_effect_operation_status)) {
+			ARRAY_SIZE(pidff_effect_operation_status)) {
 		hid_err(pidff->hid, "effect operation identifiers not found\n");
 		return -1;
 	}
@@ -1220,7 +1220,7 @@ static int pidff_find_effects(struct pid
 {
 	int i;
 
-	for (i = 0; i < sizeof(pidff_effect_types); i++) {
+	for (i = 0; i < ARRAY_SIZE(pidff_effect_types); i++) {
 		int pidff_type = pidff->type_id[i];
 
 		if (pidff->set_effect_type->usage[pidff_type].hid !=
@@ -1270,7 +1270,7 @@ static int pidff_find_effects(struct pid
 #define PIDFF_FIND_FIELDS(name, report, strict) \
 	pidff_find_fields(pidff->name, pidff_ ## name, \
 		pidff->reports[report], \
-		sizeof(pidff_ ## name), strict)
+		ARRAY_SIZE(pidff_ ## name), strict)
 
 /*
  * Fill and check the pidff_usages


