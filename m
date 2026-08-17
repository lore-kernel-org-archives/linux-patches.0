Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5442AF84;
	Mon, 17 Aug 2026 14:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977178; cv=none; b=AqlNXr2vjf79dAb6VUdf7XJEoXwqMFN3zq7A0dPu3o+kCmy6DXJlTovMKVl9I6EHpYxeITStvKOge8Q24HTqgJWk7LWVi6rO1/wh3CYXWPTka69TklEnIzkmIiEhht3tPEIGNVKCij5b+IRiEWeCR4cteNOPLPDEw/m6hBgxeEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977178; c=relaxed/simple;
	bh=mu481mwcwODA2jmhjbBLheT62Nk+CpoGZ71vBEY/uOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiw8bouS+g4lBKDbGryRIVVhVcQPKGmV23Obobu0o5HeuUtp8qBlJAFMApMyQXHggoZX1K4KWe4oGN9gKD0u1dKSO+nURS5b+dz5dfXeYSZJ04Bc7Jgs1ejf7GRp8bA+sgiIJpVixiG8faMLTFFJYxdx0pEjT0BOmhohuXd9mro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei2V+Z1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei2V+Z1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63081F00A3A;
	Mon, 17 Aug 2026 14:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977177;
	bh=yYZXtUbf8wYYNeEc+nvMtzjRQXKhdMQtDFKOebtTBto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ei2V+Z1FnSSFQ/ClbB8WSeR5WR/+R9It7I+NxvhuqjDDgr3x00enjmqbB33Hp6+LE
	 uELYsw+h4KxducKUy+IVFUg3kC2JSGs8ejqwFQEEyKGrG8rhfdHk1qLrqpoj2El+JO
	 aNrNopmH2vjFHWGslR62hXecAXXy2Vqtj/GmOyTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/456] HID: logitech-dj: Standardise hid_report_enum variable nomenclature
Date: Mon, 17 Aug 2026 15:30:30 +0200
Message-ID: <20260817132549.448772270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit a940aee176437046598dfc786b719bd96db3c74c ]

Since we will need to differentiate between the two report_enum types
soon, let's unify the naming conventions now to save confusion and/or
unnecessary/unrelated changes in upcoming commits.

{input,output}_report_enum is used in other places to let's conform.

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-dj.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index be9fbf14f1371..97b679e4cdbe3 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1749,7 +1749,7 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 static int logi_dj_probe(struct hid_device *hdev,
 			 const struct hid_device_id *id)
 {
-	struct hid_report_enum *rep_enum;
+	struct hid_report_enum *input_report_enum;
 	struct hid_report *rep;
 	struct dj_receiver_dev *djrcv_dev;
 	struct usb_interface *intf;
@@ -1793,10 +1793,10 @@ static int logi_dj_probe(struct hid_device *hdev,
 		}
 	}
 
-	rep_enum = &hdev->report_enum[HID_INPUT_REPORT];
+	input_report_enum = &hdev->report_enum[HID_INPUT_REPORT];
 
 	/* no input reports, bail out */
-	if (list_empty(&rep_enum->report_list))
+	if (list_empty(&input_report_enum->report_list))
 		return -ENODEV;
 
 	/*
@@ -1804,7 +1804,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 	 * Note: we should theoretically check for HID++ and DJ
 	 * collections, but this will do.
 	 */
-	list_for_each_entry(rep, &rep_enum->report_list, list) {
+	list_for_each_entry(rep, &input_report_enum->report_list, list) {
 		if (rep->application == 0xff000001)
 			has_hidpp = true;
 	}
@@ -1817,7 +1817,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 		return -ENODEV;
 
 	/* get the current application attached to the node */
-	rep = list_first_entry(&rep_enum->report_list, struct hid_report, list);
+	rep = list_first_entry(&input_report_enum->report_list, struct hid_report, list);
 	djrcv_dev = dj_get_receiver_dev(hdev, id->driver_data,
 					rep->application, has_hidpp);
 	if (!djrcv_dev) {
@@ -1825,7 +1825,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 		return -ENOMEM;
 	}
 
-	if (!rep_enum->numbered)
+	if (!input_report_enum->numbered)
 		djrcv_dev->unnumbered_application = rep->application;
 
 	/* Starts the usb device and connects to upper interfaces hiddev and
-- 
2.53.0



