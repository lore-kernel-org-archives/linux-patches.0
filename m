Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32469471260;
	Tue, 21 Jul 2026 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657588; cv=none; b=XeNFEKGZLL6L9pMxF0w/ClO8loOr7lZ63PywZrt77H3AeDw+CrwUtOKMV1zER4qfN4b67KxhyyJC9CUKBp3OgsosjJCk5MasqwGt6aBmCFffCYkt3sjbB0ZBYuVCBu+WR0iYg5NJs/ob/mXGB3VdAcAFhC9KcE7iu1DFMuzsP+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657588; c=relaxed/simple;
	bh=1r3eWq7eetse94ZQ6Yhy3XlHC4a2M9U9txH66dbCEQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrbrsE7+bNfDr2LSdJp+lENvuVODMdCXhOhGwBFUFRiD5EuUJLOV3V1zN6NvpZ4i6xbrOsbwufu3fEYMw2J19mrSaOd3ZmVXCeEPIgKIdAmP2lHyxmyJ5KunwMgjJzg4m5HQF/sTFxIGjHMPMPk1jrqwYCU98GJSbuT63dWTxc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHTrpcwO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHTrpcwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9921D1F00A3E;
	Tue, 21 Jul 2026 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657587;
	bh=eggGHhoBjUSX2mVk6gqyE8mMyw11U6J9Ar+Wk0YtnUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wHTrpcwO2StsPihC9nbGP65u0PRvrgBsLnFdIw9LGKpIGnqKb0DntLmMwZL3O1soi
	 XQB/Ej4AKXtg2R49XSxcEPjJH1ny2Pp286Da6r3UAPTu6kYuiv+UvQCC4LFdNjNmlv
	 gT6ebLdbU/ESmCv71re2cJz9cJmcB9oZX6BM7HlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Petr Machata <petrm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0820/1611] selftests: vlan_bridge_binding: Fix flaky operational state check
Date: Tue, 21 Jul 2026 17:15:36 +0200
Message-ID: <20260721152533.834139936@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 4045f1c3d68ef4b589ae2587e6ff66ce8017daf2 ]

check_operstate() busy waits for up to one second for the operational
state to change to the expected state. This is not enough since carrier
loss events can be delayed by the kernel for up to one second (see
__linkwatch_run_queue()), leading to sporadic failures.

Fix by increasing the busy wait period to two seconds.

Fixes: dca12e9ab760 ("selftests: net: Add a VLAN bridge binding selftest")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20260616092733.3a31be4d@kernel.org/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/20260617104323.1069457-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/vlan_bridge_binding.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/vlan_bridge_binding.sh b/tools/testing/selftests/net/vlan_bridge_binding.sh
index e8c02c64e03a47..d04caa14202d03 100755
--- a/tools/testing/selftests/net/vlan_bridge_binding.sh
+++ b/tools/testing/selftests/net/vlan_bridge_binding.sh
@@ -64,7 +64,7 @@ check_operstate()
 	local expect=$1; shift
 	local operstate
 
-	operstate=$(busywait 1000 \
+	operstate=$(busywait 2000 \
 			operstate_is "$dev" "$expect")
 	check_err $? "Got operstate of $operstate, expected $expect"
 }
-- 
2.53.0



