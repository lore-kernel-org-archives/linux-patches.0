Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9EE2B9C7;
	Sun,  1 Sep 2024 16:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208716; cv=none; b=llWcLirQZYVklytZXIJYvZwBOJA0V8nzzlqupB4nQubwPFO2aW4+8q2ZAPVymMmgfIHrPVMexQv/DloKnUgJ+zBBoNtFH8TLlgpCQhxeVIpGrfzTusOHl9MwvnfeFq+YnWj0v2yeVTS8Rd1OR0qU4hMF1P2HA52Dz7TPIJOKQME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208716; c=relaxed/simple;
	bh=PEH0sjxB4ZLnTBACnTDKBU37N0ClQqxfkgmJtNX14rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBg5R6LM1iZrFCPCvNkcqN2QAYKeOYbq/N0SMPkPyVHheIvyJDvZEnV8ubXuR2iRz1/Y2ToHseN9i1M5KolRiQsGUidYbM25uT4R5DS8HZGAmSL/ZM/pFrSJmmbQ/fn0m921R44IcvIHUESiO9R3ygg2IdUQZ0bPD+90mwNqfNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nx20edK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nx20edK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9903C4CEC3;
	Sun,  1 Sep 2024 16:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208716;
	bh=PEH0sjxB4ZLnTBACnTDKBU37N0ClQqxfkgmJtNX14rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nx20edKmYqD2QCQxXBTgFX0ZlDxZqZOTaGbqp5Ngea2WSUAk+ifJLYq2GMuH914f
	 OD7mGLpOTWaLVnlACp+Qae9gUcXXMCM17jM5eVoXWoMiEa+zR/EkcljUQyVXEIvlFR
	 qdt/jAEtojI5VJTo/qVJAPRVpz9nG243d4BChVZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Juan=20Jos=C3=A9=20Arboleda?= <soyjuanarbol@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 002/134] ALSA: usb-audio: Support Yamaha P-125 quirk entry
Date: Sun,  1 Sep 2024 18:15:48 +0200
Message-ID: <20240901160809.848921762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juan José Arboleda <soyjuanarbol@gmail.com>

commit c286f204ce6ba7b48e3dcba53eda7df8eaa64dd9 upstream.

This patch adds a USB quirk for the Yamaha P-125 digital piano.

Signed-off-by: Juan José Arboleda <soyjuanarbol@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240813161053.70256-1-soyjuanarbol@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -390,6 +390,7 @@ YAMAHA_DEVICE(0x105a, NULL),
 YAMAHA_DEVICE(0x105b, NULL),
 YAMAHA_DEVICE(0x105c, NULL),
 YAMAHA_DEVICE(0x105d, NULL),
+YAMAHA_DEVICE(0x1718, "P-125"),
 {
 	USB_DEVICE(0x0499, 0x1503),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {


