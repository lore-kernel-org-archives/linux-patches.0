Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104528;
	b=p0eaNMbYqX44qmJzo91Uccv5PDbnJ5CxODGTSMWZZklCWY1Jz6acJWXu5U9VppfEFT1+
	 WHXgrfYHNwsoJXB5shlOBqkkNi9/knvJozu0OJ9iS0QUX/Tz08a7g62heR7mKAX1gtfUT
	 ffrDRaM/SkJCCAerGE6o5z2beML3oHS+mlTFtSVC97B7RmcWl5Xs96xQCSSnJnuX0WYAh
	 11hZ17FdeTLkrXp2tRC0mFozAL0RmYrikPChxRh1Ekt1RGHoK46LfTNILuEwZewupLGtw
	 TKR0Z8NedTOv6qUrbWZKyhYi7GrC0Cdqey8e4U0BuIzVEDjNZqVOZhHkA8Q9+kgCt0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104528;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JzFlm7M/N8S3VQkbWRiFsuO9fPloCbcwOMIXArfrE/g=;
	b=aw+4Jy3XCpvEbnJCTZCDDSog+4qUOneeIoQG1ZryhOXUIYCSM8H2uH2gk3mTx68uMjZR
	 x5QqhocobZ4VjoRxnCzCsYftaICNYdBK1DIGn13WkAJ5BVSeHOabukFNnxpEDw4EYtsSF
	 +MdsW4kbwE2T2GAJFrP9JubLe9Nsyl/C4277OAw4WZVaW5ytwhTqvHJt8R765GC4Xv49K
	 KkQ3FwKjoU2A3w1uBtQ2aDX4EuMnfcj/4qNMBXJILIdRlRklQTGksLdGJ58Msyt76/VvQ
	 Hh2Q+QB2D4LWqkfoPYKIZvB67hCSEMgwEvtFPebLcBL2Qb4gHxAI4PxjY4X6e01d9HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdkjdy+y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03B5606A326;
	Thu, 19 Nov 2026 16:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kdkjdy+y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C841F000CA;
	Thu, 19 Nov 2026 16:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104527;
	bh=JzFlm7M/N8S3VQkbWRiFsuO9fPloCbcwOMIXArfrE/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdkjdy+yg7U24YYn20ETTm/vG8R0CwNkT0+1VZCz3fiNV7xVQZIduuqf2iWrh6CjC
	 fo9gTzWV20pJ+k3lJgGVq30rpVtM8I7SEm7cmKSF4PnYPEPwfjPAGlyutoEKQmw9kQ
	 +TVbcH5DzZj68JXiLg8EuJztnCZ8UkkVCuC1T+FyyqrW2/T2EtD1b0MBhhjCTYWwDQ
	 /ugYV7X3KY0MigPPsahIWXQzzPLTXX7Hx8SQ4yjH8tIFY6GD+Teo545YFDFg3bVhG4
	 3ftzAyaP5IUcSfuc57cICeqxA2ZG6Xmgui91/w6bT1bwyPca0CQ9Mue2YZrRggIgNe
	 8SZ14zAzwJIsQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Sergey Lebedev <lsa.uz@pm.me>
Subject: Re: [PATCH 7.3 1120/2651] debugfs: make debugfs_create_str() read-only
Date: Thu, 19 Nov 2026 11:08:15 -0500
Message-ID: <2026-11-19-1-daily-reply-0013@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261119032437.37062-1-lsa.uz@pm.me>
References: <20261119032437.37062-1-lsa.uz@pm.me>
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

> This is 3/3 of a series, and the two before it are not queued:
>
>   493daf5bf2b9 ("interconnect: debugfs: replace writable string helper")
>   98421ba5925f ("soundwire: debugfs: replace writable string helper")

Queued the soundwire conversion for 7.3 and 6.18.

493daf5bf2b9 ("interconnect: debugfs: replace writable string helper") is not
needed: drivers/interconnect/debugfs-client.c is compiled out (#undef
INTERCONNECT_ALLOW_WRITE_DEBUGFS) on 7.3, 6.18, 6.12 and 6.6, so it does not
warn there.

-- 
Thanks,
Sasha
