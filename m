Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023819;
	b=tpD6wH7ufru722E/vtsE7NSY/ahKXg4jk5gP0S5FiDaQJVCyI4m/M4KtBdt4IW16V7VV
	 HqlqWmGDEqMih8RBerGxrlA5MJYtUilesfjCmGwsw1cuM7Et+TzNo7IlM6WglgdxcUFPS
	 KSTdE0l07FIGOygaJBhvU2PJycROMpuPj4Np00VzkGK4i7M5dBEe0Ua32NsPzmosV5RyL
	 U4GkUmgoMp5J5YqCb20DdK2E3jersiSIRJIWFMps6ryDwHb2+L7zTcu5wUDf50uqnkjUH
	 uc9PJguwW5bi5/ldI6D2bKOmb3I4WMuWsk+1Ncdzvjx0d2AHziVLi+Qgb3BWoxpncfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9fDHHWIeHmi/SEHYPViSZb6SsJ9bk2BVj3oyAr2fDNc=;
	b=dqnxqhbbxO4Pzqmhy4fRK9HJYsODYmP7quYimGrdbvZgZ9vZ1PVRN4ySA8msmtjQxgym
	 8e7yoxZl48bZpnphWLvvFW2BUbmt5tVevU886XE1Zo7wmv+44r6VE0b7wg0SSTyyC/Fj7
	 Wnt0S2qhq0FNA5EH0y97gSe26vRjseY+Q/f0Ev4ZkABt/OCqE2k19FlYKGW6jYfTGU4Aw
	 bGi6RDYToenv7YVguwpYQsuKOsMzWcC9MswNC0KDLkrJ3iYqArZw/EriIO/yTyRV32Yqg
	 dE4lcqHa0m3m3EtZ0ejI6D+oF9gajSPt0otKver3xf/iskHPEymypeSrrFW6OzbVOTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7nmBDpE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F4E606A32A;
	Wed, 18 Nov 2026 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7nmBDpE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693A51F000C5;
	Wed, 18 Nov 2026 17:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023819;
	bh=9fDHHWIeHmi/SEHYPViSZb6SsJ9bk2BVj3oyAr2fDNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7nmBDpEGyH1QMnYArpnqzXIThhr2BW33flD4RNApwSzDGdo0Mpt2qgERu0mqRykJ
	 TDepfnTdt0XCUbjmnRwq4yXp/UVkJcc8QDwCAZlyPqM91qfbPfYLaZJxdtf0WdQyj2
	 9XEc+OP4pT/sk/SB4TH3+Fx1ySGjwR3Gq+IsmUZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingpei CAO <caomingpei@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0504/2151] libbpf: Reject local struct_ops bitfields before data access
Date: Wed, 18 Nov 2026 15:37:19 +0100
Message-ID: <20261118150140.409454318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 711a30e70ec22..f6d29013d6697 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1182,6 +1182,12 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
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
@@ -1218,8 +1224,7 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
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



