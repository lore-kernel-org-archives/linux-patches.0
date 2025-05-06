Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26678224AF7;
	Tue,  6 May 2025 21:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567385; cv=none; b=nuDKQ0GpYjsLvE6Zol2pJ4FxmFziWRmnTigUWceF9oM2fdcRSguRWROkXPePZ+n4xNLSFOD+D7kO5/N1rxAj5+QEdYyndcs2SGeoyt99sj2liL3ZKPQNZSFivw+YvAMa8uN120DTwFt13b3aUPtKyVxmwXQFfgirf4g8jNPAiBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567385; c=relaxed/simple;
	bh=6CBKxtxV46y/JcjwWYNa+IQV04c9qBXyeFOnqf9zPM8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XuBdhrpQ0R9Qut/WXZa6L8Cc2jzMuhc+RKggNtWmwN6N2FX4FlYVgsqO1q6/4FLkzyHZhtJeqCilM8iEbCUMMlvsOHawDdSzaf5Qj0SQEx8XpndThO8csVNDKNPBeev31VW6IIKakmmKeHHiCjZFcv2SHwNPBgPNB1mgO5YlWmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LADznOaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LADznOaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04037C4CEE4;
	Tue,  6 May 2025 21:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567385;
	bh=6CBKxtxV46y/JcjwWYNa+IQV04c9qBXyeFOnqf9zPM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LADznOaj5uSbYIrPbAqnOcG1luxLO0OcYEFelLReg6gFDAfZy9cXnDNbc5WaVdbE+
	 xpzuuokUlX+Bv2ZdBqsM2/Uy+E+xl/BgcFk2VdMDMTCHLKbsZqvnyX4Djz1YDsxPpf
	 mf7nZuNdseZTJWtHXqJtv2S+4zdG7xsf9zjbxlPeSVgbTDXahuiNBBpm/qGNePSNpI
	 gvDV9Am18Z/9wuCDWIMTnRhAETi1dOz4ITnH1ZdV29xjQLOoBiBx8AQkqTsD9lpcGs
	 jqQjEy7A85rSfpuTciZ0SIRSY/SEmgNiwKrSrJv3MM/S2qKVbdgd+x1NBf+f9o4kxH
	 LZAbltMQiGdhA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ga=C5=A1per=20Nemgar?= <gasper.nemgar@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	ikepanhc@gmail.com,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 07/18] platform/x86: ideapad-laptop: add support for some new buttons
Date: Tue,  6 May 2025 17:35:59 -0400
Message-Id: <20250506213610.2983098-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
Content-Transfer-Encoding: 8bit

From: Gašper Nemgar <gasper.nemgar@gmail.com>

[ Upstream commit 02c6e43397c39edd0c172859bf8c851b46be09a8 ]

Add entries to unsupported WMI codes in ideapad_keymap[] and one
check for WMI code 0x13d to trigger platform_profile_cycle().

Signed-off-by: Gašper Nemgar <gasper.nemgar@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250418070738.7171-1-gasper.nemgar@gmail.com
[ij: joined nested if ()s & major tweaks to changelog]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index c908f52ed717b..bdb4cbee42058 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1297,6 +1297,16 @@ static const struct key_entry ideapad_keymap[] = {
 	/* Specific to some newer models */
 	{ KE_KEY,	0x3e | IDEAPAD_WMI_KEY, { KEY_MICMUTE } },
 	{ KE_KEY,	0x3f | IDEAPAD_WMI_KEY, { KEY_RFKILL } },
+	/* Star- (User Assignable Key) */
+	{ KE_KEY,	0x44 | IDEAPAD_WMI_KEY, { KEY_PROG1 } },
+	/* Eye */
+	{ KE_KEY,	0x45 | IDEAPAD_WMI_KEY, { KEY_PROG3 } },
+	/* Performance toggle also Fn+Q, handled inside ideapad_wmi_notify() */
+	{ KE_KEY,	0x3d | IDEAPAD_WMI_KEY, { KEY_PROG4 } },
+	/* shift + prtsc */
+	{ KE_KEY,   0x2d | IDEAPAD_WMI_KEY, { KEY_CUT } },
+	{ KE_KEY,   0x29 | IDEAPAD_WMI_KEY, { KEY_TOUCHPAD_TOGGLE } },
+	{ KE_KEY,   0x2a | IDEAPAD_WMI_KEY, { KEY_ROOT_MENU } },
 
 	{ KE_END },
 };
@@ -2083,6 +2093,12 @@ static void ideapad_wmi_notify(struct wmi_device *wdev, union acpi_object *data)
 		dev_dbg(&wdev->dev, "WMI fn-key event: 0x%llx\n",
 			data->integer.value);
 
+		/* performance button triggered by 0x3d */
+		if (data->integer.value == 0x3d && priv->dytc) {
+			platform_profile_cycle();
+			break;
+		}
+
 		/* 0x02 FnLock, 0x03 Esc */
 		if (data->integer.value == 0x02 || data->integer.value == 0x03)
 			ideapad_fn_lock_led_notify(priv, data->integer.value == 0x02);
-- 
2.39.5

