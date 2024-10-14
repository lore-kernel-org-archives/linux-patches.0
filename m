Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC1824B34;
	Mon, 14 Oct 2024 14:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916420; cv=none; b=MuobjtHYeZ5EOTQETv7ehpFmW74QeishdBIhJXW+dvsmjbyYc7yF3aZ8V6CueBRp8mOcP+bjGbg4KAUSqkz4SOexx33CtOcW/t2L8AsNt9kp2K47CPwD+J5MZvCbN+St9kCiU8ABfszobWJdpxpbX+HFL/Sxqvr++vnTo2ej9B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916420; c=relaxed/simple;
	bh=XPbo3Sd1v6k1z7MjFycYmBziMsfGgYYO6Yn7iVtTGs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOkB9Kh1b4raLgHZaPyKH/WvfC8O3Ad6y17p5zkywPe+s/1+MS4Vrv7XLi0exHwdilkxdZTwXuU1OlTyR1B4VJq+WPT8g+GvxrD0TwW9wg0iBbWIlBG5rYIt0l66GaUBlL7UG8rbnVaetNTJp3KXukPnrLgprWiGsOthbKax6jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcsoia32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcsoia32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7445DC4CEC3;
	Mon, 14 Oct 2024 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916420;
	bh=XPbo3Sd1v6k1z7MjFycYmBziMsfGgYYO6Yn7iVtTGs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcsoia32fh1pWzoQw/+342Z0Ulyu2dvZ0/QHZ3ITuSZE1+aH+CO55tjg2lc3xiSWO
	 WDifbq5mMiyhBhx4BCZm3KTMkrMP/IhV0IJhxl4QSXjW0ZlLCeuCZZ0QRqiVz6Smfx
	 EpLrlXieHXCI76YJmkWe4AgYLjYwrY9zmGlcTLCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jutz <daniel@djutz.com>,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Christian Heusel <christian@heusel.eu>
Subject: [PATCH 6.11 161/214] HID: wacom: Hardcode (non-inverted) AES pens as BTN_TOOL_PEN
Date: Mon, 14 Oct 2024 16:20:24 +0200
Message-ID: <20241014141051.269299387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 2934b12281abf4eb5f915086fd5699de5c497ccd upstream.

Unlike EMR tools which encode type information in their tool ID, tools
for AES sensors are all "generic pens". It is inappropriate to make use
of the wacom_intuos_get_tool_type function when dealing with these kinds
of devices. Instead, we should only ever report BTN_TOOL_PEN or
BTN_TOOL_RUBBER, as depending on the state of the Eraser and Invert
bits.

Reported-by: Daniel Jutz <daniel@djutz.com>
Closes: https://lore.kernel.org/linux-input/3cd82004-c5b8-4f2a-9a3b-d88d855c65e4@heusel.eu/
Bisected-by: Christian Heusel <christian@heusel.eu>
Fixes: 9c2913b962da ("HID: wacom: more appropriate tool type categorization")
Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/1041
Link: https://github.com/linuxwacom/input-wacom/issues/440
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Cc: stable@vger.kernel.org
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2501,6 +2501,8 @@ static void wacom_wac_pen_report(struct
 		/* Going into range select tool */
 		if (wacom_wac->hid_data.invert_state)
 			wacom_wac->tool[0] = BTN_TOOL_RUBBER;
+		else if (wacom_wac->features.quirks & WACOM_QUIRK_AESPEN)
+			wacom_wac->tool[0] = BTN_TOOL_PEN;
 		else if (wacom_wac->id[0])
 			wacom_wac->tool[0] = wacom_intuos_get_tool_type(wacom_wac->id[0]);
 		else


