Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033851;
	b=lHAYOblaIeZZ0GH9SPpEK9YfCboZL8LDbCdhL7UVM+RBZM6VJc4QV6kaAYTJ5QcUAM4w
	 SXPbNyUv3xF5i26eyDv3COVATkG7Gk9zeIPn/6bdWe7OuXhKZ8595+dU0ZCgOowEyLHSq
	 xsrNAgvFVPw/x50KMkJXbTlTvDfXIoDTDgn3tok6GPJEzP6bvqY30se+Z0DsJ8Hzudg0y
	 zKVzKqBXSkkXPfavLddaVZ9J70XCny4QWD6YgW5GQXFlOBGwyuzSn2SduuPQMvyQXII1v
	 uHitNmsdNeNt9yKuIg/VB9BMKmQKAKJ5LEQitJ6j4cr/LdvfzVBOxhSPCgquoDKOJUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KTy97mPAddS7H0hUWWhkWqUIFUAJRYrgLMarumVw9yM=;
	b=w/SNvGYpUX7M3/if6rCdT3f/C34ThW7e93OHuP/EMtekPkxXddyRe+KBruGOvc/w+wg4
	 yU7oz6BTFt73S8s6a4bqWQOjRgam55R/CDyOn8kO8KbPq305MFwdWH/si6ujoXe3BPGjW
	 PuwoEmKjfsbAjQ/q/AspgGZ9KDu8dgIS7c8fUM3ygTHCFtyUUzIcOdBbDz2ZIUn3XkU8f
	 ftJzWn0hqRhtvHqVOKwYj2OrtQvPa3CTho4vZOysEo32It9QW2MSYt0JoJGjewPg26x8B
	 Nc0vj8wMIztrpIh+AqzA5gqNCHfI+5VaG9gaoZc4DdhI2imnWqdqoLqNgZCfPbGIJeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKPveXMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21854606A31C;
	Wed, 18 Nov 2026 20:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKPveXMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743191F000C4;
	Wed, 18 Nov 2026 20:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033851;
	bh=KTy97mPAddS7H0hUWWhkWqUIFUAJRYrgLMarumVw9yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKPveXMyVYiVL1Iz4P72B04Nd9TJmfnsFtHvy1uQHAi9xISAxGM5DVeYMkptQeeuV
	 de5LMklnQTw8GAL4cf76tluzoPNHr5arO+RPruTmmJHxc9jrVt/HRd8uDJehPaDCLx
	 RENXiRzyJyv+RW5jUGld/vM2hKSpcsehhjvsRqE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com,
	Michail Tatas <michail.tatas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0120/3318] USB: misc: uss720: Fix leak in get_1284_register
Date: Wed, 18 Nov 2026 15:12:22 +0100
Message-ID: <20261118150317.926512216@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Tatas <michail.tatas@gmail.com>

[ Upstream commit 15902712b9e2a46649cba2f22002d05faec2a990 ]

if wait_for_completion_timeout() times out in get_1284_register()
then we do not destroy the reference acquired via kref_get() in
submit_async_request. Add the missing kref_put in the timeout path.

link: https://syzkaller.appspot.com/bug?extid=56962eb32ba0136cd330

Reported-by: syzbot+56962eb32ba0136cd330@syzkaller.appspotmail.com
Signed-off-by: Michail Tatas <michail.tatas@gmail.com>
Link: https://patch.msgid.link/allaDTUua9n5DQ0a@michalis-linux
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/uss720.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/misc/uss720.c b/drivers/usb/misc/uss720.c
index 3bb0405d85c0e..fa66e1d5cfb04 100644
--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -223,6 +223,7 @@ static int get_1284_register(struct parport *pp, unsigned char reg, unsigned cha
 	}
 	printk(KERN_WARNING "get_1284_register timeout\n");
 	kill_all_async_requests_priv(priv);
+	kref_put(&rq->ref_count, destroy_async);
 	return -EIO;
 }
 
-- 
2.53.0



