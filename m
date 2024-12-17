Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781F21F76AC;
	Tue, 17 Dec 2024 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455805; cv=none; b=lVpYHbCaUsvxLz0+iAIIwRtG37KUlOGSC8Y5ttf5lw0bcLq4Uq5EnUhyCiPFv4wC3JCMbhv+Hx+whai/Qd3l9EtFqdIEcqcDesu1cH69WWchoA44JoidSvJsiUFimmH9u/hDbiCeas57936/6fUM5SGr8rUGbLccWzKKEP/Vfvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455805; c=relaxed/simple;
	bh=24cT+HTs9tE9AGGRYSv81pQeFLrptOL9vLb+vdbLPTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNG2bg8Xb/Z/v9biOvcNH/DlbolwGsI2JwYlHEjC7+7cRkbRTQLfS/L+pcvyZM/fAjgzx1+TbNrSxTHdAA8SHaUuJu3mu3pAe8a1dA86hIUgFJCMGXzmRyetrc+eVRC6fLny1d+wt9iIP4OYkDZ0YUF0w00S5dvXHlSdaJ+IOSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsP0Kpcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsP0Kpcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B057C4CED3;
	Tue, 17 Dec 2024 17:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455805;
	bh=24cT+HTs9tE9AGGRYSv81pQeFLrptOL9vLb+vdbLPTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsP0KpcpBHSBY6gd5ZVHBJU+h7D3wpkokto55BZJXNmvfdwalq3IvD2rIs9RjCdFC
	 JCBEnsB24q506G87zwJFQKETYsdgGfLH5QnEKGO+SIfmAfYGeoarUbtcx9TZdD4orG
	 P6WtfXdd5WNdEDa0QdhuB1WIZst75As8RyK6Q3Lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/76] selftests: mlxsw: sharedbuffer: Remove duplicate test cases
Date: Tue, 17 Dec 2024 18:07:18 +0100
Message-ID: <20241217170527.843275968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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



