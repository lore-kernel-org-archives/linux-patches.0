Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795104532;
	b=cfXQAaWrwFV/XQYirQXrWXnjjxHFhN+GvD/DESh7r5D3p/UjmlaUg20Zey9lN3LioD5g
	 qO3yjjVNQgXtDNVJ0MGW5FsT8QKdI4ryhkHenXOQTb8UKiWoExKHVh+ZH1JwfZXSu7dO/
	 dp7O0VQSSXUo06z043cFCZw2k4yQ72sm3xag0g9XTnzAHcPNob+RR/3/5eVTXcEWtd+Mj
	 lc7cAeIwP/6euNUENbsWRP5f9RTepMx7YEs9NdHtQFZR0M3BNgBoHvzJqwwJ3FTxK4ANO
	 OXVHExsB0L8x4eW32zb5tHPzwe5iqRD3lvfqc5ZERoVRV1zuP4uQGVAswg/kFAeFFuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795104532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=k0WC7e4wPNkzIKZpd9PM9ryuIzRDi8P8kUXWxiMsJh8=;
	b=uxp1Qaf9LR36hzW3njAOaW7ZtrWaWkvk8JVwBcRRpIcRg81bl2eNKWHm2j94x7oMu1EK
	 yvoW0lIBAIeb41/i2zwBn0SqJJlOWS9hO8NW9HrQb80kIcN5FE0k13cjXje9BAGPI9BwA
	 D5iqWoUOV2pBd7DTKVyMR1CNrxeAFuGrw8+CYDVdp8Ix+pIvwf1xIcuZSH/gTgpoB8rEH
	 4L9pIcwz+y/f4dR2RqzKoasOuvevHjwzs4d0gbz4yRP89tSky70Pz3iXKQnLDyjqXMk76
	 fqMeLjPQ1J9AfCe8CBhtife7rhEyCATpof0Q4VZLxB5v16hinjAgu5jbaKLGiYKZoxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ve7XG6db;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C88606A334;
	Thu, 19 Nov 2026 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ve7XG6db
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B871F000C4;
	Thu, 19 Nov 2026 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795104532;
	bh=k0WC7e4wPNkzIKZpd9PM9ryuIzRDi8P8kUXWxiMsJh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ve7XG6db4R63CvxjZvxQAsKpvZWzzAm0w6wJiYIbwTKNSTTAw6cTGyhW4yAqxJBw4
	 4DU/l+8SCX1pVwt/K1rWBvTHEpO+Hww4VyykBxHPhNNkOrnbRx7rUaaH0NnTcBoHlu
	 5Jgd/+/NFu7SOS4HWpKo8uG3D4H6Q+MBmGayDZk7+wWqRMcVF8RyAp/SVhIiw/jzU2
	 ADfF7OloRHjv0CkiV18XmAzMQ72k4haOIaQ+iVHqIijxM4/uwkBYtT0u/xB7p4ntit
	 aNUbUtUxwrLUuC3/jyrgFQwWqUqmskIAT7deuv5z6Ddu470sG5kFiTbQFzr03j+fNz
	 bWKjIpr72LSZg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Yilin Chen <1479826151@qq.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 7.3 0949/2651] rust: configfs: require thread-safe callback data
Date: Thu, 19 Nov 2026 11:08:19 -0500
Message-ID: <2026-11-19-1-daily-reply-0017@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9c8d1253-ca72-4adb-a324-8dc86c8b6e9f@kernel.org>
References: <9c8d1253-ca72-4adb-a324-8dc86c8b6e9f@kernel.org>
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

> > This errors out too:
> [ 494s] error[E0277]: `UnsafeCell<MaybeUninit<blk_mq_tag_set>>` cannot be shared between threads safely

Queued the missing prerequisite for 7.3 and 6.18, thanks.

-- 
Thanks,
Sasha
