Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044434;
	b=hRtX8hsyk5zfyhKAOWFeflbn0uAvXfTuMYxvATEkhl7J/XPuFg1v6+dhEYH03M4VO0in
	 YDe2w3/P9qIgTRIqFX5DrM39nVmlWW/OlXnjZpVL+WwWnMTrd2vbgXZHhoT++X5AOYJLB
	 ezJLMICMMn65JvMnsd6PR/PCLUBhzTP7CjjuCyBPfGd0u0BppXpC5e1U0Icntq23AKEz9
	 2ktYCt/+eTNbqKR6RU4d03EgVnXvPxuf1+M5386znsfDXDUBpGqwFrl8UWdJuykJDPfZQ
	 RVZLKG2vn6kcXcuZWdaF93d1Wcyl9yEG/iyz8Typ1QWimox14mmqcGXnfH9wESqtDdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fsOb32pVRvYHsWpHYXAD4OKee35r+1w5/ECysSQRlUo=;
	b=y37F6iMxjQGMmTBQmM/70FQwB3Wj4jjjSuhp+jmrQ6iXDiXgMi5Ni/iqNOnsLe+f/Wku
	 hzMP+OQm5kpyZfPfDjM+RY5Nfg/U2JetKloCmIGJOLs1zQ0GCVahfLBflQ7yvBoAmcKJ1
	 opFSb3w58X//bSvV78+3bf/kLM9wMglu7iGE58F+xtMY0CcPt7kckT8E7vszoDZQjxBA4
	 P+uOXgGnDu5NR3uswm28BnrsymJ7mdEdBOTQYH8E+AfI4iN23DLSjwoYH79KQRQ9fVr/q
	 16IQS9bDUbpVwqEOFDNcoIDOrbpH3R+2EJ3dC4LJjgQm07HHb5M4NvVUzToFPWea/Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HO1DF8Ar;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97454606A32A;
	Wed, 18 Nov 2026 23:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HO1DF8Ar
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41EC1F000C4;
	Wed, 18 Nov 2026 23:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044434;
	bh=fsOb32pVRvYHsWpHYXAD4OKee35r+1w5/ECysSQRlUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HO1DF8ArVzQKEkNXogwi9zdxXcNlAEXtRcnppkUfq0s7ci1wG0TNOjVaBFOU8fT6G
	 wW/C9U9T5h93gGuAZzXFLmBqNomIENrf/9BSkH6zcH/+QsuQDPnY/1aB+/4PjkgGoi
	 XUX0TZDIAePGVGJibPTLk9M6A75B7bb5K62Cvq4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 0564/2857] wifi: ath9k: delete channel-context timers on deinit
Date: Wed, 18 Nov 2026 15:26:38 +0100
Message-ID: <20261118150221.796155932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


