Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2032D6E76;
	Tue, 17 Feb 2026 20:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361218; cv=none; b=TtIOYJehmR8XKqN/eZQ8iiLkTIP50RaYO4K2Z1Rec9O2ZU5Teis9nMJXyTjiyik68gcdfbU4LVmHRfrm6MKMPBVLxLgodBIrufCzyDnrp7GzfQzDNXeZleISGfMnQkXqZywWyPRjFoShrhkJ3ag0WSxKqK6J0BNO8ZPay8koPRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361218; c=relaxed/simple;
	bh=Vfw8mKd8+NlHfx5XxMMWTU5JNGGt/hLwwrrfqOyy2Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqC+y/NtolXR1qeG7KerXxSvVj21ZPSxQQwoK69kyAZlTMKhXxseo9IzwdAjjJwCRd+XZDdsQ/1oLINeqJKVhjeRTePrNjgZme09uHsaglrIeXPrg66TfnT2DKJeydxPkCeJuD6miH5QDkkLqUgBRz/bcG7JYEVxo4PM/gT19vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6KmE3cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6KmE3cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5935C4CEF7;
	Tue, 17 Feb 2026 20:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361218;
	bh=Vfw8mKd8+NlHfx5XxMMWTU5JNGGt/hLwwrrfqOyy2Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6KmE3cTZm78q2xnILGjjSyva0tU0erXbyBQQbvU30017AGGiTsMOdNKtw/8Tkpx8
	 CjzrEdgu+SUH9ob17rtL04J5/TfAF1PNVvDJj5Ii75RTUrWEA6jKdKd3D0J5wx7K/3
	 4Dgv6/pgJJqM5TQUMEHFvbRhLkZ7lgTnXPybN8iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/64] ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU
Date: Tue, 17 Feb 2026 21:31:24 +0100
Message-ID: <20260217200008.576154666@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

[ Upstream commit b48fe9af1e60360baf09ca6b7a3cd6541f16e611 ]

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR55xU devices.

Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260119151626.35481-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b45e5b268a65b..2fd52b6b4fb57 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10906,6 +10906,10 @@ static const struct snd_hda_pin_quirk alc269_pin_fixup_tbl[] = {
 		{0x12, 0x90a60140},
 		{0x19, 0x04a11030},
 		{0x21, 0x04211020}),
+	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1d05, "TongFang", ALC274_FIXUP_HP_HEADSET_MIC,
+		{0x17, 0x90170110},
+		{0x19, 0x03a11030},
+		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 		ALC282_STANDARD_PINS,
 		{0x12, 0x90a609c0},
-- 
2.51.0



