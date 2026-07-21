Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C95D46D2B3;
	Tue, 21 Jul 2026 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655611; cv=none; b=DwSpYc5dxb3jdIjMLAfdnVpDk+XLGAr6fM0NLbW20SfTjrBkfIGZtQhaXWHyGkXJ4/ITEJmEd9aQmCrYHuO59N7nF30nGx33q0Jwi0XARU+l8L6sG+V1TG8MwEP0R4VKX89KAsX0YnCNSh30BXIB50sILDAxeXDojg3ENEUguYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655611; c=relaxed/simple;
	bh=CkRfP1Bz2BzLFWFFI2nzokpJ2pCxJm01nB1SQ0W7MQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2EeLbx9iY7kg+S7RE5sE5WRRts5o0jrPJp4Mw+h0m6vVVtb8yKtCx+YEk10JJQ/PWPz/jsKlJp1M+GKQ4pK8AFvkAe/jucZT6Qae47ed/XmMd4y4d1o9gd69eBALzpltsRGSZYVs7cwRkELkm9dAm0fZzTq8spWBCVLYJkRU0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YnZ0w3d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YnZ0w3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35121F000E9;
	Tue, 21 Jul 2026 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655610;
	bh=+kOVTRs5gdbYgrR8JUA0i7LHZIlOltaRzZEDW8/dNVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YnZ0w3dU35dTMXI8VtL9cIfSiHiLgdrjpqHSio9v3jzaKpxW3J/O/b27rK+FdR+0
	 55WFU6Tnc++Pkry9qdlAI3kUdsQng6YjmAVs9a0x8gOthqLDTbP4v48+B4cCLVspXp
	 MnzP+MMYzPvVl6FxFFbYTPET21D3iqw0GdIR0tSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Bell <grbell@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0074/1611] selftests/bpf: Use local type for bpf_fou_encap in test_tunnel_kern
Date: Tue, 21 Jul 2026 17:03:10 +0200
Message-ID: <20260721152516.500377475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Bell <grbell@redhat.com>

[ Upstream commit afb0450be061907a0f5d36bd8b010ca30eda3d3b ]

Replace the forward-declared struct bpf_fou_encap with the existing
bpf_fou_encap___local type in the bpf_skb_set_fou_encap and
bpf_skb_get_fou_encap declarations. This removes the need for
the forward declaration and the explicit casts at each call.

Fixes: d17f9b370df6 ("selftests/bpf: Fix compilation failure when CONFIG_NET_FOU!=y")
Signed-off-by: Gregory Bell <grbell@redhat.com>
Link: https://lore.kernel.org/r/20260417154122.2558890-3-grbell@redhat.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/progs/test_tunnel_kern.c  | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
index 32127f1cd6872e..30f1de458669d3 100644
--- a/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
+++ b/tools/testing/selftests/bpf/progs/test_tunnel_kern.c
@@ -6,6 +6,7 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
+#define BPF_NO_KFUNC_PROTOTYPES
 #include "vmlinux.h"
 #include <bpf/bpf_core_read.h>
 #include <bpf/bpf_helpers.h>
@@ -36,12 +37,10 @@ enum bpf_fou_encap_type___local {
 	FOU_BPF_ENCAP_GUE___local,
 };
 
-struct bpf_fou_encap;
-
 int bpf_skb_set_fou_encap(struct __sk_buff *skb_ctx,
-			  struct bpf_fou_encap *encap, int type) __ksym;
+			  struct bpf_fou_encap___local *encap, int type) __ksym;
 int bpf_skb_get_fou_encap(struct __sk_buff *skb_ctx,
-			  struct bpf_fou_encap *encap) __ksym;
+			  struct bpf_fou_encap___local *encap) __ksym;
 struct xfrm_state *
 bpf_xdp_get_xfrm_state(struct xdp_md *ctx, struct bpf_xfrm_state_opts *opts,
 		       u32 opts__sz) __ksym;
@@ -781,7 +780,7 @@ int ipip_gue_set_tunnel(struct __sk_buff *skb)
 	encap.sport = 0;
 	encap.dport = bpf_htons(5555);
 
-	ret = bpf_skb_set_fou_encap(skb, (struct bpf_fou_encap *)&encap,
+	ret = bpf_skb_set_fou_encap(skb, &encap,
 				    bpf_core_enum_value(enum bpf_fou_encap_type___local,
 							FOU_BPF_ENCAP_GUE___local));
 	if (ret < 0) {
@@ -820,7 +819,7 @@ int ipip_fou_set_tunnel(struct __sk_buff *skb)
 	encap.sport = 0;
 	encap.dport = bpf_htons(5555);
 
-	ret = bpf_skb_set_fou_encap(skb, (struct bpf_fou_encap *)&encap,
+	ret = bpf_skb_set_fou_encap(skb, &encap,
 				    FOU_BPF_ENCAP_FOU___local);
 	if (ret < 0) {
 		log_err(ret);
@@ -843,7 +842,7 @@ int ipip_encap_get_tunnel(struct __sk_buff *skb)
 		return TC_ACT_SHOT;
 	}
 
-	ret = bpf_skb_get_fou_encap(skb, (struct bpf_fou_encap *)&encap);
+	ret = bpf_skb_get_fou_encap(skb, &encap);
 	if (ret < 0) {
 		log_err(ret);
 		return TC_ACT_SHOT;
-- 
2.53.0



