Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD3F478E25
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228213; cv=none; b=T9NnyzC6Pql8mvm5XIDdPICdsot5lOxO7ULqaTolH/qd0CSvKLtTMs1/iC67QooRV4FTpGMXobx/PylPYlOUOpCl3dc/WDs/+Fs0MuoYvGcSsAAZUMNigWNwLWRtoRX5eNywODk+8m99u7eR5/zbIOz/hBzHDF0C3BAFYHgBMhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228213; c=relaxed/simple;
	bh=Lfsv9Jwo/NzR90UQ1GpGURPwlmgOG/eX7X5dgvB+LHg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EME0KHpMESyPDoHRiwoZZHQwyt4xPj9snPCVosUe79rlU0at9bRzPPIPCQ91IvCNMGHkeB9+4ODWnW0mNpy1W6ju1Dtj9PDrjcblZpqZgNK0JLy1aXYh9SEora6hnKmig6y6alRGmbD8EtZbcVL+4mKmCb0OMG8LRuih2uyGK1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Suhp7qUU; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Suhp7qUU"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7355e411so2219845e9.1
        for <patches@lists.linux.dev>; Sat, 12 Sep 2026 08:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789228211; x=1789833011; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1u4A7LzZi2E3L85+KAE+JWL0cNDqMgSzTA0AyhQoIvU=;
        b=Suhp7qUUlDEFNX3CdjEIbS/MiWQUh6NF9vGZwSxicgzius7I5gg4tGxtpGKlr95Q94
         RQQuK/RJhtneVIusqjaZL0bQ6YdG6w7ogWujWUvN3RkLo4aQFkZwA25vtV47IYhr88RE
         7N3BWZBeEVky2SZX0n5HxAWHMyOyQ3Y2ZdP/TyY2dLbMmE0Le0XZtHqdAZcyap8cs3MO
         alPsqtkAhE6tBdhr6C+rkA/JHH+KYK3KtIScVXJ2pOIOonlbkNmKT+5lltRZHGTz5kLg
         288yd/D3f6udXsonwM2hpLbSYjo4VFSJzFRU6gllnApXHGNVWOu7gDj0/wFvub6+A9v/
         /rMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789228211; x=1789833011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1u4A7LzZi2E3L85+KAE+JWL0cNDqMgSzTA0AyhQoIvU=;
        b=aqmVvRBejf/RHMLU3wFAFXwK2bqZ24JI8kp8SEqPDJ5/OwV3aK++fHk8wO0x+jp9nW
         7rplicCjvJXKmPCjsfNxDJmbFtmr6Z08V3MBzCuDP2Ky4kBpy2cT/gRPAeyK191/wjFg
         tCLJ2tMzPxSU6xXCdSi3v4OxQ5s+xm/R6v2h4d9kzRcXpyTHn17hjyfdZNHg7e6PBJnB
         X9wS5ipVBlsoUxBzfZiJns716tBAk2XZa2VOacq9yftIusqGBcKDBdlnLzte3v1qY6mR
         GjYpuRwYJPwWqescJjbvOFejsVsxevH8skcLZBAADyW10aziHaWMkWReWRuZLWw/6Bhd
         7GRQ==
X-Gm-Message-State: AFuF++m5OfWiMgQzSsOOfSiKiKMvf9cvMbge+PwGZOE4M+5KvtjvtLjZ
	K63+c6Rz9YylyXltqBgRd3+LKWXiRG7xTui/Bkvm8vToAaa7HWyys2HW
X-Gm-Gg: AYBFou2Iv4CVWdXxk+ZyUavpYbNJ0PO9sWVULdxXZo6YIQI+qusZiJKHr803r/Th3Sw
	002kxMOHSqubK0kmjjREcvmGp33N96TcS6IEIrjtaGUQmqckZ7uzmaTFV296WWIgY3IXdP8jNsT
	ORdg/TZHMp/He2PSmxmkYWXJabM3mufIrru/Z24UeY1j1vNSYKzqj3XNpMjlkX9ck+wib/6LusQ
	mfSjDmo8XmpRHUSQkci9ejig1dKvqwpyZ6syx/su33zQeH2B/aTELr9PU21lS+ZdHCbcD+PNmA0
	yz8UCSkZm8cQ7st2JjtBJoOPS1uBFPnHpsWRZBgF0QRQns64Wp0+y9aAXe6igZ+W1TXeb41bTSh
	YAuHJbzxy88X/vuiR5zzCRzQZ9IFNZd0AABSAVkf4bJ8VP7+M+k8oM0DbUNXGI3Je2mphWMBRjb
	HovsMLVyNgOp4cocsp/nNHKjawZxgcuNah7I8WnLCTgk+mEINp0N4C+j8yATFVg+KtaBOBDylq7
	8LwyMD7/y2reUuYz44fnsOyz7yjs+jQy1fReHzTsJvHdY/1d637MjC5dtjQkEg9mSmPAePCZZTK
	fi8hkl2LJODXqxO1FSUcdnUnA40Jt0Af7vSxno9H/K7bTY/FhKVXfBZm35mNzo2g5Gqm0BqIJxT
	aUw==
X-Received: by 2002:a05:600c:c178:b0:49c:f512:2361 with SMTP id 5b1f17b1804b1-49e61a15c31mr205481115e9.14.1789228210445;
        Sat, 12 Sep 2026 08:50:10 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b260-f201-9983-e8c4-aff5-7a36.310.pool.telefonica.de. [2a02:3100:b260:f201:9983:e8c4:aff5:7a36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33fd3bsm13682386f8f.19.2026.09.12.08.50.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 12 Sep 2026 08:50:10 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	"Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
	"Russell King" <rmk+kernel@armlinux.org.uk>,
	"Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 7.2 1107/1815] ARM: 9483/1: select HAVE_POSIX_CPU_TIMERS_TASK_WORK
Date: Sat, 12 Sep 2026 17:50:03 +0200
Message-Id: <20260912155003.96209-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <d6e2ea6a-0297-41ec-bdbd-ae06b5e2f952@app.fastmail.com>
References: <20260912065648.999753832@linuxfoundation.org> <20260912065715.005565892@linuxfoundation.org> <d6e2ea6a-0297-41ec-bdbd-ae06b5e2f952@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Sep 12, 2026, at 12:50, Arnd Bergmann wrote:
> Are you backporting the RT enablement as well? That may need additional
> patches, while without RT support, this patch is not needed.

RT on arm32 is already in 7.2. It went in with 7.1:

  c6e61c06d606 ("ARM: 9463/1: Allow to enable RT")   v7.1-rc1

So a 7.2 kernel can be built with PREEMPT_RT as it is, and nothing else
needs to come along with this patch.

I have tested this rc1 series on arm32 with PREEMPT_RT in QEMU and RT
works correctly. cyclictest, signaltest, pi_stress and the posix_timers
selftest all pass.

One thing worth knowing: the symbol this selects is not RT only. Non-RT
arm kernels also get CPU timer expiry moved out of the timer interrupt
into task context. That is how x86, arm64, riscv, loongarch and s390 have
worked for years, arm was just the last one without it.

Karl
