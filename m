Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D3E3491FB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302636; cv=none; b=QAnn0dlYtkqqLDD91lT/X6FGfE8+Am583+4stg0RiMz/Vqi3zv3G3tS8B8Li/P63gDItx0e3bUZqKxT3ecFEESs+A5Gi2lPy0opRddr5QW42R0d4rrK1IXKxwCk5R7wQuXMPRI57DYjH5dIEligixW9Ii1i87YjT/3Z1xYRcfO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302636; c=relaxed/simple;
	bh=NaVTAgh3EY9rLt5CSipYUV0FEP7B429zT7LuRlZscBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA9EdfWlMurAuLUwkM/S8aHAE11VNbDmG6dh8ks0f9+O2bLoKDLUZFiW/eW3pnl4xMvOajis/oXY04ZCZ+ByxuEhcxaoBS6AH39VoibAbW7N9GdiSqgH154FzcZ7VrVzNBMC7InY4iunKOzaLVAG5L4FyplnO2Jac1IVn8MrT5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bls38e5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bls38e5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B8FC19423;
	Sat, 28 Feb 2026 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302635;
	bh=NaVTAgh3EY9rLt5CSipYUV0FEP7B429zT7LuRlZscBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bls38e5OUO/ZX+CUwAVzIaZtiukoUutG3nusL2cdBzDPfmZIXe9DVpFO6jeLJ1EyN
	 FnrAsIoikBxB9QJ2Da01PLxiSU0GJhhERbQDicBKnYJT6j2wxH6pImlqeCWfMXlwko
	 oE0Jn34wGvLRYQGOJ7IwfHSEe/LT7EbhvBo6jgHsGDNzNnJq9LIvHumVZEIv5BD36y
	 bSyf0MXsjqqfU6pM6+LbP2oyBkQrok05KMRBqzpmLjsoW+RNph83TQF3yLWGT5xURg
	 IT5UYX2iMIrHbEbw4tPehYh9ZJr1rB8ZgsFO5HYfiMbW12bTrsDkcnUtT6vV2ONf/C
	 UQUzwmn4UPZ1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/164] selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2
Date: Sat, 28 Feb 2026 13:14:55 -0500
Message-ID: <20260228181505.1600663-156-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 5ec3beb637c82..2e9669408d3b0 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -316,7 +316,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 0.5kbit burst 1m conform-exceed drop/ok
+		action police rate 0.5kbit burst 2k conform-exceed drop/ok
 	check_fail $? "Incorrect success to add police action with too low rate"
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
@@ -326,7 +326,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 1.5kbit burst 1m conform-exceed drop/ok
+		action police rate 1.5kbit burst 2k conform-exceed drop/ok
 	check_err $? "Failed to add police action with low rate"
 
 	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
-- 
2.51.0

