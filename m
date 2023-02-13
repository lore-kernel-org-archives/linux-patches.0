Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012FA8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79370C433EF;
	Mon, 13 Feb 2023 14:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300271;
	bh=pRAFlcwQSv7P+/yxBg7PGzKKAbAVtwwAvtiFsm3hwPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=097swOE0lCxtPOg+exIqbboK9ubsO8UCL1sZc//Z5MEe10pM3Mq5fsBgDXe/7AyZF
	 0ftFS/AgETsd7mdw69TapltNp5Or8STceQQsXVibvuqHQwAIvA+7vD0gc0/KYzPp9M
	 TG6KkEH3/FxgxD8xA6lQ/NGuSo/VRliGRxBy/zaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anastasia Belova <abelova@astralinux.ru>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/67] xfrm: compat: change expression for switch in xfrm_xlate64
Date: Mon, 13 Feb 2023 15:48:56 +0100
Message-Id: <20230213144733.059340938@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit eb6c59b735aa6cca77cdbb59cc69d69a0d63d986 ]

Compare XFRM_MSG_NEWSPDINFO (value from netlink
configuration messages enum) with nlh_src->nlmsg_type
instead of nlh_src->nlmsg_type - XFRM_MSG_BASE.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4e9505064f58 ("net/xfrm/compat: Copy xfrm_spdattr_type_t atributes")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Tested-by: Dmitry Safonov <0x7f454c46@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a0f62fa02e06e..12405aa5bce84 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -302,7 +302,7 @@ static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
 	nla_for_each_attr(nla, attrs, len, remaining) {
 		int err;
 
-		switch (type) {
+		switch (nlh_src->nlmsg_type) {
 		case XFRM_MSG_NEWSPDINFO:
 			err = xfrm_nla_cpy(dst, nla, nla_len(nla));
 			break;
-- 
2.39.0



