Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AA010970
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2F8C433C8;
	Mon, 19 Jun 2023 10:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170655;
	bh=c3pVXo5fuSH1Dg3eOEvcLgnwYcHNHak4F7yzB/2DLpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mwo1V84trXFkBXqqn6VsEsG3bFk/+yTJ5KLMD61ZaxAJB1eQ6KobVmP6xCCmdSBe8
	 MfMcsxk0z1VK+WScShWSmDU2q48GCqjToPo2eIRRLGkVFisyIbr9jmLGAWQ8jjS5fm
	 StrU9Zys+jOKzsD/lsD5IBQVVxfNWpKtB+XyCmmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/32] net: tipc: resize nlattr array to correct size
Date: Mon, 19 Jun 2023 12:29:15 +0200
Message-ID: <20230619102128.981745703@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>
References: <20230619102127.461443957@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 44194cb1b6045dea33ae9a0d54fb7e7cd93a2e09 ]

According to nla_parse_nested_deprecated(), the tb[] is supposed to the
destination array with maxtype+1 elements. In current
tipc_nl_media_get() and __tipc_nl_media_set(), a larger array is used
which is unnecessary. This patch resize them to a proper size.

Fixes: 1e55417d8fc6 ("tipc: add media set to new netlink api")
Fixes: 46f15c6794fb ("tipc: add media get/dump to new netlink api")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Link: https://lore.kernel.org/r/20230614120604.1196377-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index c8001471da6c3..506cbd1b22235 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -1072,7 +1072,7 @@ int tipc_nl_media_get(struct sk_buff *skb, struct genl_info *info)
 	struct tipc_nl_msg msg;
 	struct tipc_media *media;
 	struct sk_buff *rep;
-	struct nlattr *attrs[TIPC_NLA_BEARER_MAX + 1];
+	struct nlattr *attrs[TIPC_NLA_MEDIA_MAX + 1];
 
 	if (!info->attrs[TIPC_NLA_MEDIA])
 		return -EINVAL;
@@ -1120,7 +1120,7 @@ int tipc_nl_media_set(struct sk_buff *skb, struct genl_info *info)
 	int err;
 	char *name;
 	struct tipc_media *m;
-	struct nlattr *attrs[TIPC_NLA_BEARER_MAX + 1];
+	struct nlattr *attrs[TIPC_NLA_MEDIA_MAX + 1];
 
 	if (!info->attrs[TIPC_NLA_MEDIA])
 		return -EINVAL;
-- 
2.39.2



