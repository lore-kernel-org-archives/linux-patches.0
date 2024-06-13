Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551717FD;
	Thu, 13 Jun 2024 12:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282348; cv=none; b=JHwkQE/0yIyHoJF+NRKn6x32txJDIDBsvJlj4zILNWCdcuipiV84SUy36pGNXcWozi3kBhq0PM7OiKVJZy+to7/9moWTgGrYVtzG0mPm/VQNWAUhpyD8k34Taf1apXwCvmHhXSXGbqNlc+RAYZ2VW8fkIF6UI3WWXY1DOWFFExU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282348; c=relaxed/simple;
	bh=9hkmk500X620F1tZ+svAxHvDLFzPsHXB9hKNebVvoOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l92Cw9XXvNwqrlfB6E8DHjRNGP2RKK5GEKFsFN0IkbWWHcZxeew4PmX1PfaB8O20xTeB/nDS5QIO/HTN/lgVfiQJQVPC12Prvf7QY9sy2lUApuqZcUu+7Rx3Je/imgrfvRfTU3YuPX1lDQVwO58uXHMxpndpyrVM7BWSyu44Gn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4SVuTdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4SVuTdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF788C2BBFC;
	Thu, 13 Jun 2024 12:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282348;
	bh=9hkmk500X620F1tZ+svAxHvDLFzPsHXB9hKNebVvoOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4SVuTdVVQNGdE2JkUZpWk1t1VbfJBkyaC+ir3vPpNFSNKkSpnkDgxmsCr0B9ZFdr
	 J4hMpw8uZoReY0qts2ggRHhDFBoTHDOBCJPm0xp0QHuQ2A2hMUWHjvwhVBqLgCo9KW
	 5Qdyn+ZO/sBeOJeEZvUIcg4m0UnyFkEIrvZaiLiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 245/402] s390/boot: Remove alt_stfle_fac_list from decompressor
Date: Thu, 13 Jun 2024 13:33:22 +0200
Message-ID: <20240613113311.706132375@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1aa11a8f57dd8..05fed61c5e3b7 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -27,7 +27,6 @@ int __bootdata(is_full_image) = 1;
 struct initrd_data __bootdata(initrd_data);
 
 u64 __bootdata_preserved(stfle_fac_list[16]);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 void error(char *x)
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index b7ce6c7c84c6f..50cb4c3d3682a 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -154,7 +154,7 @@ unsigned int __bootdata_preserved(zlib_dfltcc_support);
 EXPORT_SYMBOL(zlib_dfltcc_support);
 u64 __bootdata_preserved(stfle_fac_list[16]);
 EXPORT_SYMBOL(stfle_fac_list);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
+u64 alt_stfle_fac_list[16];
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 unsigned long VMALLOC_START;
-- 
2.43.0



