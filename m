Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791531E520;
	Tue, 27 Aug 2024 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771412; cv=none; b=OnNRONy6kRc4+XMFdy+9UPv51MInPzuUBKbDPeyfn2Sq1LtkYNqlCQCKge7G1soYmcE77Y9Romnyunp7LL6neLDELKMiKnskKfFO44sqKR2myyNYOklKVj5uCnLn24kLBGkD1VGRd+BkVaF2UMFRmeXZlpzVi0rTJfyNz8CRVU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771412; c=relaxed/simple;
	bh=8wAWlU1ETzl1UfHPSQ57VCq8YXXs73UANcz6Q/XnlIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyQiRxeLPJrdIi6WYKbywmSSSWzurVebv+tsmtWZjcCGOIvvtT15dL2GpB8qDr/C+UO/GkV/WINT2008Z4iLhLA3tccdk/G6kK+OexvSfie9w1U6U9mp+DiQz4bdJ7NQag3gYDAxHA7+5ySEYhJeGV1z3gPSLLukjv0v3pensI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcFho82Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcFho82Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF14EC4AF55;
	Tue, 27 Aug 2024 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771412;
	bh=8wAWlU1ETzl1UfHPSQ57VCq8YXXs73UANcz6Q/XnlIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcFho82Z2grp2n0u/th9I5neZoO8yuUx6ply1MsiTD9unZ1Go/LDzl4kohKRjPNew
	 p+afL/Xj48n9ZMT+dKM3UWL+Pvbx6iS1ylcRT8++2EFgTbP2Vs6dK6p+dAhotVt4Bd
	 v0tUt7Mfv8k6uXfImCv7BpcaMnZZGo4j3shO+FhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 181/273] selftests: mlxsw: ethtool_lanes: Source ethtool lib from correct path
Date: Tue, 27 Aug 2024 16:38:25 +0200
Message-ID: <20240827143840.298720390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f8669d7b5f5d2d88959456ae9123d8bb6fdc1ebe ]

Source the ethtool library from the correct path and avoid the following
error:

./ethtool_lanes.sh: line 14: ./../../../net/forwarding/ethtool_lib.sh: No such file or directory

Fixes: 40d269c000bd ("selftests: forwarding: Move several selftests")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/2112faff02e536e1ac14beb4c2be09c9574b90ae.1724150067.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh b/tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh
index 877cd6df94a10..fe905a7f34b3c 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/ethtool_lanes.sh
@@ -2,6 +2,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 lib_dir=$(dirname $0)/../../../net/forwarding
+ethtool_lib_dir=$(dirname $0)/../hw
 
 ALL_TESTS="
 	autoneg
@@ -11,7 +12,7 @@ ALL_TESTS="
 NUM_NETIFS=2
 : ${TIMEOUT:=30000} # ms
 source $lib_dir/lib.sh
-source $lib_dir/ethtool_lib.sh
+source $ethtool_lib_dir/ethtool_lib.sh
 
 setup_prepare()
 {
-- 
2.43.0



