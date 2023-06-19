Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87C98BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C75C433C8;
	Mon, 19 Jun 2023 10:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171792;
	bh=/Q66y4WMNn/Z04nQYZUZYZqkuDSZEMw3qF+FgawNnbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nd2rj3O+opUx/qUGidJ7gKg8xEYhEGbbEZoB5UPBh5uA3jrrT2mxgjxNB9jy1lOXh
	 ejf0HmpxyYMB1GLsTe75bNlddCIR24LS8h3YtSkc5ptLNM7nWXAP2rpA+7GNboZOCe
	 YoadjzX65AtVLWIqW2AjOJK1aOGiHLdjUR3s0S0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 158/166] net/sched: act_api: move TCA_EXT_WARN_MSG to the correct hierarchy
Date: Mon, 19 Jun 2023 12:30:35 +0200
Message-ID: <20230619102202.356894583@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

commit 923b2e30dc9cd05931da0f64e2e23d040865c035 upstream.

TCA_EXT_WARN_MSG is currently sitting outside of the expected hierarchy
for the tc actions code. It should sit within TCA_ACT_TAB.

Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc extact message")
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1603,12 +1603,12 @@ static int tca_get_fill(struct sk_buff *
 	if (tcf_action_dump(skb, actions, bind, ref, false) < 0)
 		goto out_nlmsg_trim;
 
-	nla_nest_end(skb, nest);
-
 	if (extack && extack->_msg &&
 	    nla_put_string(skb, TCA_EXT_WARN_MSG, extack->_msg))
 		goto out_nlmsg_trim;
 
+	nla_nest_end(skb, nest);
+
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
 
 	return skb->len;


