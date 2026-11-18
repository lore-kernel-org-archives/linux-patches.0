Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040708;
	b=QSftCuiy/PUCAun2VkVv7CTURzvQLKVP8mdH9krarQCLetVQUoRCbcmG60H+WacFCbAQ
	 HkCEZJqZfHwQJYXbCqaffXvvvB5Wv39YVRQyWN88vIoaRUNmnQsokDPaEYFBIu14uoOMz
	 KQQVST9GehU71nEvTWnly8B7esSVlT1Jn2CV7qV/ZiQyhmpXIgFfJn6jY5ulda3Fxufz2
	 JlopEnEoGZq9Oaw8SduZCbhBAXe/RUrLRBuLOPS0Ap1hz234Lc/gPUawZy5/43bO7y2Z7
	 owvMJhLsluSNPL6bvg5KxzF6VGxACF+NxA/rw0UuLuUZ4O6uMM7o+MB0LKeUcItLWwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IsclvlVeWW0+yhfBLOXk3KOJ3fVdaDJXrYZoQgOdGOs=;
	b=VmpIOuiL/akZwVjDVAW9X040oJhoMEWGUGY7rnU/cWF4CwXPzvJ2/clv6UbVnkuzoGIq
	 Q4FwJqcvWaueLco2gqYF2Faw3Ic/XMpl+t2LpQkpoI+24J0BK2vjgykDx7JPHcFzjlrLs
	 lTloAidt7uSieRgcz9BbhpciLsqgEeYSPnPtvz633f2cRt05fiDAqLrPHC/4LN3oZA+L8
	 FN42tPjREeI5cCBvWk6VTsMEyR43JctCOR3crMAwd/RKlbW+oIMShLBCSkhWZ06SgCZLz
	 5d/HGTiofN2m33db+NspEGupxED9+YfNn1oGiaQVYYuZlFl3XsKbeunb+BGddZvt1FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keIEe2lK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A65606A320;
	Wed, 18 Nov 2026 22:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keIEe2lK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9909C1F000C4;
	Wed, 18 Nov 2026 22:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040708;
	bh=IsclvlVeWW0+yhfBLOXk3KOJ3fVdaDJXrYZoQgOdGOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keIEe2lK7mjkRG+i1ngWecfbYwfHyQqPYwyC6MGnylCZYXtcAQ0OsUkx6Iti1m3wS
	 JrGZFFqBdwz5fVe8oMeZiIpvCJzfUXueSiV64MfAHvzReJmvGWh4vfIOXjsSmPkEtE
	 bJ2eZqQyiL9cZTbsA9NwlJQKJnaGBhzz9v0310WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2554/3318] selftests/alsa: Do not take another controls event as our own
Date: Wed, 18 Nov 2026 15:52:56 +0100
Message-ID: <20261118150437.898897523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit c9b0768669976a1beb0a1537b4257bd6b76dfbac ]

The wait_for_event() skips an event for a different control with a
continue inside its do-while loop. But continue goes straight to the
loop condition, and that tests the mask of the event just skipped. So
a value event for another control ends the wait as if it were ours.

A driver that notifies a second control from its put() queues that
event first. The core only sends ours once put() returns. So the wait
returns early and leaves ours in the queue. The next test then
reports it as spurious. And event_missing passes for a control whose
put() said nothing changed, as long as it notified a neighbour.

To fix this, clear the mask before skipping the event.

Fixes: b1446bda5645 ("kselftest: alsa: Check for event generation when we write to controls")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930111534.3782264-2-sammiee5311@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/mixer-test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/alsa/mixer-test.c b/tools/testing/selftests/alsa/mixer-test.c
index c43774056670d..432a238839aa1 100644
--- a/tools/testing/selftests/alsa/mixer-test.c
+++ b/tools/testing/selftests/alsa/mixer-test.c
@@ -241,6 +241,8 @@ static int wait_for_event(struct ctl_data *ctl, int timeout)
 		if (ev_id != snd_ctl_elem_info_get_numid(ctl->info)) {
 			ksft_print_msg("Event for unexpected ctl %s\n",
 				       snd_ctl_event_elem_get_name(event));
+			/* The loop condition must not see the other control's mask */
+			mask = 0;
 			continue;
 		}
 
-- 
2.53.0



