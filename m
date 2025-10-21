Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E387350A0D;
	Tue, 21 Oct 2025 20:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077221; cv=none; b=j5EguUV/Xm7oX+ZcyjoP5C/wLeQNFXjXtgzzoFyxhLA+Sc34POJPfkxzfXbi0JH/jGMh6AopTupWogGBN4ZljzwgjhKeaCMHz/0e2P2qyTvVJZMTGxtlgj3389Ux8yPWblfNVZH0Pz5I54keghXROUdhEU4rrlBseyaPYap16Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077221; c=relaxed/simple;
	bh=DGlW69yyZNaYHzGAxa2CCcMnk5DDEYM3Vk5Tb8xu4eY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuK1j7MPugaGYFppYbMKPSPvaUnVMbvl5Qb8klsmJus16yRjA6SNqPdC5Mkz3hcPoA5PuGoCaP3/WVb5VeUEWOtevpCc1kk2/DU6fLO2TQNXZ1kb+UOlJftgxlxcMf/iXZwE5VhKyLy5E8xnFQoo3sRIydK2EUFpr4bS4n6lefA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uikp48rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uikp48rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA73C4CEF1;
	Tue, 21 Oct 2025 20:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077221;
	bh=DGlW69yyZNaYHzGAxa2CCcMnk5DDEYM3Vk5Tb8xu4eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uikp48rvhhGaea0TaM4Yz6aYt57S/8VpQHeYBkkM+a4zTrFBp5toORQuhgAI35yPN
	 hCFRmnd4Lg4oRxolfpcDEeSoZ/ubZt6NwEklMb8PGD2wKqQ1XxFeGbM/XzAU2YczBy
	 ssf0lfgIvENiPJKjNYVzouwWAadRxj39I/pIL1kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 036/159] ALSA: hda/realtek: Add quirk entry for HP ZBook 17 G6
Date: Tue, 21 Oct 2025 21:50:13 +0200
Message-ID: <20251021195044.066984259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 5ec6f9434225e18496a393f920b03eb46d67d71d upstream.

HP ZBook 17 G6 with SSID 103c:860c requires a similar workaround as
its 15-inch model in order to make the speaker and mute LED working.
Add the corresponding quirk entry to address it.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220372
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6390,6 +6390,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x854a, "HP EliteBook 830 G6", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
+	SND_PCI_QUIRK(0x103c, 0x860c, "HP ZBook 17 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),


