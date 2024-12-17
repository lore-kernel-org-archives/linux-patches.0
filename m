Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EED1F76B1;
	Tue, 17 Dec 2024 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455604; cv=none; b=rjF4QUeMRq7cXDqfBgKAiMtzaQMdEhXuimfk6SIoWkZT1yYfVQeFgXaCzguNDLmvRChv2Q9t+HcJwJmeIXQPvjy74UtqvYhjSCASNhQ532RhCq+jjTcYTxcAOQDxkhQIrs+z4YjgmOKHo8FcdoduG5RMHdZzM/5i8VmIFNUJE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455604; c=relaxed/simple;
	bh=0tp0O3eUur7Xf284WnHgYnMuAuKqHP6Y4dkm5iMH0GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNhqtY69NG76miBkh4TlW4MyL4Palc+isVYe1uJl8rfiG4NHByr4B/GSQ6uaKYom8m0BU/K2sJyobezvLVcJtfnSel9gyj/MTOShe1yR7TUiiX63DIfWKEkannD3nDtTY8VjJs9l0ki+8lJffq3VgiK/6K0hCGwrGJFI+yMOdWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wanXAVF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wanXAVF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B813C4CED3;
	Tue, 17 Dec 2024 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455604;
	bh=0tp0O3eUur7Xf284WnHgYnMuAuKqHP6Y4dkm5iMH0GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wanXAVF82V4FRPk1s92qPxkCNLaGaNruLQrQo53JauwZGP4kMUtlfw2QVyzYDubde
	 QkyQGqJvLnlpugMAMPk3RS73XOS+I/1s2frL+Dx928nzxozuQ1KinFFVgKJO2tEeJv
	 fEIVqfZ+P5+Immc/GXezrDmuDWAh9f9dcFAjYQm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Ratson <danieller@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 23/51] selftests: mlxsw: sharedbuffer: Remove h1 ingress test case
Date: Tue, 17 Dec 2024 18:07:16 +0100
Message-ID: <20241217170521.244335543@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d9e73a43a49..f6f5e2090891 100755
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



