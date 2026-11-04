Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827190;
	b=gV51VHhaiTxziVqZnhj+cLtpwakf9sPibQEXMH6Dqtre7sslIGW1/k6pZmpdwPqjA1ro
	 7ieU6uKfE30BJ6um2HXSxB7cgXxru9nlpI2u3wZhp6jgUwjoFBaQlW9RQg/v1QujcZNVV
	 7aY7psMqjU/1yE3i6/rrH5RpOqwT457j/RYQdvbGzlupsYPsBpsWBRJ56I0JClyFG2Std
	 T2E0QgGd6YyKUJMrFMvuCAkDll0cteUGrt/Lgq/bZVaRa0pR8B67VrAX7L2ry3qCHl93L
	 8uc2ha0efDwDIsNZVpJW4Xv6i/fiijCZ8w92UMBcskjw6zKj3udP/9TcupHTMsz6psQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=waMxDnW/5pYXLezeBOXzDhSHOeCifFguKITRrm2rrnA=;
	b=ddheo1uMRFH8mRsjzsrZljrpgo/U3rRQJWE8J5vzBblT7Bu2dBf2IR+w/oCiCtvGSmqW
	 h9oUhnVfFmkSo/BpOOQz4FV8PoIBIKQVpNUnk7m4DYmatFKBEXATwbOphwaOSJlf5x5gx
	 FXCEf1ifIIHdmHAB8jP/T7LvI7z33GAefE/BIiwuaGtTNYpx0sLv/UThs+NoVUN0PsB+f
	 s7laroEh9zzLrJiUakBB6BAjQqk6SGH9O4doP+jL/khptJ79KmCS0ewvLysvgypCfhC2H
	 5wytRAi94D0PvKbneqnzbXupb2tvjQOoFzt+PpIBFKfdu+TjNEoToI9og7qzGhGhlMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJNpcLom;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C93D606B2C1;
	Wed,  4 Nov 2026 21:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJNpcLom
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D762C1F000C1;
	Wed,  4 Nov 2026 21:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827190;
	bh=waMxDnW/5pYXLezeBOXzDhSHOeCifFguKITRrm2rrnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJNpcLomdsv8w0Zq2LFTfAFp71YpPOhstSCN3oVpWcL8kb00oKgF/M8laPvEGbtWm
	 lvafi25YA9OF1s5u7XHrlXO8PBu+Kl/f6dV6q4T1mA8Vkh7LO1ZOxM7sU3XouvPfgL
	 uVvOpnni1x/iBtW6sdNjG0/2tl0tcZSbZmjgU06k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 7.3 248/547] wifi: ath9k: delete channel-context timers on deinit
Date: Wed,  4 Nov 2026 16:07:12 -0500
Message-ID: <20261104211045.218913066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 


