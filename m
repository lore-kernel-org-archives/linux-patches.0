Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831488;
	b=XWsXspkWKjTq8OCrkfuJy8jJedjMqldQoxuwBX42hwS1OLmzTuQfIzed1nbpzXq5aAXh
	 IjZ14wKsLFWZwaUV+3tRTaY3an4o2/Lmn5wCIQFDyuMsWThyYvVazcL98MPUshkhqbtOY
	 c9Zhv+RUhtTe5Zs76duyGoCmx5XVsMJY0X6H8nj4ISAaHGM0vcb7gS5thsMli0JpdVl8j
	 CZokRPLMN/H+wFc1sppyeGOF1SCkbcoZMfAt/X88x7yupwtte5ajwmjo7dojn6hPHtJUl
	 0rDzCgQGXr0EOXVBB76EyYG39SeAVvJAW777on+977YpjOLB317wx90NuKUSia4EPBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Z04rXpRCGcvEQ7yCnAnut0hMyTYu6DjfqytJ2AKwYhU=;
	b=hylitJaqgGbSLevRaK/yZNgkt0jriv3aIh0XSvrlptXiHC8j8bqaZRN1rj1ru17wecl8
	 CqOCkYKi14/wut2B7lBuxtgRVu7lyto/g7WejEUo3I//7ZXhgPy+BaMWJe3FlYLtKiioj
	 nFCugzZDAlN8Sa8uqsruqkhCBHJ1fLNsyNLO7kkicVgfec45Lh8cjkZ8zsK7GZbCSsRee
	 FoSMzG6hi/2FCO3b0h4v0mfymEWdoqBFxFhpE7yszYLV2uzn1dgQ5jCzjITA15RSKcZ79
	 NqyCHi3nzzSchuJ7IVSph9yt693tFUcA/WeKQsXRoQh7mL2qs1CKBtOxrSgkdnAgyug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tz5XPsDM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27776606B39E;
	Wed,  4 Nov 2026 22:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tz5XPsDM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71291F000C1;
	Wed,  4 Nov 2026 22:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831488;
	bh=Z04rXpRCGcvEQ7yCnAnut0hMyTYu6DjfqytJ2AKwYhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tz5XPsDMPlcGIPAsnDfXWk3kjtc48OCbNt3m7XnhJAedBZdZdZjMQZLh2H39qYch0
	 4m7RQPFMivBTzOV8lu1qcriGS6cclbjQ+uRUJklvd1gVaTagObW5p/2Y9In1GMYkKS
	 Ng54s6n5I6Jfm614t2sdwXD09dfV5Pw8Jkdbaa8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 0734/1005] wifi: ath9k: delete channel-context timers on deinit
Date: Wed,  4 Nov 2026 16:07:47 -0500
Message-ID: <20261104211104.052840553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1363,6 +1363,8 @@ void ath9k_init_channel_context(struct a
 
 void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
+	timer_shutdown_sync(&sc->sched.timer);
+	timer_shutdown_sync(&sc->offchannel.timer);
 	cancel_work_sync(&sc->chanctx_work);
 }
 


