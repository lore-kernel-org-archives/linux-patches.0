Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215913;
	b=kQ7pblD74ck50MYcqkIEPHNuD87xA5ktJdQrnLM48TVeF4YdTArwKmHoAnIrQKjM7iDR
	 LzsMo3CjeysA6OU4mZynG53ZJksE91+tJRFFeR6B/WsKAnfAJq64EFaFq1VUDDxbpz1F8
	 7O+PAbaWVa/rb7B0Q7Yi+psMtql6NLwLQrVtkwmfw733G7gV2wQi0pUPk4c6CYBsdIVlV
	 c4u2HE2Gu6CkjNSxpaPTBp3MS2AmpRr6UoxmKUSiLwl2Y7s1rgFC0MlEp+gtBst9qDBaN
	 9GQhJOOnX+ECocE5fGQ+ylOyptquM1ByIOSXHjSkawpWN+2cNJel/a5Huc2Vee/Rc+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FJmOm8zm/jW2LYEsKZn8pRXFi0xCaXeFUwIpTp1eri4=;
	b=iCfX9lBpTE68+Itz+BfnGBwzM8f+Q1zSTe8hK1GcsH1JDYjhLrcOLfMjV/f4YTiiGXQE
	 49k9PQXt56YkXPU5WtkJuHLGnyn02xgnfOZRtS4A/gT+WhKmfVel0pJeOcenC9A1GRT2i
	 GUVveRht4ps25EDV3OL9F/uVSprEr3UE0hKFvr+xi1Z8IuZJFxExBhY5jSJThrS2OgkhX
	 RJfvz31EJgMCtgQp5ua/3zm6w699wwCuS7T2r8aVrLYdlVt881G1YZbZfdJIxy9vWXxqJ
	 9lDjPXVuyMXPc3JO60GNeEcoGaRK/UUZU4ed1EqlTtImvDl+CzgKB4tfJ8HS8oyA8EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzsE8I+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A8F606A31A;
	Wed, 28 Oct 2026 19:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzsE8I+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E282E1F01825;
	Wed, 28 Oct 2026 19:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215913;
	bh=FJmOm8zm/jW2LYEsKZn8pRXFi0xCaXeFUwIpTp1eri4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzsE8I+ksQ/RS0wfeYBP61JZsM3eGFNqlvHjJcLgcZfl53nPtTOZNjobY9kuFPkq0
	 gPKmk1Qpgbje9QAC1FGlgisc2ObhOnGRrOZ62BWzlE1Zzp8WZuvLYm6sZ93ddOntjE
	 OXSHUZgm8tBxmhaNzuZ+ORSFqMxCEQJcg3T/eOQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1377/1887] net: l2tp: do not propagate multicast notification errors
Date: Wed, 28 Oct 2026 17:57:53 +0100
Message-ID: <20261028170530.783493881@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit af20e269f7459d2ce69887fdf2fad7caf986c865 ]

The tunnel create, tunnel modify, session create, and session modify
netlink handlers send multicast notifications through helpers that can fail
while allocating or encoding a message, or while multicasting it.

For tunnel and session create/modify, a notification is sent after the live
operation has completed. Returning a best-effort notification error as the
command result can therefore report failure for an operation that already
committed and can cause callers to retry and accumulate live objects.

Keep sending notifications for listener visibility, but do not propagate
their best-effort status as the command result. This also keeps the tunnel
modify command consistent with the other notification-only paths.

Fixes: 33f72e6f0c67 ("l2tp : multicast notification to the registered listeners")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/54f48e812ca0424c47ffdb9a8182180921f7e6b2.1787247008.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_netlink.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 05314419c7bbb..25800de8b4825 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -247,8 +247,8 @@ static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info
 		kfree(tunnel);
 		goto out;
 	}
-	ret = l2tp_tunnel_notify(&l2tp_nl_family, info, tunnel,
-				 L2TP_CMD_TUNNEL_CREATE);
+	l2tp_tunnel_notify(&l2tp_nl_family, info, tunnel,
+			   L2TP_CMD_TUNNEL_CREATE);
 	l2tp_tunnel_dec_refcount(tunnel);
 
 out:
@@ -304,8 +304,8 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 		goto out;
 	}
 
-	ret = l2tp_tunnel_notify(&l2tp_nl_family, info,
-				 tunnel, L2TP_CMD_TUNNEL_MODIFY);
+	l2tp_tunnel_notify(&l2tp_nl_family, info,
+			   tunnel, L2TP_CMD_TUNNEL_MODIFY);
 
 	l2tp_tunnel_dec_refcount(tunnel);
 
@@ -637,8 +637,8 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	if (ret >= 0) {
 		session = l2tp_tunnel_get_session(tunnel, session_id);
 		if (session) {
-			ret = l2tp_session_notify(&l2tp_nl_family, info, session,
-						  L2TP_CMD_SESSION_CREATE);
+			l2tp_session_notify(&l2tp_nl_family, info, session,
+					    L2TP_CMD_SESSION_CREATE);
 			l2tp_session_dec_refcount(session);
 		}
 	}
@@ -702,8 +702,8 @@ static int l2tp_nl_cmd_session_modify(struct sk_buff *skb, struct genl_info *inf
 	if (info->attrs[L2TP_ATTR_RECV_TIMEOUT])
 		session->reorder_timeout = nla_get_msecs(info->attrs[L2TP_ATTR_RECV_TIMEOUT]);
 
-	ret = l2tp_session_notify(&l2tp_nl_family, info,
-				  session, L2TP_CMD_SESSION_MODIFY);
+	l2tp_session_notify(&l2tp_nl_family, info,
+			    session, L2TP_CMD_SESSION_MODIFY);
 
 	l2tp_session_dec_refcount(session);
 
-- 
2.53.0



