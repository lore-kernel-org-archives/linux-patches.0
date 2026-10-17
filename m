Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D023A542B;
	Sat, 17 Oct 2026 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259965; cv=none; b=M1DxJoWIRoswSxola3qwQzh52Ou/BqlekaXlXipR10ZS8PcyKvw0+LPqvR2KWgtAba6JOSxjjzxKYPUZBEbNsLDaYoXXJMaIVpB1IpEMiYokbyn1CdB7LwyfyVntDWSVFqQSZmdWA3EFJtelVsTyzOrdJ7uYEy14Lc/gwCLmWFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259965; c=relaxed/simple;
	bh=U2dBdLKmHDtTkclE/3tLzmGHy+vkvE4SqnZCTeFJEwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQw2dUBc5clR0TOdWx/i6NKRIyUbChSXGbxlNi4Sd1c1sRQ7W1vO6pfF0YsFLO323e7WKqM9rHdOf24oZwqEV1V0oFbt+CmLpfZnSEhR/apnvUBQK+Q5u3lvFP/Fw6cSOw0FcxfOTt3vOuaQFM0mI9/85dERRUxbpF88RHR1piI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0plz44s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0plz44s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B46B1F000C4;
	Sat, 17 Oct 2026 17:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259963;
	bh=02kaaMUx1eLPGVHHsnXtnHda9BkZ99VsbpJ+aFiu8ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0plz44ssOfi/wtaPX+zX8cjEYyKmQNBFmdRGgewntzJRYtehA1lJ5Wo0o21oe+vN
	 2IcYmSiO5YcCWXLpYTkLhdE95FzCEELY6RwcpydbatUmLaqkXl+gOXiCLqbMTPkJHu
	 SSwcdXBfNiXMlo7xgyrmMa4UJucejS0l7lGQJvA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1388/1674] net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()
Date: Sat, 17 Oct 2026 18:01:00 +0200
Message-ID: <20261017160506.794947775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 0b1c2af8a22c35cb099c735c2f63ea3ba757557d ]

sashiko is reporting that trying to read /sys/kernel/debug/ref_tracker/*
causes use-afer-free crash when either alloc_percpu() or dev_addr_init()
in alloc_netdev_mqs() failed, for commit 4d92b95ff2f9 ("net: add net device
refcount tracker infrastructure") added ref_tracker_dir_exit() to only
free_netdev() path.

Closes: https://sashiko.dev/#/patchset/56c707e7-1fb0-43ec-b8fb-cf6f451e513e%40I-love.SAKURA.ne.jp
Fixes: 4d92b95ff2f9 ("net: add net device refcount tracker infrastructure")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/b06ce35d-e7bc-47a5-8e0a-e82be7e4dd08@I-love.SAKURA.ne.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index a389e9e3762fa..bad8765c7f13b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11040,6 +11040,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	free_percpu(dev->pcpu_refcnt);
 free_dev:
 #endif
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 	netdev_freemem(dev);
 	return NULL;
 }
-- 
2.53.0



