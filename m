Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029717;
	b=PAnpLPsV/2PDb9ST2nydDhj5KuepQs2rgZqNvUXgqLmL3Y5HFwBlI5c7TRSwwZC7FUz6
	 kNoAJShN1ORuszAw4g3rv2HyrUfySzR/nKeeR75HNCKpe+vEYnKYnkw1ZmbGSzCDX9ve9
	 QsubtvE46ul6/xtZrukjzpQXscWyEZZjnMMSraYGSZdQTUj6OXbUFzBtGLsS4YRo1EABq
	 +qVLOsMXYAoo6Tl9XE1czCOWdHO1oY85SjElG18QvkM0FFTnqrRh4y8vNKgPqbzaTvsff
	 /nbji55eH++cQrLmLlTXQmfdGHM8K6llNYhr+7OM0o46hMOt1sCzYZfqKciBd8gXkRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c2Q8Kz2rQYyi64tODVuf2/5+J8WsFNEg0QqlkB2xNh4=;
	b=wpEtu0vdQNpYZnI563yOwilrQTPOrSFX9h5x31QCVPdgZUGzI4X8C0GN40tAL+CL98mN
	 B7X2+xH9gk+oqUasHnYDwbZcnH7qFAq1EUiGaN30GnVAdCDCwQjcoCTCLOPJ00dOk1Uze
	 zz2RRhOLmTFAQjUY7au6rKUh1+Lv13pi7UsSKBvqTdP4dJ9DHAN9c5gN6KcxFg5h2T+oo
	 0ixzmSu7gyxvwWhUlbHeYEux29KR+4UjzZlURxVC82R34f4GPDnO/cWcJ5rpd0MhHvnQ5
	 1g9Wl7CQMVMK3iASF5OGBuPthjPeO/2jwGRXo+BTimy13dAW1e+0XrZVnA8ocK/zfeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEF5UGVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCE960A2609;
	Wed, 18 Nov 2026 19:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JEF5UGVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFB21F000CA;
	Wed, 18 Nov 2026 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029717;
	bh=c2Q8Kz2rQYyi64tODVuf2/5+J8WsFNEg0QqlkB2xNh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEF5UGVCIP8OvOdFaJOttMbRw/WgYLcWkRqNkLNevBYNDT2YlZx9QD4QF5cdFLYhk
	 GtNIWS7fKqUac/hivlJ9iPYvlaPwJJUmBVcB25d9IKD4CpsD91g0whKajCuXGeYxbQ
	 KA7AydeQsLdcrys7t2MjdhFj8x/uobp2LO7IelDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingpei CAO <caomingpei@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0449/1756] libbpf: Reject local struct_ops bitfields before data access
Date: Wed, 18 Nov 2026 15:42:56 +0100
Message-ID: <20261118150026.679324393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingpei CAO <caomingpei@gmail.com>

[ Upstream commit 961b8946acb482b6d7a39c266d623e5f9c4e873f ]

A local struct_ops type can contain a bitfield absent from the
corresponding kernel BTF type. bpf_map__init_kern_struct_ops() checks
whether data for an absent local member is zero.

For a bitfield, member->offset contains the bit offset and field width.
bpf_map__init_kern_struct_ops() used the encoded value to calculate the
member data pointer before rejecting the bitfield. The zero-data check
could therefore read outside st_ops->data and crash libbpf.

Reject local bitfields before calculating the member data pointer. Keep
the existing rejection for bitfields in the kernel type.

Fixes: c911fc61a7ce ("libbpf: Skip zeroed or null fields if not found in the kernel type.")
Signed-off-by: Mingpei CAO <caomingpei@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Link: https://lore.kernel.org/bpf/20260915162252.473044-2-caomingpei@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e43dad57c1125..262da96f2ca3b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1176,6 +1176,12 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
 		const char *mname;
 
 		mname = btf__name_by_offset(btf, member->name_off);
+		if (btf_member_bitfield_size(type, i)) {
+			pr_warn("struct_ops init_kern %s: local bitfield %s is not supported\n",
+				map->name, mname);
+			return -ENOTSUP;
+		}
+
 		moff = member->offset / 8;
 		mdata = data + moff;
 		msize = btf__resolve_size(btf, member->type);
@@ -1212,8 +1218,7 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
 		}
 
 		kern_member_idx = kern_member - btf_members(kern_type);
-		if (btf_member_bitfield_size(type, i) ||
-		    btf_member_bitfield_size(kern_type, kern_member_idx)) {
+		if (btf_member_bitfield_size(kern_type, kern_member_idx)) {
 			pr_warn("struct_ops init_kern %s: bitfield %s is not supported\n",
 				map->name, mname);
 			return -ENOTSUP;
-- 
2.53.0



