Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021149;
	b=2vbafEC0lz06wR6D5kC2EN2UwnayfesP57IpqHiyAPeSRZLrS7fcVefCzCe/sf1HQwGx
	 19e7OQp6LzrrNQYN0EgJ89CHsH3XEsA0AymT6pv2iAPwNFvMhrLCtAEENAmhcZdh2pAt0
	 mQqwDPvZIFnwdPMPBGl9gOUycEWRJKSyNsCO8iyyjm1I3b2tdwGkxMY8qVDYgdZ4RQeqP
	 YkzxsPpreZD6rNeT9YTwulXIM+J9UnnllNH/cszOaJzfN36DzSpAR+knxCl1S1E/ZykHg
	 9UoYLMiJQ/s6Jxq8YNjmrbiPq8fCLfmq7jhdlIlAh+PRtRhHU+oKdATGQUzZOSnLLFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ReRrRLBDGZhcB67038isnHLoOsudp2K0NggluJ1/Nwc=;
	b=PcO0YmHFHzy4I4M9KHeR+i7xjQudDsp+BMrEOB14x40RsrcGDF19bRReQPQf7/oOmZzz
	 kxfZb7Do5KPrJe8RL5kv6qPsg9AXEkG8eo3+OJsthPHAnPnjPyrBod6pWxuO3kzVrrr6u
	 4sQK5UFnlYTlqOTgcK6GtU4TWttoqrAvT9yPJqhz2Tjeduj+YRruZ8ctN2qOoFaIGr7iS
	 izal3DDAyrg0+UC8qQs4Wl+Z8cZbLqIl91nmac6OuIZBoFVKPJugCAEVn7gRggaA/NgwZ
	 KQZOvyHnbm04KVcAzt4Ufc1q3X6oomhizTePhJYJLlT7WPibmJJSLMDTDox/p2TlHVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ShdUUcTy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B7F606A325;
	Wed, 18 Nov 2026 16:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ShdUUcTy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAA21F000C4;
	Wed, 18 Nov 2026 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021148;
	bh=ReRrRLBDGZhcB67038isnHLoOsudp2K0NggluJ1/Nwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ShdUUcTyeD7dwdemUX2KSMDkz0Paea8TXpXe7wu1w9w3JCl5/7e1pKX/3XnufU3aF
	 pd+ZF9u+ly4rstb8c4Xk0LqSd11YT3Fwyw/OS6hCOnsiAjSOAFLQ859ovgzcB/EF/g
	 cjASU1QSgfjbMzfHZWmy95FsPxvSYao+qXhC6/3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2204/2651] ntfs: return -EINVAL from ntfs_collate_ntofs_ulongs() on bad length
Date: Wed, 18 Nov 2026 15:57:24 +0100
Message-ID: <20261118150405.031185968@linuxfoundation.org>
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

From: Baolin Liu <liubaolin@kylinos.cn>

[ Upstream commit 41001a72daa35ead23d74ee7b6f2373f237c0d72 ]

ntfs_collate_ntofs_ulongs() returns -1 when the key lengths differ or are
not a multiple of 4. But -1 is also what cmp_int() returns for "collates
before", so the error is indistinguishable from an ordinary result.

ntfs_ie_lookup() acts on that difference: it maps -EINVAL to -ERANGE, but
treats -1 as a tree-descent hint and breaks out of the loop. A malformed
entry in $Reparse/$R or $ObjId/$O is therefore silently taken as a lookup
miss.

Return -EINVAL, as the sibling ntfs_collate_ntofs_ulong() already does.
Well-formed keys are unaffected; both indexes use key sizes that are
multiples of 4.

Fixes: 5218cd102aec ("ntfs: update misc operations")
Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/collate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs/collate.c b/fs/ntfs/collate.c
index 77e34038902d1..744fdfd7bf585 100644
--- a/fs/ntfs/collate.c
+++ b/fs/ntfs/collate.c
@@ -73,7 +73,7 @@ static int ntfs_collate_ntofs_ulongs(struct ntfs_volume *vol,
 
 	if (data1_len != data2_len || data1_len & 3) {
 		ntfs_error(vol->sb, "data1_len or data2_len not valid\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	len = data1_len;
-- 
2.53.0



