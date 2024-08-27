Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4FD1C7B9D;
	Tue, 27 Aug 2024 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772284; cv=none; b=VwUg6/q3zu4dcHZlzz9amrNQBMTPt3zwFFEk+igUBsRn4LuqURGNZX+uBG3yx5SmjAyQHJTzGbEsz6xkC1mSLIR7fuKhHirKvbY+euy00i9q9ofbeW3o55eocxaoQuq1N5yX3uyUNcyCEs3zLQUUhktF9uoBUdpAKesPS3/+Wa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772284; c=relaxed/simple;
	bh=iteDeW351vigif8/yifKPU6DLf7GxweLG2l8ILaUqAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYixckgtldgrVEdU9GPQPYIAWIgOR/XkV8/BpKyRvBYX6fwClR4NiiareK6KfXZBRfZL2K0W5Kxa0FmTLplFqThzHcKChMaaYFuqzft/omn2VuTf9/ymzfgaYxBmdTDCAwAL8vSLmz23Zyyxop4EwrBtRO0XtgQq6a7Eyer3zAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sV8JS2Cp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sV8JS2Cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869D6C6107C;
	Tue, 27 Aug 2024 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772284;
	bh=iteDeW351vigif8/yifKPU6DLf7GxweLG2l8ILaUqAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sV8JS2CpgNNe38BdakzCtR64+obeO+5PCc+gueOHdeyqxB4PgOs+2IDFsnx4YZiYp
	 b2e8D2aB4yLh5WhC+RTODyMqwtXDZwssM2ZpwTX5AGlIbUqp6xoYSEhIM2+9xNC83v
	 6X0dRG8+C8WYyPIp+yEClUAWpt/SS5rly1DJjAtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/321] gfs2: setattr_chown: Add missing initialization
Date: Tue, 27 Aug 2024 16:37:25 +0200
Message-ID: <20240827143843.458463623@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2d8d7990619878a848b1d916c2f936d3012ee17d ]

Add a missing initialization of variable ap in setattr_chown().
Without, chown() may be able to bypass quotas.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 23e6962cdd6e3..04fc3e72a96e4 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1907,7 +1907,7 @@ static int setattr_chown(struct inode *inode, struct iattr *attr)
 	kuid_t ouid, nuid;
 	kgid_t ogid, ngid;
 	int error;
-	struct gfs2_alloc_parms ap;
+	struct gfs2_alloc_parms ap = {};
 
 	ouid = inode->i_uid;
 	ogid = inode->i_gid;
-- 
2.43.0



