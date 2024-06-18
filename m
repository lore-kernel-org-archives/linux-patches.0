Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374E413BAFB;
	Tue, 18 Jun 2024 13:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715832; cv=none; b=KRrzvGnO2ZCp6owctu1sT4Ni0EiBgAyYBMmTExFCfF+sBtKE8xAecJ7tGlKNaCh++zeKXvC27/Sok9y1n0LtyZYNAMBfJ4ti7xOHbPD3OOIMUaU+Qv2vjmmja0fXObdAefF4A/YpBiOi26Y6s5qI/KzTho5xbLdwMlNBq8/H0LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715832; c=relaxed/simple;
	bh=UbNmr5P6fIZ4Nn97Ln+p3HCXvz9jwgJpFLKx7pI5i1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WTDM75IUB1Q/85CYGJb1g6zOnjzOfKV0FqgBxWrfDLXpwDyKwCxnZx5W+jmTlTdzTNh4AAaffSQYBGveO88WYm0GWgQToPlBmMnn8hrdWOWVY0p1OQdzf50yLMGZWYfQdg6PqA6dvazA9n90RDBm89F1n1Ya4INzBIEQn/pKe1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baVF4lH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baVF4lH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B336BC3277B;
	Tue, 18 Jun 2024 13:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715832;
	bh=UbNmr5P6fIZ4Nn97Ln+p3HCXvz9jwgJpFLKx7pI5i1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baVF4lH5FafBYhZjVmrxf5zHmozSFBVzema+XlCCOVZxm87ANmErnbBSlfGILedXh
	 8uuMoqFKAokvFY+dPIGTmxO6V5iKFt8yr9MoCmVc+29y2WvANAsFveCUVtvTVFHeoV
	 4+6O30DrnRjJebJ/phZ63fhGx0TQ6L7nzRW3pQnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 440/770] NFSD: Fix inconsistent indenting
Date: Tue, 18 Jun 2024 14:34:53 +0200
Message-ID: <20240618123424.271850268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 1e37d0e5bda45881eea1bec4b812def72c7d4aea ]

Eliminate the follow smatch warning:

fs/nfsd/nfs4xdr.c:4766 nfsd4_encode_read_plus_hole() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index d9758232a398c..638a626af18dc 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4812,8 +4812,8 @@ nfsd4_encode_read_plus_hole(struct nfsd4_compoundres *resp,
 		return nfserr_resource;
 
 	*p++ = htonl(NFS4_CONTENT_HOLE);
-	 p   = xdr_encode_hyper(p, read->rd_offset);
-	 p   = xdr_encode_hyper(p, count);
+	p = xdr_encode_hyper(p, read->rd_offset);
+	p = xdr_encode_hyper(p, count);
 
 	*eof = (read->rd_offset + count) >= f_size;
 	*maxcount = min_t(unsigned long, count, *maxcount);
-- 
2.43.0



