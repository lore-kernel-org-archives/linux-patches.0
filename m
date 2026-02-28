Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DDD340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301084; cv=none; b=DQkdmHmunldnMp0CHjaBXzyvf3PZ20oznHNX2DHaXXyz4iiIO9VL2zczqPzzV7RFsmYBOrfc6n549fCTsbSuSHXVgj0A6BzFnUvaeMR6jHTqLJ9N7VhN3og39q1ju7bILntc/f/Q3UUqHkzc2fUDowG18Y8Gkj/PHLX1rVKaT0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301084; c=relaxed/simple;
	bh=AXBOqY9ZVDMWb7XB0cLlKFg7w40qZ8Ob2M+5PeSXyvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSnnXFp9gko2P1h/eoGwD8WaB9TkzpfexUFf8K/i82raK2l8cnV4P2/BocXV0hFGvV3rF9K2rvPZ2slu5PqV1+02iqO1+HvoO/ywz7cc5LIoYJ309xp93j7zXQitfP+S9kpGuxH50AeCgJE167NMJbvB1SopTnIHYhi9MR9/Ug0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXtUJhCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXtUJhCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8187CC116D0;
	Sat, 28 Feb 2026 17:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301084;
	bh=AXBOqY9ZVDMWb7XB0cLlKFg7w40qZ8Ob2M+5PeSXyvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXtUJhCspkwQWXDFPzfhFLbJ7e0kzX78N+pnHW1FDhXGp+Gm998E1Svf2vUgMngzi
	 KVV+VjTZrTyDjGIyHsQhtvRdcIgPeGemXkIS2hrVF2wLspuvcK54039EIafDtidUTG
	 N4r09FrwRbabpkVg1sztjG3aWwgZzY4KB+CrSMDkukyM1oIAqczJHBE3Jyp73ypWvj
	 TmjloLcmU/ihHuVrHeeot3f0Z/MC8mK6hDKUNA/QgPo3iiIbXPs+q8Q5mP837PwL9I
	 HOjNCZpF6wu34M04zgH1jIeIIInPn6cWSDU0c2JicLYaAGmtvWf5KruRQ7Jhw/NiOc
	 qFXp99ms3EF/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 232/752] wifi: rtw89: Add support for MSI AX1800 Nano (GUAX18N)
Date: Sat, 28 Feb 2026 12:39:03 -0500
Message-ID: <20260228174750.1542406-232-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zenm Chen <zenmchen@gmail.com>

[ Upstream commit 3116f287b81fe777a00b93ab07ec3c270093b185 ]

Add the ID 0db0:f0c8 to the table to support an additional RTL8832BU
adapter: MSI AX1800 Nano (GUAX18N).

Compile tested only.

Link: https://github.com/morrownr/rtl8852bu-20250826/pull/2
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260112004358.5516-1-zenmchen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
index 0694272f7ffae..add5987110b33 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
@@ -30,6 +30,8 @@ static const struct usb_device_id rtw_8852bu_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0db0, 0x6931, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0db0, 0xf0c8, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3327, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3574, 0x6121, 0xff, 0xff, 0xff),
-- 
2.51.0

