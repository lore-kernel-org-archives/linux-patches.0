Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026928;
	b=kxrXJp6VeRk7oBq/yQE02teSbpcy0/qSAoTTlnmhIdtPt63mAWgifyVdlbxbIWXvOf/5
	 Fi451OqCT3SedW301Wtv9ETmlum1BTfcNAVsp7kYSKBX4SbH/9Enr1W7WpQF++fM7Cy8o
	 KvS0JHmd1VeGTt3A1Z+LlpkU26uwo/uN9jubr32WqOYC05DSgj6mTlta51nJpAM2B4nqS
	 XPX1Gd9xcKYsogWuBQmqGdBrc8CPZeZxZQ9YiQAhLTmghWoYMibtBwPz7a593OhA9jjL7
	 MSlkfnp/3vgSlBzeF5m0qjvM29uPc2f03oPYtCf06i6Z6LGS5i7f0Hz95TUb454KnEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026928;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Bkcz6RexBxMwXfBE/AAwfA5jSGMj01/9J0k4o8RbZI=;
	b=4MTxkKHe4ARVHCqj82cteU0M43od/cQENPoVzvw1V8Pxr3WceHBB4NPPRM5UNZtH9ZpL
	 SmAPyK8CJuzsAcJre+dGC3QUiDXiyNjVVXB0/UdJH6gAObaj0yvAkFDj/VOce6ZCDek90
	 Vw/tnXs5mb2O0nKqkO72ShpR3+LFABfrrOfzH121Uh91/IF3IaxJF6PDf9z7hVXyifDbj
	 dnMZfOUHV91b5lcBuMzKf5WrWBN4XSjx9SYErFIl7lp97+Dsz94+ubIVgmECmogr+850P
	 5kyUpilql8J7xwGXyMvjgNPIcs2inml0wVE4hEn+tfNCgXKzeCD4al47d39WJUh7ImA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7+ys+Ep;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E5A606A335;
	Wed, 18 Nov 2026 18:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7+ys+Ep
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C311F000C7;
	Wed, 18 Nov 2026 18:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026927;
	bh=3Bkcz6RexBxMwXfBE/AAwfA5jSGMj01/9J0k4o8RbZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7+ys+EpXyzKA11B8sI1EuWtkY2BeFhHEtkZTZohuZDUDjXQoIfjpD8X4QplD6xnY
	 P4p3jpzD8tUK9CRdgpte9UEwC7FiDwhV+G9JkL3tDfHiWwH5qHtlLQJ6IoT5ziruWa
	 NUcM4Xjco4tXvLkL7InIXUZ2MkwxyaZxxiyInbWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1610/2151] selftests/bpf: Create the vxlan devices of test_tunnel with their MAC
Date: Wed, 18 Nov 2026 15:55:45 +0100
Message-ID: <20261118150220.520942932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bae0e9de277d2..5e876a5f0f32e 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
@@ -161,9 +161,9 @@ static int add_vxlan_tunnel(void)
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
@@ -198,11 +198,10 @@ static int add_ip6vxlan_tunnel(void)
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



