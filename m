Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF446196D9B;
	Thu,  6 Jun 2024 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683003; cv=none; b=C1dCYOMKkEf9Yt/0GS976l7njbxQ5ifL2siMoTNqlLtiDbo/882f5rwCG2VuQUyPqfZm3xrnlBAmXKlnnl3d5c6+fUzS3NMUBDxJkdofAsyl/Zv+Ek+30+ZK78aP0iOM6qaw3+l9hSbRVcsn0Qqmn0FLuRyvvxaP6JVNtHdGOYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683003; c=relaxed/simple;
	bh=xYRHcSvgjZwpBXHP9ldFEpWcnIpczpTqdhDr/MEx6nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOoKhQPC3aXCDyoVKgKlbEPlP+6AuRuC2Rl4KpTguTNcbC73ybsxC8CrxWJBl8aTZMJlSKhCLrIim5ZwNex528UyNeyooqSEhYM/RxVjHNFDGca0GlgH06widmns11nl4siFe963HRygBQTG9UFOct5mlD24swftmRGmFAYXtHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNbHfWbd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNbHfWbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0F2C2BD10;
	Thu,  6 Jun 2024 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683003;
	bh=xYRHcSvgjZwpBXHP9ldFEpWcnIpczpTqdhDr/MEx6nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNbHfWbdZUKTE5D/glTTfas/T9S8siptOw+4V6QeDMUQLsbwuyFLBhJybjt7xo3NY
	 elbww3OGUeScQAc/F/SLxJWI+zlArF2cB62hpoPSepr8BVZ5AjegM/oq0smRVkWaeP
	 mFFdXfj77hkCVqY6/aDM1vXFtqvOwV910HOuwyG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 209/374] null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()
Date: Thu,  6 Jun 2024 16:03:08 +0200
Message-ID: <20240606131658.818737914@linuxfoundation.org>
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 9e6727f824edcdb8fdd3e6e8a0862eb49546e1cd ]

No functional changes intended.

Fixes: f2298c0403b0 ("null_blk: multi queue aware block test driver")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240506075538.6064-1-yanjun.zhu@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index eed63f95e89d0..14ffda1ffe6c3 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2121,4 +2121,5 @@ module_init(null_init);
 module_exit(null_exit);
 
 MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_DESCRIPTION("multi queue aware block test driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



