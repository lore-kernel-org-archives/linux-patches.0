Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46243F825F;
	Tue, 21 Jul 2026 19:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661442; cv=none; b=ZGXliZumeFYpLnX3Ef0qKU7OzH2HWL3eaowRbWqNkV5FOtK4ekUxwv1glM5WVljRTd5yBdtI93enBfrMvtimChzbCEEwbWaQNz+ntvI7oxg5h1X3ojLllFGzipKuAF/BZJIcwk7IEi0/l7OdEBqQz+8Ia9Na23X4zdbQkgqjeu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661442; c=relaxed/simple;
	bh=VNiIeCPAbqrxNEd5Cv3WQOM6THlDCr8dquA55S5NUEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk24GFyjkzKblrWT9gl+WNrOZt3BuW9YonJLAGShPyz/ilTaKqDQcauiC/oWI2EEzTuP5IiONpEat7IKznkB7phO9Kh1gs4w0hrZX4GhEs5jqYgCrCFBvivDG+tg+fqsVUCRilNqsY2vymDYH0PvrQ9i8dpwiqkf9o49y4T94nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L0Q1gk8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L0Q1gk8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215301F000E9;
	Tue, 21 Jul 2026 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661441;
	bh=b6lSHJJKF205h3Yc9F1cCpRXqEeKKUXDvKx8ghYGzGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0Q1gk8rZBBuJVQD9WQJlthPiZoa7MGHgXmyIP/YyuM6XUqLWpwRhLKT5uDi/fmAn
	 mcF5Sx5i5IVPPnQ1mZ8mtORJF+DsxtCrPc1XYWmibWnDgRqZ5/Z7DECV0NG6zLXOvS
	 K5nNhT/yz7K1gXOBmJmz8HzSSlM0QXdf0zXYapNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Bell <grbell@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0068/1276] selftests/bpf: Use local type for bpf_fou_encap in test_tunnel_kern
Date: Tue, 21 Jul 2026 17:08:31 +0200
Message-ID: <20260721152447.610658483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



