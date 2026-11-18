Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016522;
	b=3tmj48ksLaBZwEWvYMaROGZG1HNA9s5ohLja5dkoFUPlCfsTvemYJNTB1jUex/LnyYKB
	 SPO3/tFduTCW9UAWK4UZAaKdFiFyip8GANGxu3J33l/Eml0Wvpnzi7XL63y+Cyv8JfPBY
	 iJk6yCPdczmXVwblAmJap6BoxkanyXLUReqNw0kQJPE5kkMI2AmrOYMfBLaWqTa2CIz7G
	 3e3/YUctWvgTPJcT4xzUIl1vG+LMireylWBhX6uHEHCpVONW94HVFbg/ni5j5nmRAbCP0
	 8UvC9ivu61geKXEkIqp/Qqfj9MMG+5Qn7l8U34LzHo3zLx1U4Psm3wH9isOSeRPmh8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1a1rejp8EB8Vx0QRA3YNAklyA/TxqvZgXVDxrBNeb9Q=;
	b=v85HNGiEvc6MDdbjWWWpLFUpcb2e2cjhbnzPM4SxwzXhmYL11IQ4hZgAJ5yeXIfBXOI8
	 evmIywKwLqPAN6yzpwJ8FbtCYd0C0OKlWflZ03oXf/D24+w2ClEr6uzvYxBkwBbrvs5JP
	 IBMnbjp5nEHPkqRRRYwiKrekEqeWU1+KZtYw7FVr7z8yYPH5Cwsd4Pq3uDucqu9qCWALw
	 oVxw7kXTH4o+d7WMi2Ysd0N8xl3DHKT/nhOniYiMq+YztKvxPyu1HqP25y3fNQmA6pi7H
	 i4hm2NTMHeGcmZ0ZobO4sj883ZqPbex3T7/SfpeuHjv+DxaaZ/rnk1ffL293KohXKgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rkl8kXE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103E7606A31C;
	Wed, 18 Nov 2026 15:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rkl8kXE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C261F000C4;
	Wed, 18 Nov 2026 15:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016521;
	bh=1a1rejp8EB8Vx0QRA3YNAklyA/TxqvZgXVDxrBNeb9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rkl8kXE0eKlwXFCtw3aIpp3LC099OCMY31MdorVus+lHKhguIw1q1JVJAQFODwHAs
	 CkO9Opzg8ZzJ1Aub7NKrpUACXZ7LsApEoGSbn684nrJpz7JtqTA/WLSxm/Dao32MFd
	 zMWJrZTyaYF5nnSxMnEmI6LjDd5jR0RuoVoxpACM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingpei CAO <caomingpei@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0556/2651] libbpf: Reject local struct_ops bitfields before data access
Date: Wed, 18 Nov 2026 15:29:56 +0100
Message-ID: <20261118150307.758989719@linuxfoundation.org>
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
index 5dc99096487f7..03daf99224a3f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1223,6 +1223,12 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
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
@@ -1259,8 +1265,7 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map)
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



