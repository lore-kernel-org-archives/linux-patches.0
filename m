Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051867;
	b=I6oNTluYHSddg2tgWpRXdsbmST+OazSOVtRqBjinGeVv7bSLCpjaaJ64j3UAi4PsyeuZ
	 aoYBmmQu/wbsLp8Y6ziil3om2AB4t+rnYrcVGGLszFFoZCgDCYLzxle+lfICIOstxA8C0
	 3viqDBbUJG6N841YaBPyBuZnQuTATVrMWLBr7pL78lRHwa1DkPh/HYpV7QIJD2h6sfdnR
	 zlEYzJ3ewnxVhCIzG3HKq73Y3P6jY4fnk3ZwFFuE5Ea0Hy59Lfc94inr0l5orXSPMUxsG
	 8mkH6Qs/fuuH9SPlrYiEoKPBlu6BI4YA1rl8if9ilTj0c1ENolqHGNgsPDIL701m7aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lDFs/YSXgaGzykj21uy6SJWo1pXlJ2KfRfbTCa5hLss=;
	b=J3CNqTkbsn5ChKJQmwgOh6vKNDmX4RgMh0RN8tW2rf2eI+qg5Qg9YiFtt+uS1Udbizct
	 FTnywBphgIEoSs4tAfYn4O1g0zVETYAQAh436w/kYhgqvtxpt8OevcKLCp+SeCAWgCv40
	 IxCfHtgu6tXkPCV5tX4PfeguCr8WlgVqOOUHUNNwg1A6UyRIEitlvyr8kIwJKQ70alpSk
	 6RNrAvhIG4+9rB+JtQDsH4V+5J7ONTJEnbgeoXm1wKFrexBMdAAUxi2nJZj9gkRTpQg5O
	 R7fIpBHQvjNSywo7FaV9biNJh8Gzk7WDuoLavUeVzgR0KsKfH0hPV1ISXKVgefSyUNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gs5l7qtM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73A8606A325;
	Thu, 19 Nov 2026 01:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gs5l7qtM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B8E1F000C4;
	Thu, 19 Nov 2026 01:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051866;
	bh=lDFs/YSXgaGzykj21uy6SJWo1pXlJ2KfRfbTCa5hLss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gs5l7qtM6NFYquhnpYLjf8VC/t4pFI09PV99Kvw9VGIjTF2qn1ZLTUiyLqko1Aysx
	 A0g/9jOjZxxp5hqyVw1N0es+TZfZm0v4UxukWLIdr6ZVj/d6iktMDp/d721A9dBm1u
	 PMc+w3j1J+rOLIAziboIAiscqhIgrSc7vMOh2/J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.15 0314/2214] wifi: ath9k: delete channel-context timers on deinit
Date: Wed, 18 Nov 2026 15:33:10 +0100
Message-ID: <20261118150022.704143450@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

commit 81394dfb9a7905472957628b560ae894eae3a30f upstream.

ath9k_deinit_channel_context() cancels chanctx_work but does not delete
the offchannel and sched timers set up by ath9k_init_channel_context().
If either timer fires after deinit (e.g. during driver unload or
suspend), it accesses sc->sc_ah which may already be freed by
ath9k_hw_deinit(), causing a use-after-free.

Delete both timers with timer_shutdown_sync() before cancelling the work
item.

Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Cc: stable@vger.kernel.org # v6.2+
Fixes: 705d0bf83dbe ("ath9k: Add a routine for initializing channel contexts")
Link: https://patch.msgid.link/20260911213144.130192-1-rosenp@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath9k/channel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1368,6 +1368,8 @@ void ath9k_init_channel_context(struct a
 
 void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
+	timer_shutdown_sync(&sc->sched.timer);
+	timer_shutdown_sync(&sc->offchannel.timer);
 	cancel_work_sync(&sc->chanctx_work);
 }
 


