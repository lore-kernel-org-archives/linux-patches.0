Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B6415B0E2;
	Mon,  6 Jan 2025 15:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177724; cv=none; b=eABucb0/yz+KVMW8/74yK+/8jTCsm5mxMzH2IzKOZxv1+l48g0rV87BXsnIE/gtnAhRLBOu3R2fskPioXTupnvLQujJDrBk/lpFhYvN56RxR7jMyAahc2xXNQipiFbQwjzeN8tdXcHc3jwXT0VkWic1sZz+fkh2QKOyAEuqpmwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177724; c=relaxed/simple;
	bh=7fkv+Vylyg59/eqiInbyo+QhWhkxO5NogJ+9nErqk5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqgD90zrfXAief5b03OZLGRFuWMdMWX5097ARssqihQxEJ33505UDO3de0nQLxG+i88I532O7up1u4lt1f0KzeSaaoRA8G0FBNhwfGdNgOml2PcqN62c4kVu4eCciKk2m5AMDOIPSO7ab3O+ES24NDgMOWTy/QNIaMNlRJ3dW0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f08YjKOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f08YjKOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFA0C4CED2;
	Mon,  6 Jan 2025 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177724;
	bh=7fkv+Vylyg59/eqiInbyo+QhWhkxO5NogJ+9nErqk5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f08YjKOFGtVdCkRqeE4ml2GMPau9RbdjBiB83ixs/5SyFyicX1/MHrYr8jtPVMhLM
	 oelOeioNRU+OPZe7a4DmVHk6gfQO1T75MxHD4aoMNW8BZXiD4KMt4BgvFSSNkiyysU
	 MOVbRlGQ0neSvj23/c7eKa6Nc3tUMK4OZKlHYna8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/156] selftests: net: local_termination: require mausezahn
Date: Mon,  6 Jan 2025 16:15:21 +0100
Message-ID: <20250106151143.060197062@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 246068b86b1c36e4590388ab8f278e21f1997dc1 ]

Since the blamed commit, we require mausezahn because send_raw() uses it.
Remove the "REQUIRE_MZ=no" line, which overwrites the default of requiring it.

Fixes: 237979504264 ("selftests: net: local_termination: add PTP frames to the mix")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241219155410.1856868-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/local_termination.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/local_termination.sh b/tools/testing/selftests/net/forwarding/local_termination.sh
index c35548767756..ecd34f364125 100755
--- a/tools/testing/selftests/net/forwarding/local_termination.sh
+++ b/tools/testing/selftests/net/forwarding/local_termination.sh
@@ -7,7 +7,6 @@ ALL_TESTS="standalone vlan_unaware_bridge vlan_aware_bridge test_vlan \
 NUM_NETIFS=2
 PING_COUNT=1
 REQUIRE_MTOOLS=yes
-REQUIRE_MZ=no
 
 source lib.sh
 
-- 
2.39.5



