Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EBF37E5EE
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 19:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327515; cv=none; b=hdQevnFdES5Om6skjY8LOwGDjk9aRj5kzsRNHOoAY0uQlGcw8vmNQI+7pYUTV5ouP1QIv2z05OG3D/VY/Q+sZ7GTxBrX6lsDzkG/z47wHMsKRedh6pL6kpAwWh2BcHePpoZw9ue8nWDPyTZVy6xqoIY7Rc1Cfi5UCQ53139pwwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327515; c=relaxed/simple;
	bh=IEHj8+/NBMCpzccJHWJCbgJwrrIvxl98kmy7wm+Anu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qu356qHBidBL5pR5cBqA+z2tK0KuyZnmkrFr5BddJHtMY+KFlhVY+f1WSOARUTiHe7OO8RmEVl1+K4vJr1JbqrmgZFgOFflVYAi1dTbg/p57/VFX2pOd69pvHXw0URNC+2tmcDYWQ1sVpc+oHXD9C9kka9P5OyXH+3sqH3RR9JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2Qy61+G; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2Qy61+G"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b2522so1184749f8f.0
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 12:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789327513; x=1789932313; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IEHj8+/NBMCpzccJHWJCbgJwrrIvxl98kmy7wm+Anu8=;
        b=N2Qy61+GOSt754iiQl6JaoYVHNx4o/PDB/HTGwOYRf7VwIxLXd1U/R8emh1R18kM1R
         I11oAkmOVqvGxsqQ9rlQ90RH2rn4WpKC38CQktJsG9M5U5jOV56x0M44QWeTIxsoVfEk
         Kha/HzP6KoS2uNWksNJjrtuNjO/DRptrRgKv9SzF2EbWoC48piBbjyLknFccQ1Bn3BYq
         A0TwMO9dlDVVcwAx+uzCfSyySjHNTbxyWLf02iZI3jPxZ8ilqiWoVVQCWJYXOXdx4crX
         xYbn1MhJTG/4nzN0hVXjuFmcpTrvfp0HMtdsmCu916C5xwPZO2R8dOaVcr6xdRYQBXgi
         hmlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789327513; x=1789932313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IEHj8+/NBMCpzccJHWJCbgJwrrIvxl98kmy7wm+Anu8=;
        b=N/3irip3Ayx7XBvLRdPAYI+S1Ncn+6ISlrcV/Zbj31WhGw9szSQSKvBu6cFeUoFLwq
         3WDKtnt1lHbKUauVJbDI/yzLFQYPdrZFJ7DaGLVyLEfPKpKEv14ESJjxC5y3E8yea74O
         NAxvB0mYfefJd+HpwkH6biho7hzXqhrpgj050V15FT+4U9SFA9m3EPPU/Nk215IzWjEA
         wYlcQ1MCYLA+Xy/67Hbc4OPMgIc5cXcdcfveGzOnhlLQ6sQVirj54jGc/uXv1vx/Oq9N
         nJPtuT5W+VTjOUGsYe/yQqz4GLjl27HBnxgJNoD136f9bTzH1VFnxwM11qE/zR6dNGIu
         rMSg==
X-Forwarded-Encrypted: i=1; AKwUvBzsgnHxpk00jhVrJrA/Ly0jFd6nJWuUqVMM1eI5eVFDA5pnw0vKH7aZWeULjkDXANSdHmmlo1oC@lists.linux.dev
X-Gm-Message-State: AFuF++l5USqiB8xngi9o5h7O0Xn33VPWkyrt72cNwl7U056p49mT5tVt
	NIJKMDMfpCpcYX/IJrQzAPTQbOQ8k09f22MSBCu4rRPktzKkDurMq6PN
X-Gm-Gg: AYBFou2WeMuhP7ZinlEBDo0rMvwWw1MXhm8AgAkj8AocINosrePW1+ekz3BxeXLgDuR
	9rjofhmjgM3txcFnyjRaGEFNRxImC+ws6DD+L/qUovNtspHXHlKCOHOX+h5DbeHnKV8+1Y6EOyv
	D5hN6JN+d4hfePxGEkwDxjGVKUlMClcTikhdMH+1f1J3/wBUAf9ylSSLcaqYLhQqQxwlFf1amkd
	yQWgBFiD9WZjIVDCnd56MXSAVD1ZSX2bDC80tTBBxM25jLmmr+iPaOqFL+ShAicGQ/htIuKAdGh
	GqKB4tkPXHtYwnrSAamaAMZiXi6eEPfAAIZlKZj3vcOovh0BnOr94GLc0eecoMnY+Vt3//fyHaK
	XkZRTxagj4dbeBYGJNZvbiaaY2kO7XoStGUS+UccUFovM+ZJIJQx0Xm1A1EE3AekWT2J214hsQ9
	df/9svYP9bV3jUgy7kWOGlvFq3m55yE3+BcvvTPR/7RMb67IkrwkECm4Z3XW31KeRHNtrTp3Eu1
	msuauqfzBXM8bEBRtWDIT/JLm16CSp1b0i46u1fdcc/2b3xoKb23TmhF/r9jmcMEBRimbQhIab6
	KcJjKohrIBSIi/ndji/I0CmL0ExIf7XWLARSJ0N8/s/a9BajOAaF1Xqj/hyLp/BmAwHTp4p0fPG
	I5Yo=
X-Received: by 2002:adf:f9d2:0:b0:486:e6a2:2d7c with SMTP id ffacd0b85a97d-486eb31b1ccmr23284644f8f.15.1789327512581;
        Sun, 13 Sep 2026 12:25:12 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0e6-2301-7846-2cfb-35f5-6359.310.pool.telefonica.de. [2a02:3100:a0e6:2301:7846:2cfb:35f5:6359])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb2ed0fbsm21480307f8f.3.2026.09.13.12.25.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 12:25:12 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 1103/1191] net_sched: act_skbmod: use RCU in tcf_skbmod_dump()
Date: Sun, 13 Sep 2026 21:25:07 +0200
Message-Id: <20260913192508.2469-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065612.927930999@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org> <20260912065612.927930999@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless a 6.1 backport of upstream commit
3016024d7514 ("net_sched: add back BH safety to tcf_lock") can also be
included.

This patch replaces spin_lock_bh() with spin_lock() in
tcf_skbmod_init(). A rate estimator can take the same lock from timer
softirq context, so the timer can interrupt action replacement while it
holds the lock and deadlock on it.

I reproduced this on 6.1.188-rc1 in QEMU with lockdep: after the estimator
timer ran, replacing an indexed skbmod action reported inconsistent softirq
locking on tcfa_lock between est_timer() and tcf_skbmod_init().

With only the skbmod hunk from 3016024d7514 applied, restoring
spin_lock_bh()/spin_unlock_bh(), the same test produced no lockdep
warning.

Thanks,
Karl
