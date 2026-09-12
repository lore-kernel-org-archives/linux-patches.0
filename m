Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E26235358;
	Sat, 12 Sep 2026 07:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199387; cv=none; b=ICTDlG251+xoi/+kl2kF17gXxe4xxWUkAgeRhTLLOjwkPvtyrzYAGZqGsrclT2MndndvRXmMZmuClHNa4EwNPjyZx8JD2gu6fwbtyXmGXTWe8hod+zSzkGa0o6HKHtVApES18xfSvHcq7lUWXHBhFe7UtgmB+P4dxKgQGMAo7k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199387; c=relaxed/simple;
	bh=Oaa6vveX27m4ZWHXzGxaAmqQTatLFpUQA7xHQTE2zUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P91hqt2r5RkUs7iUZW+xVWrCjU7fEQv22eAfvxthPLiZfiHTjhc1VIdfe/2SxmfGXGt9g75jvryBXg7zsB9rt6/cYOfxRMKtOVXi3I7xXUfInKRp/4WGvxIHhC3a7m7x3GF/0rhanBevpjK/xNiP/HH7QhexkxABXULmUEhdhEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQQXcgZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQQXcgZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877BF1F000FF;
	Sat, 12 Sep 2026 07:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199385;
	bh=s57O+cZanGcK3TCeB3hEBtyqh69X+1n7OvMQanlrR0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kQQXcgZjxSCm+iKc6rNRYfihDvMBbhjuDTVF/SMGPp2UciCVzgwZqqBgY1o6Wuxv2
	 0ZeBdrtgtyWgzY1ckqEB9E6SgfHbVeuoBbkpEUtSWwsickIxSXsZl6JbSWQIXn8uFf
	 BuRc9YrpCQTL3v/QmVwUNBJIPirRAwf4AiVxmCjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0574/1815] bpf: Mark bpf_refcount field as unique
Date: Sat, 12 Sep 2026 08:38:44 +0200
Message-ID: <20260912065702.356568583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1991003f1e87a..608be952717d4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3669,7 +3669,7 @@ static int btf_get_field_type(const struct btf *btf, const struct btf_type *var_
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



