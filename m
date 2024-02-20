Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B71152DF9;
	Tue, 20 Feb 2024 21:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463410; cv=none; b=k7lNciXxEkvpSqzLfLtGIK4t+OK/4UptJwqwNaSykZ9L+DhBl7j/UekC920TH03HMIIs9x3zNtMVm/MPIDtegmNbFnfsymUXFHT8Nm8igwB47xNdw6zgXPyIU8GRlTLXb+MoEADlViCSST+fNW1WnYBACqKB7ME3ER9ymVGHrBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463410; c=relaxed/simple;
	bh=Fm5nyNiQhAHEoqroFUFCfugFa6IubF/aLZ0+sIskEdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCrkn1FB+fwjSUeGNcrFx7EAn7AYUXljLyfpPvKbMSrciZeo4ZP7U3rL5fPkIMMVZc82ZPHtsrW6m2PDXC7/tQ3khZAKjBsqPq6qvyw+4WUM524sBhMubXrnuUynrL6Fbt1mgtKm/0m4C5lkKALz2iKiZtrGVmE2DQBE9Z3/VaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERwy2sjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERwy2sjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2237AC433F1;
	Tue, 20 Feb 2024 21:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463408;
	bh=Fm5nyNiQhAHEoqroFUFCfugFa6IubF/aLZ0+sIskEdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERwy2sjGYXXNg2sKX+1d/Dr8XMlijlWqtJHgUNY1HkV7EsmSmnzt4rnsCFpZi4dxo
	 IXlCM+AXZWUpT3rsTU8E0dJpuZjvNphhO/F2jhmDWyusVr1rajG0VwphfBYP+VmvJX
	 VCj+/2rx2/5TfI3Q3fM7ceY6L2WY0a237gEzeues=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/331] selftests: forwarding: Suppress grep warnings
Date: Tue, 20 Feb 2024 21:52:31 +0100
Message-ID: <20240220205638.699618769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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



