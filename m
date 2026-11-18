Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051276;
	b=lDPYITGyuLlWCRs2GovruudXrfI6f+EDky8KIeMJJ020oNivTH5E1T89l37OW8Vz00ft
	 zgGiS2MsLvShHnbtfHJhUokivmoOl6q3mC3M3UJDYo6E6KkYFjMuRsyBcJt/i8rDAYyik
	 Nm8vnDsZqDS1BhWPzQpizo8ejBeDql0V93dusGAvu4TO3Gc3UW+GQMsiC3DATqmps/u6V
	 5qkdsssVQVDdqgs6wCsfo4mktrRgvfjpKBQiadUgbM8oyrI4YQmmw2b2soVWEwTwCoxid
	 s3eaLyqsfaJG3f3SJpmrA4VIz2NUUJYO7Aolo4gOEwdlxre4GLqbns6iYT/DTLFZ8JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051276;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K9MEnZ4dzwtEEUD/EK/co58xNmFYqhx4aCcwXdZtEL4=;
	b=3ed9Xw7B2O6ARnIo85DCmBUr8InVKQrNWAoI/wb8YEmhENn+COBySp9SJV/0Ura+EaSr
	 ftS2TIwtkUmgr46Ola5WkYG27hyviNPJL0MhYV2A3rUFwqkALmSCuw+BLVs18lAjcO95V
	 g88tPiEb9izBlRRDxaUDP0jdqiHMYFYJFwAmHHfXE3uQ0nzvgjmQJ99zLBmnBXlGckdzo
	 rNAxZwV9j4uS+pkGG1NwHKBvevtUDPrpn7aSf9KyWM/zxxtqquUYgWdh4PlSWZi1bXuxH
	 copqmhVbgz2p1aFUzoQ81KJgne3k0yOc3S+Gfi234HF5mlce6ruY04VdHknHPgt9wzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYRVOrHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4F9606A31C;
	Thu, 19 Nov 2026 01:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UYRVOrHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF431F000C4;
	Thu, 19 Nov 2026 01:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051276;
	bh=K9MEnZ4dzwtEEUD/EK/co58xNmFYqhx4aCcwXdZtEL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UYRVOrHIaFuhxgJ9TELIY7IslRQdkn2J3zsC1Gn6qPA+Py0C55qnEdqdZsk4+DyLR
	 A6HUdolklDZUHk9i3EH8IG9pFzzS5p0IdMmn/pG2YhSXhA/p/LjXeREzVRDkeX/JCA
	 t46QMkqPjGJyNJyLQPvuUwr+uXCgIwqIYXIkTPCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0151/2214] ALSA: hda/realtek: add missing NULL check for codec->bus->pci
Date: Wed, 18 Nov 2026 15:30:27 +0100
Message-ID: <20261118150016.195483511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 3b36ac93739e7b119a30affaee9c2dd41f24efbb ]

In alc269_probe(), codec->bus->pci is dereferenced without a NULL check
for the ALC236 vendor ID case. Add the missing check, consistent with
the existing pattern used elsewhere in the same function.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-2-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index a7ad6c552ef03..c2aa68164e812 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10479,6 +10479,7 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
 		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci &&
 		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
 			spec->en_3kpull_low = false;
 		break;
-- 
2.53.0



