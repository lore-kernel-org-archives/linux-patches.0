Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0815B37879;
	Mon, 18 Dec 2023 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO/4gTOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8B1C433C8;
	Mon, 18 Dec 2023 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908928;
	bh=Tipmba+KUnbrRotdHvG41RC1RIs1/AYO0hD7YBB7Dm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lO/4gTOZcN6Omdx56l2f3kwjQdi1SkmNTW6hDkkOIxeRakMrUd6phJZICtta1qwHe
	 r9DFPu0hMGH4dz/tFjojhal3PlJpqsKcuFxOUv8bMAEwF0yDnkvqh0Pu7XflXYWBu+
	 s0v4UA+qrQR6RR8FwRLkhpetJJ/6QJ9uK1twZeHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <benato.denis96@gmail.com>,
	"Luke D. Jones" <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 61/83] HID: hid-asus: add const to read-only outgoing usb buffer
Date: Mon, 18 Dec 2023 14:52:22 +0100
Message-ID: <20231218135052.420954858@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Denis Benato <benato.denis96@gmail.com>

[ Upstream commit 06ae5afce8cc1f7621cc5c7751e449ce20d68af7 ]

In the function asus_kbd_set_report the parameter buf is read-only
as it gets copied in a memory portion suitable for USB transfer,
but the parameter is not marked as const: add the missing const and mark
const immutable buffers passed to that function.

Signed-off-by: Denis Benato <benato.denis96@gmail.com>
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 8c16995105043..493814f7f09cf 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -382,7 +382,7 @@ static int asus_raw_event(struct hid_device *hdev,
 	return 0;
 }
 
-static int asus_kbd_set_report(struct hid_device *hdev, u8 *buf, size_t buf_size)
+static int asus_kbd_set_report(struct hid_device *hdev, const u8 *buf, size_t buf_size)
 {
 	unsigned char *dmabuf;
 	int ret;
@@ -405,7 +405,7 @@ static int asus_kbd_set_report(struct hid_device *hdev, u8 *buf, size_t buf_size
 
 static int asus_kbd_init(struct hid_device *hdev)
 {
-	u8 buf[] = { FEATURE_KBD_REPORT_ID, 0x41, 0x53, 0x55, 0x53, 0x20, 0x54,
+	const u8 buf[] = { FEATURE_KBD_REPORT_ID, 0x41, 0x53, 0x55, 0x53, 0x20, 0x54,
 		     0x65, 0x63, 0x68, 0x2e, 0x49, 0x6e, 0x63, 0x2e, 0x00 };
 	int ret;
 
@@ -419,7 +419,7 @@ static int asus_kbd_init(struct hid_device *hdev)
 static int asus_kbd_get_functions(struct hid_device *hdev,
 				  unsigned char *kbd_func)
 {
-	u8 buf[] = { FEATURE_KBD_REPORT_ID, 0x05, 0x20, 0x31, 0x00, 0x08 };
+	const u8 buf[] = { FEATURE_KBD_REPORT_ID, 0x05, 0x20, 0x31, 0x00, 0x08 };
 	u8 *readbuf;
 	int ret;
 
@@ -450,7 +450,7 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
 
 static int rog_nkey_led_init(struct hid_device *hdev)
 {
-	u8 buf_init_start[] = { FEATURE_KBD_LED_REPORT_ID1, 0xB9 };
+	const u8 buf_init_start[] = { FEATURE_KBD_LED_REPORT_ID1, 0xB9 };
 	u8 buf_init2[] = { FEATURE_KBD_LED_REPORT_ID1, 0x41, 0x53, 0x55, 0x53, 0x20,
 				0x54, 0x65, 0x63, 0x68, 0x2e, 0x49, 0x6e, 0x63, 0x2e, 0x00 };
 	u8 buf_init3[] = { FEATURE_KBD_LED_REPORT_ID1,
-- 
2.43.0



