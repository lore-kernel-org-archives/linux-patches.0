Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061578;
	b=UPBixO45bEdflS7GAZoJOiY7BUxlsOjQwCJE2WdOs8yokRwyqrw24LTzTd/GPOpD05Vl
	 /F58ctH87TCaM8K96yTTUohA1aq53OjuID4V7TIyn3mX9NOPwq2i3W8OUlcHd5Ef34NLf
	 XvHmz1iPCC+6DlhG57bpWd7RBmop5ueFBnCBXbOKXpUq+XVxVVLwFSXxT0Q2Kc6utSOqt
	 ikSzjIFYU9dVfAMtiQUT+A/LOBNw7gr2JPJdZ8t4je7iOQPN3rrzA8h6vlw/7L/N22g5k
	 0/Wzv+sfjD7vJ1QqQsIBx9rw0e5BH8OGIDN6ABjRkp+h3/FcG5ZwB8wCqUqFqeimluw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AfA7m5zHtgK47Vzui9OZICAuE8Q03NWAip/9hd4gL6A=;
	b=tYKohaebFBVXkF8e56GH0XNv2ZQ7taK6ekMHqHz4wWMBvNzXdTMYZm4OiPioa2ZKtBdB
	 KWf8ICTU4BMIcM1QkOZI+TV7xJ2L9RWo6B7XLrdp4DMdvOGQ/h2ZK/0VuQTam1lcYlJZp
	 ZfXXIx0co4hkqSzdbpUljTFoBE13PAHoi6G0rq2mZn/TAYE2ifv0CRhkMOfRRtE1sRZgF
	 AZ+J9Os7rsIVshfy3WYX2pK3tnaipXrg1TgxcZW378M/E5e6W9llKq73h+XMErH02Zz49
	 zWz3ynFzmDWwhvjd89lDIA9w40Gw83bibLIZAice/7lxuzw8ef/LTVkDBP58ba6bA4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UsaqYjkQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9184606A326;
	Sat,  7 Nov 2026 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UsaqYjkQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C141F0089F;
	Sat,  7 Nov 2026 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061577;
	bh=AfA7m5zHtgK47Vzui9OZICAuE8Q03NWAip/9hd4gL6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UsaqYjkQGWRuaFavxxEp7xX3QbBXSIvsy2VyUWv3BBUnrMv4d9PlK00su7CBtHIKa
	 4YqwUG79k4aETfBRVjzWnKW9AifVePnPgRBV1Yhb3Jd5jOoyD9rcplWPzsaX8kBRrz
	 ZOkXvQQCSZ4AXBfBUdSl4qzPaN51dGALraIiGqRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.12 0654/1536] wifi: ath9k: delete channel-context timers on deinit
Date: Sat,  7 Nov 2026 08:44:30 -0500
Message-ID: <20261107135015.896146312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
 


