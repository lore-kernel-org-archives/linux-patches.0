Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80654364924;
	Wed,  8 Apr 2026 19:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674900; cv=none; b=Ar0b/HnsZN9FpKykD+9INYPm9lvZCuqdLQ3JqT/FuT9WOrdHVeJ7ESQxRo6vzJQYpA6gUmLOVFu2E6nrrbRcLzqWazxmpjqsBj4aD9qv2wYzIZ2nSqZ8mClglNZafVotbONPDD2x3SV89a67EUZAXKKRGWu8crf5ReYqPvytgmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674900; c=relaxed/simple;
	bh=sd0eJdvajDHVmNBdYySnvsP+Yg212hxyxyHQur3VOYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQwR40al23JfG2/ehCU8rQH5677ANvnKp5MzAd/WpXTkQ6+Hj6aESRrbbFcqWTi30PhAz53VnZ3e426gRkagCXvjZ/VNU3D6qqzKBQMVe6n+1vpwwuOdGUhTQjgUbBOgTADyn4qiG577OAHj7lHazShMzY8M7Hl5ZNGgOwMjhto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IinDxLx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IinDxLx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D03BC19421;
	Wed,  8 Apr 2026 19:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674899;
	bh=sd0eJdvajDHVmNBdYySnvsP+Yg212hxyxyHQur3VOYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IinDxLx0Sa/kah0wFaOON9xxN9Zbclhf9YgCc/HXM9BL7sd+86+WriNIJohx3t7xI
	 mjDvxNqLRKToiY/p7qpB6JDBU2jBy+f1YBkY2R4hjb5qI8JdfRCG7wncyAlV4za1Rc
	 be+8CRjchv9NHcaYQlz+dHOv2frfb4og2nR4Sl4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Yuan Tan <tanyuan98@outlook.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 275/311] vxlan: validate ND option lengths in vxlan_na_create
Date: Wed,  8 Apr 2026 20:04:35 +0200
Message-ID: <20260408175949.649538455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yang <n05ec@lzu.edu.cn>

commit afa9a05e6c4971bd5586f1b304e14d61fb3d9385 upstream.

vxlan_na_create() walks ND options according to option-provided
lengths. A malformed option can make the parser advance beyond the
computed option span or use a too-short source LLADDR option payload.

Validate option lengths against the remaining NS option area before
advancing, and only read source LLADDR when the option is large enough
for an Ethernet address.

Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Tested-by: Ao Zhou <n05ec@lzu.edu.cn>
Co-developed-by: Yuan Tan <tanyuan98@outlook.com>
Signed-off-by: Yuan Tan <tanyuan98@outlook.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Yang Yang <n05ec@lzu.edu.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260326034441.2037420-4-n05ec@lzu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1965,12 +1965,14 @@ static struct sk_buff *vxlan_na_create(s
 	ns_olen = request->len - skb_network_offset(request) -
 		sizeof(struct ipv6hdr) - sizeof(*ns);
 	for (i = 0; i < ns_olen-1; i += (ns->opt[i+1]<<3)) {
-		if (!ns->opt[i + 1]) {
+		if (!ns->opt[i + 1] || i + (ns->opt[i + 1] << 3) > ns_olen) {
 			kfree_skb(reply);
 			return NULL;
 		}
 		if (ns->opt[i] == ND_OPT_SOURCE_LL_ADDR) {
-			daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
+			if ((ns->opt[i + 1] << 3) >=
+			    sizeof(struct nd_opt_hdr) + ETH_ALEN)
+				daddr = ns->opt + i + sizeof(struct nd_opt_hdr);
 			break;
 		}
 	}


