Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC433FF1DA;
	Fri, 15 May 2026 15:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860283; cv=none; b=XgV5aigtbn254vKGE4CHOhomIFY9IuRFdypSzqhBTyOEwkQ0si0d4nBQcNn5MBu9/HZVPMjOcv031WJMPl16Bj7g9xlwJ/Dk0FYc7t9C6BMhnL0qr+YY/YBBDdZJ7C7v/9+WXq2K7bqQPNjclviKaElrAnnOltQ0JZsgYQCiYkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860283; c=relaxed/simple;
	bh=5HCZF10zD2sFI/Exk5w3QK6uT/fbjpJ6kI5xNnOJ6Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uICzDKFdBN0UcVM/gdaYfaajSUPL2GFIL9cbVUolmapxvHRmfoTlRRAWHwoiG2u4KW0kqEHjiu64vxWDCqUkdl9knUh6TOGT8Zhla8O6RlBx9x7Sbh7G5cXcW92CBsPtjKRFkj8zLxIDfI59aiiHgeiMj2CQjKoh+R8qPTwTEUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0iyCv4V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0iyCv4V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5669DC2BCB0;
	Fri, 15 May 2026 15:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860283;
	bh=5HCZF10zD2sFI/Exk5w3QK6uT/fbjpJ6kI5xNnOJ6Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0iyCv4VQb7SBizSW6E18849/2JNb/iCSyGd/gSgcRT89UevFYvLv837xwlTzdGA7
	 Vk/5tZKDkyu0VoL72x2ggREbq2HD6YbPcO9sk4QU5Isd7axmUCauyHn3lqANE2YF2k
	 APA5ODhocfw4wawQEuJHbeyTIhsz078ptq2mhUoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Artem S. Tashkinov" <aros@gmx.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.12 030/144] platform/x86: hp-wmi: Ignore backlight and FnLock events
Date: Fri, 15 May 2026 17:47:36 +0200
Message-ID: <20260515154654.208844583@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Krishna Chomal <krishna.chomal108@gmail.com>

commit e8c597368b8500a824c639bfb5ed0044068c6870 upstream.

On HP OmniBook 7 the keyboard backlight and FnLock keys are handled
directly by the firmware. However, they still trigger WMI events which
results in "Unknown key code" warnings in dmesg.

Add these key codes to the keymap with KE_IGNORE to silence the warnings
since no software action is needed.

Tested-by: Artem S. Tashkinov <aros@gmx.com>
Reported-by: Artem S. Tashkinov <aros@gmx.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221181
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260403080155.169653-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-wmi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -261,6 +261,11 @@ static const struct key_entry hp_wmi_key
 	{ KE_KEY, 0x21a9,  { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY, 0x121a9, { KEY_TOUCHPAD_ON } },
 	{ KE_KEY, 0x231b,  { KEY_HELP } },
+	{ KE_IGNORE, 0x21ab, }, /* FnLock on */
+	{ KE_IGNORE, 0x121ab, }, /* FnLock off */
+	{ KE_IGNORE, 0x30021aa, }, /* kbd backlight: level 2 -> off */
+	{ KE_IGNORE, 0x33221aa, }, /* kbd backlight: off -> level 1 */
+	{ KE_IGNORE, 0x36421aa, }, /* kbd backlight: level 1 -> level 2*/
 	{ KE_END, 0 }
 };
 


