Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348A7F9E0
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76D3C433C9;
	Wed, 20 Sep 2023 12:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213222;
	bh=AoR7XirbOiIVcMVd6qUjhKAWTzQW9bpNfp9hHMWBhXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YULBYoCFYCWXYphpDdVB+31qTbVy0uoylbfn7XArtI7FEyaIICR6Xvm6BKQCozv7l
	 slz4uY9Grss/1Q2f043dYjri1H8xSVmLcx6dy7vNBa30RVNtVAth2SlK07m30ISKxJ
	 CoXqg1LrVJxkxTg186jCvYRw95fWlWR9aRAk/OIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Kyle Zeng <zengyhkyle@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.4 205/367] netfilter: ipset: add the missing IP_SET_HASH_WITH_NET0 macro for ip_set_hash_netportnet.c
Date: Wed, 20 Sep 2023 13:29:42 +0200
Message-ID: <20230920112903.928021944@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <zengyhkyle@gmail.com>

commit 050d91c03b28ca479df13dfb02bcd2c60dd6a878 upstream.

The missing IP_SET_HASH_WITH_NET0 macro in ip_set_hash_netportnet can
lead to the use of wrong `CIDR_POS(c)` for calculating array offsets,
which can lead to integer underflow. As a result, it leads to slab
out-of-bound access.
This patch adds back the IP_SET_HASH_WITH_NET0 macro to
ip_set_hash_netportnet to address the issue.

Fixes: 886503f34d63 ("netfilter: ipset: actually allow allowable CIDR 0 in hash:net,port,net")
Suggested-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Kyle Zeng <zengyhkyle@gmail.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -35,6 +35,7 @@ MODULE_ALIAS("ip_set_hash:net,port,net")
 #define IP_SET_HASH_WITH_PROTO
 #define IP_SET_HASH_WITH_NETS
 #define IPSET_NET_COUNT 2
+#define IP_SET_HASH_WITH_NET0
 
 /* IPv4 variant */
 


