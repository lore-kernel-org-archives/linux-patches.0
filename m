Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986978BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB31C433EF;
	Tue, 28 Mar 2023 15:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015648;
	bh=E7EQYQXRaLRNx1bbv4x7/S3qJQ4eXr3q7YX+k86XXQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIF+lNWsOyEECg2vZG5CKzzHPov5ot7BBdRNcITfPzCLhxPiAT4gupMeo1oaXnCtp
	 Bsq2R9nfkFbm0x0u/E/FxFhbKWzgLLgESvTKPpDmWdHvb4Z+GrF40fUwYUNIgxlXTf
	 ppfZkp5ZNfbyhl7/dU/wGHPGqszN8SxbwS42Q0rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Szalecki?= <perexist7@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/224] HID: logitech-hidpp: Add support for Logitech MX Master 3S mouse
Date: Tue, 28 Mar 2023 16:42:01 +0200
Message-Id: <20230328142622.565261400@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Szalecki <perexist7@gmail.com>

[ Upstream commit db50f7a3983f0154e730f1147ef729e0c5c2f90c ]

Add signature for the Logitech MX Master 3S mouse over Bluetooth.

Signed-off-by: Rafał Szalecki <perexist7@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index fdb66dc065822..e906ee375298a 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4378,6 +4378,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01e) },
 	{ /* MX Master 3 mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb023) },
+	{ /* MX Master 3S mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb034) },
 	{}
 };
 
-- 
2.39.2



