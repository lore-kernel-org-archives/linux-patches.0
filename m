Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F2B1F63D5;
	Tue, 17 Dec 2024 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456058; cv=none; b=lGijSyD332j0rlQtTVpT7jFd4oHEx5xQdICMWb/O4P0ryCYCi6tnts6uujM03rhPrhklbBd6mWLFxfiFv/aE4+zncdyeY7a/bLydjLbbgDi3Xtz6M2aUp2m4wB02K3ppZMPge+IH6koPfSTQePdP2jKJOhnEkMcnFl+XwmbSrxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456058; c=relaxed/simple;
	bh=99bjrKFi/BON++OmUxG/4DudaeggpksqlZuH6fCTm8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaucQxFNvoGsftRJ8yLNH2pyDydVj0PdE36LJIVJ9h12TB+LORG7LspFFyE4U6LXVN1vbBfxTiojO+EaBgQfD2pl63RxTdLOz/cIrxxVywefi1vhhfeCv/N6+JEX9n2XfzadAB2x8srD2Dk6gXzt1xi+0NxwBR5WmypFBVYdJi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsgKQPu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsgKQPu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15337C4CEE8;
	Tue, 17 Dec 2024 17:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456057;
	bh=99bjrKFi/BON++OmUxG/4DudaeggpksqlZuH6fCTm8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsgKQPu/CFwWv+thZuKtt3z8M28XguGt8LphCc/hP4CmF8VA048BQIZ0xKUN0cxQ6
	 w98cp9lx70Zi+NCg0RYz0ZxBJt2EMnRFGhEKABS+vYOlv2njubDrPFUi83j4z05431
	 DyQhEEq/taBxHG7EM/XRwPBGvqnvVEfGbWvaEsgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/109] selftests: mlxsw: sharedbuffer: Remove h1 ingress test case
Date: Tue, 17 Dec 2024 18:07:31 +0100
Message-ID: <20241217170535.340834265@linuxfoundation.org>
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

[ Upstream commit cf3515c556907b4da290967a2a6cbbd9ee0ee723 ]

The test is sending only one packet generated with mausezahn from $h1 to
$h2. However, for some reason, it is testing for non-zero maximum occupancy
in both the ingress pool of $h1 and $h2. The former only passes when $h2
happens to send a packet.

Avoid intermittent failures by removing unintentional test case
regarding the ingress pool of $h1.

Fixes: a865ad999603 ("selftests: mlxsw: Add shared buffer traffic test")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/5b7344608d5e06f38209e48d8af8c92fa11b6742.1733414773.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
index 0c47faff9274..a7b3d6cf3185 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sharedbuffer.sh
@@ -108,11 +108,6 @@ port_pool_test()
 
 	devlink sb occupancy snapshot $DEVLINK_DEV
 
-	RET=0
-	max_occ=$(sb_occ_pool_check $dl_port1 $SB_POOL_ING $exp_max_occ)
-	check_err $? "Expected iPool($SB_POOL_ING) max occupancy to be $exp_max_occ, but got $max_occ"
-	log_test "physical port's($h1) ingress pool"
-
 	RET=0
 	max_occ=$(sb_occ_pool_check $dl_port2 $SB_POOL_ING $exp_max_occ)
 	check_err $? "Expected iPool($SB_POOL_ING) max occupancy to be $exp_max_occ, but got $max_occ"
-- 
2.39.5



