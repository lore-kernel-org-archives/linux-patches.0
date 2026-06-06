Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ECF2F5A13
	for <patches@lists.linux.dev>; Sat,  6 Jun 2026 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780737386; cv=none; b=VHmnCqIaIfdpxPjAHztohKy7vpehnmeZeZJpm/U0L79y7+ujVeNPkrSYcOmTrdrHgi9dtOvPtk/cf0PoCTXp4KtRyD2z7zdLrxjc+e5NMPPwIQk+0//REUXqPiYoSA1DdVfqUcq1y1i9zOXujIq0RNXJLnBMb5qiiBDm+wkMqUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780737386; c=relaxed/simple;
	bh=CpQdRBzECz1cjWSW+VoW6/cj4i4cip2V9Z6XLkYrqQI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHmVkhWxzyXf81NiOkrW9UlnIsGPMlmxB6wuhYdR+i9BTXuV6cmk2HlsKU/DtWj0V/5Ftnl9XZLjQi7nOL0+UC+x65zRBBiZW2Gr6gvzW29nfIEpNHGgkbs8O+rLoo5IUFDLWqw0mh46fJxbqQHJwnChhSo0WtBCMi1mREKuX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RStPV9/g; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RStPV9/g"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490ac357c55so32231815e9.1
        for <patches@lists.linux.dev>; Sat, 06 Jun 2026 02:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780737383; x=1781342183; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/SxOH3sBqh56WyqC7iKaRtAkj2hv0SNo09/WoL7JuhE=;
        b=RStPV9/gELibRSBEvYKqPDUbEEdc+QcEdGnpSOeGoU1EgY8qW2U645cW7muOaFEmMI
         SoMTMjUfH3TQOm/IwKwdNBgLyW4pyhUWEhUfXPDAt4ifGGzgUQbFImV6Y5Vek+inXbt1
         D97MRQA2t+n89+iH5rU2DNH0MjazOnyOcI+pdlXZ4pXXuwo8IE4tlTOL8DmyFj9XKp5w
         fWguex57fN2oU/sKWGFdTEfKtBTqonNauQ8kDW6b3XMQSA9lz0oZUeZkW0jWuaQeA9X6
         zXlpCSFnexN6HQt6LIW0i2QTUaaFq+f900FVPC9xgA4/YUuQaE2gcSvjNsAvpNC49/ES
         iZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780737383; x=1781342183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/SxOH3sBqh56WyqC7iKaRtAkj2hv0SNo09/WoL7JuhE=;
        b=Jp0k8X2jbtfzPpci41EnB2dZQK0LNUFyUOwGuJhhJ9KAIGkCDhzJKEj/LkS1FALIuS
         BXkWXKSjypS3ENQ0+tpTi2yxV04uapqoVPt43Ee+bCBNtMc0kR/rqn/aPF1mw2Y4LFr7
         lT4ouMZ89FzqfyY+qICcdoKr0C07ZYAYlItbigTEu23bzl+UO88hAKlmeOPz9BbtQ4lQ
         U6d95JamtAzTB2/H1w2mqU2Z+kT5LahP1iYhwNXweVrKcfb6dVDE9Mjeav0AYBmqXgfT
         NQfaWensuTLITC2Q9oDrGCrRaNWP+QHMfWr4gDP3wJU1/YavEcBbNYCYg5XeShFGv3Xy
         SSGA==
X-Forwarded-Encrypted: i=1; AFNElJ9laE2w1RmusaeucC7wjYTmKTfzaiICRlB2I9JPW99X0zLz/vli6Y4EnxQ49ibAyPdyVMXYqJT6@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/CSpMLmnW9PO89BJRTZ1aJEs66d7M8ewE1xE3RTphCOoDW6D6
	Lmbr/KWS7W5AY5S1KpFc1f1XneGV+PRiyuO38ibLY1bH9w6XGjfL1fdS
X-Gm-Gg: Acq92OEsK5lwrbUJ9JFivHULKTsRYT1TXDudJc7tP8u7wbbxnPM74FbJohBZMV0a2lS
	wpFcece3A1AVjLlGeGe/rw0oMmo1Dcg+sEdd6iYO1JJb1qQpSYNQ+FPGFw8SEi04sbnZlU3vrT/
	rQb/3RrK96A2cdsG2fQnHGjqfLqyN4GoYH2fy86/k3Ofv/arCtNRLYFCp0q9qagr0RTC/xkgT5Q
	mPH74aC/lVtCWrf2pw9UlEY5eeYW13s4YhQtTbKtTtU6DXKFd4cKeMWBdZ3C9P6JKDV2Zy17oEu
	3s4xkEIq4XdnMmOn3uu2pbo4BtvmjXmeZpB5eV2Nzy2nPQRenKXsKkttuu4u/qM1g+m2OU/u4l6
	W4H/qS78ZdrUe/BUMCZxhFds2jxXmqW9JNkkaBtGiVeLY2Wh0GOpJ8dXPJsQ6Nj5vEFBvPsq7oj
	7uEpDyQquXaniwHybzewVjNGblBodZCSmBmTeDZUr+rqBApRDN3mD5APDn6qTx9Dvt3oURvsc=
X-Received: by 2002:a05:600c:83c3:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-490c25a21a9mr135656445e9.9.1780737383320;
        Sat, 06 Jun 2026 02:16:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3fd663sm247272215e9.10.2026.06.06.02.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 02:16:23 -0700 (PDT)
Date: Sat, 6 Jun 2026 10:16:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>, Askar Safin <safinaskar@gmail.com>,
 metze@samba.org, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260606101620.602ed92d@pumpkin>
In-Reply-To: <CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
	<20260604223216.73468830@pumpkin>
	<CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
	<87se71jps4.fsf@oldenburg.str.redhat.com>
	<CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
	<87wlwdhrvr.fsf@oldenburg.str.redhat.com>
	<CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jun 2026 10:12:05 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 5 Jun 2026 at 09:30, Florian Weimer <fweimer@redhat.com> wrote:
> >  
> > > Uhhuh. But that is only specific to 'bool', right?  
> >
> > Also char and short.  
> 
> That sounds like a complete ABI violation as far as I can tell.
> 
> Scary. Because I would not be surprised if we have code that assumes otherwise.
> 
> Now, the kernel *seldom* uses char/short types, and since compilers
> are typically at least self-consistent in those cases and we don't
> interact directly with untrusted sources.

There are plenty of places where char/short are used for function call
parameters/results (and not for single characters or similar).

I'm sure some people (even some who should really know better) think
the smaller type will save space.

I've always worried about whether the calling or called code is responsible
for ensuring the unused bits are zero (or maybe the sign extension of a
signed value).
Clearly the compiler should obey its own rules - so mostly it is just
extra instruction to do the masking.
But for interactions with asm code, and possibly code that gets mixed
between gcc and clang (maybe for out of tree modules) it does matter.

You also don't really want to be doing maths of char/short (and there
are quite a of of those as well). I think it is only m86 and m68k that
actually have 8/16 bits maths instructions (is s390 old enough?)
everywhere else the compiler has to explicitly mask the high bits.

Maybe it is time to 'nuke' all the 'short' locals/parameters/results
(eg from htons()) as well as all the 'long' for values than aren't
dependant on 32/64 bit builds.

-- David

