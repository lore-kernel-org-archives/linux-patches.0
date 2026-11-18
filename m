Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030892;
	b=GkV//Drn8pPGLoMuJDxk2QI4uACi53nluBSelEMxaO+1El8mOZwPZ45LgwNmhM43KrI4
	 7RLTuYkbvWJ0AmyHXx3p1V0RjNRVl9qBl7khXowoR+0/sDlGvqMRe+GY7Mg8r17FKz1qH
	 Ljo+2hNIpWsCeocU3byA4Urr12H5xXL+GhExjEnoXksQ15JpR9j2c8bDBQIWfeShP4iDx
	 9Drtz3VBCrF+PrNpFVaA8HNNNXsHnM297SzC0vapx83UFZ7jvWkE9xaRkR+OWIyFdTTzy
	 lz0nMvWbJg96abwWix0lKxSC7um4QMIds9nLYnRf6kgXGMGfiFNq8kFJiG1xHIwbzxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUG6t7iIsTZsn0ZUf4PVwjEKP07u9mkHP/2QbYVJS5M=;
	b=nfU0sIoL54BX+pzVl1xkhHD0zJ964lMkdIa+wY6QVYaySgLRCWZKkMvOKZEycivPGhth
	 0WlpACJ8GYzSuGjwV/sIjAHbAvLKzMdMRVaP1dBeqcYBkND++pAPuid6CTnPAzpwacQbg
	 RP2+B81NNGwBdXNvV39iFqecUOLDkFIFzJ6x8emmWTzsFNNYlu8b+0GZ5BHTHvMQd55i1
	 iMYbW40JKWr7IhThcHOanD8c4BPWd+JvO+mzga/KtVYcsza7GB0ARtdzZVUwqywS/ecl6
	 3w+OzlcC5LmnBOw06zurLPer+s/2bdxkFXYX15ULGO4cythf+zPq0LPuvH69oi6O9gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yX93Vzv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420E7606DD0F;
	Wed, 18 Nov 2026 19:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yX93Vzv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F2C1F000C4;
	Wed, 18 Nov 2026 19:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030892;
	bh=HUG6t7iIsTZsn0ZUf4PVwjEKP07u9mkHP/2QbYVJS5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yX93Vzv+OruPxJLMf59wAnAJm7N1uw5rO5vURJuGHjegDH5+GvW5qAfRgXxx6Gq3Y
	 hoT8Y3NdPVp0f8xmSOx/FHaF01Y6FoeoxYofillHGz0dZx2wr2KuMsfrpBxwFTJLDU
	 ris240CW9obf0JaJH6GRg77llWDo9u9Tw5kIKacY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0864/1756] wifi: b43: dont pass unterminated string to sscanf()
Date: Wed, 18 Nov 2026 15:49:51 +0100
Message-ID: <20261118150043.725515190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



