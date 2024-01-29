Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B0A755F2;
	Mon, 29 Jan 2024 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548592; cv=none; b=JXsKr7NG/oRLfCPb0S2ZGm59KoC/czzmEV9zevxws68GkmjH//536VsEgBX/GnZoMyYkkqOfxtrsFPFdkfM2CHW0Sk2g8emdspJUc6Hhb0GCTYWkGuzH+WOUMIN7Jsc4venSbcX2j45M1xYJ3cPIAcN6eHZoJtJRuSMyNAP5bxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548592; c=relaxed/simple;
	bh=5lw1bceprDtNgPw4q7rZUTNh4kM/eQs1x47QEh2KvWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuB4YRqzeaN2IAGBShDFHdVnKkl9eBOWsrM32b4xyZ220TH9Z2DtjjL3t21ssybQVCcVgw0B37mnr0iBUG8qgoEhJF8PZ6FlH8jyAoFVy6+Tnmgc/JyQrJXIpZUvdf4+Qc9eTnfdYxLbo7vjaePKi8B+tvznoBOcgFU5ZpMLtks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vLvZHqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vLvZHqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA3CC433C7;
	Mon, 29 Jan 2024 17:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548592;
	bh=5lw1bceprDtNgPw4q7rZUTNh4kM/eQs1x47QEh2KvWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vLvZHqZXACUNw23smEVLMxSfgJJ4lSEo+qYeePlwtDJMFalbgbC6baN6yMfMVJO9
	 NRZYvhhG8pzuu5XwY/bMIRhjL9Zv/X69vxmC/Xue+Heojfkcplo6yWAJ3i6X2L4VqQ
	 YA61A/m6iG1Xm1Vp5H/v5/W2AmQHDXOw2CvKvsAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jay.vosburgh@canonical.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 226/331] selftests: bonding: do not test arp/ns target with mode balance-alb/tlb
Date: Mon, 29 Jan 2024 09:04:50 -0800
Message-ID: <20240129170021.485548372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a2933a8759a62269754e54733d993b19de870e84 ]

The prio_arp/ns tests hard code the mode to active-backup. At the same
time, The balance-alb/tlb modes do not support arp/ns target. So remove
the prio_arp/ns tests from the loop and only test active-backup mode.

Fixes: 481b56e0391e ("selftests: bonding: re-format bond option tests")
Reported-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Closes: https://lore.kernel.org/netdev/17415.1705965957@famine/
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Link: https://lore.kernel.org/r/20240123075917.1576360-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/drivers/net/bonding/bond_options.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
index c54d1697f439..d508486cc0bd 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -162,7 +162,7 @@ prio_arp()
 	local mode=$1
 
 	for primary_reselect in 0 1 2; do
-		prio_test "mode active-backup arp_interval 100 arp_ip_target ${g_ip4} primary eth1 primary_reselect $primary_reselect"
+		prio_test "mode $mode arp_interval 100 arp_ip_target ${g_ip4} primary eth1 primary_reselect $primary_reselect"
 		log_test "prio" "$mode arp_ip_target primary_reselect $primary_reselect"
 	done
 }
@@ -178,7 +178,7 @@ prio_ns()
 	fi
 
 	for primary_reselect in 0 1 2; do
-		prio_test "mode active-backup arp_interval 100 ns_ip6_target ${g_ip6} primary eth1 primary_reselect $primary_reselect"
+		prio_test "mode $mode arp_interval 100 ns_ip6_target ${g_ip6} primary eth1 primary_reselect $primary_reselect"
 		log_test "prio" "$mode ns_ip6_target primary_reselect $primary_reselect"
 	done
 }
@@ -194,9 +194,9 @@ prio()
 
 	for mode in $modes; do
 		prio_miimon $mode
-		prio_arp $mode
-		prio_ns $mode
 	done
+	prio_arp "active-backup"
+	prio_ns "active-backup"
 }
 
 arp_validate_test()
-- 
2.43.0



