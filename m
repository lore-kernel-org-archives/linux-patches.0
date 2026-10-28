Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213235;
	b=XWYM+0Xr1w1VW364nsQ+7+RXEPnR/48R3iHgvoomGsuqCHxZdANCLraQXSf3LYahHelk
	 lMU0cBTf0QqTE0PFhdcBboVVab2zXcm5NHwSF4coJ/UvYuoHLFxc4dImqC6Pcf7czrfZz
	 ZOT0q5AO1eSmvLmQbkdWk7rsRCAbZ//zBmpl4tTxqPfN2yUQDQtj6jJy+mV6q17niaAKD
	 h1KzN0rlbgovNs1+TDkQ3w7uz2E2N48TyS3d/hLyD9OO7+moGpFB6KErQOChiePt+CVQR
	 QxmwV3H1Gb0q6q/W+U+Vq2Fd5dU1ZWpDc8aiEr6MkL3V2G2Iy+EB3GPjaRB8gi80Gdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JBqSSySV4zdcmcsZw5w1QsXzt6mrjsRWjTvWHUKy3EQ=;
	b=r/k+lsOz16XDSP/rXKQTeguNkF3LkHX7iRkr3j4pSgSU4kXvL4fBuEPGJxGD048OTuU9
	 lCIUs8RsVZBt9HTEomUkVNqaH3zCjj91IHKCuy/rpX4g6gPDpjXmKqoBAtOHeNwNMoWBl
	 zQUFpsF/4v9azxrLS0Wm3SfOkbIXNmebhYjlA2ATFirgcgS8Po31ui4ROAjDr11fTSHW7
	 aMccSjhdXfQR1M9k6I3YyXqZ73LUpZNZwVPg4Z05SNxtSuoqTGulwhJFg2MU5s8IaWDPP
	 V+3iw/OATra0zwTFyVRmipqPWEmLLMXmiUBkDLjLOdnxcZxvb1PwsuaUtOKTLo1UBgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8u+GuPM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36AC606A320;
	Wed, 28 Oct 2026 18:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I8u+GuPM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA001F01825;
	Wed, 28 Oct 2026 18:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213234;
	bh=JBqSSySV4zdcmcsZw5w1QsXzt6mrjsRWjTvWHUKy3EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8u+GuPMPnTf0OdX7DRdtXVrEH+CJ5HZFrQaVKoCiNl06mJL3GXemK5DJVCDzO26Z
	 QYhhG/+b/ELIvtcf6Nuzq0J4RdF+4jtgJQpLXzY4m0od+1gfGZtezswmxQ6GgKJYDY
	 4veqEB67+49VOOvuU3wxARLpKwWOH70jJSGxy0lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0432/1887] ipv4: do not warn on route notification size race
Date: Wed, 28 Oct 2026 17:42:08 +0100
Message-ID: <20261028170509.064458673@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit e02a5b6588161673ef75a4bc5cdfb62bd493374d upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib hardware
flags are changed") added asynchronous route notifications for hardware
flag changes.

fib_alias_hw_flags_set() sizes the skb with fib_nlmsg_size() and later
fills it with fib_dump_info() while holding only RCU.  With nexthop
compatibility mode enabled, a concurrent replacement can grow the group
between these independent snapshots.  fib_dump_info() can then
legitimately return -EMSGSIZE, so the warning does not prove a sizing bug.

Remove the warning.  The existing error path still frees the skb and
reports the error to listeners.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261004082043.GB92032@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Link: https://patch.msgid.link/b7e203fc5867651cb67ef84aa03e082f0f76008e.1791423190.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1084,8 +1084,6 @@ void fib_alias_hw_flags_set(struct net *
 
 	err = fib_dump_info(skb, 0, 0, RTM_NEWROUTE, fri, 0);
 	if (err < 0) {
-		/* -EMSGSIZE implies BUG in fib_nlmsg_size() */
-		WARN_ON(err == -EMSGSIZE);
 		kfree_skb(skb);
 		goto errout;
 	}


