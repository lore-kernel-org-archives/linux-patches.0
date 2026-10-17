Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7FC38F253;
	Sat, 17 Oct 2026 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253606; cv=none; b=nQuKcDD5LnoiuGkkkh2hXSExSyqMwWezX+1GU9L8oqaj1ROj+1QA8qN8gXHp+TeVau8HzCq5u1qTBBTcHfmcLQ7BhgozfpRA7iySpRl1Iu6+8e+GIP8oiGmSZBYTe+dtukf0GfSjZXTKoIN4hNZZ9+PL4DkJjm6X3k+/zFuBGNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253606; c=relaxed/simple;
	bh=dAmR4AYjciAvVUZbdnDkpE/1S1dpio9UCPxkZD3Lbn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfrbX7LzJA6JGW+VmAvzv/nCbb7NvlBnVgOf6CPusqQ9vHhinnqT7HYcJWPuqvTA3XVw43E+kNuZBNIsIi+7WUG4WjfBuI8KjbQ70TLHChmR3DtRBAlTxZsMbR1flYFx1Vjn7CVufSvRQ67GHMXvdNT8mksxBrjrB9I38qMNlbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLj0s5ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLj0s5ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EB91F000C4;
	Sat, 17 Oct 2026 16:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253601;
	bh=2CtHmpvG3sx0p8CV/anGuOQmFt1Ofa6w14Vn4+cOEyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zLj0s5ul/A2OwdmP3rQtCLoXBx/I6wbXMy+exS2G2QKnlzOjkkMjgD+ubRTrK+XAG
	 cycVpgfcRhvn3ChKB08JzGw8X0oH6kA7/d6lctc+XVNle2O41mvsQ4A65LyxZWXHM3
	 k5kVOb/HsANVRM9WeRE1Igi+6fC/3ilWjzwBiBkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/869] bpf: Mark bpf_refcount field as unique
Date: Sat, 17 Oct 2026 17:50:14 +0200
Message-ID: <20261017160041.488251323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 61e655391cb19c31f94ecd4354f624c81ce4cf75 ]

BPF_REFCOUNT is not marked as a unique field, while it should be. Fix
this oversight.

Fixes: d54730b50bae ("bpf: Introduce opaque bpf_refcount struct and add btf_record plumbing")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://patch.msgid.link/20260719153634.2908692-4-memxor@gmail.com
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5f3b1162208b5..0c6d0b029f016 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3518,7 +3518,15 @@ static int btf_get_field_type(const struct btf *btf, const struct btf_type *var_
 	field_mask_test_name(BPF_LIST_NODE, "bpf_list_node");
 	field_mask_test_name(BPF_RB_ROOT,   "bpf_rb_root");
 	field_mask_test_name(BPF_RB_NODE,   "bpf_rb_node");
-	field_mask_test_name(BPF_REFCOUNT,  "bpf_refcount");
+	if (field_mask & BPF_REFCOUNT) {
+		if (!strcmp(name, "bpf_refcount")) {
+			if (*seen_mask & BPF_REFCOUNT)
+				return -E2BIG;
+			*seen_mask |= BPF_REFCOUNT;
+			type = BPF_REFCOUNT;
+			goto end;
+		}
+	}
 
 	/* Only return BPF_KPTR when all other types with matchable names fail */
 	if (field_mask & BPF_KPTR && !__btf_type_is_struct(var_type)) {
-- 
2.53.0



