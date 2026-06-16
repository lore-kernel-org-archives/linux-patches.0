Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D7B466B5E;
	Tue, 16 Jun 2026 17:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630606; cv=none; b=CUSqt8VynBGT8+LxU409/mygvRFcKHaRrYiHC/b3eirXisnbBF8eA745VnxVvpHkCIqB+NIUwqiVCx4GRHrmGbC9HPXS1a/a7ksgmv5rIz6JEKJm99g23o5cyGdz4Hqae5XRiMdNg0pMN+dRnenVj/WhU8XGSSVxZBpA4z/ISEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630606; c=relaxed/simple;
	bh=om5LhKJb8zlGSHfMCh+BFSMlmpjzv0KrNeNsYbls8So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+MKKc1oCu3JGE7KPyyY6eZbiAurGHxbggl2NBzLnh/FXn+og4JwCc9Hism10B69C9cPSMADDFZEQFMgCU9hU2qhmxrWnBzkdgNO7opnIVp6mTKA+u54OtptAtuj/9Ecu2DGZl3thFVq8oB7g1xGjGUWjiR5sEeBDyv8haAEPB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPi0+k9d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPi0+k9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C4A1F000E9;
	Tue, 16 Jun 2026 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630605;
	bh=pfCFUYea2dGGzkHE/jOiKTh62vG8DKV3Nm3Q9GU5pVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPi0+k9dIAYM98XHxqoRTPaZm7/VZNoa7Oj0wD7oE7GZYn2Ih8pW6BrcHwoYUP8iI
	 nSbo1lmUgcYsi5sGMSfmkCfg4YKanqYmPGzW2Xd43eo6l7QpyGd4Gf0TmJ523pQeZ5
	 0uAREsLpxwkhGaNWUQMAJc8v6Qak1phabkMxihGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@google.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/522] selftests/bpf: Update bpf_clone_redirect expected return code
Date: Tue, 16 Jun 2026 20:23:27 +0530
Message-ID: <20260616145128.599516752@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit b772b70b69046c5b76e3f2eda680f692dee5e6d5 ]

Commit 151e887d8ff9 ("veth: Fixing transmit return status for dropped
packets") started propagating proper NET_XMIT_DROP error to the caller
which means it's now possible to get positive error code when calling
bpf_clone_redirect() in this particular test. Update the test to reflect
that.

Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230911194731.286342-2-sdf@google.com
[ Note: Commit 151e887d8ff9 was backported to 6.1 so this fix should be
  as well. ]
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/empty_skb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/empty_skb.c b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
index 0613f3bb8b5e4e..329e34e5226e3a 100644
--- a/tools/testing/selftests/bpf/prog_tests/empty_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
@@ -29,6 +29,7 @@ void serial_test_empty_skb(void)
 		int *ifindex;
 		int err;
 		int ret;
+		int lwt_egress_ret; /* expected retval at lwt/egress */
 		bool success_on_tc;
 	} tests[] = {
 		/* Empty packets are always rejected. */
@@ -62,6 +63,7 @@ void serial_test_empty_skb(void)
 			.data_size_in = sizeof(eth_hlen),
 			.ifindex = &veth_ifindex,
 			.ret = -ERANGE,
+			.lwt_egress_ret = -ERANGE,
 			.success_on_tc = true,
 		},
 		{
@@ -75,6 +77,7 @@ void serial_test_empty_skb(void)
 			.data_size_in = sizeof(eth_hlen),
 			.ifindex = &ipip_ifindex,
 			.ret = -ERANGE,
+			.lwt_egress_ret = -ERANGE,
 		},
 
 		/* ETH_HLEN+1-sized packet should be redirected. */
@@ -84,6 +87,7 @@ void serial_test_empty_skb(void)
 			.data_in = eth_hlen_pp,
 			.data_size_in = sizeof(eth_hlen_pp),
 			.ifindex = &veth_ifindex,
+			.lwt_egress_ret = 1, /* veth_xmit NET_XMIT_DROP */
 		},
 		{
 			.msg = "ipip ETH_HLEN+1 packet ingress",
@@ -113,8 +117,12 @@ void serial_test_empty_skb(void)
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		bpf_object__for_each_program(prog, bpf_obj->obj) {
-			char buf[128];
+			bool at_egress = strstr(bpf_program__name(prog), "egress") != NULL;
 			bool at_tc = !strncmp(bpf_program__section_name(prog), "tc", 2);
+			int expected_ret;
+			char buf[128];
+
+			expected_ret = at_egress && !at_tc ? tests[i].lwt_egress_ret : tests[i].ret;
 
 			tattr.data_in = tests[i].data_in;
 			tattr.data_size_in = tests[i].data_size_in;
@@ -133,7 +141,7 @@ void serial_test_empty_skb(void)
 			if (at_tc && tests[i].success_on_tc)
 				ASSERT_GE(bpf_obj->bss->ret, 0, buf);
 			else
-				ASSERT_EQ(bpf_obj->bss->ret, tests[i].ret, buf);
+				ASSERT_EQ(bpf_obj->bss->ret, expected_ret, buf);
 		}
 	}
 
-- 
2.53.0



