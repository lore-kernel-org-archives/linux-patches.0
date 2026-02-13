Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C465123645D;
	Fri, 13 Feb 2026 13:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990804; cv=none; b=Bhqi9IuOUW9Ov2LuMP4x7kgat3z8z0cC2nu+pUNujfFjVSwffnU3qxApTdCCsaeH/L+lWUy6pbIji9BKv1sN23J7gVol6wWI+IkSXGVVqt0JngIm9P+8CQGumQpe60RM8/OrkPVU5z9gFGaDYkkG9G0u525ZMt3ZM6iiCTt/vsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990804; c=relaxed/simple;
	bh=02A/QUoxLhHQStb9cN41mGMnHn0OJFHZALhsFx7A5Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6Mrb/xjQJKp1RXrDC65rY2YMgLdPTOdPyLPBLBG0kZYsCAfhAZv5ME/OUXKYPi9cMyEmEb2jJgqdrg3/g02xQzsuFyYwN/H7wFRlR/BHS3VttURmHgkifMLKWYsZObG5/x/0skQBMfpIafCH4Ebr/w0/3Qxz/oix3wUaW+tCs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUUdhmsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUUdhmsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35147C116C6;
	Fri, 13 Feb 2026 13:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990804;
	bh=02A/QUoxLhHQStb9cN41mGMnHn0OJFHZALhsFx7A5Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUUdhmsniDafZGYYJgItSJAeVBe6Y6U17OHttrTmPp0WtSELTHCQHoceIY2bu7Iz6
	 QAafqWFK+Oh4T3zfkonfciBe65bPnAR5KAInYT20/uWAZLMdEkRg9Do0QJ4SfjDGMM
	 IsrvZZdXwBA7CkrjT5gEc52Z1XeHYjVskzJkMqsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 29/49] ALSA: hda/conexant: Add quirk for HP ZBook Studio G4
Date: Fri, 13 Feb 2026 14:48:13 +0100
Message-ID: <20260213134709.951149503@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
References: <20260213134708.885500854@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1585cf83e98db32463e5d54161b06a5f01fe9976 upstream.

It was reported that we need the same quirk for HP ZBook Studio G4
(SSID 103c:826b) as other HP models to make the mute-LED working.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/64d78753-b9ff-4c64-8920-64d8d31cd20c@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221002
Link: https://patch.msgid.link/20260207131324.2428030-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -1081,6 +1081,7 @@ static const struct hda_quirk cxt5066_fi
 	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8231, "HP ProBook 450 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x826b, "HP ZBook Studio G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),


