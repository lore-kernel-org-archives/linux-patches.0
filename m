Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FC4355029;
	Tue, 16 Dec 2025 11:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885872; cv=none; b=T5t2hmsRrolrNtOI0gT+z79a3b+xyZVu83hkXVlmLZLwNkrdCqzPf7qJ3T9tFUyaTSBAYz4Dm96Z3/tnq47LfUiRo4Ee4MuSNCkDWT+RPCO2WTD8/wRByf3MwLefSIuh8WvnxEUg88EFrprvwIbGe6larIYvNWgMJ4mwrnwvqQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885872; c=relaxed/simple;
	bh=zORTR9C7+o52F15EvDUtiXy++wKVlFZf8WYj2zkeSCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfrWZq4DSASbCLDfQBfG1vDcSWxUtQ8d89q+uvv7rdXN19qvYzXJWMCf7TQ7KLUaB6XbiwJEPfjBfi3JuYK0LWbNrGojQ52YYAT1Rmyx+N2UQ/AuwnpNuOiR2BdKiAk10TMVkAWvitGC5rLuR/9yH8870CJwXgdJ22Odm7mFNGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnXQopr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnXQopr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAFEC4CEF1;
	Tue, 16 Dec 2025 11:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885872;
	bh=zORTR9C7+o52F15EvDUtiXy++wKVlFZf8WYj2zkeSCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnXQopr54I8ZKgrh8exQ8k/t4CwX/Qy2Clj9u/YFr7B1hN10yH3srcMceggwdVpI+
	 Z7cMMNCF5oxngt1adfXlZGQbsArKq5fokRMB9bAGD1U+pzKq2GmN7pdgKuWWAC97Ip
	 jGq7hrqA06JgOdl24K5pfnpQW0Omb1bYbmc6VT7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 269/507] fs/ntfs3: out1 also needs to put mi
Date: Tue, 16 Dec 2025 12:11:50 +0100
Message-ID: <20251216111355.232348537@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 4d78d1173a653acdaf7500a32b8dc530ca4ad075 ]

After ntfs_look_free_mft() executes successfully, all subsequent code
that fails to execute must put mi.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 8f9fe1d7a6908..a557e3ec0d4c4 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -1015,9 +1015,9 @@ static int ni_ins_attr_ext(struct ntfs_inode *ni, struct ATTR_LIST_ENTRY *le,
 
 out2:
 	ni_remove_mi(ni, mi);
-	mi_put(mi);
 
 out1:
+	mi_put(mi);
 	ntfs_mark_rec_free(sbi, rno, is_mft);
 
 out:
-- 
2.51.0



