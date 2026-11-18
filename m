Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020611;
	b=DPo31nWdgKFFr+Q6JawtYvYDJzKbgCA54ni7Y0QhAuNqe/uUoQZUgp9qYfV96Ap50qA9
	 mmU5xRjENBCFnDxKKbi5WTaFG587hubZq/ybOxym4AmEppMY/FRN2DwsDAyH+hQz7F4df
	 AnkcZkcv8G2hDieoCHqFIe/jQDiMYhgHBKzRdzMaltiQuOULu/nXrh+98Vf4ac7x6QR34
	 gko5SVyvAY1U3JpHF9ZHmMnLnaaFA9u8siUK6Tn2VBbVZRrQOO4PE4+gE5hTaRwsxoaJj
	 Mt8BA3wzSuKoHcEP/cYqEHEWVVTFvRCFDQsl/nDXCjL96XTAPjyTE11eedIeLY26Mkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y2rkBTrBTJAo75mDyc+P634X8e+/CIE+VqXmB71PXJg=;
	b=rOVn0YlIOtxdbeZFGm/rmkH42nHThEttes4Rw6hNN0zRvT1NOT2EIIGG0a9mtborCTb3
	 oHtYAmj7+EMAvpUGCOoGY2GgljWmiRmgs5PitYNAW70s9W0Pp26Pcnm+/r/FDUGSLrcry
	 s2HW4F6HnWIf/Sa2+ArlCvOGcd79AdFEwWJWYnwTiH8OPYY5eiu7jPzuro9I/d+tZi9Sc
	 4aG3cyfOXIjHNZuGFHPW/B3wARSZ9ljyFrDn7/E4vN+ZXxkk7iRiwkMHxUdEIkdZtSeVa
	 22eaErbTTI/3vjZmKGH3Rx9u5UUTj7vW3yOvNhYkl+psyCjiK54GDYb4i8Yvhl8mvOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyT54Fti;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6624C606A320;
	Wed, 18 Nov 2026 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FyT54Fti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B399E1F000C4;
	Wed, 18 Nov 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020611;
	bh=Y2rkBTrBTJAo75mDyc+P634X8e+/CIE+VqXmB71PXJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FyT54Ftii5bQYfegERCuBttlpKA3n4wYlQEEdzORnbQxqT14uGCDSuwwIlU9EHDuU
	 Fka3WZda/jAfpwv/7AyQt5RwI8UVW0C3Z2ZFD8vDaUVNvk9d9ZeRMZ80ydBrVl8J2j
	 jVnNgc0SWA18K0cgp1cUAJtK6i4Zu0/lykIaUA4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1973/2651] selftests/bpf: Create the vxlan devices of test_tunnel with their MAC
Date: Wed, 18 Nov 2026 15:53:33 +0100
Message-ID: <20261118150357.477244196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index eb93099312720..7b35bf9498056 100644
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



