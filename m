Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829566;
	b=yr5wsndzXHK9eDppA9lTOxa4310oYDmTroUS+RSVLtP2K3jYcxN+i3SNz6A6URxDAmLO
	 bHV2BFG2LEtRiGL2pQJXfQFKiAjJtAKEOXcQSUUe9O92FLY4CvywY07AoKt4AZxMIHq9g
	 xkpnvYZ4rvO9S5s5zy0gUY9zp8RxEJwMwUrzjLB07xK+s1ixuL7cv0v7nkfmIwlvH7bbp
	 QtlfV4HmPy5x60TROL/3qDGi6twRxfP01RWMrmTWf7qnTeFqidtp/FEDeHWTP87weRYJ+
	 9ySjGEKP7ypitPFpntuBJ5WQVWABNwvtkQfomul3soi94ajT6ofPBerfHpA+0Y1GUjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9hTudvdPyWYoZ2WPjJXimCOiwpfjTPEgxM1dspyZBlY=;
	b=W92iPydqQ3p/MC7s/h6w9AlmrlsF+wTdL4Liyh/c7u/Qy8u/KqSuPTSk/Uke2gU2skye
	 fG/siWROREswbCM1dUYRjAbrnn/W/MUOPr4FH+mJdmJ0KNw9pbk2LrXl/sDX498aBejnv
	 /r4PcVS+UMfVzhJg+RrOjnUThCpYZPZXA5wFPkrBgwGvcfWJJdenGCz/IfOKlQgjspR/g
	 m8EgEe/ecjC1SpQYJGvR4hS+uBrf0G/smiFrRzp82BfYbyNoclcRy2ep34hbKEhhtOW7I
	 rYkf81xUjT3QqspTupWAdNLaJDUGR1AYVYrGW/wTimHKG1LQq5XWGMcTZvcACOCiqAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDJyaCDM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160F9606A33E;
	Wed,  4 Nov 2026 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDJyaCDM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54AE1F0093A;
	Wed,  4 Nov 2026 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829565;
	bh=9hTudvdPyWYoZ2WPjJXimCOiwpfjTPEgxM1dspyZBlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDJyaCDM8dZKbisWI4rVvCmN9h7/XUaq44WmaGRKlG73lqpwV9R3osaj9SNxew/aH
	 9xEEKLwSz0QstCDxd8HxCYy5PtTMTwYSVSIWTUwonUN6JdnqTTjtkZIAgfxfIAawAR
	 DE/1mu6WIcnI+Ds41wnC5tPJDc9/mVQlcsGHacMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0205/1005] platform/x86: asus-nb-wmi: map ProArt key (0x8b) to KEY_PROG3
Date: Wed,  4 Nov 2026 15:58:58 -0500
Message-ID: <20261104211049.541781918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>

[ Upstream commit 6303451189a6d8f304221065c44ccd597e0acbe5 ]

The dedicated "ProArt" key on the ASUS ProArt PX13 (HN7306) emits ASUS
WMI event code 0x8b. This code is absent from the asus-nb-wmi sparse
keymap, so pressing the key only produces a "Unknown key code 0x8b"
message and does nothing in userspace.

On this model the key is exposed solely through the WMI interface and has
no HID scancode, so it can only be handled inside asus-nb-wmi. Map 0x8b
to KEY_PROG3 so the key emits a bindable event, consistent with the
existing KEY_PROG3 mapping used for the ASUS programmable/Armoury key.

Signed-off-by: Nizar Al-Kabbani <nizar.m.kabbani@gmail.com>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260719090843.66777-1-nizar.m.kabbani@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 8dad7bdb8f612..a840d16e063e0 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -622,6 +622,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x86, { KEY_PROG1 } }, /* MyASUS Key */
 	{ KE_KEY, 0x88, { KEY_RFKILL  } }, /* Radio Toggle Key */
 	{ KE_KEY, 0x8A, { KEY_PROG1 } }, /* Color enhancement mode */
+	{ KE_KEY, 0x8B, { KEY_PROG3 } }, /* ProArt key (PX13/HN7306) */
 	{ KE_KEY, 0x8C, { KEY_SWITCHVIDEOMODE } }, /* SDSP DVI only */
 	{ KE_KEY, 0x8D, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + DVI */
 	{ KE_KEY, 0x8E, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + DVI */
-- 
2.53.0



