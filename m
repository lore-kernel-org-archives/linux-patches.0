Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44976246BB0;
	Tue, 30 Sep 2025 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244461; cv=none; b=KciQh6PMsqA6F9IS2kpW6zyfqKuT0Q+7jPa9BQ323i6xWqXmMw9LiFYtKnTk/l0a9kvxeu9ulkGWp4fM917Ybg3OlWXogIAAcf5b1wn92pzfUwefVcRONkE15Nw7aCvfp/6NJ6LPQ4w4VJT7HjYBoHSdWAaxvEqp7l/xOy4Cjhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244461; c=relaxed/simple;
	bh=cirzdiIPEV0NAgIIlyeDIXd5tzmPkqcYaPmDd/CkrTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeUi9lGl5ybj5CwfIgIIn9YmW5fJaPYHZA1wkAAoailMnzI6pjoXMiP2KtlbvjnQVTYxlUVaWOb96Tr7gje2qKS0MG+bAulLO6LIGrlLXPBcR4Lkb0uzKlAekE6wlpbQIo9YkAAnp//lfEF9lLv8eICWhZIEFN5J0Q9huzNpdhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCuIljVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCuIljVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0455C4CEF0;
	Tue, 30 Sep 2025 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244461;
	bh=cirzdiIPEV0NAgIIlyeDIXd5tzmPkqcYaPmDd/CkrTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCuIljVfG7aql77jJ+hwc7E5tjdsqIpAMPDd3UFoxHUOcTxceoshT6v1KprovazEo
	 C2A9amF/cZojXSmf0bDxuVFHa134YJECMj0yNuTl0oH4146ApUR7AonBjBwcseE5LF
	 DqwW8KyH9Enj/1mMRIovwaVc1ttHgAATPib3zL+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 014/143] HID: multitouch: specify that Apple Touch Bar is direct
Date: Tue, 30 Sep 2025 16:45:38 +0200
Message-ID: <20250930143831.814389339@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit 45ca23c5ee8b2b3074377fecc92fa72aa595f7c9 ]

Currently the driver determines the device type based on the
application, but this value is not reliable on Apple Touch Bar, where
the application is HID_DG_TOUCHPAD even though this device is direct,
so add a quirk for the same.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c9f9f21a6ec6b..edb8da49d9167 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1349,6 +1349,13 @@ static int mt_touch_input_configured(struct hid_device *hdev,
 	if (td->serial_maybe)
 		mt_post_parse_default_settings(td, app);
 
+	/*
+	 * The application for Apple Touch Bars is HID_DG_TOUCHPAD,
+	 * but these devices are direct.
+	 */
+	if (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR)
+		app->mt_flags |= INPUT_MT_DIRECT;
+
 	if (cls->is_indirect)
 		app->mt_flags |= INPUT_MT_POINTER;
 
-- 
2.51.0



