Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAF515E85
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDX7jLNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1031C433CA;
	Mon, 23 Oct 2023 11:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060449;
	bh=nU+mHROonVJbSymk85bMPEGOEuUZP42Tl8A4RQjsrQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDX7jLNu3zyVT76DOWySCy29i39zLVH7gPJ3PjPFWNALasTt4M32ADDjX8hbN5K1O
	 VK6wRy8lMnMfgs/kQ+sW48EuiVmh4pddubO6sopafcJujRN3G5+3Z2MCNve7jpkmaS
	 cOmwT95ZZeLfeAY/MgeSUymo1BbDZ6b3gWta75Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James John <me@donjajo.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 176/196] platform/x86: asus-wmi: Map 0x2a code, Ignore 0x2b and 0x2c events
Date: Mon, 23 Oct 2023 12:57:21 +0200
Message-ID: <20231023104833.384611689@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 235985d1763f7aba92c1c64e5f5aaec26c2c9b18 upstream.

Newer Asus laptops send the following new WMI event codes when some
of the F1 - F12 "media" hotkeys are pressed:

0x2a Screen Capture
0x2b PrintScreen
0x2c CapsLock

Map 0x2a to KEY_SELECTIVE_SCREENSHOT mirroring how similar hotkeys
are mapped on other laptops.

PrintScreem and CapsLock are also reported as normal PS/2 keyboard events,
map these event codes to KE_IGNORE to avoid "Unknown key code 0x%x\n" log
messages.

Reported-by: James John <me@donjajo.com>
Closes: https://lore.kernel.org/platform-driver-x86/a2c441fe-457e-44cf-a146-0ecd86b037cf@donjajo.com/
Closes: https://bbs.archlinux.org/viewtopic.php?pid=2123716
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20231017090725.38163-4-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-nb-wmi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -531,6 +531,9 @@ static void asus_nb_wmi_quirks(struct as
 static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, ASUS_WMI_BRN_DOWN, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY, ASUS_WMI_BRN_UP, { KEY_BRIGHTNESSUP } },
+	{ KE_KEY, 0x2a, { KEY_SELECTIVE_SCREENSHOT } },
+	{ KE_IGNORE, 0x2b, }, /* PrintScreen (also send via PS/2) on newer models */
+	{ KE_IGNORE, 0x2c, }, /* CapsLock (also send via PS/2) on newer models */
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },


