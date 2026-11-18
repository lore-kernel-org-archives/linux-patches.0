Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031537;
	b=KWwX0Y/ri3po79Px7LFWAezEWN2OVPdVH7G1Q3VcKRN6wfDBlVC+fGYd2uY4g5MrlJJ9
	 jmpJ2uOUqQYhhJB7oQj/V92pAal8N2HE1od0WSP8orGtyN3qwe5uI5LAYVtC7xRynkYNZ
	 bf7bYoWpgfX0qGHrDS2AmpzCYp94OOdxfo9uKCKvH5yACZpslEUEXiGoFkdWOlppXYXQw
	 tpJTbi/sD4x9g0j/OV0eL6AT/HZeJu7M7bbocpDEU1uYYbmACdoTstPHMO5NeP5pCTrZL
	 FOyCn7CuvNhCcInOQAZQZNrt0c11A6qTqtPjjAPVlxw+kXD1zIfSDNh/Ra1DDVMnXwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=akTraUku82Aq97pQ2CxtSqAoKNkAKPX9TifkcJm4eTA=;
	b=Ihx0OMciV7T/PgMb8hAG8AgBSzufJU8laSK/lYoCi5+M6nr2oMOT5W3lpg/nrsS6G2uN
	 VbDVDr7Z0N0kONfmLRdfOJ3yHULq1JQ1vIJ270js6ybMS9vEiRQb9T5cuTb+kOB/RlzjF
	 Gk6CZBjkETb8tAdF6Rq4fl+QLV3M3i3cd8T29/6JzECsjGru1TsC6YTP22sWDoLq6bnTS
	 iG4w2DneJkQpNQ5+MGptqM3VG222ujeD3aJ370I8uctkf2A273eK42k407U99lV0OIxPF
	 VXluu8S6cJWQbLpczDLSkqC3X78iZb9XJiOidXCz6TnqZEw+FDVe9vbgw7HTZ+lQtHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyTxFwS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CCE606A325;
	Wed, 18 Nov 2026 19:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DyTxFwS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BC01F000C4;
	Wed, 18 Nov 2026 19:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031537;
	bh=akTraUku82Aq97pQ2CxtSqAoKNkAKPX9TifkcJm4eTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DyTxFwS7PclApwWtsIfVdlQHAPJchDEUsFwkWPlJSvHQKWdo89QmJ3gZ2rffYDiTD
	 tuLcc9h8XJrbn10WmokO0/Tct1N1kCIJ1aQg3ymQSR5oVioHkbISoKGsf4G1nuIUkS
	 Ab+dPPdMqI62fy9N6EqbHTfh+1kElW9Wd5Bs3fx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+40b06a86af225236fdb4@syzkaller.appspotmail.com,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1092/1756] ALSA: hda: intel: Dont free card in the probe work
Date: Wed, 18 Nov 2026 15:53:39 +0100
Message-ID: <20261118150053.666980870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

[ Upstream commit fbaccb1b19c79e79220e3bcc5bb18ca54ffb017b ]

If the delayed probe fails, azx_probe_work() frees the card and clears
the drvdata. azx_remove() reads the card before it waits for the probe
work with cancel_delayed_work_sync() so when the device is removed while
the probe work is running, it frees the card again after the work has
already freed it.

Only disconnect the card in the work so that its slot is released right
away and leave freeing it to azx_remove().

Fixes: 39173303c838 ("ALSA: hda: Free card instance properly at probe errors")
Reported-by: syzbot+40b06a86af225236fdb4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=40b06a86af225236fdb4
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Link: https://patch.msgid.link/20261012162841.1879278-1-aliamemis@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 13fce4668f481..979290248eaba 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1728,7 +1728,12 @@ static void azx_check_snoop_available(struct azx *chip)
 static void azx_probe_work(struct work_struct *work)
 {
 	struct hda_intel *hda = container_of(work, struct hda_intel, probe_work.work);
-	azx_probe_continue(&hda->chip, true);
+
+	if (azx_probe_continue(&hda->chip, false) < 0) {
+		hda->init_failed = 1;
+		complete_all(&hda->probe_wait);
+		snd_card_disconnect(hda->chip.card);
+	}
 }
 
 static int default_bdl_pos_adj(struct azx *chip)
-- 
2.53.0



