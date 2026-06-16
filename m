Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C613AE71F;
	Tue, 16 Jun 2026 17:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629947; cv=none; b=rzVitHPg4OmtE1fPhJq8+K3ESQaMo7BpQu/GbT72Fsl3Pxg8qhz1kR7Ec9HDsUcOD0W2BkM3t+iHwoJLENbFoU8oimE9TFOMfHiDaPMD/dSKkaYYnOOUWXdaSD+uETdz96KOCDKnxWuWrDkl5nInWZcQ5jK7vmMWdmcjfxImISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629947; c=relaxed/simple;
	bh=2fhC/YYC7xnONXeHtB9W0yJ1qInO2Xq5aPPovFyIVzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViVCCHC2PbixTqijjD1fVoQGlFhyXRgnHAiLeZO61UPfGBEvcXjgDIiNN76PAgTPHwnGUCy4cyt1XyHWt9aKBiS7S30Y7BtvPMX+/65yff/hi0+hRzydUFcPeoIFQDEwH4Q0WwVULmYPA8pYkv9vUL1jnEaccT0jYrmVjGJDwCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWfcvp3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWfcvp3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F65A1F000E9;
	Tue, 16 Jun 2026 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629946;
	bh=odkbs2nd2Bd4hUSjxF//da3JVe9ZVYaLWTcFncMQwWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NWfcvp3NNtXXKS74DIAJatJLd2xtVA6K0oPEQrrHN5dqLn2H7vsFKtv65XpOoJNGl
	 a4IIuJ+1Tp9rCcStP81b5xHPYQ53VQnAWxR9g4E7pWRkT43/EXluP0VRuUErDPfo5Q
	 UyNYK1xy6OuIPC6JmSfUgsgThJtYiE0VcaxM25Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/452] mptcp: use plain bool instead of custom binary enum
Date: Tue, 16 Jun 2026 20:30:10 +0530
Message-ID: <20260616145137.052442612@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit f1f26512a9bf18f7a4c0d59df113a49f39d7d4b6 ]

The 'data_avail' subflow field is already used as plain boolean,
drop the custom binary enum type and switch to bool.

No functional changed intended.

Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231023-send-net-next-20231023-2-v1-3-9dc60939d371@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0981f90e1a05 ("mptcp: reset rcv wnd on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |    7 +------
 net/mptcp/subflow.c  |   12 ++++++------
 2 files changed, 7 insertions(+), 12 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -451,11 +451,6 @@ mptcp_subflow_rsk(const struct request_s
 	return (struct mptcp_subflow_request_sock *)rsk;
 }
 
-enum mptcp_data_avail {
-	MPTCP_SUBFLOW_NODATA,
-	MPTCP_SUBFLOW_DATA_AVAIL,
-};
-
 struct mptcp_delegated_action {
 	struct napi_struct napi;
 	struct list_head head;
@@ -513,7 +508,7 @@ struct mptcp_subflow_context {
 		is_mptfo : 1,	    /* subflow is doing TFO */
 		close_event_done : 1,       /* has done the post-closed part */
 		__unused : 9;
-	enum mptcp_data_avail data_avail;
+	bool	data_avail;
 	bool	scheduled;
 	bool	pm_listener;	    /* a listener managed by the kernel PM? */
 	u32	remote_nonce;
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1303,7 +1303,7 @@ static bool subflow_check_data_avail(str
 	struct sk_buff *skb;
 
 	if (!skb_peek(&ssk->sk_receive_queue))
-		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
+		WRITE_ONCE(subflow->data_avail, false);
 	if (subflow->data_avail)
 		return true;
 
@@ -1337,7 +1337,7 @@ static bool subflow_check_data_avail(str
 			continue;
 		}
 
-		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
+		WRITE_ONCE(subflow->data_avail, true);
 		break;
 	}
 	return true;
@@ -1358,7 +1358,7 @@ fallback:
 				subflow->reset_reason = MPTCP_RST_EMIDDLEBOX;
 				goto reset;
 			}
-			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
+			WRITE_ONCE(subflow->data_avail, true);
 			return true;
 		}
 
@@ -1375,7 +1375,7 @@ reset:
 			while ((skb = skb_peek(&ssk->sk_receive_queue)))
 				sk_eat_skb(ssk, skb);
 			tcp_send_active_reset(ssk, GFP_ATOMIC);
-			WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
+			WRITE_ONCE(subflow->data_avail, false);
 			return false;
 		}
 	}
@@ -1385,7 +1385,7 @@ reset:
 	subflow->map_seq = READ_ONCE(msk->ack_seq);
 	subflow->map_data_len = skb->len;
 	subflow->map_subflow_seq = tcp_sk(ssk)->copied_seq - subflow->ssn_offset;
-	WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_DATA_AVAIL);
+	WRITE_ONCE(subflow->data_avail, true);
 	return true;
 }
 
@@ -1397,7 +1397,7 @@ bool mptcp_subflow_data_available(struct
 	if (subflow->map_valid &&
 	    mptcp_subflow_get_map_offset(subflow) >= subflow->map_data_len) {
 		subflow->map_valid = 0;
-		WRITE_ONCE(subflow->data_avail, MPTCP_SUBFLOW_NODATA);
+		WRITE_ONCE(subflow->data_avail, false);
 
 		pr_debug("Done with mapping: seq=%u data_len=%u\n",
 			 subflow->map_subflow_seq,


