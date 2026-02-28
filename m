Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8934250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301930; cv=none; b=eEvy08ivAPrwq/nfKjOTnALweZ0Xnkttj48xA7eTbf/hy9hvfUNiPB5JiCUtliVkYHddYz3drI2OLv7VuqXiXDiPxiSC3da/SBQFQphYsrfSc8zqEWQyzi6jog655b9Uu32bnMtherluF4z3dqmQwRGWzxlN8A2KiImuMi9sjhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301930; c=relaxed/simple;
	bh=2WYxL2TlHn/Oc5cYAnp7iC5LVz2lk82EZtx2JbhHgI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mo7n2pgaJ+76eMkCfnsTIXQ93jAuS/bC2CnRyIiF2q0fJus9SeOpaPLrTZTjmnLFfVdkxrzeyFu0r1+9IG1jXwd2ayiIO5z25mT124MLRV5Ymf5n4sZFSHuor72hDTuNH27+X9t8tpSp6L+0xD94sEOb4LScEgvJGQr2AtePM7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izX/mlQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izX/mlQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911C1C19423;
	Sat, 28 Feb 2026 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301930;
	bh=2WYxL2TlHn/Oc5cYAnp7iC5LVz2lk82EZtx2JbhHgI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izX/mlQhYjx3/FqpFQA99ElbfQ72Yy/ucrWSx/J2MbJA66NNrkmoKahNITrHLJpcM
	 t0A+Cyh3GQMGLxNfsw9eVzyF6W2FrpAPY7jG6VSIleel5JB70WhtFWnfT1d6RYSveS
	 7YIkigGgHXQrAXJcCEGh0WJYEXP5SHsGNhQ9DpRAcNiCLFYsgd060QRAcOmruKMA0Y
	 hqjVUkJ7ZjtWpMQJ7v5FGM3bloMh4I0DWEkSEW9Wv4/y54m7aAYEhwZReW+C5nXjp0
	 jf3oB35RP1Do9SgBGG9gQpS9aQI2zOCOn0Kl7FwyW+/61yNT9ohLM7A/le4bnH+R37
	 zP1LaSWJOlXOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 365/385] selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2
Date: Sat, 28 Feb 2026 12:59:47 -0500
Message-ID: <20260228180011.1568201-365-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit a2646773a005b59fd1dc7ff3ba15df84889ca5d2 ]

As explained in [1], iproute2 started rejecting tc-police burst sizes
that result in an overflow. This can happen when the burst size is high
enough and the rate is low enough.

A couple of test cases specify such configurations, resulting in
iproute2 errors and test failure.

Fix by reducing the burst size so that the test will pass with both new
and old iproute2 versions.

[1] https://lore.kernel.org/netdev/20250916215731.3431465-1-jay.vosburgh@canonical.com/

Fixes: cb12d1763267 ("selftests: mlxsw: tc_restrictions: Test tc-police restrictions")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/88b00c6e85188aa6a065dc240206119b328c46e1.1770643998.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index 0441a18f098b1..aac8ef490feb8 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -317,7 +317,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 0.5kbit burst 1m conform-exceed drop/ok
+		action police rate 0.5kbit burst 2k conform-exceed drop/ok
 	check_fail $? "Incorrect success to add police action with too low rate"
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
@@ -327,7 +327,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 1.5kbit burst 1m conform-exceed drop/ok
+		action police rate 1.5kbit burst 2k conform-exceed drop/ok
 	check_err $? "Failed to add police action with low rate"
 
 	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
-- 
2.51.0

