Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01668615A;
	Tue, 17 Dec 2024 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456060; cv=none; b=QDCKCInBSko02vqLbQ5T3LARg54cOVPuLpDxVOZaL6DL7n5iFicUzVy89xCiXPN76jzyZrQe6Q8aG5QTj0k/cI/gV7e6/Cl6cXN6ljk8pVzRJmKs1NuVL/x3f8lsF1ptrpCV2bbkg6I9lLqkODZ/aqRvBwqEnnbx/sVvtTEul58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456060; c=relaxed/simple;
	bh=ubyjvrUgIh/xuH5dUoxvjSpC5jdRbMVXONaTRkEB2Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bamg0SE03zbeM9hX/4yq25p//8llqeOthuobHnKcQ7c9JrQVuQ5lispJTMaIx60QsxCjTV3dCbYOOOMUAqf9nleH6pRN+Hwi1YcirwpwxZ5lu+JXxz8fLnNE6xt+HRdaGswQa7xrIZv64Tmbc5qjeO78rA8Mx+LZur8/v3VOlVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8dSlrqL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8dSlrqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44ABFC4CED7;
	Tue, 17 Dec 2024 17:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456060;
	bh=ubyjvrUgIh/xuH5dUoxvjSpC5jdRbMVXONaTRkEB2Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8dSlrqLH7NZxqxTHaiREydP/W/nSCbiE+gY3MUZbfNaOKh2YP9+sEo0IkOPBSM9H
	 ZgPW2Vy7zd9syVIorKdg2y7B8NwEZKMvxUnIaLQMs+R76QKI5mpXJlDQ+XbsFwxh7i
	 TGkObgFOJgCoh3xYniv+e5cinsVpXXjmZeYt/3DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/109] selftests: mlxsw: sharedbuffer: Remove duplicate test cases
Date: Tue, 17 Dec 2024 18:07:32 +0100
Message-ID: <20241217170535.382138784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



