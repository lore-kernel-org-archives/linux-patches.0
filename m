Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026398;
	b=f12LU0TZbFol6FqXPbXrdUiyfvzVV/+MkZXnEJgS9jJaUFKlP9qO47LNJ5zX7rod4yav
	 YPMO7tcbxZVfSuUrh+RYljUIpxaVpyXc5fVoeXxgd2MExf/tRu+v633VUBlXRR7sUOVrf
	 U67Ci32kMWDZ24B54oYIb2eyxodDFn5GVVl9/0bp3th/PhHq4op5kK1krXbfyDA71PWIx
	 XsRIBCpM9vxTVxrR+582+fCHwMXvXJd62QwVbeZwWM3UKPdwTTIEz4PxMtGn5FzIaSiRU
	 sO9d9FLy987SouKdiLHWLeNrHD5U7mz8eovwBBOTTrSK49mHSf8Eprpl0jvc3++KfuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dRa7QtzwPhBx78vt4id2MLkmh0jg5SseoGnTD29kPYQ=;
	b=ihU4+LQ8VKhGzQzH4UQxNy3pfPi+FubYCDwxt5lYey4ZLAdJsjQLrfPGJ/H3biYXIz8k
	 ylBwMAhqfMG9YaEbMmdgPc1nq0itGOBkzsNnpbI3m5FM3nCYEdJzcJWf3ZK2GcM6XT/k3
	 uWot1JOTOHPo5xnZnY3lQUQi6NJiIjZ+JT0OqAqReyI6PdtU4I4nDyC0NY1Mes9oDFCW9
	 m0klMpKPNC1pmcxJpYCSsZr6nsAXai5DWbc5auLZ0d/HeFNKXQsFBkQKq+8OJiw/hrwu6
	 HDrbcN1+LEZdhY8LdwJhOWxxoA348RfX+g0bNj8K2aZuyO/00YHtyVzlG968+FTn88g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+rM7JN8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96B2606A31C;
	Wed, 18 Nov 2026 18:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o+rM7JN8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1081F1F000C4;
	Wed, 18 Nov 2026 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026398;
	bh=dRa7QtzwPhBx78vt4id2MLkmh0jg5SseoGnTD29kPYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+rM7JN8p/OhYgns5WPilaX8oTFBgqAjUSiRzN8Gu+ZIaarfSiVtqRDE5j8nqHoVx
	 XGKvpQBQehqZwjhWkfOijGWprQhlzrmlnnw6Gc9WEXuB/jDAcSEZ2uh5SmsXejzmso
	 GvXQQXKSk8FZ6YtSjhH7g1qzDK/oCpiygQBdtJGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+40b06a86af225236fdb4@syzkaller.appspotmail.com,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1380/2151] ALSA: hda: intel: Dont free card in the probe work
Date: Wed, 18 Nov 2026 15:51:55 +0100
Message-ID: <20261118150212.280614244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
 sound/hda/controllers/intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index 449b6fda94913..6390fc91c0a45 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -1723,7 +1723,12 @@ static void azx_check_snoop_available(struct azx *chip)
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



