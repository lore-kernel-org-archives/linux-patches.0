Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216351;
	b=Ts2rjHspYmWH9PBIQ6mY/kbWnZ7kn92HfrMSx8SR1oX5Ky3m3nPJKhzB5u6vF3A8YcrB
	 Qj0cqejD1cdQZ6SwUuPa5OzSgmpSfZLKWFBdki74LaoMFCPcKTJ+q3IVRqUD9RtXXINdf
	 Q1PnO3cps2db/9qrzmKU0ncm7B5/xWUlZRt1i4XnwpqMP/DOzyFisHQxwTrWOucixnaC1
	 28lptabqaKvLWYSEnvc2BT18JQFZTWT/sJLA88/qzETqTR1KItgXC1T9vVrbWFoosNvvY
	 5Q/7G/Lyhc2Vp3BPLB86dD5+lJYWJrOd9WJkSSTfsbKxBJ3Y01CDRMiqMScq7aSIoWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7VumMwcj9SGfXe5Rd59Jq7CWgZ99ERwBpE+QCz+URoI=;
	b=JZDa7aUSAC1WJYNckSCC9U1PF1llFYofxfsP0Oh4HXZkmj2ydZ1NXlwcM1uwnqSKsvA3
	 Z+KuJiW8SLNN9005J41XjRZdmRnprTfbmn4DvdQeoKz/5xD4D7nYkHW9lMWt38Z89BA7p
	 +Anb5p+rYHYx1zmBpMlZ+LZ1iOCDnqtK0WEMjGVSQx6wmIMrjDDVLqefP3y4HgJBmzJTW
	 +5UNBhZjynT1R9YUh2xhIyn4RZE7k1odrCIWmiDyunNFRSyEAHaLskJl73vBaFXp9wo90
	 n7g9lsMYmo/9NEyq6sN4tnky9RpMZ8bBkADzEhcCQw5z7C59tVaryV9mfFKGZrIF46w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vY0PwUy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920C6606A31A;
	Wed, 28 Oct 2026 19:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vY0PwUy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BF61F01825;
	Wed, 28 Oct 2026 19:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216351;
	bh=7VumMwcj9SGfXe5Rd59Jq7CWgZ99ERwBpE+QCz+URoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vY0PwUy0MxhU/wnMDng7sbApS59o78ScMvT2wiZQ6LpUXQIpwqxlpoPuID+c76Yy
	 1++Cx+KQ0Ayjx5XITBLBctciRbs9Gr4x08YrfqR5rVnT+dH4LzTzUXVqg3AGyVQT8D
	 ZJPPneRzGYCvXFRpbWl3F3z92kGXG3gSOVO4UTjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1528/1887] net: add missing ref_tracker_dir_exit() to alloc_netdev_mqs()
Date: Wed, 28 Oct 2026 18:00:24 +0100
Message-ID: <20261028170534.233862864@linuxfoundation.org>
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
index 4a1b16a0c04b8..804752cc864f4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10873,6 +10873,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	free_percpu(dev->pcpu_refcnt);
 free_dev:
 #endif
+	ref_tracker_dir_exit(&dev->refcnt_tracker);
 	netdev_freemem(dev);
 	return NULL;
 }
-- 
2.53.0



