Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE3D2FD665
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 09:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782378191; cv=none; b=UtmR2NTVN9YNQO6YkOZyXW8OZV6HjtjPWKRL1QNgdpJH/invxHtAjynNvh4mywrJeyZFrtxfYmTG9qKMslk9N/FoSbeQgy4Pw80DNrTos2KBJ1XMUkEi9AufR1deTeUVnkI4SJI8l3Spcdq8bJN+kWFUdQzH1ny9PmzM8Wxnwzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782378191; c=relaxed/simple;
	bh=FguPNFEFgDgE8rgvKN7AiVQat7qypuBZ+3etEcHfrYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VYV+uTBXyWZwnV7e0aqRlCCXXsEQylcRN9evt14OtbYInrGS6v/5eY5RWXGQ0lPD8Ka/CgU4udbcg6bFNJeTmzsvpF1T2cxdSXqYZZM4/jii8+kVHFKute6wK9Lw14pAIJU5Aq+7Lsz2QycXh8OZCAb20wgQMYyFjeG1guI8PZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c4sNincm; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4sNincm"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490cf322ed0so19603815e9.1
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 02:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782378189; x=1782982989; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HBSEPUdUYWVlvar6bWIrKaomQq421L3gUjBqqjys/Kg=;
        b=c4sNincmI9LIukFdjAfVElstNAX+3+cjS/HnX/XrPNfZahBsMo9G3xmecwtBfrZH78
         OstCkDdpyFA/u+VduFsf0CQYQrOf4m17pclUdFKqOVijxzu3o2qmRj1zMvRTxzqn9uq5
         J4mNsATfe+Uk9VQUJ3OC+Bad6zHtDoQb+mILkPU01H6o+P2fQpMpR4rMOElr9/dWQMm0
         DITzqo36GTJ1kHqnYu9b3eQElROtFYtGQBoCeUiKGjlyUgr7WyLsbVeWyz4D+cedcEMD
         QKgqJ1+nBltoAVhxXKLAtTQNE0M0nEb4sdhJv+6dU5VKXDUStEjLV8OzPnD4fK3Hz0Rn
         BqnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782378189; x=1782982989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HBSEPUdUYWVlvar6bWIrKaomQq421L3gUjBqqjys/Kg=;
        b=g6WOD3WY2WLglSwomwNkvBtqLyiK8ZSLBvYNjVId+uUwyZ9qTU3Jk7xVNcZutld2aB
         ndvXNnQJqxRya6UTxKlYK09icQvu8oos3ULO5OGV+/x+7qGbDznAHvWDb0ltn6hUfDHS
         q/uI0HazuheZf3vymfBiJoxtLPVCTnr1APiBRgNbN5cPuo2SEoIbMDWFSigcNeAS6syp
         nhHgVMHc7jAVqyJu/0NwmTlVseqa7Ir/haF+Br9qzz8hWX3aQ58MyRpZ2d1EG8Nl4MpH
         7NHDOOuN90ioX+JRrAcpgROb0GNhCl49uUg9zprKumJTJsLy+7u/hnJ3bwtHUXzTEiva
         +ygA==
X-Forwarded-Encrypted: i=1; AFNElJ/G4bR4EGdDzzGsbWq32XAOu0qemi1WX8cRYSOPttxLLwhlh7KhH8tPLjNvPxtxcMqol9QvaXTY@lists.linux.dev
X-Gm-Message-State: AOJu0YzUv/5KfpQYekNrRBiFWCsUyBfNbqBnFk4PaG/f1veiVeafO/2q
	NmfflGMCwvu9RoUxTidWNCSqalRlX8k4QMagZs/tyDTEPe6h04xz9Xw+
X-Gm-Gg: AfdE7cmU16AQJnbDNivKpf0KdQFQ4hSwk7XlQQP2whhX2qzSGywe0u73jbzLkNVMD7f
	SiAu1r0a/QNHPTIMZTjKmiEAWZptIPz0aSqVeIh/7nzZjAdqKqUyHwcK3w/CH74pC/uDZ3pNA9W
	4Htpis9CNQWrRJmA9Mbsc5UL9wvQg/OJ22fVT2gTgs/ViO6IGgzJ7PRikl0oedAcGARQIb2BiTr
	Y6qCyK+nQ8yWSoGhNMMdLuPuev6IbW097wZxQsi3Fi47YW0SvgEqdital3dwTKcIKJTgWpRfEuR
	WgTXGViNLo2HOB7nfi9jUXZtizylINYfYdC2Q9ytO6LLmni76s7NvDlFDXyMnn8JSLW3yulW+OF
	mSXa0Enp4SSamFWldUIUYp6HHBZlIN0yUNw+M6YVdk4XamAOf4FhLsbS2sd4POa4T/ddc8mem4k
	lMvadneB/S/hBuifroOJY=
X-Received: by 2002:a05:600c:c059:20b0:490:bb3e:30c2 with SMTP id 5b1f17b1804b1-49266885955mr16491185e9.18.1782378187463;
        Thu, 25 Jun 2026 02:03:07 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-49265975147sm55948915e9.5.2026.06.25.02.03.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 02:03:06 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: val@packett.cool
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	fuse-devel@lists.linux.dev,
	hch@infradead.org,
	jack@suse.cz,
	joannelkoong@gmail.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu, 25 Jun 2026 12:03:01 +0300
Message-ID: <20260625090303.3796964-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
References: <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Val Packett <val@packett.cool>:
> speaking of fuse_dev_splice……_write actually, this series has broken 
> xdg-document-portal!
> 
> https://github.com/flatpak/xdg-desktop-portal/issues/2026
> 
> Specifically what happens is that the EINVAL is returned due to oh.len 
> != nbytes:
> 
> fuse_dev_do_write: oh.len 16400 != nbytes 15526
> 
> (where 16400 == 16384 (read len) + 16, 15526 == 15510 (file len) + 16)
> 
> After reverting the series, there is no error because oh.len 
> becomes 15526 too.

Please, test v2 version of my fixes:
https://lore.kernel.org/lkml/20260625083409.3769242-1-safinaskar@gmail.com/ .

This should fix this bug.

-- 
Askar Safin
