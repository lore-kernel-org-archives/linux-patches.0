Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8532822DA1F;
	Mon,  2 Jun 2025 14:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873262; cv=none; b=nyaJX/gwJBszlW3IbaYEi4jLalwZv6A/TBq9YUG4ZlRiE9leNFaeKs4+gr2Cq1sNSjJCrrR0tKe5hOMK4bVb1usjUQgvvUnU9As0dPiXy3ccoCo0OOFD+8HNiiBWmOhyVhDIgY696oq1FF3ZTqaituBlMv5KmpOdPQBpmRwOPyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873262; c=relaxed/simple;
	bh=0CA03q4KR1wCxuGWOoEELFSR5mwg65NpdC8FfQYM2Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkWcUAkRTwleI2ymgRUnLdkYPkJZ3b0sCgTeg4m+tZOPkTBslvkLjifXr+wAAy1CyHLabddCkYnDyox58whqSePYWe0bRDWUs0vzSPdHZJEpSgUls/TVP3zZuLWX34YGaootqPrFpOdmQ8+5HD+L27KreRqb1HSmTbGQEKkqx3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOd9j2wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOd9j2wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A2CC4CEEB;
	Mon,  2 Jun 2025 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873262;
	bh=0CA03q4KR1wCxuGWOoEELFSR5mwg65NpdC8FfQYM2Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOd9j2wrB/0FKmc/BEwzzmk5IY6aETrbFEY27RhHBDJ7xCvCmKmx1gej6D5f6h368
	 m5/JsP3YsTfsnXpQEmKZ+Fz7ZCQZJpYGOkwGBgDjGrGiwuxfqQd2pL1T85Y9FjfMLr
	 J/SnZMkN840+wGeyHRYBSLyY/IFGDPtPjeSZY0qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 087/444] hypfs_create_cpu_files(): add missing check for hypfs_mkdir() failure
Date: Mon,  2 Jun 2025 15:42:31 +0200
Message-ID: <20250602134344.426868678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



