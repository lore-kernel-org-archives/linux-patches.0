Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660F634CFC3;
	Fri, 13 Feb 2026 13:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990708; cv=none; b=cWGaMhh25jD29E/lNas+1nLauawrZE7qU6BxEeJ78zhbYlkGAC9CELHC+pr8pbO1NndmKzfQEoxruwyrigRjoo5iRI3FILN9vYGw/BGJlKtXUxGtEaZSgNXTqwWuSWLpGojOjpF70ZJCmx9NX+H8msnThomVMh+Ex8zsBA/OxjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990708; c=relaxed/simple;
	bh=wS3VyLIpyby7pjtMXjtHLI6EBwU0oMktyzAx+VW+KrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fS3/sxKQ/7MMzE9G9syT01AeiT5tc/F2qg3Yo0enapEz422gKPJr468KlP97f10wnqK7M/gYRz5cVbgp+LTcNP93mMMtl0Yk0zgSdKk8NVDEAIB4cVXCpMxK9UfnH+GDfKd9SavvEHLwViierzfriPC4m2wmyaHwew2fgNbdvts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9khW/B8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9khW/B8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F58C116C6;
	Fri, 13 Feb 2026 13:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990708;
	bh=wS3VyLIpyby7pjtMXjtHLI6EBwU0oMktyzAx+VW+KrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g9khW/B8Z9MBDooPT82unZ8OlYVfdKZMTNw9GpY4Xu+Aav4a/nyS6kjE8AA2AD1xr
	 TyRbN2Oj1M4hc+jqzn0R2/w5pubwEgJquI3+xWTwiDh26vDB9dpQ/BD5QwaGzr4csU
	 k/7B0IvAG5+6yCv2+MbgPL4+jJb/d5xI5jhqLO1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 29/49] ALSA: hda/conexant: Add quirk for HP ZBook Studio G4
Date: Fri, 13 Feb 2026 14:47:48 +0100
Message-ID: <20260213134709.798291529@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


