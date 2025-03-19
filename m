Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247581D5CD7;
	Wed, 19 Mar 2025 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394854; cv=none; b=S+oAQ7jl+1SrN7ulnpawMoSaiz3lvChTdxUNhwGAv1MqrwzQX8aPpeuaBJXComqbHGmicYx8nusCkh8+6rg8oEUgB90lIfvf7XpOcKAGfawHMv4dQOVDNVQV7l8DMC0j/RJ4Wl+pFpvQwwOK59DWPxGMakFdbQBuWEiy3Wk9mjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394854; c=relaxed/simple;
	bh=vtYzNJk5WoZS2BQOGEovNIxNZamzGkthZl4HOWFk3hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2St1v249uBJLmDLjDvR/8EWtxjVayljriHbUJtALAeWrNqJrkgbZ2zB13aZP3zR8GUoAgqKS8rSXK28kmCbB4XZcvfFYjk5hWWq3qlTNaRdO+AlkkI6L5Wa1kSjygJc87JboK45qBeV4KKQmx1o0SaZDnmJavsP+lOdTww8Yv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxn/nuGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxn/nuGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE174C4CEE4;
	Wed, 19 Mar 2025 14:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394854;
	bh=vtYzNJk5WoZS2BQOGEovNIxNZamzGkthZl4HOWFk3hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxn/nuGu+eCtr1jq1M+p4WllAX01amOV2EcduJP4K17963qUk5p8xPWgWfJttq0Fr
	 FpQrQzxjijTQG6E/lId+CNqqQgJXTICgoRKZ3Ky/zO7ceAp9sDnH2XVVV4MAHee/No
	 5JmtgKhVH/Pl5MQvMb4okROEpIc4wG9fdbw5Pk0A=
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
Subject: [PATCH 6.13 041/241] selftests: bonding: fix incorrect mac address
Date: Wed, 19 Mar 2025 07:28:31 -0700
Message-ID: <20250319143028.736140851@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



