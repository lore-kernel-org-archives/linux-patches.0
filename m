Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7F447ACD4
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 20:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789244395; cv=none; b=IuZMcnp2SEpqbNj+Snh2UbOZpxs/w8bCWx4JEz/2Dr3aWdN73jaXeXjmnDYSCzFD/9n93uFV8Mn3A29M15skT5EUDwj+4AEVq1n8Mk+ityvmQ1K4aDACLlwmb+ac/P4//xJeOekqHb/JbojkTe6kOKL10l/258jWJ+SMKrAt2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789244395; c=relaxed/simple;
	bh=txURU+K8mrxI98s4PbzewGVHcFWr+Th149VPC2FxOHw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sz5V8wbnC9odYJcE8wbifvX9lfSSKkPzhhwXACYwrLiSsArjgCUNw7PR6mNV09790NxzIizAe1JYR4s+Z57i0ODWGmCxjVaLCUbfcR0T1uxQKRnABCEwX06kK4KYDsnqu6XAxvVlMT2tJ97hBP7yjBG3rLyBChUsefeuW9wjErQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OkIF1vvm; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OkIF1vvm"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49e6e69d528so6470885e9.2
        for <patches@lists.linux.dev>; Sat, 12 Sep 2026 13:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789244391; x=1789849191; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=txURU+K8mrxI98s4PbzewGVHcFWr+Th149VPC2FxOHw=;
        b=OkIF1vvmHED7Bxvu2B4ds3b/uiCkXRQSsXxxqK0BE4HH0nCYjUFhBH5gYrDPaX4olK
         RvJV83o+mZdIOyuo2gGBa9/6JeMUdmGNbYgSTwKr1lxp8bKyHEMVxsM71tnuSU5H/K5V
         fo2BG99LKpIitOzPNwc4vmY6l+hJHYDhrEsdwqxJMQg81GNhKTkxNyLa33Nsoqdg03zN
         fNOUx5AP36CAr0ewy5HzC1jWqC/rdRQYdTesctiQ4BdREkPuWCXeknmtT8EUtZSdq8fw
         IzuI0hAc46Zxex+Iv6kh5v3uDUW535XD6qyhZsimfnDdZCwOJb/pkCgpbn/GJ+/1Qg7N
         TKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789244391; x=1789849191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=txURU+K8mrxI98s4PbzewGVHcFWr+Th149VPC2FxOHw=;
        b=jZ6ECaRBtoX8TKmlPbk8aMt28EkLo1c69LW1Lpdi4Tv3q7eueTqCSWPOeB7AjLy9O6
         csvi7TJ+tqaxMqA+/5LTAtLo5FJO1uryZHIuoR4fyylc1WaqlRLU2laO5a92R8PvN/Wv
         J8a93CnKwx8Ak5JB6gRvwHGlpWcOizJWFFvWwRjcsN+SIrJCQJKg2Ch94XUtSHyAo7Er
         xLbbW7r4lwO5b+olyZKg4I6QAUIuZ0+f2k+fdLa6aXjvDDD58nKimqFwC3U5k1qHvPKZ
         PVwqGBXtMnAF/vx/x0p23BnZxSBCwcunhbKTAN4+OFyGy67TwRIzaU8IVBP4S7mhbQyl
         3XMQ==
X-Forwarded-Encrypted: i=1; AKwUvBzq9k2lYiKIhBkEQLIGQxKYCG7PYNGr5kim9Yg7sRGzKfrqnu81+ZiWDJcRxZj7Zy6BkligB+IW@lists.linux.dev
X-Gm-Message-State: AFuF++m2tgJiZum8YosUVZnCL+0IDKBnfGx8ylKxNhoqbpoTySiVduzh
	IMofkEpHcao78i++RXmTINwy/C7nV9caoAU0U9RbEK9bTM7C904cdkWcALEpAMne
X-Gm-Gg: AYBFou1xxWDts2pV1RTxiPBbIthQm/IqNh/uldU4ffORudgzOrQYvrB5QDhuqDOrZ/s
	16uVt0BbY6AfVEdFpLmk5JQNSsxKye15xrMaZYoJYHjEs+neQbR1MvR+KOi3ifbFkf5AzOd+h5y
	nw6eitUUmpGZJyo4Qr1SlCIBTaK3mbfpzKnTB7mqdGY9ZOBPQVPbtpoMftruBxw+zmJU8GOuSY/
	WoptvnA1XPmeCHeSKvMoZAD/E7P8S2kfnvjrW5eHVY7qXb7BB9/8l2azFv/cbbFHgWluCZcJ07Z
	aDKXi4pek6EsPtcEa65QWPm5+ncVi1QTwwaRfjPFjA9pOpQjYy5XcRbgZkP69ZFWanjKxS3uHuK
	WCKQyj9FoeUQTE4LtAVTi35umF0PPxUGLiCKxS9yM3Nv6QvhmLRiGhIXfjIiuLE6WXCE2czCcWL
	vwX1p7TAXn909NHJL7L0tRigJpdR4Hg26DI85MKo6gABUYCRtQA+cLuiEpaqSxcw44D/bEDC+kL
	rF0iHSzfW8Jaha6bxzelxtYXnEyap6afdDOSG0B2bKRS39qr8voN5sLP4+lTN6qFpwATYHdeYcW
	Sj0BwuoiURp+yqAf+CaAhk+BXoGjOl2CVniKYznPNxo8RmvKXtkPpOxo+SQZR7SO2CDB5PJyE57
	k8hpXFns=
X-Received: by 2002:a05:600c:8b41:b0:49b:d45:703e with SMTP id 5b1f17b1804b1-49e6198865dmr131747885e9.8.1789244391211;
        Sat, 12 Sep 2026 13:19:51 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b260-f201-9983-e8c4-aff5-7a36.310.pool.telefonica.de. [2a02:3100:b260:f201:9983:e8c4:aff5:7a36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e61a81943sm119571285e9.1.2026.09.12.13.19.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Sep 2026 13:19:50 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	tianshuo han <hantianshuo233@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 836/935] ksmbd: limit repeated connections from clients with the same IP
Date: Sat, 12 Sep 2026 22:19:46 +0200
Message-Id: <20260912201946.77500-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260912065545.998510042@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org> <20260912065545.998510042@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Please hold this patch unless a 5.15 backport of upstream commit
98a5fd31cbf7 ("ksmbd: close accepted socket when per-IP limit rejects
connection") can also be included.

The new -EAGAIN path continues after kernel_accept() without releasing
client_sk.

I reproduced this on 5.15.221-rc1 in QEMU: with one connection
held open, five rejected connections from the same address left five
server-side port-445 sockets in CLOSE_WAIT and raised "sockets: used" from
4 to 9.

With only the applicable 98a5fd31cbf7 hunk applied, the same test
left no sockets in CLOSE_WAIT and the used count stayed at 4.

Thanks,
Karl
