Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D6B4DBD9E
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 23:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780527690; cv=none; b=JDCazEQJs1DkalLqEE8WIt8jwlWMgLHw71hi9lVQ/dsgGIINxOmyKVo/wcPyVQTmPMWDquisRIuHGz1uW1gkGWQstuIitC9ob9vvBZ4J2cy+qwkHrAgYXH0y7h6Y32uHbcTaAoOUVCviMA9miINNgUJ+TvLC65csn7rKLgXYHng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780527690; c=relaxed/simple;
	bh=kjRfpHBz6N1AcpGrp9EdxI0+Sil4adZV+IHhFHCAUwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I/NpGfzuPzulJ2XYeez9NkN4BVCg4yfxGrCArobewY5DPw6mWFsBUsviTO537H9H6vgAESzwIhQTqiV6+B88YFzzAdjYjJIkB7mdHsIN9/AQbDy7Dbs6rO5PbPBKrd6wXukqqGT1UDXls+aCpL5oJ+XptzhuVdARAzT/GqDPZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NEMnSkY/; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NEMnSkY/"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490b8a97b11so1048295e9.0
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 16:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780527687; x=1781132487; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1JUsgVJ7d9U2h7quy8Vg4SoAkC431+Nv0NzGMCDYE0=;
        b=NEMnSkY/UjttEEmpm89Po07KbSmiHZYzRE31e/KGd0kB3M5X1lG2K6450eFfM/F848
         vEe0YB2wXYmhggpccUtmrvLp2j83K6baoCJaIbJ3x+z10SqflPGpsU/XoHIbcY0IBcbC
         yJSDIqcEszGdXHywGH918LJgFGYNHePFeSgwC6DLKorACXVnH66mz2aBnG3BcnpG4nwK
         SZz7jEhLuBebJkpcPIl7FiWefYfGJpYnZQG/FXxxmGUbs3nk0OcVJZWT0RhFpW6qCEdo
         wv5fAwUfV0cl1T+F1BHYb0SN2wjkG7ZyWGDT/2Zz5n+6W3byIkPsouxOxkqBMVIMveEx
         kGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780527687; x=1781132487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b1JUsgVJ7d9U2h7quy8Vg4SoAkC431+Nv0NzGMCDYE0=;
        b=hj1Ddbqkzcr2WH2RgP/wZZOmG8K6AwWhFEIvCGtCWgQrrIALrjoVPRVKQ9bkvNno8n
         GUScNfS+On9KeqCeIwnnQSJXBqNBWco5/2N88wfLBrZOWMBltzNIuBZtGab+K9916yBV
         RZQnIn9aWihrxF/SyG/nTs1fKAATNA/WzD8xwQqiaXbC6AUprfCHv+rbJdvPYVv1qQmZ
         KNUOrJrdikwQ9h0Bggn57uZcY5FeH0h//+QoCme6ylZO+Hdbw+Zo74eskpV9aXVfvOO4
         bPAAQoPh5NIZhF3fq2JbgeXSFNbhHTBiJHLKFYUpOvuIM2kHJCqFeoYYbYSOfgo4YxxA
         fyNw==
X-Forwarded-Encrypted: i=1; AFNElJ9QNNDhpNeW9Fmh1D1OILV30qDozyGIIBodawhnzHBszYMUEHNjEAAj9Xgsbknj2doZ3ujefI/G@lists.linux.dev
X-Gm-Message-State: AOJu0Yyu8rry4ntJjZAXKzMVFYzOtO1LkPc28nSv+GoBcI3rT/gnWObK
	Xr0Jyld5bDB+tMotUFx4LyU/4BZjL04ss3ic90sgHkqZe1io/0y96Ynv
X-Gm-Gg: Acq92OGG3D+hO68U+hRIzlaRKGIBQhmMjJ5kNw9dDgEINohQLq3dnzAPiDnwXHjB5eS
	RPUXj8E+sfyCvIS80P837rPFFvlEqWdMI1TlTu2eb5Hw/BfzyVqVgQKVXLE8L8gV/8zY9MGyaV7
	1a8rhFeW1soll/W0xKToNkusygJoxay47sw7aEUlx426KGE9ZzPxcgSay9DlGz0rhLEWVSRZj4S
	UtveW0b0Cq2B+UnXfoWjkkC9u2owdwldURkdykEHm5jAbNq8gxWZbPinvUDyifODQm4tY0Si5H9
	jb4FQvlg6stvhM/FbMC35z6aXjjbTY4rYNhLPYWyFsIINwxyXWqCSE/v0zLb5A6qzDkFjhPLpTm
	U/0T0dcFYA7EUW9/3TmOFtMTBo97r+mZ14KJgnHtU0eaZidwzAIGFOOX8tZu1f8NU0OLQoLc6UJ
	Znt4FHrlfyIHCA5d2VDRWrSEVNyTM5rQ==
X-Received: by 2002:a05:600c:4043:b0:490:b2a6:8c2a with SMTP id 5b1f17b1804b1-490b5e748e3mr51931455e9.5.1780527687138;
        Wed, 03 Jun 2026 16:01:27 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b7e6c6a4sm45890145e9.2.2026.06.03.16.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 16:01:26 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: luto@amacapital.net
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
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 02:00:25 +0300
Message-ID: <20260603230122.851517-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
References: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Andy Lutomirski <luto@amacapital.net>:
> On Wed, Jun 3, 2026 at 3:43 PM Askar Safin <safinaskar@gmail.com> wrote:
> > Finally, we can degrade tee(2) to copy, and hopefully this will
> > allow us to always be sure that pipe buffers are not shared with anything.
> > This is possible future direction.
> 
> I'm a bit nervous that, if I've read the code correctly (a big if),
> then iscsi and nvme will still send *shared* buffers via
> MSG_SPLICE_PAGES, but that normal user code will not be able to do
> this, and that something will bitrot.

As well as I understand you correctly, you mean that if we remove
tee(2), then there still will be subsystems, which will be able to
send shared pages.

Yes, I totally agree.

So, if we remove tee(2), then we will probably need to remove all
non-standard implementations of pipe_buf_operations.

-- 
Askar Safin
