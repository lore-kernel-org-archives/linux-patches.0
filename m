Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022536;
	b=OKNgiC+33nVUFqu4C52hgoZLgJvyXTS02gBDlSxnqFlFmG7OZ0EfAVBXGUyKbe5pipIi
	 uXEF5YdtiT9yRCA30N+OvnFhi/E3LNSIoGKZVL2r25f5N+9F+nMjh7VooukJjQWv8hrre
	 2bPAEPrurJ2MNYwMqZts4vS9i/KA0BwORGJjNSLf4b3LvjhpME633ZH/0x/M272qpSCCf
	 A/usjtRHmC7ftC1L89vQKJV04ELktIYbTILYjZHC0P5DQZUmXn6/08ex1sgwoDt9Q8leI
	 Kqe2p9SALelkFZ3Vxkb3ZfnUw0kPkOuapUjXqJkQued6dYtVQNO/kYynR220hT0wGdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=e2bPGi9P5kNWHnwjVT/GXi8HoEDfGhcHneatYeOEVm4=;
	b=mQr+gZUm0eXoffV7ql83GK2yObT63/uBMkkhocTF9aai56EBrjBgYbgzpVKIsnkZ/rw1
	 1sSEfw5CTwX+ngUspyoO9J25iVe6b7GHeHhzuuqarEv/D9QToMjsnoxv8FdH7sJvkq+g3
	 T22E2wx810S5WeZcTfXAojWMZfhGxPBbmhQYEV71hCIN74Kz2cuDP3kTd3VOALYeKNbzZ
	 J33iFGhxPT2S3CgVQaae/LwUfZ2CnANNSbO0+IcWRB7mg6s7HBUi5pf3Szy36tmKtqR7z
	 YOnjeHINIGIC2nN1L9JE5dMd+bzQEi6aJMqbR3lqZyHfOLZBeKJs44aih65vi7CosWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFXvRDC2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCB260A2612;
	Wed, 18 Nov 2026 17:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFXvRDC2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6511F000C7;
	Wed, 18 Nov 2026 17:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022536;
	bh=e2bPGi9P5kNWHnwjVT/GXi8HoEDfGhcHneatYeOEVm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFXvRDC2N2bLBFLOLLzI9iWmxN7aayIuq04iJ8RdZQwYviZHUE39ts9Z6IU/v3j6i
	 3oxB/S5xDU/q+I26SPBdmJ4IWgJm2a1UtE9Ni6aWsVxSA4leE2SXtzVfaQYapzUwFX
	 ysUQ2ofNHNEFcnf0Mkf7og4202KAVtA19OCBVJL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ciro Pedrini <ciro.pedrini@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0046/2151] platform/x86: hp-wmi: Add OMEN board 8A17 thermal profile support
Date: Wed, 18 Nov 2026 15:29:41 +0100
Message-ID: <20261118150123.395419478@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ciro Pedrini <ciro.pedrini@gmail.com>

[ Upstream commit d35a1ea827a2efaea7fb059ffafefae7c13b9556 ]

The HP OMEN 17-ck1xxx (board 8A17) isn't in omen_thermal_profile_boards,
so hp-wmi uses the generic thermal profile query. The firmware only
stores that value and never acts on it, so the EC stays in its default
mode and the CPU is held at 45 W whatever profile is selected.

The board uses the OMEN interface (mode byte at EC 0x95, thermal policy
v1) and also needs the timed profile quirk: without it, the EC drops
back to the default mode about two minutes after each profile change.

Add 8A17 to omen_thermal_profile_boards and
omen_timed_thermal_profile_boards.

With this, all three profiles work and sustained package power under
load goes from 45 W to 56-79 W.

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Ciro Pedrini <ciro.pedrini@gmail.com>
Link: https://patch.msgid.link/20260925205226.883724-1-ciro.pedrini@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ sashal: adjusted board-list context to account for missing 8A18 and 8A43 entries ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 9a9ff35c3b954..71b246378d39f 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -131,7 +131,7 @@ static const char * const omen_thermal_profile_boards[] = {
 	"886B", "886C", "88C8", "88CB", "88D1", "88D2", "88F4", "88F5", "88F6",
 	"88F7", "88FD", "88FE", "88FF",
 	"8900", "8901", "8902", "8912", "8917", "8918", "8949", "894A", "89EB",
-	"8A15", "8A42",
+	"8A15", "8A17", "8A42",
 	"8BAD",
 };
 
@@ -149,7 +149,7 @@ static const char * const omen_thermal_profile_force_v0_boards[] = {
  * "balanced" when reaching zero.
  */
 static const char * const omen_timed_thermal_profile_boards[] = {
-	"8A15", "8A42",
+	"8A15", "8A17", "8A42",
 	"8BAD",
 };
 
-- 
2.53.0



