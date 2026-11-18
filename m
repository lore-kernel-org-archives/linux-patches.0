Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041752;
	b=pe+LpWiIkOuAtKsuMFWNUeXbHWxB651qQYn49+eTm0r6cBnX+01GZXV7jr86uCQgz9dr
	 t7jqQ8qpsYl34fI433M+dOS5zX0ZA7V2bUx6E7+HR/mynHQh3F6BGLneKEpiqgoC34JZx
	 bPoXfHBGeP0fMLHhP6h5A0tBW4qTtkiAS8QbVSc/6luWOmDmkae+9tiYw7vbG5V1JY5O4
	 X6ZLR1gpQGhsilbLE6m6UsclunfVnvGvzrI59HSVNZ0ZfoCYSmQc2f4U2bLSyNOtk/A+c
	 b+N+mRvyObhVA7gkZL0xVwbVY8aD07Sbq20hNviGrGvPxKE3ZIAQVB8LksUfLrj5vew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+p8EBhaynCoqyMR8ub+4cW/nOQhlFo1XRX1T9EA40sU=;
	b=QEGFyLpbaN4JYDh//qJ6Z2LR0NMFEO01k0MeSaNHUfakY7mYlijunhityJe5F4fDd+M9
	 w9KUlN3bJzAXCPFGvmyAjqa33brHBo6lhwqE1LDP1DpqavE36FRYtd6JGHg68hQhmIPHR
	 JLdzpS71CA1YuwmjKmHBMbUlkkjbma4amlFuhJ2VhG4egyWJ+LPN5lfy3S25VNzzRXjrM
	 4Uv/Ex/FXLaBN3eF9EfKb5Mjd97H718UCBUmT04alm9dvHiZS6BERWR8y99K4up1xjkxQ
	 obf40WLpfAHdl3MOChkkwhexXdN/cbaqaeGfbBducj6o8zc9QzG+6nc681qeWK9Iukw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7ZSBUss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D0606A31C;
	Wed, 18 Nov 2026 22:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L7ZSBUss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB7B1F000C4;
	Wed, 18 Nov 2026 22:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041752;
	bh=+p8EBhaynCoqyMR8ub+4cW/nOQhlFo1XRX1T9EA40sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L7ZSBUssWutnSDXm0UwJ63xpoC6W5yy/WVMscgeQb0zohoKReK8BW+EeijyvtsgNW
	 sVL+Z52Al7H1w5iwC1sRg2CduZsJE7i25UHXCIr8htIoGL4Gl5Gdeh33XJxZGnzdWU
	 EFUBCYuP94MV/C8ajmLGY4GQe9tEZBi4FQjDb6wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2925/3318] selftests/bpf: Create the vxlan devices of test_tunnel with their MAC
Date: Wed, 18 Nov 2026 15:59:07 +0100
Message-ID: <20261118150448.151799472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d149ab98798db..b5c7a4e623722 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tunnel.c
@@ -132,9 +132,9 @@ static int add_vxlan_tunnel(void)
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
@@ -169,11 +169,10 @@ static int add_ip6vxlan_tunnel(void)
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



