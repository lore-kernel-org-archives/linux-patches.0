Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051F3482C2;
	Sat,  3 Feb 2024 04:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933714; cv=none; b=teH2kKiRwghoYwXIiHedDI4zyn0i4mi/8vE9+v5+Zg3DZlH8FjL5FOAKsB1nGnlnhAKsJ8g+QB9VybkGnM24igrJRpn8MNq3OuHjIDEqDD72Drdck5uk9+kOg+d3J9H4oBDxUcjXDhF999LvbbPMhG1ED9ikZGpQ1honF4lq6XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933714; c=relaxed/simple;
	bh=tMd5vov6ZdtynQgcY6wnunQ/ZSLy0Kn6xmpSJlv6iHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHh4kr2UTPyvbSeCJEZpd0EykAjgsNeNxCbuUiB87z1vm6jnDiStF6qxPpSRHWB6MPGMgDYQwtwsCeISjS3dRqtSnV9vrMxLu1DSDSqp8CgN3I1Bw/9LtRo8bgCWG1hN2Lo9CuXPFfTjliIyIdt6ij/xz1t6a1vpbwj4B33vjOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SK7l/rJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SK7l/rJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0ECC43394;
	Sat,  3 Feb 2024 04:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933713;
	bh=tMd5vov6ZdtynQgcY6wnunQ/ZSLy0Kn6xmpSJlv6iHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SK7l/rJOTEPYTwLfF/noPYr/RcfRdD+ccjUYsVaER+5j6/cH+uMh6sIOJ0/5PzUgz
	 RZBvtLQ7v/yAPSyUXKdDr9JClQdwWu+4DzCocOmm9ZrcHVPTvW7vwqHvAi8ynQbHLb
	 ErEXWP9cuucGV+r2+wCT+VpgsjLGRMCOWOMwjQCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias May <matthias.may@westermo.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/322] selftests: net: add missing config for GENEVE
Date: Fri,  2 Feb 2024 20:06:29 -0800
Message-ID: <20240203035408.505833296@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Matthias May <Matthias.May@westermo.com>

[ Upstream commit c9ec85153fea6873c52ed4f5055c87263f1b54f9 ]

l2_tos_ttl_inherit.sh verifies the inheritance of tos and ttl
for GRETAP, VXLAN and GENEVE.
Before testing it checks if the required module is available
and if not skips the tests accordingly.
Currently only GRETAP and VXLAN are tested because the GENEVE
module is missing.

Fixes: b690842d12fd ("selftests/net: test l2 tunnel TOS/TTL inheriting")
Signed-off-by: Matthias May <matthias.may@westermo.com>
Link: https://lore.kernel.org/r/20240130101157.196006-1-matthias.may@westermo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index b4e811f17eb1..dad385f73612 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -19,6 +19,7 @@ CONFIG_BRIDGE_VLAN_FILTERING=y
 CONFIG_BRIDGE=y
 CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_VLAN_8021Q=y
+CONFIG_GENEVE=m
 CONFIG_IFB=y
 CONFIG_INET_DIAG=y
 CONFIG_IP_GRE=m
-- 
2.43.0



