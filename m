Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214587;
	b=RSmXKmD10iA/TC51p+xBq257RzTVgdm3c1C7h9FSLy0GNlLbY8crl6wrTHYvn3vyPLYY
	 iIqyiVFB4QeRVIYzLlQPgHSF7zZZ1ekrJZVN8QqSXi7c2Y9Qh+V6PjlehlA23K8vot1Pp
	 2wDHR7yijoy8CtUWgPUOfNoagFadh68J9yf8SHxNu2qEybA6OGXgr2ZzDFtpFS2syE2gd
	 vkSegW5oLkEmsYvVkQ4u4Pam7Az14ByWpYw+BTNIw5dCkrSaMgtyfI5yyVXWoTDiGSi7Y
	 fFZnfEX6I2TkPPbvZvTM32AIWp+K5nyfAg/zt7QiYnRUddhNcht6E8xx7EuBjrj1Rjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=2867Cbl0iRD2pPq/5TZrHR06EjKLdxtsJXJb4oMfG4U=;
	b=vlxLgpbBCxMOB/mtLn/uZPTCaZxDgGfLAVw2xxqfjILpy3NDKi6yXvgt3IeFApA3Uj/P
	 oRQd8UCPqXHtdQ4XhXqK6QN5E3nwH/NerrOnAUQ/C8TTGOVW4OYxvg0SOkNRdyj8l/OGm
	 0nHeW/bvqmby3Yfv8REicZs44nE0zvEJ44OiSm583Fg7K3wYNMi5WyhWFloc7E+d7+Rmy
	 pVdCOtdt5/sdh7TT0QpwAfCMKXAXftHzUx8kAgMjtG3pEpB2HH0dqek+ebp8buRFntL7o
	 Gf0XqmVL18OvKafXji0hMesW92CU1LasmzscZs1JLkEg/4pQGc9z8CPGTO4+Zr7vuHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwWtQeAZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE81F606BFB5;
	Wed, 28 Oct 2026 19:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwWtQeAZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EBB1F01828;
	Wed, 28 Oct 2026 19:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214586;
	bh=2867Cbl0iRD2pPq/5TZrHR06EjKLdxtsJXJb4oMfG4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwWtQeAZhkyHj1P0lCqgG9rqBmQEmge1NaR/FnWeRWgu0qMOMQHoRg33FedsvsDn9
	 /vFO/am8sxz01b+mnaI/KyYDdoyeaVZYHy/1hxuHZF0eQh7PgXwKrc4MDtnHNf6TFN
	 fovqWY8Kk3b+SrvLf08ygcQkyUpnU4Zk3KnrBaDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d991fea1b4b23b1f6bf8@syzkaller.appspotmail.com,
	=?UTF-8?q?Miquel=20Sabat=C3=A9=20Sol=C3=A0?= <mssola@mssola.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0912/1887] btrfs: fix NULL dereference on root when tracing inode eviction
Date: Wed, 28 Oct 2026 17:50:08 +0100
Message-ID: <20261028170520.170561860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Sabaté Solà <mssola@mssola.com>

[ Upstream commit f157dd661339fc6f5f2b574fe2429c43bd309534 ]

When evicting an inode the first thing we do is to setup tracing for it,
which implies fetching the root's id. But in btrfs_evict_inode() the
root might be NULL, as implied in the next check that we do in
btrfs_evict_inode().

Hence, we either should set the ->root_objectid to 0 in case the root is
NULL, or we move tracing setup after checking that the root is not
NULL. Setting the rootid to 0 at least gives us the possibility to trace
this call even in the case when the root is NULL, so that's the solution
taken here.

Fixes: 1abe9b8a138c ("Btrfs: add initial tracepoint support for btrfs")
Reported-by: syzbot+d991fea1b4b23b1f6bf8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d991fea1b4b23b1f6bf8
Signed-off-by: Miquel Sabaté Solà <mssola@mssola.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/btrfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index b2b41b98ec6d0..dcb861e813f2f 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -225,8 +225,8 @@ DECLARE_EVENT_CLASS(btrfs__inode,
 		__entry->generation = BTRFS_I(inode)->generation;
 		__entry->last_trans = BTRFS_I(inode)->last_trans;
 		__entry->logged_trans = BTRFS_I(inode)->logged_trans;
-		__entry->root_objectid =
-				BTRFS_I(inode)->root->root_key.objectid;
+		__entry->root_objectid = BTRFS_I(inode)->root ?
+				BTRFS_I(inode)->root->root_key.objectid : 0;
 	),
 
 	TP_printk_btrfs("root=%llu(%s) gen=%llu ino=%llu blocks=%llu "
-- 
2.53.0



