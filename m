Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F57359A72
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302469; cv=none; b=PqgCcMJTXv78bnNIGIUHerEVVdM8tIfTRiQPi4Vlydd0nLykorK8xrTyzS8eeyjgNL7AjJgPj8NEu9zLIjztElfdkr8kHUtPVGvEm1Qs5VZdCzCnj1qqSS150ZmXJbK1TlbQdGes/qjahtej1M9uyXFqyKVr8UTBz6JQ+51GODg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302469; c=relaxed/simple;
	bh=2WYxL2TlHn/Oc5cYAnp7iC5LVz2lk82EZtx2JbhHgI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cni6e5JKoMBdGl4ndmSGUAC6TSq+UXRHyaC2Q+QyMyl+u8y56Or4ztVL0NDh8+yMtEGHpID2CELKU0192lv/3LpXw44RwBPe85bnvIOwVT/jzalx7MzUWXttl6leiOZZc8dYewrezFi3Fjdxwy04+nOhTiO6Oxa/dD3+UdKR7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TM52sz2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TM52sz2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD17C116D0;
	Sat, 28 Feb 2026 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302468;
	bh=2WYxL2TlHn/Oc5cYAnp7iC5LVz2lk82EZtx2JbhHgI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TM52sz2TGkJ/lEQSBfo2R1lGDR0RygAPwk7aXxPsTP7XCo71o9xtjOGi4Jm/4SwNx
	 GSwSMwe88wQTFyKhgTmPvX6EXzgQIHCQuiBoCTvxV1tqRH9I+X1xRunhFmIcDw+xYm
	 hdzIRPTZi4xug+myrXTDKH1nTqDIP5LB0qtgL1A83pZr+CrUMkkhaKI8cdNnhu/jLr
	 bvbvRU7w68GznzdCUUC5Z1/eGTHk1E9jgdWDel4Vz00ucN8N7FFJFokO+GOlTfIYIk
	 QIvzwYuqoz2KX6qsqOJs3c5eqEhTcRJR2wL7Rt38pzjno+6ONeDgsRUbdbKBb/FKJh
	 IZwdn1MkN5bTA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/232] selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2
Date: Sat, 28 Feb 2026 13:11:06 -0500
Message-ID: <20260228181127.1592657-213-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

