Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244F71531E8;
	Tue, 15 Jul 2025 13:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587767; cv=none; b=XEUsJ80/HTxf+mNkoci/oFQbctFKbXW8e8hdpOKvDor4PDG2RXb/xubHApGFPmNbykphIOolk1YD+RMl8cui7SG7cn7+P3fTUefCcL6d4bhv6VA62BUlNjHrSuZuwAeS6ZyM2SSEvUg1kUopivdtlJaLx+DlHPYFrWkcQEzHBLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587767; c=relaxed/simple;
	bh=4Ks5zBmBSzp8Tsn4ePwaijoE9Xiz7h0spPPFKzbIYMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4Py4/x8HXY6Femh5dksMI6Do9TULW52cYhwu/14u2TdIMowE7ptJi4a2oPGsccFG6cqYLHEskYxHEpzdUgu/7y7PS1v6YFAFZiK3OEF0CgCxUe9mE6NMuFNUaBsraeTN3+sTGcWOinNvV4LcXw8pDtx6Lq7tBUx2UTeGLi+Xo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UitcQpE5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UitcQpE5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9EEC4CEE3;
	Tue, 15 Jul 2025 13:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587767;
	bh=4Ks5zBmBSzp8Tsn4ePwaijoE9Xiz7h0spPPFKzbIYMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UitcQpE5A35fDH8b88JgaqelYrTwNV0MuSB++VIebmro3dHOCTdy/NNKJID83Af34
	 kUcJQL3sN2Zxbp1hhbq/gN/1dS0q2uWLW/9vh+CbH4UgKCXGfeI9bLjfuY5i/riROk
	 kAVhBRIxgLCbzrPeq+4Uld3yJ/wx7IU4gdql7Ff8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/208] lib: test_objagg: Set error message in check_expect_hints_stats()
Date: Tue, 15 Jul 2025 15:13:23 +0200
Message-ID: <20250715130814.707785222@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e6ed134a4ef592fe1fd0cafac9683813b3c8f3e8 ]

Smatch complains that the error message isn't set in the caller:

    lib/test_objagg.c:923 test_hints_case2()
    error: uninitialized symbol 'errmsg'.

This static checker warning only showed up after a recent refactoring
but the bug dates back to when the code was originally added.  This
likely doesn't affect anything in real life.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202506281403.DsuyHFTZ-lkp@intel.com/
Fixes: 0a020d416d0a ("lib: introduce initial implementation of object aggregation manager")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/8548f423-2e3b-4bb7-b816-5041de2762aa@sabinyo.mountain
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_objagg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/test_objagg.c b/lib/test_objagg.c
index da137939a4100..78d25ab19a960 100644
--- a/lib/test_objagg.c
+++ b/lib/test_objagg.c
@@ -899,8 +899,10 @@ static int check_expect_hints_stats(struct objagg_hints *objagg_hints,
 	int err;
 
 	stats = objagg_hints_stats_get(objagg_hints);
-	if (IS_ERR(stats))
+	if (IS_ERR(stats)) {
+		*errmsg = "objagg_hints_stats_get() failed.";
 		return PTR_ERR(stats);
+	}
 	err = __check_expect_stats(stats, expect_stats, errmsg);
 	objagg_stats_put(stats);
 	return err;
-- 
2.39.5



