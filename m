Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24E11EA80;
	Tue, 11 Mar 2025 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706184; cv=none; b=IawM5qxAhFBDwLwIfMMrN6uUrcczdnpTExw6XxW37cA9aY/wp9OGfbpHLrixGg67Mc8Wcb1ecgDn1rMWrgBHiSyvQVav5AZRFNvc6gjixsHNBFgKttSGTfNP496cR+G/fXZNaAZlvKdiBdHPi9OE0Pann+kIdbBpPADYO1hnmzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706184; c=relaxed/simple;
	bh=3bRKCA6A5WeC1r9od5UudrigLSvjvomsP8ywtXhJW1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfamoXt57CEFRBhT36l9p++gVcFwPSPwFuq9R4K35f7bprwO6iwRickqEdogiV8QLgXn+S0rsEbhrl5e4YDFai5ms9uhPpGBVTKnHFdhGOAFz2iBxrDBnvEBB3awJi+KejARp7aVRsAe+SFRXkCwaKw3tjwcw6VCy8faV1wzKE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0Xk3Us6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0Xk3Us6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5915AC4CEE9;
	Tue, 11 Mar 2025 15:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706184;
	bh=3bRKCA6A5WeC1r9od5UudrigLSvjvomsP8ywtXhJW1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v0Xk3Us6+1gpBDL/QO76cYWKyPfwq7N5MgReymMKzjPmkmitJvDyiyi4DobSgbijU
	 FF0ZZv0z99e9L7T4WVuMeCi0HHmDVQdnVI1CBMlc2VS1rt6N7GhWxYwgMllOZzkeq6
	 HxGF75SxJyULMbyv4GctyudhU9izxLmCgLAnMUZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 273/328] kernel/acct.c: use #elif instead of #end and #elif
Date: Tue, 11 Mar 2025 16:00:43 +0100
Message-ID: <20250311145725.763720322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 35189b8ff18ee0c6f7c04f4c674584d1149d5c55 ]

Cleanup: use #elif instead of #end and #elif.

Link: https://lkml.kernel.org/r/20201015150736.GA91603@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 56d5f3eba3f5 ("acct: perform last write from workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/acct.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index a98ce49d12fa0..79f93a45973fa 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -397,9 +397,7 @@ static comp2_t encode_comp2_t(u64 value)
 		return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
 	}
 }
-#endif
-
-#if ACCT_VERSION == 3
+#elif ACCT_VERSION == 3
 /*
  * encode an u64 into a 32 bit IEEE float
  */
@@ -514,8 +512,7 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	/* backward-compatible 16 bit fields */
 	ac.ac_uid16 = ac.ac_uid;
 	ac.ac_gid16 = ac.ac_gid;
-#endif
-#if ACCT_VERSION == 3
+#elif ACCT_VERSION == 3
 	{
 		struct pid_namespace *ns = acct->ns;
 
-- 
2.39.5



