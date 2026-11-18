Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049938;
	b=d3nm1mXw2EVVeSzkYDz3FRY1mg9h7y2cCm0Rek31oba5MqPbWxBvkonWlIuwb916TyqW
	 F7cXiJ0il2Kj2DlH+gSsVPaTrd/juYEs8lcNO3VmS0XZ5dR55JPGBoCOuk3YTc+QFmJw5
	 8K2L+6U4CuDC1b1sTwEE9h+Gx1kAYPy39hKd+6gk5BHWO7r4gpRwtNCIgaOMB567V+NVX
	 tQpBc/vFn2nQYgwT+RUfUAHBuK5Jqr+pEU9lO6UL5gKF8g1cpPYKElxBtw7EexYXmPHIy
	 8VQqvzEFQLyd3dwyVN5ax1Vk926yiEegJW1rxZQuQGXZmID3kz0eENHAJWcAjqbv7Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T/YFBaHH5YrFo73G3kYlaGcO1xwv9FKieljuVe51Fqo=;
	b=aLBe7PZ62kHPlTx7Ep4V3Tce3AVI3IkUEb3n9j2BvAM1W2oljcrCgxZJBBJwNSvm4d0H
	 wu566pLKkrpNGlpK8h9lQ757PuC0w6ELabQsOC63i/DM8YXCpHDQOD0v5B2fX3g6TU6fZ
	 r3X/2FmIDENAan3QQOp/iNUNfn1dsmFiWNUpppC14sV37iKvxW1iSP+1MC50Chn2oivNu
	 UHmCl74w/Nm1anYbiT7VaY2TLPEd4TVFI/rWeD5Gt7QVpvEN/ts3ZsHxZEX2mm9GBUsop
	 BVrC9m9cjIzTbXSiikOlCuYSimMSAl2WyYSnWR4tAFkEVRlcHsylvjv+Jf3qXCJON1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0YLYdF4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD03606A320;
	Thu, 19 Nov 2026 00:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r0YLYdF4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1591F000C4;
	Thu, 19 Nov 2026 00:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049938;
	bh=T/YFBaHH5YrFo73G3kYlaGcO1xwv9FKieljuVe51Fqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0YLYdF4DzSjIObW0vefziZcBf6pTtI39f6IbZtCJnbCw2Sgu4SBi1kocPd75qXLI
	 ya4sJQfkst0cJmHAwOXOmEmmCx+r2rDPAjiLeKAh86wjPwxLY6bahemloWNlwocFvz
	 pWveieYaNU0wvtVqdvAnlezaGDWBoT2YiNIubPIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2529/2857] selftests/bpf: Create the vxlan devices of test_tunnel with their MAC
Date: Wed, 18 Nov 2026 15:59:23 +0100
Message-ID: <20261118150332.596918298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit 33cbc5c2cadfe3b43f024e89880dd8fe2efb3a2e ]

The vxlan tests of test_tunnel create a tunnel device in the initial
netns with "ip link add", and then give it the MAC address that the
static neighbor entry at the other end points to with "ip link set".

systemd-udevd assigns new devices of the initial netns a MAC address of
its own, following its MACAddressPolicy, when it handles their uevent.
When it gets to that after the test set the address, the replies sent
to the configured MAC are dropped as meant for another host, and the
ping of vxlan_tunnel fails after 10 seconds.

Pass the address to "ip link add". udevd leaves alone the address of a
device that was created with one.

Fixes: 1ee7efd40abf ("selftests/bpf: Move vxlan tunnel testcases to test_progs")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20261009-selftests-bpf-tunnel-vxlan-mac-v1-1-624dd769c334@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/test_tunnel.c  | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
index e0823c2472fe7..632f3b709e829 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
@@ -129,9 +129,9 @@ static int add_vxlan_tunnel(void)
 	    IP4_ADDR2_VETH1, MAC_VETH1);
 
 	/* root namespace */
-	SYS(fail, "ip link add dev %s type vxlan external gbp dstport 4789",
-	    VXLAN_TUNL_DEV1);
-	SYS(fail, "ip link set dev %s address %s up", VXLAN_TUNL_DEV1, MAC_TUNL_DEV1);
+	SYS(fail, "ip link add dev %s address %s type vxlan external gbp dstport 4789",
+	    VXLAN_TUNL_DEV1, MAC_TUNL_DEV1);
+	SYS(fail, "ip link set dev %s up", VXLAN_TUNL_DEV1);
 	SYS(fail, "ip addr add dev %s %s/24", VXLAN_TUNL_DEV1, IP4_ADDR_TUNL_DEV1);
 	SYS(fail, "ip neigh add %s lladdr %s dev %s",
 	    IP4_ADDR_TUNL_DEV0, MAC_TUNL_DEV0, VXLAN_TUNL_DEV1);
@@ -166,11 +166,10 @@ static int add_ip6vxlan_tunnel(void)
 	    IP6VXLAN_TUNL_DEV0, MAC_TUNL_DEV0);
 
 	/* root namespace */
-	SYS(fail, "ip link add dev %s type vxlan external dstport 4789",
-	    IP6VXLAN_TUNL_DEV1);
-	SYS(fail, "ip addr add dev %s %s/24", IP6VXLAN_TUNL_DEV1, IP4_ADDR_TUNL_DEV1);
-	SYS(fail, "ip link set dev %s address %s up",
+	SYS(fail, "ip link add dev %s address %s type vxlan external dstport 4789",
 	    IP6VXLAN_TUNL_DEV1, MAC_TUNL_DEV1);
+	SYS(fail, "ip addr add dev %s %s/24", IP6VXLAN_TUNL_DEV1, IP4_ADDR_TUNL_DEV1);
+	SYS(fail, "ip link set dev %s up", IP6VXLAN_TUNL_DEV1);
 
 	return 0;
 fail:
-- 
2.53.0



