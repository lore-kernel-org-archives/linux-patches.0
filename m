Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FFC13B7A0;
	Tue, 27 Feb 2024 13:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042157; cv=none; b=Dsq6WYlgVD86s3B5rSv0/33HS7M6qZy5ajqBD0bgNhGNm5LAQhFVYrlwTHYSsw1Y0DX8TCk13M27UeQozDX0RdT+8Y9l9aUGUlVZAr++kCNp29CK3415Yau3bZsfGKonDO9QXSlwq3p4U/jeMiOfukYrHJYSLnu4z4Hrxeq8WGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042157; c=relaxed/simple;
	bh=2T7+YjmHPWNQvIH5ZKMrxyLtapsbPOOSbpIv86tYpl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHRRrGzGdwQY+exfgXjTGsDPAnuwW2TaJhxJmx1NZL9CjAiAxQpca3lgVgvABzTeTr+kuIeUkxFHeRlkHmQb6pzlAbztj2Up0+K61i/EaEHqpP/ysyAvvjx0KNQ3LVVK29EWyH9O4V9oDsGTFzwo+vjOv0n54sSosu9/Zq1yIt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xM1BOevu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xM1BOevu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA73C433F1;
	Tue, 27 Feb 2024 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042157;
	bh=2T7+YjmHPWNQvIH5ZKMrxyLtapsbPOOSbpIv86tYpl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xM1BOevuJGl1bjpwzOjlmohFcyBjD19xU97N97gLbUY88lkAF2pm9tN+lBGVZcxHI
	 N3tFaGAlYjjsD0VEcCzTHDd/GXMlPERTaF+my6x2WXf2nFZdwVntlNlV0eXuDnUOx6
	 aqJh66RZJwDAQaPd/VYGmrSFpGumjCLH2MJbAnfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 200/299] selftests: mptcp: pm nl: avoid error msg on older kernels
Date: Tue, 27 Feb 2024 14:25:11 +0100
Message-ID: <20240227131632.247481639@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 662f084f3396d8a804d56cb53ac05c9e39902a7b upstream.

Since the 'Fixes' commit mentioned below, and if the kernel being tested
doesn't support the 'fullmesh' flag, this error will be printed:

  netlink error -22 (Invalid argument)
  ./pm_nl_ctl: bailing out due to netlink error[s]

But that can be normal if the kernel doesn't support the feature, no
need to print this worrying error message while everything else looks
OK. So we can mute stderr. Failures will still be detected if any.

Fixes: 1dc88d241f92 ("selftests: mptcp: pm_nl_ctl: always look for errors")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 79e83a2c95de..71899a3ffa7a 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -183,7 +183,7 @@ check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow 10.0.1.1" "          (nobackup)"
 
 # fullmesh support has been added later
-ip netns exec $ns1 ./pm_nl_ctl set id 1 flags fullmesh
+ip netns exec $ns1 ./pm_nl_ctl set id 1 flags fullmesh 2>/dev/null
 if ip netns exec $ns1 ./pm_nl_ctl dump | grep -q "fullmesh" ||
    mptcp_lib_expect_all_features; then
 	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
-- 
2.44.0



