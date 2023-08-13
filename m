Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912679443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2FBC433C8;
	Sun, 13 Aug 2023 21:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962155;
	bh=3gHNiJlAYoBN1UEY/DhNVy1/4ubApVr7KOF6R/s7+9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4OiD79gv12Od71OGB8qYsAdowIqM41g7JmgRBPon0tYmzpXybuQQiA4fJ69AuuuL
	 fDcV78m49XM6vk2EzvH2hdPz71rNq0Pu3ZPGZh6g7NEvUDSkftwyqw2ZPYyCUUtbGL
	 OuE7FicGKfY+D2VV2/83Jqjyw8ovAdyybGY1qkYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ping Gan <jacky_gam_2001@163.com>,
	Manjusaka <me@manjusaka.me>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 134/206] tcp: add missing family to tcp_set_ca_state() tracepoint
Date: Sun, 13 Aug 2023 23:18:24 +0200
Message-ID: <20230813211728.860086941@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

commit 8a70ed9520c5fafaac91053cacdd44625c39e188 upstream.

Before this code is copied, add the missing family, as we did in
commit 3dd344ea84e1 ("net: tracepoint: exposing sk_family in all tcp:tracepoints")

Fixes: 15fcdf6ae116 ("tcp: Add tracepoint for tcp_set_ca_state")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ping Gan <jacky_gam_2001@163.com>
Cc: Manjusaka <me@manjusaka.me>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230808084923.2239142-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/tcp.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -381,6 +381,7 @@ TRACE_EVENT(tcp_cong_state_set,
 		__field(const void *, skaddr)
 		__field(__u16, sport)
 		__field(__u16, dport)
+		__field(__u16, family)
 		__array(__u8, saddr, 4)
 		__array(__u8, daddr, 4)
 		__array(__u8, saddr_v6, 16)
@@ -396,6 +397,7 @@ TRACE_EVENT(tcp_cong_state_set,
 
 		__entry->sport = ntohs(inet->inet_sport);
 		__entry->dport = ntohs(inet->inet_dport);
+		__entry->family = sk->sk_family;
 
 		p32 = (__be32 *) __entry->saddr;
 		*p32 = inet->inet_saddr;
@@ -409,7 +411,8 @@ TRACE_EVENT(tcp_cong_state_set,
 		__entry->cong_state = ca_state;
 	),
 
-	TP_printk("sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c cong_state=%u",
+	TP_printk("family=%s sport=%hu dport=%hu saddr=%pI4 daddr=%pI4 saddrv6=%pI6c daddrv6=%pI6c cong_state=%u",
+		  show_family_name(__entry->family),
 		  __entry->sport, __entry->dport,
 		  __entry->saddr, __entry->daddr,
 		  __entry->saddr_v6, __entry->daddr_v6,


