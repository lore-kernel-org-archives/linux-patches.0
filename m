Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543B93D47A5;
	Wed,  8 Apr 2026 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671848; cv=none; b=KNhwSWCsbM5JZkmx6dMSI89P9q/27e9yOtAlpmiaZ1RjLLyQo4WrzUUCb4CP8y7jnoDf8HmFUBgmygoEPquji7RK+GV1ORhdy9ZSrVrhpDWxLIxPEoTwjVoRKYX0yrZrGUEZJQ6A0MZDwkBZYWsoNpj3CLGEja9upjd9jYr0KPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671848; c=relaxed/simple;
	bh=Yg93voCzoAprbqWdnHWMnTZxBX3/lpdqp2yWn0YhaPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZiG8OaEoughWd0bi1yXsGwtEULL2a+IJIZU/op0etJ1QVVr/F2ACzjgoj4HSkqIF5HNQsDGh9Z9gcV8YCfTookURN+tMta4v2D5YmqlwkOb1QUnGsDfRz2fOO9mGRQKsBqaQlk3gztW1d7epVef5CXKWZR/QVdwQS6AYPBfclw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wuqf4kpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wuqf4kpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBDFC19421;
	Wed,  8 Apr 2026 18:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671848;
	bh=Yg93voCzoAprbqWdnHWMnTZxBX3/lpdqp2yWn0YhaPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wuqf4kpMvfx1+hXYmXaMIzeeX809+OsiSV6yPC+HVJY6RY7g3AqCQ0eTP6KlMsCUk
	 YyFwL4G/+oiPisQzzrhAtxLuMyZaxzwYjoT1Ns22VEXgRLnO0g2DSJKGB1Dy70SrgN
	 w/AxTJSHn+CBL9sImtqsYBfC0uTdEN1gSZLx2t8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/312] netfilter: ip6t_rt: reject oversized addrnr in rt_mt6_check()
Date: Wed,  8 Apr 2026 19:59:35 +0200
Message-ID: <20260408175935.904270397@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ren Wei <n05ec@lzu.edu.cn>

[ Upstream commit 9d3f027327c2fa265f7f85ead41294792c3296ed ]

Reject rt match rules whose addrnr exceeds IP6T_RT_HOPS.

rt_mt6() expects addrnr to stay within the bounds of rtinfo->addrs[].
Validate addrnr during rule installation so malformed rules are rejected
before the match logic can use an out-of-range value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_rt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 4ad8b2032f1f9..5561bd9cea818 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -157,6 +157,10 @@ static int rt_mt6_check(const struct xt_mtchk_param *par)
 		pr_debug("unknown flags %X\n", rtinfo->invflags);
 		return -EINVAL;
 	}
+	if (rtinfo->addrnr > IP6T_RT_HOPS) {
+		pr_debug("too many addresses specified\n");
+		return -EINVAL;
+	}
 	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
 	    (!(rtinfo->flags & IP6T_RT_TYP) ||
 	     (rtinfo->rt_type != 0) ||
-- 
2.51.0



