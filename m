Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDEF21422E;
	Wed, 19 Mar 2025 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395037; cv=none; b=OSyd6kKGYLLxDc8kW0+8ixa4aHsgbI6YXTtlSenExCW6eP+zHy0Huc2moF4tDOIE6ytqFUSd1xchd295n2tTlLwzSFG6g4HJIdKs+Y8cmeMv2XVoxkPkis4K7EcPqBtl85aoxhpj3lpo5gwIyb4LyNCEr6xBmGNeThlKiuwjslQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395037; c=relaxed/simple;
	bh=ToZPJXPRFYW5mULc2bM3RJM/iLGk01ukTnusTphZWSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSVvXhNpNQ8h/J0n2Ija5/kJjH1DewCmvLdbdK7fj/K/Xe8I94f4pGOq1urlM/gtgFlNGnJpMz6ahlnQH17YHMRQoWyX+GV76oILI3L7XMEaRRZFiqQuPdOHY9J2ufI+PHQAF800oTDIOi9v6wPvuDx59khNFwffRuz9ssm1Ndw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlj4PD99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlj4PD99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22BD8C4CEE4;
	Wed, 19 Mar 2025 14:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395037;
	bh=ToZPJXPRFYW5mULc2bM3RJM/iLGk01ukTnusTphZWSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlj4PD99jNGVlIulsSODNYc88evuZVYPzvdPgxLXnEN6ffSYmybzYN+dFs+J2kEil
	 RImed2P8wn4zAPvX+WHh+K4pKWcv/mL1PAE/V+xIXy1aHQKIpRLoNNzQM1l8TmesJS
	 3UDwLh962k9qxEyVxctYX92BfnFhZZzdRexCyYPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/231] selftests: bonding: fix incorrect mac address
Date: Wed, 19 Mar 2025 07:28:55 -0700
Message-ID: <20250319143027.854864886@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 9318dc2357b6b8b2ea1200ab7f2d5877851b7382 ]

The correct mac address for NS target 2001:db8::254 is 33:33:ff:00:02:54,
not 33:33:00:00:02:54. The same with client maddress.

Fixes: 86fb6173d11e ("selftests: bonding: add ns multicast group testing")
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250306023923.38777-3-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/bonding/bond_options.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
index edc56e2cc6069..7bc148889ca72 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -11,8 +11,8 @@ ALL_TESTS="
 
 lib_dir=$(dirname "$0")
 source ${lib_dir}/bond_topo_3d1c.sh
-c_maddr="33:33:00:00:00:10"
-g_maddr="33:33:00:00:02:54"
+c_maddr="33:33:ff:00:00:10"
+g_maddr="33:33:ff:00:02:54"
 
 skip_prio()
 {
-- 
2.39.5



