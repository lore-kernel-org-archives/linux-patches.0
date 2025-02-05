Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56161C6BE;
	Wed,  5 Feb 2025 15:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768053; cv=none; b=FGdVeO6ectjkofI/PLXwyDEsscBItlYgouasRnJYdMD27C7wemDAjHpJUWWxuHUC+pkE63DSoqa/o69p3KS0HBnNuWQAD+7uuMhaqaTprN2jK21Ho/EBi5xq0+BkkzlfZqSUtCPDvVnawqHdRQtP11Gaby1d+Pk0x9ROICp/NS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768053; c=relaxed/simple;
	bh=XadcQGSAGFE8/uZjFl9UgzBdOwt2A6OqKqMp85gcPXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1ybyygY6vZEp1+Ill7x4jT2cQh4phIRhtXuRg4W0Mz/721Agd3YxncW0Bewo8rr8nt/13Ugl/67xWTe8330eAsTdO+YGeo+upBao9mCZGoeueRRGaxGBGs8WJ88MKg5Aaua95zOo3oqQ/bChQlJYImnEAt55ig5XiN/MthI3vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w9ogjxgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w9ogjxgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4901FC4CED1;
	Wed,  5 Feb 2025 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768053;
	bh=XadcQGSAGFE8/uZjFl9UgzBdOwt2A6OqKqMp85gcPXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w9ogjxgpb92Ya/pq3j0oz4YqXKJKuj3ll9OrLJjlxhrLyWDH6UHICY3dDJPVeF0yJ
	 VpSCPWnOCkATpqrB8KmIRqXnKXI3Ybd9hjnndXl4UrwXo/PPwnB4JTsnFd6sjQArIW
	 rF5+jrUW8DoyX64hAgWjM8WT8+h/JhV2BmdB0ZDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 489/623] NFSv4.2: fix COPY_NOTIFY xdr buf size calculation
Date: Wed,  5 Feb 2025 14:43:51 +0100
Message-ID: <20250205134514.925055922@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit e8380c2d06055665b3df6c03964911375d7f9290 ]

We need to include sequence size in the compound.

Fixes: 0491567b51ef ("NFS: add COPY_NOTIFY operation")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42xdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs42xdr.c b/fs/nfs/nfs42xdr.c
index 9e3ae53e22058..becc3149aa9e5 100644
--- a/fs/nfs/nfs42xdr.c
+++ b/fs/nfs/nfs42xdr.c
@@ -144,9 +144,11 @@
 					 decode_putfh_maxsz + \
 					 decode_offload_cancel_maxsz)
 #define NFS4_enc_copy_notify_sz		(compound_encode_hdr_maxsz + \
+					 encode_sequence_maxsz + \
 					 encode_putfh_maxsz + \
 					 encode_copy_notify_maxsz)
 #define NFS4_dec_copy_notify_sz		(compound_decode_hdr_maxsz + \
+					 decode_sequence_maxsz + \
 					 decode_putfh_maxsz + \
 					 decode_copy_notify_maxsz)
 #define NFS4_enc_deallocate_sz		(compound_encode_hdr_maxsz + \
-- 
2.39.5



