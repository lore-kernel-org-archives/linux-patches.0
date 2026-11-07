Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065171;
	b=4FoJ6ilA1/zdlFvDOAbEEv+CpwC0p5DVqs2dso8/OJYyrISPKglA/Utecjoyn3qRoZjq
	 R4ZzfJAPWrCG7gvPvFRk968McDROEng52P0wIo77svtqFyhSVgguwsIwSoiEAANsViIPY
	 PGsSOdDPVSPHDi4xoC83tlB6W0SOP6X2XbjynTYOrCS2yUCrQhajzkJgiw5NRHPqsaIBL
	 TgPwRGqR9zEhrw6KJhjCIAPNJmb5jTxLe3ldOfSGGWPlPkBUIX7ET4zmF4Dk6I+fJfRQh
	 syR6XCNIWnQ9Qed3+pPAyiJorZTaVbVgRkQHdvNekhJG5/0JGJOp5k+eSju7ewbhWjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N8wYiieJMBE7oFNOafFLUCGmokc3FpRMHa3c7wxwx30=;
	b=5JT9HCvA/Is9qQy9SAxhUJQ2YSzqozNYbtOog9KTZmchSoDs/JRiny/UcHlPf6ucesmo
	 kTzCEeZ95aAJ5sN8HYgHErcomwqNp4bAEp/tORj6j8NFlgiR4UPTcRX6+dbQkyfT3Cebj
	 zyr2dpL91bY69JE64lTvXBcrXNKrUFj1BklvQ9MmTz6YyrtalCYbkicKOXKCk554wP7vC
	 hXRgpUUvtfGOdEXC6iMKGQ8S9lgcvXzlJ8XC6xd1fDdIfiC/eITsxnmitoWtgGHG6FiTd
	 U9TabnfIYZG9dez1hGbl2yb0A/uT2lsh7eb3thO67+f2Y75R1eeGPc6T94UxdiPPfUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9jRLi+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A31C606A32E;
	Sat,  7 Nov 2026 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9jRLi+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9F01F0089F;
	Sat,  7 Nov 2026 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065170;
	bh=N8wYiieJMBE7oFNOafFLUCGmokc3FpRMHa3c7wxwx30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9jRLi+KW+Y3cF8PG1fdpmek/m18Z15GYW3Jq3q/FYJpw4PjgM6867ev9YY298X/a
	 6ILsIMthHY4iwzNaVz0vfxxi3MqW3CmfrNnyaGHmQ1N4GfmoQPYoHCgHABc+CCVaVu
	 bueUh2o4K2Wev9CaZGVU2knShXNKlVqktKmEsVO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0925/1257] ntfs: include the final partial cluster in sync writes
Date: Sat,  7 Nov 2026 08:53:41 -0500
Message-ID: <20261107135004.900227602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit fa5489ebc8bc7c663311b0f35943fe7edd0dfe56 ]

ntfs_attrlist_repack() synchronously writes the replacement attribute
list before updating its mapping pairs and freeing the old run. With
512-byte clusters, a 544-byte list submits a 512-byte bio, but the
write returns 544 and repack accepts it as complete. If the later
buffered update does not reach disk, the replacement list lacks its
final 32 bytes.

__ntfs_inode_non_resident_attr_pwrite() converts attr_len to clusters
with ntfs_bytes_to_cluster(), which rounds down. Before repack, its
synchronous callers used either cluster-aligned lengths or lengths
smaller than one cluster, where max_t() selects one.

Round attr_len up so repack writes the final partial cluster before
publishing the new mapping pairs.

Fixes: b1d732e62a5b ("ntfs: repack $MFT/$ATTRIBUTE LIST")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index b3c5219c7b770..86e359a7c53af 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -3760,7 +3760,9 @@ static s64 __ntfs_inode_non_resident_attr_pwrite(struct inode *vi,
 			struct runlist_element *rl;
 			int bio_err;
 
-			lcn_count = max_t(s64, 1, ntfs_bytes_to_cluster(vol, attr_len));
+			lcn_count = max_t(s64, 1,
+					  ntfs_bytes_to_cluster(vol, attr_len +
+								vol->cluster_size - 1));
 			vcn = ntfs_pidx_to_cluster(vol, folio->index);
 
 			do {
-- 
2.53.0



