Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B0425B0AA;
	Sat, 12 Sep 2026 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208030; cv=none; b=lt/D/cIrQ2Au3H4ZMMrYz2ZPs8q2jjmqbqFPXYiu44pC4AMtuKxYzUYh7RH7IUzFW3NRtPhmT2Yjhuj9wR+ejkRxzm/KV3IXbr08FRkoPGGDf+szxG/OA7n7INhh+K846y4eYNyAqwU37LQp2dYothj7dOR23d9T4tIgQYuW/TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208030; c=relaxed/simple;
	bh=pKnysz7j1ag5fl01T8GiAvJgJd42wpQ1pV1mEH7HpgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaIQ1s6unrWSPEUmVhTnugk5pWZBvDwn2jatBvvjBWTAH7tpvgZi5aHCMMGGLufBrx+6gdCbgNEUDWtJS+84uj7+B+e/RswJy3iAyp0x2utny5nl4UhIyr8d/jzjKbBZkuW6y6V6gdbcSDpvSJofFsdA3XvVPMVQyxC0nuF3nTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYGUdFXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYGUdFXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6CC1F000FF;
	Sat, 12 Sep 2026 10:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208029;
	bh=jTbi3VQLi9C0ib5wMYbCLswL1e/h8JP3ARNrWxl3KO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYGUdFXPDYfKTBHRbi7tiGQhshr/VbJJy8ekLlR/zawQQ6DyHSLdGhKj/KSHGY96H
	 DeVPmLCj5lumq+MnEcnzIRAU5PU/jDJJyyuPgQNMyecK2oIpW2kkYY0ShKoZ7wf1R3
	 oLW4m6AA7rHHUhRlTXFG/scxjBc8By/1pXlj4iT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0507/1518] bpf: Mark bpf_refcount field as unique
Date: Sat, 12 Sep 2026 08:44:36 +0200
Message-ID: <20260912065634.914520756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6d616a67aa40c..f0b865afa9d16 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3504,7 +3504,7 @@ static int btf_get_field_type(const struct btf *btf, const struct btf_type *var_
 		{ BPF_LIST_NODE, "bpf_list_node", false },
 		{ BPF_RB_ROOT, "bpf_rb_root", false },
 		{ BPF_RB_NODE, "bpf_rb_node", false },
-		{ BPF_REFCOUNT, "bpf_refcount", false },
+		{ BPF_REFCOUNT, "bpf_refcount", true },
 	};
 	int type = 0, i;
 	const char *name = __btf_name_by_offset(btf, var_type->name_off);
-- 
2.53.0



