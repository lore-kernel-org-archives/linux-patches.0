Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212689;
	b=xaGvtBUVPiZqxEhnvVQVHowaRIWjmxq0UH12eEngH2C7zk/4qWxoDVAGoPnFzMdBkwVE
	 pTtU5bcT8GMoGIEywzz336MRhks01r/QEId1LKhrE7dIqAvy2W339Tk3iOe2yxjtMCYUf
	 0ECq3UEfk659yCNgRJ9SWXTgtbptLEigxGyApMPKOMNJoO8xtiSfKGRpctbYT8ghTICm5
	 AaKncbPRbTE/7hwu0MGVlcBJklbwSiSs6PDO8f2pDcEK7bMZTIt9tOahzOaINeRn8NiCI
	 UyxusFzc617DuvORhAUtO9FYva0d3ULHvW0ZvvAiW5eis3bnL6RMOFqLBKxO8rfcTHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RfgGRbopCOuO3U+lFGOL1rE31K0Upf+RMEHXXenXdek=;
	b=lgJSHg8LtKF4MDY8tgRFqKdiLhki+Qv4s2b7F+X/BxDGHyfviwadRPaeu9Jl6qBKPQJi
	 TswmGiQNMq3wiVzGypa5WvdUod4kX1TijF8b9/2Vk/W1YiFZsGrroagKJPLNlGm34wYCW
	 /Nyyev5E+D3f8RhFXXcj/uSxRqet0A4+SOHn5ws6l+8nwQlYJvYb4rqWOavxFUumqQEG8
	 UWc3+Fm4Hk3MNVj5gcjXWNLzxJeK6tadfXblwgWRzgj6QWtULLTZFVAUR6i7+E+DIX9IY
	 XJPDPM1kRvwNLbv+VCk3px0bRtxp5bUFSF0RMbg9pRK84oYD5BCKihGWvbnkY7iXnaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfABVeS9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582BA606A31A;
	Wed, 28 Oct 2026 18:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfABVeS9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72031F01825;
	Wed, 28 Oct 2026 18:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212689;
	bh=RfgGRbopCOuO3U+lFGOL1rE31K0Upf+RMEHXXenXdek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfABVeS9VCt420222Jmt0/aAkEnq2vusTv4Px380ruUVuL2dmg1iMWyYb5dtNOJtT
	 RdZ0ez8zMKX/APbopAD5hRca5JILMhbn0m713pScagE6KEBtVKRoXmVFnG5IFa6EI/
	 +mOBdE3rSbM/ksdH4GK2Ewc6Dasf/WAIiFu5kCzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0205/1887] watchdog: cpu5wdt.c: Fix use-after-free bug caused by cpu5wdt_trigger
Date: Wed, 28 Oct 2026 17:38:21 +0100
Message-ID: <20261028170503.898898669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 573601521277119f2e2ba5f28ae6e87fc594f4d4 ]

When the cpu5wdt module is removing, the origin code uses del_timer() to
de-activate the timer. If the timer handler is running, del_timer() could
not stop it and will return directly. If the port region is released by
release_region() and then the timer handler cpu5wdt_trigger() calls outb()
to write into the region that is released, the use-after-free bug will
happen.

Change del_timer() to timer_shutdown_sync() in order that the timer handler
could be finished before the port region is released.

Fixes: e09d9c3e9f85 ("watchdog: cpu5wdt.c: add missing del_timer call")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240324140444.119584-1-duoming@zju.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/cpu5wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 688b112e712ba..9f279c0e13a66 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -252,7 +252,7 @@ static void cpu5wdt_exit(void)
 	if (cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 0;
 		wait_for_completion(&cpu5wdt_device.stop);
-		del_timer(&cpu5wdt_device.timer);
+		timer_shutdown_sync(&cpu5wdt_device.timer);
 	}
 
 	misc_deregister(&cpu5wdt_misc);
-- 
2.53.0



