Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208471;
	b=Ui4vV5JuCcZE+QSj6WNlsR1tCosm51SMP6nJTXTFRDovWlWNsFBoMAZnrSDSyb2fGFKI
	 aIQbKJbrSSP7hlibJtUt1pMRxJMMUADJBQAuHCACuB4Epz8j3i/3m/8SEGwrWrUdtdOLs
	 2RbYM9/3gjeTc3MHNwiJVw5odsJXgy9V4NmYR7Uo7n4wUSQrIrTTBBxJk1P1/dctlzzEl
	 W38OrmW8Nc3zeNhItdp++P8OGByphOOvw1oKGale0OshojTPzuQULpsZh0fx5zp8ndhHL
	 l71sE0dNgwd3E7OV+4NSqh9APXxsy2885mwIBgHsfn66sfu0dyhWPJVU80P53lPZIsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nr5iJ8lH8+8e1hEPhCySrbyqRmBjkKPChMliEa6ZQ5Y=;
	b=sGP3wsJyDha2AX6R8dBKz8FwalY06XY0vFrRV+h1HgfJKYC4tCLotxCvGuU59BxJbiOn
	 Y/Gs9EjlUiOE4XsyW32WVYdEVp7x8UR2V0K1r5LfTJmqC/bVAGpzDT+UbcizGJRCUGv9o
	 Mjb7ROuJEBlLaUi6TywslQUjKM6l26dv4Dw2+pkEUUhKHm5Rs8B58FrG4bF8lpoxzF2o3
	 fWWrsebu8YcEHylMlJQCvuhBdcU3xRgHKc/ePNCMUhuCJfjrB4thgxl+fdgKC8SAOfTAh
	 qgJigyKSKrwS1pAnn/Tj4SOGk3xetG59VqgiFpUcDik9QATANn9Fc3gpvXSnv7IWa4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lh4g7QBA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6130F606A322;
	Wed, 28 Oct 2026 17:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lh4g7QBA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B016E1F01825;
	Wed, 28 Oct 2026 17:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208471;
	bh=nr5iJ8lH8+8e1hEPhCySrbyqRmBjkKPChMliEa6ZQ5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lh4g7QBAtNqRzT7wjjZNteQGsyTHvIA/5goDq2Lvdj0c0PA9+M49G4hL36NwP2W9T
	 1gpT96LZdsqg66QtxGF/Gxrg4LvG34lkMtJxqt/gZpHD0EW2NDwf0jBaG6bdTdMPI/
	 zd5I99V8Q3a8U0XQwuymvLx2snj3q8gnUOCjw43c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/516] HID: core: remove #ifdef CONFIG_PM from hid_driver
Date: Wed, 28 Oct 2026 17:54:42 +0100
Message-ID: <20261028170006.592183187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit df8b030d82dd1224881acb4e778fa06c4824f72b ]

Allow HID drivers to pass ->suspend, ->resume and ->reset_resume via
pm_ptr().
Through the usage of pm_ptr() the CONFIG_PM-dependent code will always be
compiled, protecting against bitrot.
The linker will then garbage-collect the unused function avoiding any overhead.

The only overhead in the final kernel image and at runtime are a few
extra bytes in 'struct hid_driver'.

The same approach is chosen by 'struct usb_driver' and other subsystems.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20231012-hid-pm_ptr-v1-1-0a71531ca93b@weissschuh.net
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hid.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index 5f5790f505b94..c553800ee7c6d 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -809,11 +809,11 @@ struct hid_driver {
 	void (*feature_mapping)(struct hid_device *hdev,
 			struct hid_field *field,
 			struct hid_usage *usage);
-#ifdef CONFIG_PM
+
 	int (*suspend)(struct hid_device *hdev, pm_message_t message);
 	int (*resume)(struct hid_device *hdev);
 	int (*reset_resume)(struct hid_device *hdev);
-#endif
+
 /* private: */
 	struct device_driver driver;
 };
-- 
2.53.0



