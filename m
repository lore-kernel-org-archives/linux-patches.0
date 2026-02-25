Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF0A2550D7;
	Wed, 25 Feb 2026 01:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983529; cv=none; b=fmvGQX/Kz5x8wubmgnZCJFdDM8Mc3MIEXIWHG+Lh87Tnho7xHQ82U+BgPCOykyWnLnKONedNFE0gF2q8MgZOJCUjQvU8nXuamHmEsO8RbOycXG3SNFkgSduZxl8DVGOgKzSul2WIc0EM4jfaLG6aF+Mf8Ip4019/rSzibDHmjkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983529; c=relaxed/simple;
	bh=dlRIsYPDwYdO/N+K+mcdRYHJ9fBtCSzbELZ1ZEHQij0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwNjL1ZgeL5c0OJdqtNz6ml67eM/J42iHVP4lfPnxYr2U3pXSeqO4Lzc2/Uq36kl04nYxMcv/9QPMKScXDVT0idCLt1rEuNivbLnVUaRbH1SQ0bdi7jl/RL2wAQhMw7sBvC1ym+kyeE36gMk6Cn8Z1pKsrY+ORcyf0RSVOfbwQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uh8fOv56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uh8fOv56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66853C116D0;
	Wed, 25 Feb 2026 01:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983529;
	bh=dlRIsYPDwYdO/N+K+mcdRYHJ9fBtCSzbELZ1ZEHQij0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uh8fOv56N6w0pRxAq2JO61h9Hyu5v9GlSHdf2P2W9Bsuas/vkxZzgyU5PRns1LFZU
	 zSXcPVLo60Qq7LMEGQdtmOSfnyUqnamtDioYfnYY+Lm03R79P9TOnxJHFKGr+RoTBI
	 kxIZBieRMWU05oYmTLjjeFaEPkHolAC3G09NaPxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 636/781] selftests: mlxsw: tc_restrictions: Fix test failure with new iproute2
Date: Tue, 24 Feb 2026 17:22:25 -0800
Message-ID: <20260225012415.405904561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit a2646773a005b59fd1dc7ff3ba15df84889ca5d2 ]

As explained in [1], iproute2 started rejecting tc-police burst sizes
that result in an overflow. This can happen when the burst size is high
enough and the rate is low enough.

A couple of test cases specify such configurations, resulting in
iproute2 errors and test failure.

Fix by reducing the burst size so that the test will pass with both new
and old iproute2 versions.

[1] https://lore.kernel.org/netdev/20250916215731.3431465-1-jay.vosburgh@canonical.com/

Fixes: cb12d1763267 ("selftests: mlxsw: tc_restrictions: Test tc-police restrictions")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/88b00c6e85188aa6a065dc240206119b328c46e1.1770643998.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
index 0441a18f098b1..aac8ef490feb8 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_restrictions.sh
@@ -317,7 +317,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 0.5kbit burst 1m conform-exceed drop/ok
+		action police rate 0.5kbit burst 2k conform-exceed drop/ok
 	check_fail $? "Incorrect success to add police action with too low rate"
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
@@ -327,7 +327,7 @@ police_limits_test()
 
 	tc filter add dev $swp1 ingress pref 1 proto ip handle 101 \
 		flower skip_sw \
-		action police rate 1.5kbit burst 1m conform-exceed drop/ok
+		action police rate 1.5kbit burst 2k conform-exceed drop/ok
 	check_err $? "Failed to add police action with low rate"
 
 	tc filter del dev $swp1 ingress protocol ip pref 1 handle 101 flower
-- 
2.51.0



