Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C721E89C;
	Tue, 27 May 2025 17:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366714; cv=none; b=Eoohwxr9cnnUrCDp6ILIUjhiBa/OXMiK1I2OnTBB/JTjzjD9DcX0qWzvANoGXwLrVcWd70U1KPpundmPa1Fgjwmv/DElg5uHzB4x5t6zTa4tEHxbo9svJwyj52DOCC01IDjRU/B6VDIubGEsoC4bkiIqP9a6JDsGDUKfrZFTr5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366714; c=relaxed/simple;
	bh=YA8/uZcUDvXbi29JE14W9dqn9IRhRZeEDS/Lxvvq030=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sz3ysUjtG0KtFTAP7r55MfIA/cLkmN4KPSyvkqOlaUZjHFwY/QuQLi6ObTnoPbDvDcmzOOMqe7DxBYRA3D4J3nNJsmCq2s3N3TZU94bALlcib4QBWpM9g9QDTyVC86fnFeu92xAar5cQSWW/nbrzyL9p9DCcdE5ajytjnc9Ft4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2L6+nu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2L6+nu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 867A0C4CEE9;
	Tue, 27 May 2025 17:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366714;
	bh=YA8/uZcUDvXbi29JE14W9dqn9IRhRZeEDS/Lxvvq030=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2L6+nu+wVTYQMLcJ+0DUAJTA8OhkbnbuzEh0+V7WFFgjcaaZdINDisO6R1vJVNEd
	 /h3a88KiG5krBJY2zt+peuBtMbCe4S9KkgSSBuZNxhRBTPwGTy8p79nl0HNzVqL5L8
	 +HPcs1t3PSmSOycgikcHcgSXquXTNfGKxwpwm4Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 158/783] hypfs_create_cpu_files(): add missing check for hypfs_mkdir() failure
Date: Tue, 27 May 2025 18:19:15 +0200
Message-ID: <20250527162519.605953769@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 00cdfdcfa0806202aea56b02cedbf87ef1e75df8 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/hypfs/hypfs_diag_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/hypfs/hypfs_diag_fs.c b/arch/s390/hypfs/hypfs_diag_fs.c
index 00a6d370a2803..280266a74f378 100644
--- a/arch/s390/hypfs/hypfs_diag_fs.c
+++ b/arch/s390/hypfs/hypfs_diag_fs.c
@@ -208,6 +208,8 @@ static int hypfs_create_cpu_files(struct dentry *cpus_dir, void *cpu_info)
 	snprintf(buffer, TMP_SIZE, "%d", cpu_info__cpu_addr(diag204_get_info_type(),
 							    cpu_info));
 	cpu_dir = hypfs_mkdir(cpus_dir, buffer);
+	if (IS_ERR(cpu_dir))
+		return PTR_ERR(cpu_dir);
 	rc = hypfs_create_u64(cpu_dir, "mgmtime",
 			      cpu_info__acc_time(diag204_get_info_type(), cpu_info) -
 			      cpu_info__lp_time(diag204_get_info_type(), cpu_info));
-- 
2.39.5



