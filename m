Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2567727E1CA;
	Tue, 27 May 2025 17:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365908; cv=none; b=kDx46/MNY4Rp1Xm1IJ6/xpUmzm0ERGJfNHk9h2TvBjqQE/1b8oJ85k5dBBOUUJB2fUuJNh+Irnvje856OO8jD4KQjEMVdfrD0V1bKX0fgZE3uWjpcypIOQy+LE7qj1bEdvvJb/fILwIIW8hWJwYSkPPu/RpL360uTSFYfAhIAdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365908; c=relaxed/simple;
	bh=h2Dw0ohfJWtkEb9NqqtZSFswAPDlg9YPASY11Y9iTwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=or5kyRmW567Cs1larth4QhjgILZlCeD6IpFy1qFBfzBv7c64/0eC4h4TpWc+utYeZiAKO4VZ5puJJCwcfEb1p2j65Yg316h+qdewgvmS/TWwHIo4EKQm7xqlmZI6dXoxo+WmSdHIWXwpmtwh31CeUVUUJXYWopHDLkKhy389GBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/5FyiqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/5FyiqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A2EC4CEE9;
	Tue, 27 May 2025 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365908;
	bh=h2Dw0ohfJWtkEb9NqqtZSFswAPDlg9YPASY11Y9iTwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/5FyiqNxmS8ol/OLF9huyqAB44gGPOVMi9ca0kJA6uJSua/fUs/qZRHt7mqaT1OJ
	 XocqrU7MNNaTlpAn7Qech3yVKjm7pTgvteWLpQEwJD70UY1EZydByb0Zs9Ha54DtgS
	 X71rbWQ2WTd5e7soesOun4tN1LHLiuttq7jLad9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ga=C5=A1per=20Nemgar?= <gasper.nemgar@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 511/626] platform/x86: ideapad-laptop: add support for some new buttons
Date: Tue, 27 May 2025 18:26:44 +0200
Message-ID: <20250527162505.728095711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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



