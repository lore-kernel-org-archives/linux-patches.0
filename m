Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BB03FBB55;
	Fri, 15 May 2026 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862472; cv=none; b=ExolCwLKNri0HF4/xVErBIHxcI0RYOqPKcuOM3eli5JW2ZOMzhvmQdvZ/LDtIRJUWXb6VlbPDvYUtQY5GVgfpi3zm2lO4F/hHTnxOC0vzH5lTZaLOR3M4fIvc3gGdWrZzWLnpac9edn/vPp8RxUQK3aPpMdZ/eW34CKUptx5VzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862472; c=relaxed/simple;
	bh=55zdCo+ZqOy+LDeRfebgkb6Kz1/nyd00Yi/v0OOA3+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fCrecYp03PSH78kP12rE1rhW2OrTfd+u52FnCceMYRDrng+1BPrbBZMIv7fjHuJZp2a9vvhXKsoSq8+twZW3+spnxLo/isEsyw3md1rk9RLM86UiYZ5LK0fTtyEIkrOq36v70PFXQtHrtGFfKCsS6nosyidSjK4sib3PRM7nGEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPdsGIc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPdsGIc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF6BC2BCB0;
	Fri, 15 May 2026 16:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862472;
	bh=55zdCo+ZqOy+LDeRfebgkb6Kz1/nyd00Yi/v0OOA3+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPdsGIc/E+ZVaNTXpZhxKQlzthhLfk0RhBa4TsdyTPgK2oUlgOYIpAWEBaK4A4rCb
	 xlwqi1IsCNV51csY2eou5t1l6//YJVwLWc99qINoY/f/2hvBGGcWp7IOOKa2VT4nq0
	 klcVcyoHxrzftF79i8T5fwEGjQ7tGmdfJpTeeqGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Artem S. Tashkinov" <aros@gmx.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 7.0 061/201] platform/x86: hp-wmi: Ignore backlight and FnLock events
Date: Fri, 15 May 2026 17:47:59 +0200
Message-ID: <20260515154659.856858362@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -399,6 +399,11 @@ static const struct key_entry hp_wmi_key
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
 


