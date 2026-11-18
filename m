Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044058;
	b=avq5O6EjGtieS0Z21TXRpk6pnbcseZZd3DhP0OKPc38jnJgA9i+zsla6KDxsPXjz75BB
	 YiOxOCMNpczryBvlCoUPc31McIrrILmV22bi9L1C9qHxEGInlKMzq0zGaq10Go82qgMvd
	 HaolDa8rfyH5F6SrCXkVmaAj6Rk6ytlTL36jBJwyAwZUeUv5mTdauJVLM9LdAmN514Y2P
	 qHO+WaxQKsO0EWyE6cl4YCg1rmOwCP3DfjDIy9lD5BsYVm7uS6vCCoUTjnDMnI3k8ZT0Q
	 +WKUnxRGgn9DRH9QfOuw7FVr8DHinNFrE3pDtrAvRR29CPZ+UkdWM3iw+WRom895/PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3CoppLhdfcBPuJ6kZrc73Fbysc08Cpy5wejilo6o4o=;
	b=dB3WIzH/JDc6pjhd36fUJ4IuxGqfQQXeCaofbC3Jpf7Xe3Q2oj2muHo1P1gdiMVNkmab
	 pdu/uKoheGVaOawoVGVgYEgq2mgHKDaKK/p8XTKdJQZVTpsBw+L5S0OnpIsmzY1e60Efh
	 TZgTFG2tMwtSBTlO2i1+0S5XntaLHsKU4UD0ut9B4Ep2KGnApoOaJb/aCQs5iJkS2XWuz
	 uNq++4ym6wVRt8eS/XqfrUzdl/jMeXBbXi1hqHbgh1I4gQxZA1Ko/bzbdkcHx8rCN9IxF
	 PPSRwkrVKPINZAGKOeok9uciudJd+Z/idzrFnxyiyzeOpLfuWGEo1mhjeD6VEr2aYmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bS+C1VTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88C606A320;
	Wed, 18 Nov 2026 23:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bS+C1VTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76E51F000C4;
	Wed, 18 Nov 2026 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044058;
	bh=W3CoppLhdfcBPuJ6kZrc73Fbysc08Cpy5wejilo6o4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bS+C1VTr8pOW1BntSsTUOJ0RWX0P4k5AAbLhu9r/fF1RyhRlnTEzUDYd4zNckP9wh
	 clAhcW8GPw5WFiTvSs0GC1rSjkzXzP65s0ZdQ92Erl2RNMa5HJ0SjUMw1KrRJW1MVj
	 CjZZ/ucQ2vGakv1oL4J52xJiw2PJaT/xV06Eujyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Helge Deller <deller@gmx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0432/2857] Input: hp_sdc - shut down kicker timer on module exit
Date: Wed, 18 Nov 2026 15:24:26 +0100
Message-ID: <20261118150216.935217326@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 309731e95917125bbd13626a7a5600490a5bf44f ]

hp_sdc_kicker() rearms hp_sdc.kicker with mod_timer() after scheduling the
tasklet.  The module exit path uses timer_delete_sync().  That waits for a
callback already running but can still leave the timer rearmed.

A callback can therefore leave the timer pending while hp_sdc_exit() tears
down the driver, allowing timer activity to access dismantled driver state.

Use timer_shutdown_sync() for final teardown.  It waits for a running
callback and prevents rearming after module exit begins.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Helge Deller <deller@gmx.de>
Link: https://patch.msgid.link/20260902154004.3595416-1-runyu.xiao@seu.edu.cn
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Replaced del_timer_sync() with timer_shutdown_sync() in hp_sdc_exit(), since the tree's call there still uses the old name and the upstream context line didn't match. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/hp_sdc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 13eacf6ab4310..ee096d7c7846c 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -980,7 +980,7 @@ static void hp_sdc_exit(void)
 	free_irq(hp_sdc.irq, &hp_sdc);
 	write_unlock_irq(&hp_sdc.lock);
 
-	del_timer_sync(&hp_sdc.kicker);
+	timer_shutdown_sync(&hp_sdc.kicker);
 
 	tasklet_kill(&hp_sdc.task);
 
-- 
2.53.0



