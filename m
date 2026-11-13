Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590099;
	b=CNC7dRaWWynL27eCmLrOVZ1Tg0V944xgtJ8rhdBIu1exE5R8oqWO0ZfZ5D0B4WNejaCc
	 b+9fpqiigvf8U/mB1RewC7DYQNXiN9LBXuvKfYuEj+QVMtNMNmZAKaC6UpoOEYbGRMwOW
	 btR1h9yqiHSt+8e42/aOt5FedhMgwrCD6pKcqphX+LHUhFUfG9Gg6GYLjcnxfe9S7Oqia
	 AqCB/XmnRgWAsuFENZ6RjMukKqvdLrw+eBtOeRl41QISjO3V7BPAaHmd3RdOwwfl/HmJx
	 Z76atjQ12PodpDkb0cH9eihlLY+daAZoLl0KOXzAFg5U1pYEkD9D5stazLPemHt3rYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0S1+52WuLQqbCVBTgKvVptfohZN4+oHNSOJi/ADFFBU=;
	b=N75Dy6QxmmWPwtQZEja4cPyN7TLdysXIhsxFXiLgsiM2byJ2ao6xJC25uTdUJkC4ZUpq
	 zEGY2k5cNFlk0E3bJV3euyvCrqaCMbB3Hgr81npxkHqF5gAi3tVkVNGeSUFEayMqHNrf8
	 dh42zG55R7SZEPjb+zF7MiTO2/d2YcqgzPClbbLliW22OpotL5FS+o+5N8OETCMSUR3V/
	 sU0zLWDpof1HyC6zqV4qa2UElFcsHUjs6sgf5itPr8umXs7aDk5v5uA9Kh/bpRSa0Vmuz
	 2gDFlz+c9qOKs8b0ERBeqceq4V8SldLDYc+HOtGrvkLIzS4XnEdbrf5z3LYrxAipXwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tsCdkTx/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95265606C0B9;
	Fri, 13 Nov 2026 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tsCdkTx/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1001F000C5;
	Fri, 13 Nov 2026 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590099;
	bh=0S1+52WuLQqbCVBTgKvVptfohZN4+oHNSOJi/ADFFBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tsCdkTx/G8rYF5N5VSrLu9vUriLsh24N+ocz6xit5sszKNFr8/hz5vrP7YMk1CqmI
	 BaC/Xrm5DtuyvgQ4+HaiKj+HQ2ZIHLyuAdXBRK0Mhml+6/MlVIyzGD2Zhi6uK+fkij
	 M7uvaevP7nUWABlUAB1fWtKv5OBfUxS2pYEyUOQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/686] ax25: make 16 the smallest maximum_packet_length of a port
Date: Fri, 13 Nov 2026 10:44:16 -0500
Message-ID: <20261113153824.993188645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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



