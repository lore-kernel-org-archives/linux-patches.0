Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002B41C5D77;
	Wed,  4 Feb 2026 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216312; cv=none; b=UHhoKLirKdIPO2/78hbANMsYuKZWHLnrbekWfCEEcNZETCColHJaDmHZyTpxLzZzbpNlS4VQgRuh6fVfs8h+/UyEKwl+s1zWgsfGS8pVYknI7o0sm8QwDy4j2SJLowaZFuwpPsK5j4LsHUlwxh4ytJZ7u/tigCyVt0AAOrH7sOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216312; c=relaxed/simple;
	bh=6nyCOtm2l09SfmiZT4NUk8JFQfZqFoFMPWYk6O3IZv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOywt4aLdSXC9ar5v+AyIQ+Yt5I6/S1Z50RKSIV1uN9z385UIw7WCkv7T9LJ0mJzx/9DoDCJ+JxqjDKSr29yGkW9MIlgFQp8L1osH8NRVZ+I1EuQ1MbzRTQEu3HDY23+SxwMcVUTZazKVtwO8dzRu4ZV3qA+ADpM5YC/j/8bRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1B7xjgC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1B7xjgC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0CFC4CEF7;
	Wed,  4 Feb 2026 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216311;
	bh=6nyCOtm2l09SfmiZT4NUk8JFQfZqFoFMPWYk6O3IZv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1B7xjgC/jY+lCHBLfHXoK9SGRwPi21ftitp+t0PlN8aC3HXh+E0KM/kx+EzkWOrOV
	 CvMKoybSEGeMTtG3BgH+fkM4iACf2GlyCjQbWLbx2g2Ocp3CLtVf06GAHMxNtVDwI4
	 AFSkbzOKK4NOU972xjmOwRagZo0dNLgeB51SEXo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 050/161] selftests/net: convert fib-onlink-tests.sh to run it in unique namespace
Date: Wed,  4 Feb 2026 15:38:33 +0100
Message-ID: <20260204143853.562371909@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 3a06833b2adc0a902f2469ad4ce41ccd64f1f3ab ]

Remove PEER_CMD, which is not used in this test

Here is the test result after conversion.

 ]# ./fib-onlink-tests.sh
 Error: ipv4: FIB table does not exist.
 Flush terminated
 Error: ipv6: FIB table does not exist.
 Flush terminated

 ########################################
 Configuring interfaces

   ...

     TEST: Gateway resolves to wrong nexthop device - VRF      [ OK ]

 Tests passed:  38
 Tests failed:   0

Acked-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20231213060856.4030084-11-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4f5f148dd7c0 ("selftests: net: fib-onlink-tests: Convert to use namespaces by default")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib-onlink-tests.sh | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/fib-onlink-tests.sh b/tools/testing/selftests/net/fib-onlink-tests.sh
index c287b90b8af80..ec2d6ceb1f08d 100755
--- a/tools/testing/selftests/net/fib-onlink-tests.sh
+++ b/tools/testing/selftests/net/fib-onlink-tests.sh
@@ -3,6 +3,7 @@
 
 # IPv4 and IPv6 onlink tests
 
+source lib.sh
 PAUSE_ON_FAIL=${PAUSE_ON_FAIL:=no}
 VERBOSE=0
 
@@ -74,9 +75,6 @@ TEST_NET4IN6[2]=10.2.1.254
 # mcast address
 MCAST6=ff02::1
 
-
-PEER_NS=bart
-PEER_CMD="ip netns exec ${PEER_NS}"
 VRF=lisa
 VRF_TABLE=1101
 PBR_TABLE=101
@@ -176,8 +174,7 @@ setup()
 	set -e
 
 	# create namespace
-	ip netns add ${PEER_NS}
-	ip -netns ${PEER_NS} li set lo up
+	setup_ns PEER_NS
 
 	# add vrf table
 	ip li add ${VRF} type vrf table ${VRF_TABLE}
@@ -219,7 +216,7 @@ setup()
 cleanup()
 {
 	# make sure we start from a clean slate
-	ip netns del ${PEER_NS} 2>/dev/null
+	cleanup_ns ${PEER_NS} 2>/dev/null
 	for n in 1 3 5 7; do
 		ip link del ${NETIFS[p${n}]} 2>/dev/null
 	done
-- 
2.51.0



