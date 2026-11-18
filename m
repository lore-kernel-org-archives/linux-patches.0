Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034468;
	b=pdCWMSMZcxz+gYaHDERtmEfkxheOD42Vumqefq76sGJvUFyxTPjFOQ2LJ3aDVQubAxwf
	 utPVOl9dDB24pbuxf8o231twQiQTHY+nvFJ3BrW2tVQWLpBQjCOpn/ezD6RPdzTnRrR0w
	 VE1r2pojIPuRSYbLPKPf/F+5I8NFNkW3VGwI4R9QVO33kVtVVk9EpnyjTtELgzby3QiQb
	 srJE7N5EEAmHDwqMjUpaIrbvAfjD2vlmdgDR47gNdhkJbU4LOoXKhjevViq1cZRABRMR6
	 cHv4M2yVFpSay2ZlgsqEFvH7Inn1r6W6fKEp5yEm2LHGjQ89Mgr9/3MNSXFHakf1lWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UNnoid5+a4fNc3jaTTjPPR5fQb6hMU3rzBda1YD63HA=;
	b=ZSAttZ7IqGy6wx2RMVkafEAI4e8h9JR0IJ5tulPuMSAyVJ2VlyVjhGGzUfToJ17vGwv/
	 hbgbp3PfS1ywS0+KH1AjaPLW+/4Lf4qpfEQ0fwdMBhl2ui07H2eiCkajf3u5t9x6EQaQD
	 tPGjaXrJ6zmLltL72rmrsM/QBOHI1KZ2nSMiBJ0g+Z94G+m+cAJaieds/2zfx6Qau5GTo
	 Aiuw2OMfJkAheRlFczXiBOp/CqwMLy4RsQMT9xYrtiVOtmIC6CKy0rnLtE98r6xlHPTz3
	 KsDKuotpJEkDrmPZSB0nbpzfSSmZEGHogEnTF48+UdTBS46EpU44cHb3n/woL7ltzOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rMbTo/QH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05951606A31C;
	Wed, 18 Nov 2026 20:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rMbTo/QH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D521F000C4;
	Wed, 18 Nov 2026 20:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034467;
	bh=UNnoid5+a4fNc3jaTTjPPR5fQb6hMU3rzBda1YD63HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rMbTo/QH0//47YCj8OpbEEY9hLYTQD4lS2WqZPiYCJ4oGaBY4ogd41zGUDBxIHO2l
	 Z64HOnSl4CULVbzf6ITiIPWxVU59CsfMcQDa1c1bKZjDt/7iH1xwGghAWxh+Z7FVIK
	 r3bJh59fTYxq8oYJfzQHFvBIsV/HWox8PXFieMhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0333/3318] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
Date: Wed, 18 Nov 2026 15:15:55 +0100
Message-ID: <20261118150325.929949947@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 1f0391aea883e99d402d0f77ba3530e4e879350d ]

Replace WARN_ON calls with DEBUG_NET_WARN_ON_ONCE in the default switch
blocks of nf_tproxy_get_sock_v4 and v6. Unsupported transport protocols
are already safely handled by returning a NULL socket pointer. This
prevents unnecessary system panics when panic_on_warn=1 is enabled in
production systems.

Link: https://patch.msgid.link/cover.1786968834.git.zhilinz@nebusec.ai/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 73e66a088e25e..9b51e84606040 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -138,7 +138,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 52f828bb5a83d..ead5d161464cb 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -137,7 +137,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
-- 
2.53.0



