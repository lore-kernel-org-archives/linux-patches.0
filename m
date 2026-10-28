Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215833;
	b=rpftdxhN1GaRcCn2fb4n0N8s5QMt2O7vKzAJ5xQibXrZ+z6kcajhLsRWpYcThjBpleo7
	 Z0AtBrc4+bpEfvAyafcY6bjPAdWyFpcLprSRbNUNlOLTRMBSToLeW5Ssg7O1wtqXY73b7
	 J4jgBPTR4UjGJ8jWfV2RjVdPScpR4bH11j3rKdkuXW6Q6xZoawyxCkHHNR2c4EuMAH6mj
	 7SlotycA945eTF2USW4y0L+V1198F4w4W0P9b+DBItD/rB7CEL0gnlRJQ/jn0/xsx+4t0
	 G8EAgm+RTVomPczXIaVEwp8rr3F+DoXg09PujeFG2BG6f4okZpYw59BtDqj+sZptPtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vifZ0tW6YlHOk1VoAEbzAohFZZspXuMyfRt2M6chpUY=;
	b=h0KRKmEXk+rN/u0cchOOzgaIyhVvXDv5DJ3eSOfyMcPAg3JvbiTbw4Arshzh4WMnv8yQ
	 rDsg5LX15iwtIIJzC6BkxiIrbk0evCHHhmv5puf1t0E+cbfR2zmBckIW+atnXg04kI/s/
	 0EGw0fOFT60H4eVLJjoEYipZenNtNMR3OmTEVrkX/65fmIRX+HxS9yUNithCLKsc4hMUo
	 fKgkS/KY3U62Ks3EAikbNtgMh1idTC4inxz4FxisDUhOQ8HxNuG5JclZNTuau6+rzZnuj
	 Cvuk2SVIDbOm9AzVbpz/Jp5z8mi7WVcS/Jg1iyIZeJ9MiEa2h5zr3V/IgLJwEtxMyeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMgDeFjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C35606A31E;
	Wed, 28 Oct 2026 19:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMgDeFjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98FE1F01825;
	Wed, 28 Oct 2026 19:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215832;
	bh=vifZ0tW6YlHOk1VoAEbzAohFZZspXuMyfRt2M6chpUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMgDeFjjUYLArXRrHUuoXeCdmD3svACGP1StEQKIV9p++gL2ZeQUJLGpPgFlB5OPU
	 5BuFkf77h+3fw7z3Wbl9l+qmPx/7jlGxpcqdEj0Wn4Zl1rpz5gaqkCoHkEUBGVawMb
	 5I1X7vyXJqcWMMFbkXnHCCcXPf68Lb/WWztC3mGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1347/1887] Bluetooth: ISO: zero the sockaddr before returning it in getname
Date: Wed, 28 Oct 2026 17:57:23 +0100
Message-ID: <20261028170530.092432579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 884cf2cc957da7ac178a0e6c6c69ddfec0481cc8 ]

iso_sock_getname() fills a struct sockaddr_iso in place and returns its
size without clearing it first, so bytes it does not write are copied to
user space from the kernel stack. The getsockname(2) and getpeername(2)
paths both run through do_getsockname(), which hands getname() an
uninitialized sockaddr_storage on the stack and copies back up to the
number of bytes getname() returns, so the driver has to initialize every
byte it accounts for.

Two ranges are left uninitialized:

  - struct sockaddr_iso is 10 bytes but only 9 are written (family,
    iso_bdaddr, iso_bdaddr_type), leaking the trailing pad byte on every
    call.

  - for a broadcast peer (BIS_LINK or PA_LINK) the returned length grows
    by sizeof(struct sockaddr_iso_bc), but only bc_sid, bc_num_bis and
    bc_bis are filled; bc_bdaddr and bc_bdaddr_type, the first 7 bytes of
    that structure, are never written.

An unprivileged process can open a BTPROTO_ISO socket and reach the pad
leak with getsockname(); the broadcast leak needs an established BIS/PA
connection. l2cap and rfcomm already memset their sockaddr in getname
for the same reason; do the same here.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Fixes: 0a766a0affb5 ("Bluetooth: ISO: Fix getpeername not returning sockaddr_iso_bc fields")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 999ed7df4dfa3..5bf91e702330d 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1080,6 +1080,7 @@ static int iso_sock_getname(struct socket *sock, struct sockaddr *addr,
 
 	BT_DBG("sock %p, sk %p", sock, sk);
 
+	memset(sa, 0, sizeof(struct sockaddr_iso));
 	addr->sa_family = AF_BLUETOOTH;
 
 	if (peer) {
-- 
2.53.0



