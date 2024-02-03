Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BD911CB1;
	Sat,  3 Feb 2024 04:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933587; cv=none; b=jm4c9UxE2MksNbwIXyGgFLRtDD6PRxuklVc6EMfs3JQUapeXa6mNK1naDUriM1xxLn2sW+K2WBaX6Y4xM264WuMlqcn5wf9kTASyNP9nCF+UEag8Z8B9acz8wTvJf+E9M4OvhNYU+keWfF62UEz/2doTDWtqOmITmqjNDQkxL3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933587; c=relaxed/simple;
	bh=FUQO6O1wI5f6fk9xNEh9UNZSHytymra72tgu2MXDMeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBwijDQzGXZWwMQIxpA35uF5QUQOo8TlGhQiWy1DhkY7eE9NLRKEBnmFE1oyd7qykyELSaPeznZK7cyJkLoE/Hn6pPIsd0Rw3k8faX8+FhgGsAfNzGlFuUCn6TyiwQ0qawl2pYvDwPUZqSnUiaO+Ew6H601zuWPwpi6YYfaWPxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWLSt6eQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWLSt6eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E87FC433C7;
	Sat,  3 Feb 2024 04:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933587;
	bh=FUQO6O1wI5f6fk9xNEh9UNZSHytymra72tgu2MXDMeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWLSt6eQ0MoKFRBdwJiWfSyZiwMuWwF1jr9dUas/vTOp7d+BXwo8++Lb+gWysfugA
	 dXNwUAC1AIqqxZBc/KoiywXa3G3kqQEy/0nJIZQmPOnaXXjnCojAU++1hVbgZHq2RQ
	 rsmDu2l3p/LNCWTNr2F0lZYxHgeJdlFFbO/tQAOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/322] bridge: cfm: fix enum typo in br_cc_ccm_tx_parse
Date: Fri,  2 Feb 2024 20:04:07 -0800
Message-ID: <20240203035404.029413528@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit c2b2ee36250d967c21890cb801e24af4b6a9eaa5 ]

It appears that there is a typo in the code where the nlattr array is
being parsed with policy br_cfm_cc_ccm_tx_policy, but the instance is
being accessed via IFLA_BRIDGE_CFM_CC_RDI_INSTANCE, which is associated
with the policy br_cfm_cc_rdi_policy.

This problem was introduced by commit 2be665c3940d ("bridge: cfm: Netlink
SET configuration Interface.").

Though it seems like a harmless typo since these two enum owns the exact
same value (1 here), it is quite misleading hence fix it by using the
correct enum IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE here.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_cfm_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
index 5c4c369f8536..2faab44652e7 100644
--- a/net/bridge/br_cfm_netlink.c
+++ b/net/bridge/br_cfm_netlink.c
@@ -362,7 +362,7 @@ static int br_cc_ccm_tx_parse(struct net_bridge *br, struct nlattr *attr,
 
 	memset(&tx_info, 0, sizeof(tx_info));
 
-	instance = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]);
+	instance = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE]);
 	nla_memcpy(&tx_info.dmac.addr,
 		   tb[IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC],
 		   sizeof(tx_info.dmac.addr));
-- 
2.43.0



