Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020914;
	b=gV58odSRE++RhSvs56BTEZAczpCswIjLPfOEriammH4SsrGh+pMe/jaqSMH2vFEP//m0
	 lSAmuKlwPJcqo9pDXKVBQIlJLcBNjv7fq/7zOAOLm5udEgTkcSuXIf2ociDocJSrapxmH
	 9De4DpKn978BTiqOPkTjOcFo9Wi9mFBnmywtDHXhC9nFpKPddCfKX9+rz+NCui5Cp/SXD
	 mVfzOJgPh4SoDRTVyvI5UU3LVcB1WxZkHRgy9X6+HcbEytbb5iVEx6eOeI7RY4vNS0Rwi
	 iT6P/Xv7aak3ltKLpin4qvIGpOPtLtfqyOE+PXkDTG48qp1DstjsfI1HM8+d4dWduAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1eLqoZI41uOrx2jOd67crji5XjLazEgMEPG6h0J549s=;
	b=S9CAKUyHtCQ4nTR2SWEIAPaJSBXisTQ1TX1DRJqbZi0Cdgck9FoE0WcA+w1PwnMIOeXJ
	 Tr6Q8i30cVDZfwSTxWtDNoLgoIGY4AHIakXKAuxnpOsTLz/b/hXTovoAZBFrU2rs6kEb1
	 xbansbiPRrA2sUUdUbUPNyitB3/IDlNXOlPR664cP0qxs7TkNAVT3mIq9YOcg2VzZmW73
	 kDv0bQlM1EIJYpmAqoTTur46aN9Qe/Sw8A8cV97oN+t5bIf/Yk/YLPgknLiNUK3dYbAQs
	 skk6tYbfiVGWm74Y5/zt+ZW8JotsD09MxPOcc/4r/vB7+ZLvGppfpNDcZcLiqClaLvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHIdRlHn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A825606A325;
	Wed, 18 Nov 2026 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nHIdRlHn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2681F000C4;
	Wed, 18 Nov 2026 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020914;
	bh=1eLqoZI41uOrx2jOd67crji5XjLazEgMEPG6h0J549s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nHIdRlHnvfiDAyJU8375UYptnTNC5i+XvYumwDUhVHwC969Hg+fxQy8mmat8SiqDv
	 /JHy1iMstgnKAskwRUgEE/tDOTUSDHjcmlTw5boZtjI/+cXGy3hjeaIqllCTIMtqwC
	 gMeXzsWwkn88HYZx4vwcyJV7IbSWZUytTsRkC1W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2121/2651] bpf: Dont take a program with a target program for an iterator
Date: Wed, 18 Nov 2026 15:56:01 +0100
Message-ID: <20261118150402.277025432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit b83bacf2161d0f8583e3f1e9c90402638992ad82 ]

bpf_iter_prog_supported() goes by the name of the attach function.  Commit
7cc639dc45c5 ("bpf: Don't take an extension for an iterator program")
keeps out extensions, for which that is the name of a function of another
program.  A tracing program with BPF_TRACE_ITER that is loaded with
attach_prog_fd gets there as well: unlike for BPF_TRACE_RAW_TP,
bpf_check_attach_target() does not mind the target program.

If the function is called like that of an iterator target, bpf_iter_bpf_map
for example, its id in the BTF of the program is cached as the id of the
target, even if the load fails later.  Programs of that target which are
loaded already cannot be attached any more.  And the program itself can be
attached as an iterator of that target, with a context that the verifier
has taken from the prototype of that function:

  BUG: KASAN: stack-out-of-bounds in bpf_prog_66d4234e2e50f5b6_ts26_forged+0x12a/0x20b
  Read of size 8 at addr ffffc90000d9fc48 by task ts26/104

Refuse every program that has a target program.  That covers extensions.

Fixes: 15d83c4d7cef ("bpf: Allow loading of a bpf_iter program")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-2-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_iter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 05d8b30bc4f7c..8e5069b477aae 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -352,10 +352,10 @@ int bpf_iter_prog_supported(struct bpf_prog *prog)
 	int prefix_len = strlen(prefix);
 
 	/*
-	 * The attach function of an extension is a subprogram of the iterator
-	 * program that it extends, whatever its name is.
+	 * The attach function of a program that has a target program is a
+	 * function of that program, whatever its name is.
 	 */
-	if (prog->type == BPF_PROG_TYPE_EXT)
+	if (prog->aux->dst_prog)
 		return -EINVAL;
 
 	if (strncmp(attach_fname, prefix, prefix_len))
-- 
2.53.0



