Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590935;
	b=NWJo48+YRL1Fvy99p5sprxALEgLX9kBqEPk3RbVDWaORONuVCA6Ve3q89G0oYHQ/YI8Q
	 4r39TZvC2bTKzpHtmny21Snay+AZB4leFyPd+BGRa4DRxtKzg73v1sDeCcdReAE1GODo5
	 FO5/VCB9LuSANphY6Cx5Xfbcgqm/ZF4PAAly2TI28KqPjZRtFcaxaRWQTEuFZ9UL8uhnW
	 /X3wZehA3XmkarubN+wOsJk0ULQ5LcPFqhmsT5CE6veQ7FHbSSodYwMY650k8Bfj/OvBd
	 kVyMajzkZddzXKJCM/IwdLq+N22o28txK3m2uoHAyvFNND5XU+2bvic+0p4KeagTMlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U1kLI874/Agui6veYG4RVXaCOFn5vDOA/f+uaQ6AayI=;
	b=gIEHGzsAf+lXkG9IW7aXRXQbfcEc7vioYYLZy9zbTVHwl8XuhCMVfAkxHBwye93HSeh2
	 90Cp1ak8B8Ua2AwoFouM3GZVJKH8tuajrIP8TsCx3Ine9CepzGgm+pFM2SQZDATIlNa82
	 gTvxHi3Edi8NRlximigIO4y4XvU5c1k0Zww5DsPy1eL6Qn6lYsqvr7DWyALKjCg8iPS7e
	 83Y8ESMoZGYPNIfhp0SGir+Ek5688x712Y5nl+ZZxQbPBugQx23IpGLu2/IWumcjKxCrL
	 ZylyJXg8F7WsLzHWcjZCNR0TLZkQ4/EhQmBe7BqfHYOdIgkxeVg9DJjNxo6mEVyje2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="h63vhox/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F98606B448;
	Fri, 13 Nov 2026 17:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h63vhox/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B331F000C4;
	Fri, 13 Nov 2026 17:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590935;
	bh=U1kLI874/Agui6veYG4RVXaCOFn5vDOA/f+uaQ6AayI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h63vhox/oX4OXGHgaCdbWtoTaQZNSFTNfxvfq9GUc1K75Sam65MwXR69vyVAx/sJg
	 cyRH2JMkcC8DlNcnZj9gk22wCGEoZc1jJ35c9j3IqMyI//KmxO56KnqgPuvVNP6MkL
	 GR8qY25g7bD066xVP3aKf7ETQdGNEHwF0TMESU74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/670] ax25: make 16 the smallest maximum_packet_length of a port
Date: Fri, 13 Nov 2026 10:44:44 -0500
Message-ID: <20261113153815.882849894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

The per-port maximum_packet_length sysctl accepts values from 1, while
ax25_output() refuses a paclen below 16 with a WARN_ON_ONCE() and drops
the frame. A port set below 16 thus loses every frame sent with the
port's paclen: IP in virtual circuit mode, and connections whose
socket kept the default. AX25_PACLEN in setsockopt() and the
SIOCAX25CTLCON ioctl already refuse values below 16.

Raise the lower bound of the sysctl to 16.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, ax0 on mkiss,
IP in virtual circuit mode to a static ARP entry):

  before: writing 10 is accepted, and the IP datagrams then sent give
          WARNING at ax25_output+0x6d4 and are dropped
  after:  writing 10 gives -EINVAL and the value stays 256, writing 16
          is accepted, and no warning

Fixes: f47b7257c736 ("[AX25] ax25_out: check skb for NULL in ax25_kick()")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 770beece44057f30cc873f72db809b4091c72916)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/sysctl_net_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/sysctl_net_ax25.c b/net/ax25/sysctl_net_ax25.c
index 68753aa303341..41a83e3a7e558 100644
--- a/net/ax25/sysctl_net_ax25.c
+++ b/net/ax25/sysctl_net_ax25.c
@@ -20,7 +20,7 @@ static int min_t2[] = {1},		max_t2[] = {20000};
 static int min_t3[1],			max_t3[] = {3600000};
 static int min_idle[1],			max_idle[] = {65535000};
 static int min_n2[] = {1},		max_n2[] = {31};
-static int min_paclen[] = {1},		max_paclen[] = {512};
+static int min_paclen[] = {16},		max_paclen[] = {512};
 static int min_proto[1],		max_proto[] = { AX25_PROTO_MAX };
 #ifdef CONFIG_AX25_DAMA_SLAVE
 static int min_ds_timeout[1],		max_ds_timeout[] = {65535000};
-- 
2.53.0



