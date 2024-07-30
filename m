Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781411A76C6;
	Tue, 30 Jul 2024 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360758; cv=none; b=DYAB2ih9TEbRp2XOcqTiZNX+5Geijq56SRxw+72mHI3BR14ELkDblhwl0vFhRecXwibxvUQzkfzuM/582TftMLazq1loB42Sfagahm7Ifmcc3JRogvzyIxxdp+wjl3yCF7Zf6IaScppNmJoQOind0cA6kf7C5NGOPZzBI6I21u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360758; c=relaxed/simple;
	bh=kM/JvdGRVIbVDGk7JuAdHe6F3JBMqU3e8ZUsVEntq68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SW7XyoK5p6HSWlRx40MnvaLyibdoHxP2ViRKBmtIWnfhucGRGgNXOjsQaKK76k87cigYV5fIi4Xri9MNYM+6uCXfJLB3bMYdvTN46Bu5VAxgH4Y8orlk0I+z03ekaj5q09GALBpLs0uiGQqFCOBkx9dZLNW6ebo3AGEU+TfbPKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OIN75mec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OIN75mec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8C7C32782;
	Tue, 30 Jul 2024 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360758;
	bh=kM/JvdGRVIbVDGk7JuAdHe6F3JBMqU3e8ZUsVEntq68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OIN75mecor/KshnWSHKi/C563ULiXdQw6j1sZsY3dSJZOnV8wHRBYvesNd/fNMvPS
	 AJkVe+pWnL8LXqHAq1u3rUttLSI1SB+1ZCWydrpRHdSFpAEGuTQv5iFjsMZ+WnvTQH
	 JP1Rq0uVhzVgvPEu7KezYTzuQ6oRjPFlCcv0OwN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Johannes Nixdorf <jnixdorf-oss@avm.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 767/809] selftests: forwarding: skip if kernel not support setting bridge fdb learning limit
Date: Tue, 30 Jul 2024 17:50:43 +0200
Message-ID: <20240730151755.260114446@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 863ff546fb62a8fa75757a30794ab6ec6cc4bab7 ]

If the testing kernel doesn't support setting fdb_max_learned or show
fdb_n_learned, just skip it. Or we will get errors like

./bridge_fdb_learning_limit.sh: line 218: [: null: integer expression expected
./bridge_fdb_learning_limit.sh: line 225: [: null: integer expression expected

Fixes: 6f84090333bb ("selftests: forwarding: bridge_fdb_learning_limit: Add a new selftest")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../forwarding/bridge_fdb_learning_limit.sh    | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/bridge_fdb_learning_limit.sh b/tools/testing/selftests/net/forwarding/bridge_fdb_learning_limit.sh
index 0760a34b71146..a21b7085da2e9 100755
--- a/tools/testing/selftests/net/forwarding/bridge_fdb_learning_limit.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_fdb_learning_limit.sh
@@ -178,6 +178,22 @@ fdb_del()
 	check_err $? "Failed to remove a FDB entry of type ${type}"
 }
 
+check_fdb_n_learned_support()
+{
+	if ! ip link help bridge 2>&1 | grep -q "fdb_max_learned"; then
+		echo "SKIP: iproute2 too old, missing bridge max learned support"
+		exit $ksft_skip
+	fi
+
+	ip link add dev br0 type bridge
+	local learned=$(fdb_get_n_learned)
+	ip link del dev br0
+	if [ "$learned" == "null" ]; then
+		echo "SKIP: kernel too old; bridge fdb_n_learned feature not supported."
+		exit $ksft_skip
+	fi
+}
+
 check_accounting_one_type()
 {
 	local type=$1 is_counted=$2 overrides_learned=$3
@@ -274,6 +290,8 @@ check_limit()
 	done
 }
 
+check_fdb_n_learned_support
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.43.0



