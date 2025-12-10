Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919E221F2F;
	Wed, 10 Dec 2025 07:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351927; cv=none; b=dEBjfOxIdwlGRqwnyqPF4WHoOtaCw3SwzkcJs707mq6s9pAw1sJdy2yz7Ouje+DkFuqLmzqd3nwB07sBSAd3lkkkqqIp/UFfZ3vuObJC/hbH7NxlgDpH+adKZklzPIuA567JWsC3H4oI35jklMWZNZxRbofz40Yo7MlqznKiaSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351927; c=relaxed/simple;
	bh=mrFD9MgqmodZ538CqbDbWodX59QUZCm5eDZF5GvNPOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LIvN4UXuMkYKoJjiMknFuGNS3rmAH0cO5kOrUcFxrnvUKKMtihzVhDmMStZrBtrw11wqoFclKc236ZqaL0+dRsTAOAyCC5zjZi6dYdoKI+gT4mNoh38q8ETllrX9R+pKcNvAmyra6YsDol2p0XdW6J8nyNofHwbjzk3KG00MjFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTR0rMcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTR0rMcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACCA5C4CEF1;
	Wed, 10 Dec 2025 07:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351926;
	bh=mrFD9MgqmodZ538CqbDbWodX59QUZCm5eDZF5GvNPOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTR0rMcj038RGLmUSlL4gU1tmkRsbf5LpFrsCJAYK35zqWkWxCOQ+FCngjm1HUcI9
	 gEQY23Hmfa/EQf2wyjvY5X/MDZ7XCcKhDUWkaI2+CECJ7hnftGy4CMoNQ+MA3sKVdM
	 lwNJ0RbMT0bCH2fW+04plslks70wXODJcVYz8vko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ston Jia <ston.jia@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 34/49] platform/x86: huawei-wmi: add keys for HONOR models
Date: Wed, 10 Dec 2025 16:30:04 +0900
Message-ID: <20251210072949.013184087@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

From: Jia Ston <ston.jia@outlook.com>

[ Upstream commit 5c72329716d0858621021193330594d5d26bf44d ]

HONOR MagicBook X16/X14 models produced in 2025 cannot use the Print
Screen and YOYO keys properly, with the system reporting them as
unknown key presses (codes: 0x028b and 0x028e).

To resolve this, a key_entry is added for both the HONOR Print Screen
key and the HONOR YOYO key, ensuring they function correctly on these
models.

Signed-off-by: Ston Jia <ston.jia@outlook.com>
Link: https://patch.msgid.link/20251029051804.220111-1-ston.jia@outlook.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/huawei-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/huawei-wmi.c b/drivers/platform/x86/huawei-wmi.c
index d81fd5df4a000..d7a6111b2fe13 100644
--- a/drivers/platform/x86/huawei-wmi.c
+++ b/drivers/platform/x86/huawei-wmi.c
@@ -81,6 +81,10 @@ static const struct key_entry huawei_wmi_keymap[] = {
 	{ KE_KEY,    0x289, { KEY_WLAN } },
 	// Huawei |M| key
 	{ KE_KEY,    0x28a, { KEY_CONFIG } },
+	// HONOR YOYO key
+	{ KE_KEY,    0x28b, { KEY_NOTIFICATION_CENTER } },
+	// HONOR print screen
+	{ KE_KEY,    0x28e, { KEY_PRINT } },
 	// Keyboard backlit
 	{ KE_IGNORE, 0x293, { KEY_KBDILLUMTOGGLE } },
 	{ KE_IGNORE, 0x294, { KEY_KBDILLUMUP } },
-- 
2.51.0



