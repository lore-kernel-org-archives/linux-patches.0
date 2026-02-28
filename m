Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E6835AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302766; cv=none; b=mq01xkfCvNvcGP/W6S5vyVDRdJfNB2yBYRoTWAHf0vjs28ZUD8BGhfpF3diMgeW8BGHnfWyhHCsZToHm/XfPYVRROe4lLdBKfdTSWDuQXj4Fm6x0g/BRJG1N5gl5bP/BwMxVfIwhDlDSeGRvnnLVePtBor1OpNpQoljZkfOR4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302766; c=relaxed/simple;
	bh=uPGsaKcc9i3V2KdAS5D5U1xFC5ZodnKetKGX/JQgKvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eum695+fwHPK0H4MNyGzJ5HiGyfnqhdZMmuDkt1S8LgVjjki3CPjyDj/6RKMshJ1f2Ch9ZQ8jVGbTK0kt5TBeL1ejguSDEzyY7SzPDmDCue4K4RvlCovte0r5KHknvwizMhhmpdTK/koRGGqXW5/0J8e9bDQNjolQefAfCA/BKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I5U0olqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I5U0olqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0C6C116D0;
	Sat, 28 Feb 2026 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302766;
	bh=uPGsaKcc9i3V2KdAS5D5U1xFC5ZodnKetKGX/JQgKvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5U0olqEjaNe2hticDYzURLjesAfaAYKNh6hb+LAlmTJgPNJJU79n6Onr0oE0Kslv
	 VscFpP4sMFFBLev5aS5AxllcLbtpJCZ/pyUHS68iyJi0upyt1QLHkUR9pnjPX9DeAZ
	 cR4bDwB7yI8PUQXVV60yenUitoHAdtDSR9lBWeBCmGLtrJQZjdC40ESQtum5jed6OF
	 lQO+TdO3NOc7xx6Qv905ohexUiciiDy/VRYsae6WJ0Sp+rhpXzVxb9n6oMtx8VjkCf
	 ncmjaEsjg0UOsoFQeQzWv8necfsXTMkZjwL1+qvusLSPF24zfgv7z6J/XSYO+Jvlhb
	 mdffSGpwHhDZQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/147] selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2
Date: Sat, 28 Feb 2026 13:17:25 -0500
Message-ID: <20260228181736.1605592-137-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 553cb9fad5084..9547c0992d423 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -297,7 +297,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 0.5kbit burst 1m conform-exceed drop/ok
+		action police rate 0.5kbit burst 2k conform-exceed drop/ok
 	check_fail $? "Incorrect success to add police action with too low rate"
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
@@ -307,7 +307,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 1.5kbit burst 1m conform-exceed drop/ok
+		action police rate 1.5kbit burst 2k conform-exceed drop/ok
 	check_err $? "Failed to add police action with low rate"
 
 	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
-- 
2.51.0

