Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7121C199228;
	Thu,  6 Jun 2024 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682982; cv=none; b=I6UQrbOfXRbVnYpEkd4ce13wDWGQ3W6HLMI+QEmME1fXPvLZgDAE5uhKxOexbImPWAY4OWXH24HqUDftqsiKHUF+AHTXl2oDcyLs4lAkyxJwDkN88eqdKD8UlZi+Er8a/CmEZ35fJuKNt7Ioq2qolrYAwRCYK6J8qoda5yrUHUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682982; c=relaxed/simple;
	bh=nXDBHg0tm0JBu/If/E9y2vzcRD0kx3BzUHLqSGloGnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+9Qa/8rxgts9i2pyVPqA72Z4CzuOk9+Qz9lj8QI2LCLIzQ7QUM/zdxNHphYydBcr6Ast/G2I8iYePsFs9B27uWkj9emXMD9QA0Cx0QRL4sg8ZfK75IN41roxG+B7FKZpxeBqSUZ+m/QWk2RTV7W7f3e6KJHcmfVoCN8jEWiE94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q35wntHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q35wntHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E87BC32781;
	Thu,  6 Jun 2024 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682982;
	bh=nXDBHg0tm0JBu/If/E9y2vzcRD0kx3BzUHLqSGloGnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q35wntHN4UriXavknGJbuOyA0sT5pnvseR+dXVcXL8ddGDruGiv5aKbG24I15Ol0i
	 kNkvhOJH+DBpT6vDHnpvKeU9JqOAD1gJBRg8CvxpC34p0RFJ9TTLZ40wZ+KGSuYnKo
	 MJ8wM6PvdzlHrxqZnclTsqnI2Rj1ue9jcWgPsaQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 139/374] s390/boot: Remove alt_stfle_fac_list from decompressor
Date: Thu,  6 Jun 2024 16:01:58 +0200
Message-ID: <20240606131656.567819613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit e7dec0b7926f3cd493c697c4c389df77e8e8a34c ]

It is nowhere used in the decompressor, therefore remove it.

Fixes: 17e89e1340a3 ("s390/facilities: move stfl information from lowcore to global data")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c | 1 -
 arch/s390/kernel/setup.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index 6cf89314209a6..9e2c9027e986a 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -32,7 +32,6 @@ unsigned long __bootdata_preserved(max_mappable);
 unsigned long __bootdata(ident_map_size);
 
 u64 __bootdata_preserved(stfle_fac_list[16]);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 struct machine_info machine;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 24ed33f044ec3..7ecd27c62d564 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -155,7 +155,7 @@ unsigned int __bootdata_preserved(zlib_dfltcc_support);
 EXPORT_SYMBOL(zlib_dfltcc_support);
 u64 __bootdata_preserved(stfle_fac_list[16]);
 EXPORT_SYMBOL(stfle_fac_list);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
+u64 alt_stfle_fac_list[16];
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 unsigned long VMALLOC_START;
-- 
2.43.0



