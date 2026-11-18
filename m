Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040922;
	b=xuhUWOOW6m5JlSreaAklWRUohtZW/cz3WF+s07+/G2N+i4eoP3ArzA72QYnIkggU4I0/
	 cNDrU8LavFJH2bbAH2iAk3fIotbnP2RPgJdVW7PSac4CUG55yrkn4/Woz3rAR1BjAIsZ8
	 7S0uRXmpjj8McK5FKlikhasFEAqsY5+W2qIH5vG2j7q9qwWa5LlMyUZOlabhBkT4CZ9Ti
	 QJ7+f7/SqNj25BT4yMUIB3qTFnjYyz8UzkmsT4d0qvoqDybzmUHvS4/4bcGseBmJIuciz
	 xFmYa7gvEzEmZFWIj1JYaxZ1dmjAtX5xEcg0Infhm4Ucon7vHQH5cnQeU1h7659L37A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qa05wBsPmWa0wjr646wZETT5ft9ufW1tB5NQjTs35xE=;
	b=2BK6SQ4i/pMqfR85p1SYyv2In7deNy+n5NGD1jFyhNGWbpjXlQPbiEk4pSDyYyFSeDS0
	 ib0hcgID0+eJUCZJzzN1L6wtTgmXgtj7fzQGwYP76X/7Toiw8xRHdaeh87Btwj1+dmm0r
	 oj6F5b21DNzZsIwJm3uaFSCBampNMmnAWFfCombLHev9UEY+H8gXEMnAu6MJyXA01Ru/E
	 tBFbK20jDOczXnn1lG39uy+1HUjnTPxeKoApvXjPQjmu3eFXROWwE/mqX3Swy592ru0Jl
	 nJZfCwdroxa4eNdKC4k5fTZHT7/u0RPZYtgvV7oB49RKY3Axwcd/NLq69CnCjb02CZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sko4e5E1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF97606A32A;
	Wed, 18 Nov 2026 22:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sko4e5E1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E98C1F000C4;
	Wed, 18 Nov 2026 22:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040922;
	bh=qa05wBsPmWa0wjr646wZETT5ft9ufW1tB5NQjTs35xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sko4e5E1ZRjdj2uokM2muXNj7sQ+aFsjkgx1NSVj2TENEGhUZSKdeL8vqamQRYnql
	 gJeTu2sverj1MXJQP7QxcovouojUFzpEyl7XFmnCmugjflwfQDUJE2SVnyauNoSyK5
	 9CxqO/GnDz1Ar+3w7hu0S+jIw82LF7xgqCD6WwRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2587/3318] wifi: b43: dont pass unterminated string to sscanf()
Date: Wed, 18 Nov 2026 15:53:29 +0100
Message-ID: <20261118150438.794715311@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 9b6cb072f9249e2cdb7c32be2b8069774c7e01e6 ]

The "buf" buffer is a PAGE_SIZE and allocated with kzalloc().  We store
a string from the user in it and then pass it to sscanf() in the write
functions such as shm32write__write_file().  Only a few numbers are
stored in the buffer so it never comes close to filling up the whole
PAGE_SIZE.  Reserve the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/b396713e697c7411b23a2157e2102c347ac900bc.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index efa98444e3fb0..3dcf830315b8f 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -561,7 +561,7 @@ static ssize_t b43_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



