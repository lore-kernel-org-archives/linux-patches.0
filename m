Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C362262D0B;
	Fri,  7 Aug 2026 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115839; cv=none; b=ITVS0XDUNdSjDGosbDygmMo29ZEGXmA9dcAi/9pIFqOsS3aDTAxXCRbavJnSttZ34QE1giRt2lYDggwUHwsKEdxXQJxq8anUG5kJu6Gi3UBf1FLIHvl4CxgyD4b60mxw1qJw7wQjXwfR0i1biyfJUmftkf4B4m/Krr4dwfehwBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115839; c=relaxed/simple;
	bh=UejK44IJAVqiFV32fyx30IBzGAz3lNX1+w9X6KINt50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qXHYJzoq2nirs5hWp87D6fpPNv/fyOlfPnr/eFVAa1bdfJwZ3E4kXSvnpNnm69pWvxZ0iOg3D2S7Q+/iOFCeNaUlgAv02ykSlLOvJ1IYqSIYSE7anPKIrkspY9Em3SZZsWvHGSxDcSgqQeH1rgqxCh72fEXjvog42V5/iy7VnEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U7jO0Rmo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U7jO0Rmo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AF51F000E9;
	Fri,  7 Aug 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115838;
	bh=fuEG5Ubm8fyo3N2+voMNFx6WtHRdGE4oIarc61e5pXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7jO0RmoAMwJO3b4jHk/V67EYURocOmzP44EHp593/DiAGd1rCbzOv16vSADEztxT
	 UFKp6QfmCUpmDvxBD5sI7xo+zU5wWXct78hF/eaU9/sPynNdsKXJZP8uAHO/5Q70t3
	 cHgvb35BqIlz8iQPe2jY8abBkuFQHjifxbn6uxyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/261] HID: logitech-dj: Standardise hid_report_enum variable nomenclature
Date: Fri,  7 Aug 2026 16:36:02 +0200
Message-ID: <20260807143415.480757459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 84ad70c9d0383..8b14a6062d181 100644
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



