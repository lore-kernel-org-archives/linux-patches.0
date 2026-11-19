Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058692;
	b=5ACzxj4aBRm0yUYIxy+MsrtUI2fgaVcXCjs6JiTArE1P6Q2qCoG8UW9X/u8T0KR5dKSB
	 wJCcK0J5scanyWI6+/598s5dPMwJSeAImvz3G7FBUmTSy3emTtYRLVXyHRvsrfyJ4VJ9U
	 XTHgKiS6kP9NMLnmKK0scjhXl/I4dLpPdwKmu1lMKd7xlARz4Rhai9rI7oYzTw/HqdN7x
	 hen3ZYqBB3t0vA0QStBfllUX86Xuu083RPAM/cZ/W2XX3y0TIVo0qZsSNHcV5SLTbwR+f
	 MTQgT7aSiEvYos8J5Nz8f1bOmVRTAMPxOGtCrbdnhKs7uvmpGrff0qu2qCVAAtlOAiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058692;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=SqARUBr9hLQLgSL2pE61prXhXyEKNkMCJtddnrzAKJ0=;
	b=V0iB1kwgmlhM3AZaY0qa4Hz8IyTUWPXNfYGZBl45HDmlBlahzH14zzA7MJCik4B4lCUo
	 dF4iEap/xt7al4UKiuj+yAiu68yP5+6srB7zk3AP5+92tVIYs7WQQ6kDGd487DcaET03v
	 zkpPZ54DwVXkL1FJo8GOm7P5aZ4j8BAdL0wk76ObSKLA5vpPhb05Epf9AUZ6/zy1uTjmH
	 YbT4RybVY7FReHmN6D67l1THZUtYwm5Kz8A8vQOCNchxcTnI5oR6ll5BWN1t9lqMVr9jB
	 lELawWk33yLU6E7asLoJw8s6tikuTETpg8SBbl1hQP4ibu763raZNOWuba4z4t3SWrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=pm.me;
	spf=pass smtp.mailfrom=pm.me;
	dkim=pass header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b="Nrx/f87i";
	arc=none smtp.remote-ip=185.70.43.101
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435AF606A31C
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 03:24:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 435AF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.a=rsa-sha256 header.s=protonmail3 header.b=Nrx/f87i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1795058689; x=1795317889;
	bh=SqARUBr9hLQLgSL2pE61prXhXyEKNkMCJtddnrzAKJ0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Nrx/f87iDo1wQZVJ77TSgcbKB+Osw0UTF4XK/p5Lo7ylk3U+SeUYsaVApvHQLcnd5
	 idfmCkqNaEYjc/uyL2v/OuEI8RnF5iNOrk2DYE92qr9jWxPUL1IFpDXfwW4hA7HWdr
	 tXgO+6bFx5SWZvv6RbI95Q9L1olXZ+UidZXHcuIwE+DuW9fmt+x+jyiVyMTEVDlWud
	 Brs/2dp6UZQlie7KnC+uINizeXrHEO2r6hN7PMXLe0NQNmnYOC1y3Xq17JAQdKG4AR
	 Iq7dRPXB8FGat6PDASItcxY5oDiztQ5S/EtDGQ1m17nJlPcTwC9POX+zHupR7GAtu2
	 wWqUbIA3IBBJw==
Date: Thu, 19 Nov 2026 03:24:44 +0000
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Sergey Lebedev <lsa.uz@pm.me>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Yichong Chen <chenyichong@uniontech.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 1120/2651] debugfs: make debugfs_create_str() read-only
Message-ID: <20261119032437.37062-1-lsa.uz@pm.me>
Feedback-ID: 113843758:user:proton
X-Pm-Message-ID: 8af8912c24a1f531c684de7242b1c33795e263cb
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Greg,

This is 3/3 of a series, and the two before it are not queued:

  493daf5bf2b9 ("interconnect: debugfs: replace writable string helper")
  98421ba5925f ("soundwire: debugfs: replace writable string helper")

Without them, drivers/soundwire/debugfs.c and
drivers/interconnect/debugfs-client.c still pass write permission to
debugfs_create_str(), so the new check warns and the files are not
created. On a Surface Pro 11 (Lunar Lake, SoundWire), 7.3.6-rc1 warns
twice at boot:

  debugfs_create_str() does not support writable files
  WARNING: fs/debugfs/file.c:1078 at debugfs_create_str+0x57/0x80
   sdw_slave_debugfs_init+0x18a/0x1d0 [soundwire_bus]

6.18.65-rc1 (0934/2151) and 6.12.119-rc1 (0740/1756) queue the same
patch, and both trees have the same two callers. 6.6.163-rc1 (2497/3318)
queues it too; there only the interconnect callers remain. Please take
the conversions first, or drop this one.

Sergey

