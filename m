Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB16C151CE9;
	Tue, 20 Feb 2024 21:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464493; cv=none; b=SCRXAx9A1Y+Iv2BaEmBc8cw0gDsFA4l/fE5YvTAc9RW1lIpWcn+0FLc279jQfD4HFn/0YxDCGN14l39tAp6zvYFHsUkSvhqzo305bgnXO/839FEckvmf6j3FOQCjheZlnxi+f7QnKeE+jCxtNeA1fcRdxC5pvywlbH1WVvmYI94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464493; c=relaxed/simple;
	bh=hqEIJ5AvnP8EYnMous4uAWuTMSvN3hQnkON8fJjP1NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRKHfCIIvbIlPVNPixNFqkLp27k3QxUIgvr6d6CokMfflfN9FGHy/RNjR2uWtYNHOqmWefp2252MznqlfG70ZsBZlioRBHz4Ou77SqAn81Cx8pN40jY3D+1Esk/sLu80UjXi4ijd5baZ2dHWNGdLhH0DG7vTkVN6OtcpjU5mylA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B13p1ec3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B13p1ec3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE13C433F1;
	Tue, 20 Feb 2024 21:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464493;
	bh=hqEIJ5AvnP8EYnMous4uAWuTMSvN3hQnkON8fJjP1NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B13p1ec3GgjNPzWEtHjSo/44CeZqrwl2nDSLPsoPjXI+QJmDoEO/HMbHEBcIc3pb2
	 PUAbHl+ZLz8BzJGCem9GKE83IA7jdRn6codvkyV0BR3uwalvG7Tx56xN5LOTAdHX+7
	 86I+y435GOZD+Jt8hKiochWM5AQyygtRU594xeS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 043/309] selftests: forwarding: Suppress grep warnings
Date: Tue, 20 Feb 2024 21:53:22 +0100
Message-ID: <20240220205634.533709021@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit dd6b34589441f2ad4698dd88a664811550148b41 ]

Suppress the following grep warnings:

[...]
INFO: # Port group entries configuration tests - (*, G)
TEST: Common port group entries configuration tests (IPv4 (*, G))   [ OK ]
TEST: Common port group entries configuration tests (IPv6 (*, G))   [ OK ]
grep: warning: stray \ before /
grep: warning: stray \ before /
grep: warning: stray \ before /
TEST: IPv4 (*, G) port group entries configuration tests            [ OK ]
grep: warning: stray \ before /
grep: warning: stray \ before /
grep: warning: stray \ before /
TEST: IPv6 (*, G) port group entries configuration tests            [ OK ]
[...]

They do not fail the test, but do clutter the output.

Fixes: b6d00da08610 ("selftests: forwarding: Add bridge MDB test")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240208155529.1199729-4-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/bridge_mdb.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index ebeb43f6606c..a3678dfe5848 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -329,7 +329,7 @@ __cfg_test_port_ip_star_g()
 
 	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q " 0.00"
 	check_err $? "(*, G) \"permanent\" entry has a pending group timer"
-	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "\/0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "/0.00"
 	check_err $? "\"permanent\" source entry has a pending source timer"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -346,7 +346,7 @@ __cfg_test_port_ip_star_g()
 
 	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q " 0.00"
 	check_fail $? "(*, G) EXCLUDE entry does not have a pending group timer"
-	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "\/0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "/0.00"
 	check_err $? "\"blocked\" source entry has a pending source timer"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
@@ -363,7 +363,7 @@ __cfg_test_port_ip_star_g()
 
 	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q " 0.00"
 	check_err $? "(*, G) INCLUDE entry has a pending group timer"
-	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "\/0.00"
+	bridge -d -s mdb get dev br0 grp $grp vid 10 | grep -q "/0.00"
 	check_fail $? "Source entry does not have a pending source timer"
 
 	bridge mdb del dev br0 port $swp1 grp $grp vid 10
-- 
2.43.0



