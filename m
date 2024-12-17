Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9AF1F8662;
	Tue, 17 Dec 2024 17:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456560; cv=none; b=Ae0av251DwpH8DYRn08oVFcwrMuGZ3hIOEUaTpDHk6sqvnMhEIzD88cnml4dnTf1QaG3y8iKLMjyY4MPQL7MzfBi1Lrv1e0v0o8Q2vGimKBwW0CygkB/gAwlciysxBLfTGWLtbZ8lBogQkyxYrencwIviF17GH+Is/7uqd3pRCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456560; c=relaxed/simple;
	bh=UmZq1fuZp4jqKd1F5CFhoQUlGw1U8GRu0ohV2sn1gbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qk1IgtdlCleB/fwlmIengQjGKTYimo/eZKD0qtTEowBmwsF8yA2ItvRj6NKf2OgWWk4ev+royYpZEjAjeTAyfsIAbshNPINgzP/MVvau3XEVVSq6KuWWxfQJNcuTfrA7Qgq8rtZUStlLj5MYjqF7E3aui8MlD7s0tdVNUEE4yEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSp/edja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSp/edja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E763EC4CED3;
	Tue, 17 Dec 2024 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456560;
	bh=UmZq1fuZp4jqKd1F5CFhoQUlGw1U8GRu0ohV2sn1gbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSp/edja74NUGVmffOJ0kitLAr2iLK+ApvQq/hdM2FbrAAqPHRQizY4PyMFeXwlpv
	 zmM7Pd80J+f/R7gufPteirVLRSRFcBLebfLi/QVHEc8KpI7QoKZPswVexapIohTkxy
	 yxtWeARmOwDIOw4QdvMtwjmZPk+NDn21RRKCKnq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/172] selftests: mlxsw: sharedbuffer: Remove duplicate test cases
Date: Tue, 17 Dec 2024 18:07:33 +0100
Message-ID: <20241217170550.319154331@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 6c46ad4d1bb2e8ec2265296e53765190f6e32f33 ]

On both port_tc_ip_test() and port_tc_arp_test(), the max occupancy is
checked on $h2 twice, when only the error message is different and does not
match the check itself.

Remove the two duplicated test cases from the test.

Fixes: a865ad999603 ("selftests: mlxsw: Add shared buffer traffic test")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/d9eb26f6fc16a06a30b5c2c16ad80caf502bc561.1733414773.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/mlxsw/sharedbuffer.sh        | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
index a7b3d6cf3185..21bebc5726f6 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
@@ -131,11 +131,6 @@ port_tc_ip_test()
 
 	devlink sb occupancy snapshot $DEVLINK_DEV
 
-	RET=0
-	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
-	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
-	log_test "physical port's($h1) ingress TC - IP packet"
-
 	RET=0
 	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
 	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
@@ -158,11 +153,6 @@ port_tc_arp_test()
 
 	devlink sb occupancy snapshot $DEVLINK_DEV
 
-	RET=0
-	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
-	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
-	log_test "physical port's($h1) ingress TC - ARP packet"
-
 	RET=0
 	max_occ=$(sb_occ_itc_check $dl_port2 $SB_ITC $exp_max_occ)
 	check_err $? "Expected ingress TC($SB_ITC) max occupancy to be $exp_max_occ, but got $max_occ"
-- 
2.39.5



