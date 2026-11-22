Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318777;
	b=hmQh98Smv4RBJcMfAzTyW0Uzw+WwqvoCT6n5Nrd5L3mxrewLVh5bwWzvknWCYA8nH/qY
	 wzQQq5dBtQydAgfOy7rHBFiE+aHwKefjkYWS7dfqqfIshcoFVctc4UCopZQgNu4Uj7Rxb
	 QBtKRlvFlWufXx53ntds2ZrQolBJFib4FOljVkE7NwOKr4NQJ3oVKYbtt25K1QUEijwei
	 0b2o7IiZuClLxoByJ7YZdCzmUn+W6hqW33gTsy1uW72EnU1dA/Y0pE4U+BgjcN/mlKzlb
	 Zo3eK50GmcolOdeSu3dkb33b6wD1B09wY1axT9ck4BpqM7MtuR4LnZnCUmseqtgKlug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3u7kKCatvm8sfMVYS6PGHsnfCrllDJfTzvdy/+RIMMA=;
	b=3Vn9lyJKMjEvRWq+8UWBzxZUYJPmUb1DfELo9LD79hFYFho2qmQa6q1Bp0U2i207XakX
	 ypnjaZ92XnJp45hEooZ3t3zAta4CbpcsEHEa4Uz/Gj4huwDPF48QOZ59coEtIcZym0+O5
	 2udSm/siKUeu7AjlJ40GA9ILccQbJ9TAKzis+tFFBbEhN9Hcm7wwQx3r46TjCIchON9SZ
	 VQQrSFiv9FJY0BD5UC3X7MvcaIIDK3mX5X472T+mtvw5NIHw0n535kPxkcnMPqiHZcwo8
	 4vI3L9mNUiBQP7FVICVZi7oN6LHb2nwVh5+3nWkyrF9VeE3XWhrt+IYBtgDwvn7pcKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oj4f2PHL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D158E606A68D;
	Sun, 22 Nov 2026 03:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oj4f2PHL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BEE1F000D3;
	Sun, 22 Nov 2026 03:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318777;
	bh=3u7kKCatvm8sfMVYS6PGHsnfCrllDJfTzvdy/+RIMMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oj4f2PHLiFoZO0qIORut0NxngduLHHSAboNLrJNJ/K93Ny/aGG5DEzGG8TP+GFCuU
	 0pysMnqCrXbs3QXG05bHvZm5jr7njW32VpWz86SeD66CP68+vsCqCMQ/GfsGP7khzX
	 /wjnVzm2Y4fgCiJRZkKy5v385JPdJCq3HjXjE5i2KcT5Bq6/bm7cLkENzb6UqdRQiY
	 Qi+AjdemLQsy+cg2ddwtU1DtoH9R3QogM+Pe3TM4S+UsB+Fce+Bwxsbv1JK8SP4i/l
	 KNw+Ik3PQQQBPGIsMxYluURf6ZnJEur7hcdiBsAHGSHgsybT+4XNKnL4GGAFJXNrYg
	 e5ErOs3Olxy+Q==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 0966/2214] batman-adv: tt: send ROAM_ADV on each roamed back client
Date: Sat, 21 Nov 2026 22:39:03 -0500
Message-ID: <2026-11-21-2-daily-reply-0020@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <254e49b8-c3b9-41b8-8692-bd5d9f04f7a4@oracle.com>
References: <254e49b8-c3b9-41b8-8692-bd5d9f04f7a4@oracle.com>
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

> Maybe we should take commit bbfb0d2cf035 ("batman-adv: tt: remove only
> the entry which was looked up from the hash")

bbfb0d2cf035 needs its follow-up 597c0f2f69c0 ("batman-adv: tt: only
queue local del event after successful unlink"), and that one doesn't
apply to any stable tree: batadv_tt_local_remove_now() only exists from
v7.4-rc1. So I haven't queued either of them.

Could someone send stable backports of the two?

-- 
Thanks,
Sasha
