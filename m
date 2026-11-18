Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032210;
	b=2BMBaP7sGiesJkqPQN9A921mAhqA/Myh2CN9HFbZNFBfRZs5j4lKc5UonaU+9msSISle
	 KLZBftLQ/0yHAdiWAe93p6Lmpgm+cjmVaz2qY+oQ8xCKiWKLTxlXFQlKHW50HmrHwxHjt
	 /Q2+R3tpoXCQgVDu+x38dsTQhzL36uLsz7XDtQeDfinCXDew7G5iHAV1DjeLL1FBkkKNb
	 aScZEXZGeeDPYeIIt3190YXcU0NE2Z5m6gIzga20X+javinGsiNFwDtGcs4sUcgmN//84
	 HU/X2rV0UvqFW8/WBi51n8gwMMOGYb203TruNPR9TK9QCsdoOzMpZ4TP8mIvz5Ka+9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EJ49RoGvDSPtk0hl8znuIRd5vfNw9dMPALAlyXS4qw4=;
	b=xmNA0QZLdPxAK6BYHHrfiUr45/HUyBZljK9hfE6j1vFPYigDzDQpyzDAK3D06YDupgh6
	 ZkHHbc/zIetoKlPVdaeVqLe5CV3SFDTpXjp2dQuDQE15sehfEWTPZdp9ZuzxJvkbRPIVZ
	 K44BOGpGu2zBEXf0KTMDuva/3V7jNuD425Vm9sPq+TIJAOv/s12TcdvWc8bjm5oqva/nw
	 QRnZJDo/2v+JwftlFPS+U1jrePO149B8c95V3h8LE5acX82m6clynpOGdiWjQ/7aSFOEM
	 NZdXiPSd+usHGQX+NET1I/t9XfjI2uqU0asAd6VY1cUerL2TtRNiGG6NbUXLx8QFExQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aD/LGje4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77364606A320;
	Wed, 18 Nov 2026 20:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aD/LGje4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780251F000C4;
	Wed, 18 Nov 2026 20:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032210;
	bh=EJ49RoGvDSPtk0hl8znuIRd5vfNw9dMPALAlyXS4qw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aD/LGje4exKErVEZCkHXFuK35R2jLKVKKYavX/ARjJpgGBjGpyBoZwCIsQ+ucpi9Y
	 PzDk6tGv5AzeAMqy42ZcCO99oYZZx21NRuaJyhBq5M+NXY1UvMnnQIc+UOaqnL3biV
	 R4HrgBvtgioVq6dw0UcTLnqdcxROd7mMpk7GJQKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1280/1756] selftests/bpf: Create the vxlan devices of test_tunnel with their MAC
Date: Wed, 18 Nov 2026 15:56:47 +0100
Message-ID: <20261118150100.533874888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cec746e77cd3a..672182b8b3ad6 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
@@ -138,9 +138,9 @@ static int add_vxlan_tunnel(void)
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
@@ -175,11 +175,10 @@ static int add_ip6vxlan_tunnel(void)
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



