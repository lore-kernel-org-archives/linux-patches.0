Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A531B4224
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 00:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780531295; cv=none; b=T8BE7x0Io6/RYwomfLhx+1nNE/eNjKYBMgua8XG3EnKUpVyrrOBldNU9rqmvzCWywZuejpot0W038Rhhjm/eHk5QJIoIN9xiTT45zbba3XYbWTvSf3QG/CNblX0x3RGbLP4C1RAUeWJRW2x48mKxMdo5HYtax98gcEYUDtWPmHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780531295; c=relaxed/simple;
	bh=uQcJ3DbEdxsfH/k24j2l4FHVQEAFZdw9HA2H2VMaFx4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aj9niFnsBQj5N/6yCySj4qcz9pF3gr8MjsKRiH2OugjrlF4Jw9dotVKTC6nqjPAqHArr7djtWsfhTqcHXcxFZqDzdOEQfQYDG2rM0n8zixtOAuBww9ikDPELRQn4SK7QSElhDPBm6zjaEPdLdkCjOFPpLiG+ILaKFIozfKDOuCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a8eJKSGt; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a8eJKSGt"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84237c55ef9so38980b3a.0
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 17:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780531294; x=1781136094; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fmwtcO9oMtO4r20fiMVX6YvjF6Gi+HYM7qIN8rIiuJU=;
        b=a8eJKSGte8CoUZOF6WVBYsfjIh/RbT0wZOR8/rRUy2fWP6icKCi4WfAiE8k/PIgzwH
         /s7pQf6BWkoYBJA6gOqCtT/i+g1R0bYnH9v3D7NugO9rFUVlFwIDAFEuu6csOadPtKEH
         w+eao0iaTK/hqRyb6JFxxCiEKwvOXo9/P5z90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780531294; x=1781136094;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fmwtcO9oMtO4r20fiMVX6YvjF6Gi+HYM7qIN8rIiuJU=;
        b=H8kNd6sRm8JDacXRzjRJFKpP2JUej6+MN3mRXd4qFVAvdkGSHUHFcOv4qaXAj371iW
         6+luXwj4fnul9ITFtxBMW/pZBspnSNuD5c072XM0UHtT0epyXB0M5mrOhwliTxktsiHO
         bU0W7TsDDclBF3ibnuRJeR11zBm352E8pQK+Rsg4amQ0AdFEJ4wiIAc44uFJjZksutkE
         iWejEXeLzsaV0/eoLytiWpRykx1m8MCvB9pwPH0YJAu69xSaeZ0NtnQf8hm2a1ZlBAcQ
         ssbdGw7qFndHnYOWURTdNJp9PRhlSu+YkUYsgV4byhrYiHQbPF9tnkJAjtew+9JEIoKN
         VeGw==
X-Forwarded-Encrypted: i=1; AFNElJ8ug2z9pglF2iigBmCjt87qDnZAgEWHhCW3On/sekPv4q1vQCKcqzFvmvL8nWr4D7mKk02j4f1a@lists.linux.dev
X-Gm-Message-State: AOJu0YykKbuCPB9kHtkvtojTRYqNOJgxFVJOr8GyFOmG+PdqRBTrC8H0
	2IQYaI8pJ/apn/nkMyR3p89MVkVg3H10CMcnzOh10asrmNyxb/TNrLWFsCBtiMyzUnd3Ch+kvqG
	2JFlNWFMZSg==
X-Gm-Gg: Acq92OGPK0jhbPvY3S0685ScLXPKvb+dKVf9pQglDw0P+j3tOYJn+hTWVVRb+LzMXqp
	KCB1KI1Kuu3O5l8w/dSDNIvqyG4T3q4YV7E/GZSRGSCUnOz8f9NPje2nE6a8v5DehB1/Md0zpJv
	8UOeWFDdTTE6ksYDsIWZZogM9wUosPkVpivhLVNV4x//kttLnngv4oIa2WLQAsOiuh0IbTiyngX
	j2sSSmCgk5zmuTtzAoxHXpJ4oHAybH3DMHIv8Zsts1vNCkP3CuXj4OUwdzv+oBF03Dr1h0E4EXm
	26ix+H3BNHLKjrw8+va9QFK6+KFLVHYMQ4PEOzIkjaLXV0y7AMZy9t9wo6975Ka5BAiJ1iK0Rtz
	mRfD23opPqnd9WP46AkEU615EDy13pIYxhuwo1VCtL7QiFVfLZ8j16q9RHzG+vvr1G8hhVtV8Mr
	K3vP2S8PeGgkNQoSz0dAtW1pu6LETH6h9PH22Iz7PC/KXMgnfjQ0hxERDUpO7QDTuGWLd0uOrm7
	pvAD66vHz4=
X-Received: by 2002:a05:6a00:a203:b0:842:33f3:da7f with SMTP id d2e1a72fcca58-84284db91f0mr5097323b3a.2.1780531293648;
        Wed, 03 Jun 2026 17:01:33 -0700 (PDT)
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com. [209.85.216.47])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282904889sm4119314b3a.55.2026.06.03.17.01.31
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 17:01:31 -0700 (PDT)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-36baeec21dcso37268a91.3
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 17:01:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9lpiMq6YBVX/nAfzH6yFq2pLVvPY/mQkE6/HJ50wNQsZO5eutBvYSOkBEk5NiyCDAbslCrAz+6@lists.linux.dev
X-Received: by 2002:a17:90b:2811:b0:36d:5dbe:2a0d with SMTP id
 98e67ed59e1d1-36e30c23af4mr5607319a91.7.1780531290626; Wed, 03 Jun 2026
 17:01:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
 <20260603230122.851517-1-safinaskar@gmail.com>
In-Reply-To: <20260603230122.851517-1-safinaskar@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 17:01:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjARJSHGWvZKJysvZOVEVi7bNL5x9K2X7ifhfLA9YK2sQ@mail.gmail.com>
X-Gm-Features: AVHnY4J3E2GAiTMiUKCy1DVjF0CiXaoh4gFXUo3phzZ8FQ9ufT44d-VKtd1uRR8
Message-ID: <CAHk-=wjARJSHGWvZKJysvZOVEVi7bNL5x9K2X7ifhfLA9YK2sQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: luto@amacapital.net, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 16:01, Askar Safin <safinaskar@gmail.com> wrote:
>
> So, if we remove tee(2), then we will probably need to remove all
> non-standard implementations of pipe_buf_operations.

I don't think tee matters.

Sure, it will share pages across pipes.

But if we make normal "splice to pipe" always copy from the page
cache, nobody cares.

You can corrupt the resulting pages as much as you want - through
multiple pipes if you use tee() to copy it - and it's all just
corrupting your private copy.

And yes, iSCSI and nvme might do their own splice-like thing, but
again, nobody really cares. When it's all kernel-internal, the attack
surface has gone away.

So that's why splice() (and vmsplice()) is special - not because it's
buggy, but because it's the user-facing attack surface to expose bugs
elsewhere.

             Linus
