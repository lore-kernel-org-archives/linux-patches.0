Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D4F3BD65D;
	Mon, 17 Aug 2026 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976041; cv=none; b=k/tKgXRTUENOIF0vbeOhLm1rV9XPvooSOpIxBcMwgj/1hHukyFGyz8mZrrBu6QT2N2hDMLbnUkuFBKSP7r1MUWGTwVVa42qv79R9L7vVZ4tyhACb3ui2KQrkKahaWM7+nv1YrrotrPSUe5Q61iwpWG3qVN2eZopUmvBYUfH6GOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976041; c=relaxed/simple;
	bh=ot8hXI3naN1XyZuowcwU6JePsSeZSkcV4frfrhY3zdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lB40JdSnbrkD1r0BdCL58I6nl9W8/iqqBj5JZKRUJc4J+qkgosNMtblfnrKI0SM1qc/9nWGEChBH+b5G2b1eNhWzfr3nCoDLRTsQ4zQXppDto7BCJ2Q6tamF79tbAPtxi1tTGokDFlKqBgiTbb6On0EeRxqRq1Ofqs9Mb/h5ZRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+lk45yv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+lk45yv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A45D1F000E9;
	Mon, 17 Aug 2026 14:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976040;
	bh=WQeoAx62horgLYdtn2s9akCw9CtbOnMcTtn7WEhbdmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+lk45yvO74d1mWQYDaEz/wCJf4eR1OhMoxmlE6TtluffSlj4/cdFNlp/kZ+tW9an
	 SzYVHFrc0YdZ+a5h6FnUiPuGm55UPGL6gL2MpyX5xR+/MRJ8VvvUfQ0ncnHbNIHtlf
	 AsSU8flsidGtwojLOL/JT2dkCEeDb2i41E3rcThk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/389] HID: logitech-dj: Standardise hid_report_enum variable nomenclature
Date: Mon, 17 Aug 2026 15:30:36 +0200
Message-ID: <20260817132546.895571626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bd31315fdaf5e..91804ebabc69a 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1668,7 +1668,7 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 static int logi_dj_probe(struct hid_device *hdev,
 			 const struct hid_device_id *id)
 {
-	struct hid_report_enum *rep_enum;
+	struct hid_report_enum *input_report_enum;
 	struct hid_report *rep;
 	struct dj_receiver_dev *djrcv_dev;
 	struct usb_interface *intf;
@@ -1711,10 +1711,10 @@ static int logi_dj_probe(struct hid_device *hdev,
 		}
 	}
 
-	rep_enum = &hdev->report_enum[HID_INPUT_REPORT];
+	input_report_enum = &hdev->report_enum[HID_INPUT_REPORT];
 
 	/* no input reports, bail out */
-	if (list_empty(&rep_enum->report_list))
+	if (list_empty(&input_report_enum->report_list))
 		return -ENODEV;
 
 	/*
@@ -1722,7 +1722,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 	 * Note: we should theoretically check for HID++ and DJ
 	 * collections, but this will do.
 	 */
-	list_for_each_entry(rep, &rep_enum->report_list, list) {
+	list_for_each_entry(rep, &input_report_enum->report_list, list) {
 		if (rep->application == 0xff000001)
 			has_hidpp = true;
 	}
@@ -1735,7 +1735,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 		return -ENODEV;
 
 	/* get the current application attached to the node */
-	rep = list_first_entry(&rep_enum->report_list, struct hid_report, list);
+	rep = list_first_entry(&input_report_enum->report_list, struct hid_report, list);
 	djrcv_dev = dj_get_receiver_dev(hdev, id->driver_data,
 					rep->application, has_hidpp);
 	if (!djrcv_dev) {
@@ -1743,7 +1743,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 		return -ENOMEM;
 	}
 
-	if (!rep_enum->numbered)
+	if (!input_report_enum->numbered)
 		djrcv_dev->unnumbered_application = rep->application;
 
 	/* Starts the usb device and connects to upper interfaces hiddev and
-- 
2.53.0



