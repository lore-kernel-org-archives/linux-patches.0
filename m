Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214043;
	b=KO3idtMCncgkIIcYq4UFA02fvkbgcsge6i+lTmYd6rsqXLJC+UTHX5cZ0ZVdTXk3NeQ1
	 vyZ3Eiy/8zjKZfaptuIkVJ9iWCbabQc6dg8mzplTEVHbDVAxhRWMlhQNGe3HPGzJjjuzU
	 YXKoVOygYp9L0ahTR6VSCanTw/yazQN3P1F7f93uP0tLdhaCi9pdNwJIq+/tFG82HzQIG
	 oS5EWNS0mq2wPTn7z/RbAV9hcimGqAkEUdgxVxsmjkLDMbXmDBalc0dIqN/xOSLxfmlSz
	 JCKxCAzgMHHN/mrQZQmlHhfGr8Raw3vnoAwzEeKTNWT8VzkBERHgAPNuVnoP7v+BZSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cu8bEga+KZiwlhjvpMAeWDIE/M21cNKJsSy27G68TCU=;
	b=curvK+qPN9Nr3njzTFspvCLPvrEno3RXvty2dA9Cv2OpvHJ7uK3NE1J9W72gr8PQaF8W
	 2uHniv/fru7xU90A4/KTRQxCXmITuw2A6ae7FZGeLQ0FZXtZZjKMWh1Smm/AObIouHCo4
	 k3kCDmWVCde2tza3nFuYVGybg3HwrF2MU4RB178tpZoBKoA7ocoqLqfo1T7t9fvRAXmC+
	 T1ccRnwqrypc1ie2xXZODrQ+9rMl9gIpg0kH8AOSeYgtI+Ji7Awhami5VIdLCh4n8YMs3
	 EFKK4MDrDiiK7aLpWtvj+6ifIrXX+d4K2FapA+IKcaAVv0ns+XNBP+2cRsITGY9N81g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gABV4QaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DB860A262F;
	Wed, 28 Oct 2026 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gABV4QaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BBF1F01828;
	Wed, 28 Oct 2026 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214042;
	bh=cu8bEga+KZiwlhjvpMAeWDIE/M21cNKJsSy27G68TCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gABV4QaIUFBfFcMbD8BQ+98x2kX7GDqDIw6D7/QulWVVlw6Rdr6geauzRBxi9WJk/
	 p9WJdkrG7Ue52BHqN/ihuAj0EBqeCcP/lo16NM2rFGzDsxqqiYZFopy4rbdkrgPnAV
	 mjlLU5Lfq3KUNTw1TIjPFP0BYml1bMLYQaGLl7Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0675/1887] net/ncsi: Disable the ncsi work before freeing the associated structure
Date: Wed, 28 Oct 2026 17:46:11 +0100
Message-ID: <20261028170514.770821911@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit a0ffa68c70b367358b2672cdab6fa5bc4c40de2c ]

The work function can run after the ncsi device is freed, resulting
in use-after-free bugs or kernel panic.

Fixes: 2d283bdd079c ("net/ncsi: Resource management")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://patch.msgid.link/20240925155523.1017097-1-eajames@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ncsi/ncsi-manage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 6a58ae8b5d035..82030281e60ac 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1967,6 +1967,8 @@ void ncsi_unregister_dev(struct ncsi_dev *nd)
 	list_del_rcu(&ndp->node);
 	spin_unlock_irqrestore(&ncsi_dev_lock, flags);
 
+	cancel_work_sync(&ndp->work);
+
 	kfree(ndp);
 }
 EXPORT_SYMBOL_GPL(ncsi_unregister_dev);
-- 
2.53.0



