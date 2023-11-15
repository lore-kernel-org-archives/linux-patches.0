Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17B03DB8D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qgutqe2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509BAC433C9;
	Wed, 15 Nov 2023 19:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076124;
	bh=gDXIgWZ0CTDB4DQTsuu+3KgTehqouyoROFgO6xkv72E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qgutqe2nW0L3xdddyWSAAMGBsZDeVY6kExh9UQopWJP6Lb1ija85Ov1qivQ6wL9L9
	 rKU8E3dI06av3E34sUrYm+CCnmTBpTWA0b1EqeM6jFtAJlDLSp1N8Xv8Zwr9bMdXqQ
	 Xweejoq49O4urn5sq/dHBun/TEnKq3/hW1c5VmVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 064/550] udplite: remove UDPLITE_BIT
Date: Wed, 15 Nov 2023 14:10:48 -0500
Message-ID: <20231115191605.121451485@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 729549aa350c56a777bb342941ed4d69b6585769 ]

This flag is set but never read, we can remove it.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 882af43a0fc3 ("udplite: fix various data-races")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/udp.h | 5 ++---
 net/ipv4/udplite.c  | 1 -
 net/ipv6/udplite.c  | 1 -
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 0cf83270a4a28..58156edec0096 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -55,9 +55,8 @@ struct udp_sock {
 	__u8		 encap_type;	/* Is this an Encapsulation socket? */
 
 /* indicator bits used by pcflag: */
-#define UDPLITE_BIT      0x1  		/* set by udplite proto init function */
-#define UDPLITE_SEND_CC  0x2  		/* set via udplite setsockopt         */
-#define UDPLITE_RECV_CC  0x4		/* set via udplite setsocktopt        */
+#define UDPLITE_SEND_CC  0x1  		/* set via udplite setsockopt         */
+#define UDPLITE_RECV_CC  0x2		/* set via udplite setsocktopt        */
 	__u8		 pcflag;        /* marks socket as UDP-Lite if > 0    */
 	/*
 	 * Following member retains the information to create a UDP header
diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
index 39ecdad1b50ce..af37af3ab727b 100644
--- a/net/ipv4/udplite.c
+++ b/net/ipv4/udplite.c
@@ -21,7 +21,6 @@ EXPORT_SYMBOL(udplite_table);
 static int udplite_sk_init(struct sock *sk)
 {
 	udp_init_sock(sk);
-	udp_sk(sk)->pcflag = UDPLITE_BIT;
 	pr_warn_once("UDP-Lite is deprecated and scheduled to be removed in 2025, "
 		     "please contact the netdev mailing list\n");
 	return 0;
diff --git a/net/ipv6/udplite.c b/net/ipv6/udplite.c
index 267d491e97075..a60bec9b14f14 100644
--- a/net/ipv6/udplite.c
+++ b/net/ipv6/udplite.c
@@ -17,7 +17,6 @@
 static int udplitev6_sk_init(struct sock *sk)
 {
 	udpv6_init_sock(sk);
-	udp_sk(sk)->pcflag = UDPLITE_BIT;
 	pr_warn_once("UDP-Lite is deprecated and scheduled to be removed in 2025, "
 		     "please contact the netdev mailing list\n");
 	return 0;
-- 
2.42.0



