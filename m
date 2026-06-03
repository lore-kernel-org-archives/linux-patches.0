Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EE02FDC30
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 01:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780448932; cv=none; b=NWVwwpMJmjJz9O9j7qX60FWSqBucr+HWsXUBAdhS59LFEBuo+cbE7lee4b/zk5bSBUeRzik5vYI+R6p7MKNfCjhwnZxuXfAKYaF2x5Aj0XAiCLcsmlqHHxHmpTUPAX4LvlmO79TIVSVi/maZU80B8uNASXcUG131VqLA+5JmOyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780448932; c=relaxed/simple;
	bh=2ZV+1Hj/UhdYw1uvUPcYqYevnxoEYOizS2cgooIrU6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUBvPq+qiLzYSvePf0AwiwMQLcCpoyWuMqUXehwA//CHnozB4/1KJyvUSGNNVwmVCUw9sBm5y/KCliaJwQRtL2XwKhf5PtlSYIN0hvShHRZ5uaSip/2fLJlk+3QntfuJfn+f2984bMH7dD1uWD3MqIpCsb3pLuBOiV7wyUeSJyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dbpqgSba; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbpqgSba"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so109926735e9.2
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 18:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780448930; x=1781053730; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3GAR7SC93N2eePKpNe9tCYUdzk5c1g7WEzw2IFy6ZM=;
        b=dbpqgSbaZYrs4nyuwSZzmx978h/WuRj52MBk5MoDPXeQf2evsEKqxYvP/IOLQ/B+D2
         d4NE4Wmig9Cr0jbXQPu21yZBsbhVHoZvqvq5e5XXndlP1IUUaJy8gnFyuVtiUb0NnqIc
         ovMyJtHGZzf89ijviwcB67LungyRqqDqXkkfNjX0p9xF+nuRKMfigmnY0ei/jXjeOV0T
         SbEdJM9HV0AYLMMuo3/YYlQLqoG+ICwsswMr04Y+7lES1RKAarzAwUpW3HTo7o6Cl8Pg
         z29QUA/mkYh32tqzU5wEFni1oZ2aLwR6NHmkk+mfjgRPqFeDsc55Ylm+qovrJpM6IA0u
         VqiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780448930; x=1781053730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d3GAR7SC93N2eePKpNe9tCYUdzk5c1g7WEzw2IFy6ZM=;
        b=EzTheKTf3CDBb7EQMsJcjYMllJf574aT87/q4x9H2vd4R1+BzSQnW8OgAhhV1l+pEE
         rNit+6dl7jeTIwVEwg5fJiE1uhM08Kvpejs7KaiWyQ8ndftYhUHfvr2/K3L+/Ahmdys6
         FnHVC3VzizbJ2/h288gdwL8+gfHzJZPVABexVuH6hmRMUaYvPGot44lWKQuGiLcc38D4
         TJ4vSDAHIt9KK+hgUmwBe8MNJZKhN+j5pZEK/B3wwoByO3Ki2WBJ6B9YrguU6lyT+3Wf
         lH5tqCcSK/nbME44Lf8QZW+25YKbYTYkotzCFBYjj3+bt/N2sNzhdUXHVB3Az5veCAog
         eA0Q==
X-Forwarded-Encrypted: i=1; AFNElJ8tGb66zkiQhEX8ZU1BLMiijt7YBm9nnAoajDiaWTkOw9/JAuk5AUEit2uEuegE2r3QOTW2kmlx@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw3D3Qg8PlgMpQwFoXhR+V9P+4BuGDKz6CtKMyN5hLUNE4knXj
	+Vr26/a4GTW3YYrh0dZSZ9YSEleaBc2L8PZIcIVCVe2DgWu4xBcwwC48
X-Gm-Gg: Acq92OF5/THrQhbugbEJin8wdiLY7VrChXlYdJt5VQpay011rTwqM2mIukSoUAWpvDS
	E+buGQU1sT+dhArBJhlfIqTd1W6qUod2NnnlqLzX7/i4laj9A3LK2CizjSnOUtHTBwwXRRWills
	Ng6ENzxlUOc4I6tiawE7/uzgFtuXaGzH0rAIFOd0DjdCBsZXdANTRer4D5l8Pi32KPSH5QxcMZ/
	DmN/oLz4DaFajlQrcVmtCbt38fg8V3Ypicw66dMlErEWLAwWhKwFpEufaaOMou7uavidIs6VrhN
	XgVSs56SJ4dhOXKyMg4453pfLoA69HDxzYyPT970VA0jbC9qP2qQKNt6b+jqA95RfisE8+qPID7
	2PdZteVFM2hZy9+kPbfHe+2/wgZdugDujaStHms/LtZ8ay0S1ko2nv6KdMcqtbwbcFslPdZC2f6
	RfisUFkzSfl9L11XGQ31W2+fyo2bpdFg==
X-Received: by 2002:a05:600c:3e19:b0:490:b58a:dcc1 with SMTP id 5b1f17b1804b1-490b60fcd56mr18908035e9.29.1780448929768;
        Tue, 02 Jun 2026 18:08:49 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b725fb1bsm11254325e9.8.2026.06.02.18.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 18:08:49 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 04:08:44 +0300
Message-ID: <20260603010844.257094-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
References: <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linus Torvalds <torvalds@linux-foundation.org>:
> That absolutely would be my suggested next step.
> 
> Something like the attached - get rid of filemap_splice_read()
> entirely, and just replace it with copy_splice_read().

Okay, I will post something like this soon.

But I'm slow person, and also I will test things in Qemu, so this will
take some days.

-- 
Askar Safin
