Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022264;
	b=AriwRfq1zSMcoQGW1KVzLfCGknVu5JGHiu5qbDuuSRiYd1VEi5kEq7W8T3aTyimcewgU
	 4XzOtFO4dRWOY1RllLRwQ3TQpIiBKwP8kJn1AGn8OhKDIBdWLBhntkL0EXzRjpKWhCSfi
	 tTqASPt8BHNpnYLpPih+BKkAdhJZyNWLNqOlBqWaEQv8uRncZV4+mz5SdgHyDSGkxjsb8
	 MYqswsM8j7HSP8ok41ZqVzl1ansQNCH/nRpEGbvHB+vlttMfq0Rpp62s6AlfrEDNQhSpd
	 CdXcg+ocK3dzUkDHbERo4HVePvepfYOOZtgZx3i3Ps6Q3keukTfmrhyMtzGckHXlQ/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GHLFQOLM2QrknZ4A5Td4nn1LQ+erUZKw20+tgK6zSxI=;
	b=kCNCgFVCaVENXSK4FS6RUcEbJHooNfOb4lWEuHlbgz8ptvWmGei1AAoAswRJYwMiZfNf
	 r53ZWVEKMPznf6vSEkLzyBlJrHvOVN5SFjzg0aQW7ZsI1GIQIrrj5xGViRdQc0ZovCFzH
	 JlrDEd0tftZk6Jr1QCNRl4qf0y4dXBvzo/fqMYYCaB/s1Jhqr+R06JvNhmeT69V+l7mdH
	 Dlj2s4qFlDgRr26t3bcJTNB77XlFulu33xqUu8cZwydeAsv/RtYEbewFaxKh8bmZz3w8I
	 hDWT/V2rfZw6pvrxuUdKVlnBiup8u+1pK/CugdWVP4I2D2xujQ5YoWeo24+6DsWy46A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBNAo6X1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A59F606A32C;
	Wed, 18 Nov 2026 17:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBNAo6X1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8731F000C4;
	Wed, 18 Nov 2026 17:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022264;
	bh=GHLFQOLM2QrknZ4A5Td4nn1LQ+erUZKw20+tgK6zSxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBNAo6X1jcvLdlZSolNCzfIoIchQHSNkO6RrMub1buxFrDKTxJ1+18bbTPtGJ4IPQ
	 FnYd7wqNMKMSIAxRKm8Yv9CFFyqq32oLu/K+XZ7kkA8HF24EPx//1a4l7eAqoX53i+
	 /fMdGyWLCFwPEsgq+R6QP239EAzZCeUtjMX6Ie2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2600/2651] apparmor: mediate AF_UNSPEC socket disconnects
Date: Wed, 18 Nov 2026 16:04:00 +0100
Message-ID: <20261118150417.868615643@linuxfoundation.org>
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

From: shaos <shawnq1@163.com>

[ Upstream commit 049760746597cfd054c181fe850531be3c1e7358 ]

aa_inet_connect_perm() returns success immediately for AF_UNSPEC
before checking the active AppArmor profile.  AF_UNSPEC is the socket
disconnect operation for TCP and UDP.  A process confined by a profile
containing deny network can therefore disconnect inherited sockets
even though ordinary socket creation and connect calls are denied.

console output:
https://gist.githubusercontent.com/shaos26/73b057c77b9ea22d5e6813c259dbf43c/raw/fab5c58d6f184f5fab88a3a31a80c2b919efecf0/console-output.txt
reproduction kernel config:
https://gist.githubusercontent.com/shaos26/73b057c77b9ea22d5e6813c259dbf43c/raw/b9192c97c92fdd3b59089704bad6fbd0a33ccf06/kernel-config.txt
reproducer:
https://gist.githubusercontent.com/shaos26/73b057c77b9ea22d5e6813c259dbf43c/raw/92c7dd098a227276fe3daeea45996e2848e66439/poc.c

Build the kernel from HEAD with the attached reproduction config, then
make a one-file initramfs.  The PoC mounts sysfs and securityfs
itself; DEVTMPFS_MOUNT supplies /dev/console.

    mkdir -p build rootfs
    cp kernel-config.txt build/.config
    make O=build olddefconfig
    make O=build -j"$(nproc)" bzImage
    cc -O2 -static -Wall -Wextra -o poc poc.c
    cp poc rootfs/poc
    (cd rootfs && find poc | cpio -o -H newc --owner=0:0) | gzip -9 > initramfs.cpio.gz
    timeout 900 qemu-system-x86_64 -kernel build/arch/x86/boot/bzImage \
        -initrd initramfs.cpio.gz -append "console=ttyS0 rdinit=/poc panic=-1 loglevel=7 lsm=apparmor security=apparmor apparmor=1" \
        -nographic -m 1024 -smp 1 -no-reboot 2>&1 | tee console.log

Under the deny-network profile, socket() and connect(AF_INET) returned
EACCES, but connect(fd, AF_UNSPEC) returned success and tore down the
inherited connection and listener.  Two fresh boots matched.  A
one-line control that routed AF_UNSPEC through aa_sk_perm returned
EACCES and kept both sockets alive.

Impact and prerequisites: A confined process that inherits a TCP/UDP
socket can bypass the profile's network mediation for disconnect and
disrupt that socket.  The finding does not permit socket creation,
bind, or arbitrary peer connections; no privilege escalation is
demonstrated.

Fixes: 89ac6aa752ec8 ("apparmor: push inet mediation into profile callbacks, and improve auditing")
Signed-off-by: shaos <shawnq1@163.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/af_inet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/af_inet.c b/security/apparmor/af_inet.c
index 516c9016537c6..42994e84cccaa 100644
--- a/security/apparmor/af_inet.c
+++ b/security/apparmor/af_inet.c
@@ -425,7 +425,7 @@ int aa_inet_connect_perm(struct socket *sock, struct sockaddr *addr,
 	if (addrlen < offsetofend(struct sockaddr, sa_family))
 		return -EINVAL;
 	if (addr->sa_family == AF_UNSPEC)
-		return 0;
+		return aa_sk_perm(OP_CONNECT, AA_MAY_CONNECT, sock->sk);
 
 	/* do we need early bailout for !family ... */
 	return sk_has_perm2(sock->sk, OP_CONNECT, AA_MAY_CONNECT, profile, ad,
-- 
2.53.0



