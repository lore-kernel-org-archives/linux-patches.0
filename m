Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035160;
	b=dqrSBA9fFlseJMvCptt8Mp9E09wSpH2tVne39vdh1WY0dawQEsv5RGnMcCs23OEH0OIi
	 6BIEh7kWA+juZp3H+hwSmbhhCdIvyiVQaj1vygjw/JjdyAh3CwRm544J+FuUx8jcjB683
	 Fip16etzGyE7+7bfKmgdJQU1lHhPweWtNl4U6hRCHqWhAjAl9N3OxroGRxcPIz9pWhK/I
	 pMXUbwEQu7aYE3tuGyHEERZbRfs5UYpV9HU1qnBh8YuK/60JoH49JmpVndEmHxzMzd4un
	 kQxIzmcusV4sVBPzx5aQH8wGUxYeQpk2EEjAORSZ4i4kFZD2HEGV15YJRRLQWDRvqgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1YgttW2XqdvF1a9Hz9ldO1uyI/TIr3Y2gxZoko63AsQ=;
	b=ioZBjT/RQSkQJUlHvEEfe+dhKnI6QLEw0Sy40UVn7HkSWRAQnzBpW7LpDF+nbQy0/xFS
	 VmkNRwqt2N5Q5FEzv8TtVfFzeLMAbgTSJ09WP83DCRA47WmnkbFTlF9v1eINqb6K1cYH1
	 Kj/ITVbfABl2XtzpKEyHYZT/iC2T8C72umn/yX34ZXWipwKdObvSfGyuXjwY3hiEsbzHg
	 sa3XBxTokB3wqctBfICtw8lm1gPtQiWtT4+DiMD0tczKwOhcqVvmbNWfiI1dABkZYgi79
	 xrGSfe56X1fEhHKDp1rUcP85fuBpZhkDSBnBuzCw3FF3j5h4+Fkm3dcBIK7/NZCJOug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1jamIcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AE7606A320;
	Wed, 18 Nov 2026 20:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1jamIcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B37E1F000C4;
	Wed, 18 Nov 2026 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035160;
	bh=1YgttW2XqdvF1a9Hz9ldO1uyI/TIr3Y2gxZoko63AsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1jamIcOmu3MUaDSwD0GmPkbrTQMjlxgohsDXRk81YIdTzPJJ67B3o/8XF6AiFJB+
	 a5A8S06RdCMqxDhtjOw/8atroTlo7ygLDRnzZbs6LWNCtIguZk4pvOhgrll0AGyCP/
	 yx9ho78CNsBU1bQLAVzxy9yVnkk36Z2Xvhtv7+AI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.6 0626/3318] wifi: ath9k: delete channel-context timers on deinit
Date: Wed, 18 Nov 2026 15:20:48 +0100
Message-ID: <20261118150336.638197729@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


