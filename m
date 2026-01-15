Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11C1258EC2;
	Thu, 15 Jan 2026 17:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497362; cv=none; b=sj8GF5nrCP8efniZvNd6Qim0Gh8A9QK8GPvKxnHjcDklpuK+jITNdzgO8NPVqlinK3A1E6lV8qedLlF/xpVpQxNsVcFo2mcVtzV0XuOCD5f9P2zPEWpYypKv7rV+XV/abVw9YiAV7TLyLeDSbSqpXhbCYygYlUq6RsEV6seD71I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497362; c=relaxed/simple;
	bh=uHXSY8z+uj1jV+bZIClCmvKcjc+hea+yK3QSg8Qijtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqjCf2jy3NaHvk8zw8zuHtJOR+gA5IIyrluCEZiuFosbBidOSU78SMpq5+8uiuK4f0cvM3fP8n+L9Jlbx4WvriowIZeNZQNsvmy0kxHs3CgLrvgqmohqWCP1EwCdwkxKcor4I7K5/LNayjYkCUzx6bV7E4OjppMnr313r44pZbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTsIUEAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTsIUEAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E16BC116D0;
	Thu, 15 Jan 2026 17:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497361;
	bh=uHXSY8z+uj1jV+bZIClCmvKcjc+hea+yK3QSg8Qijtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTsIUEAObHkfjI/i/ZL82iJ+bCPiJGZY1QpxHKfjTrxq+1Rjbolykg31FespXdvu7
	 jHJSr0pjv+oZh+NvdTYupMdMyW+PQBO5Agnx7t2uwauycLmFTdwDP41JluU6THym9z
	 iORIfihLfFvH9E+z+aDs8yyhc/VgfnZgnDaEkvNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ston Jia <ston.jia@outlook.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/554] platform/x86: huawei-wmi: add keys for HONOR models
Date: Thu, 15 Jan 2026 17:41:33 +0100
Message-ID: <20260115164247.223192308@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 23ebd0c046e16..da9f80bde794f 100644
--- a/drivers/platform/x86/huawei-wmi.c
+++ b/drivers/platform/x86/huawei-wmi.c
@@ -82,6 +82,10 @@ static const struct key_entry huawei_wmi_keymap[] = {
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



