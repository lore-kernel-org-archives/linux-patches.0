Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350383195E4;
	Mon, 27 Oct 2025 18:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590805; cv=none; b=WyFhyu6yhxim7re1SMb/C6RS4OwjsgHUliFtT31/OzSXs5DoBzwA10UJsw8LZMTM7J5x9p/Fw6Na6F9hvAKlADaZLcqcmp/s5zty9JZNvyN3DWUOnVzTIhZKBDVjdaRWCx0jV8akwFMniJExs9ooBdjtH32VYEyn6TmqoXQGNq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590805; c=relaxed/simple;
	bh=OnMyrG9lD7yt6Tnk2Gg5N5V2N+OG/Oc8pzPkyK+1WqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3YP81ljPDezkLfkytHWJ91Xdxw/kDgld016iuU8Z5nQEvDLexjDK1KlHFe0Q6LWHJNCdVmNwNbGpWu4/JcwPBP5E7XVGJUB77cBPNNQdvXlaICS9ZqyqiSPGmiZBjyoHeOcRvkT+1EJIXCwm3li9eejSzdpEBBhRQTviBbvVQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDoCM4jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDoCM4jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD04C4CEF1;
	Mon, 27 Oct 2025 18:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590805;
	bh=OnMyrG9lD7yt6Tnk2Gg5N5V2N+OG/Oc8pzPkyK+1WqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDoCM4jykyacjTg59XxTxAG4hKygq9DdkO3Lk2f5rSlt62zDa1tX/BLG5CQQ6skpb
	 qg95JFB37Xv19A0ZK8TXcinqOkIq4vvj9e7d6ZlmmCbokJlufxj16C9yl9lTnoRSP0
	 z/06mu5Or4mInJd8omj7/lgyp6qpVq6U8IvEprg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/224] net: rtnetlink: remove redundant assignment to variable err
Date: Mon, 27 Oct 2025 19:35:28 +0100
Message-ID: <20251027183513.727818320@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 7d3118016787b5c05da94b3bcdb96c9d6ff82c44 ]

The variable err is being initializeed with a value that is never read
and it is being updated later with a new value. The initialization
is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2b7ad5cf8fbfd..f1338734c2eee 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3823,8 +3823,8 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ndmsg *ndm;
 	struct nlattr *tb[NDA_MAX+1];
 	struct net_device *dev;
-	int err = -EINVAL;
 	__u8 *addr;
+	int err;
 	u16 vid;
 
 	if (!netlink_capable(skb, CAP_NET_ADMIN))
-- 
2.51.0



