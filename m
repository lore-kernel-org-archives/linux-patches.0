Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC26B3815DB
	for <patches@lists.linux.dev>; Sat,  6 Jun 2026 10:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780741377; cv=none; b=UsypIF/1CzyevRuIkZpfzPXlw2foXvYOEvgZjERs1kB/ktWK0WcWhbo9c7/MXTbCIzoW52oNEwJZphHBc7ld8heQX2DnXUbaXLOjiNgyPVb6Z4/SNHPvmalah1/JJL9tec6gCedql+qefkuPTS6Ndbvt4skbXOf4AnaJQ3fvgD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780741377; c=relaxed/simple;
	bh=6ZCo5g5YBCheH6lxLHUPDkhAwohoDkXUQMyBGc7LXHw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N3g6hbLjSsPFUtfEry8c4UKwqhI6pD/3jMVpJM1MZu9KcF2sHhaw+Goq0bG/CstaWYgRY6Z90z04e1QVC712YHj9KCzKOFxZ+x4Jvp9Hn2SbDt8oTgI0RRdq8yy6xJ3vs+4H1eGXsmXxBsotqc2+IJ/L1KwM6ptLiuopp4LFe2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FW1jMbHY; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FW1jMbHY"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490b64c8311so30988685e9.3
        for <patches@lists.linux.dev>; Sat, 06 Jun 2026 03:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780741374; x=1781346174; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PYftnEwTkOLQeoNu4nW8+o38nbEt2RMPyp6dfwToa0=;
        b=FW1jMbHYF9qqfALy64fvMgMo1SK4SxfZg35sY2DjvoftxhMqeq4EXVGBTcUt3Ma/2u
         KO80wYuNN6vFDKM25ZyRBsNYGOyEUowc32V8qdt7SuFjd3ntCDMRyaZOeQsYrLbVqVZ0
         4dOVK4ZWK59YBPMWxnHGqLWhBRRwuB/k6jJTtApiSNnjfa6a9lL3GJyM7+gp7xMVlC5e
         RSvCDsYNoRHGrGaKpX2UCnOP8rdMdwUoXjGbTiXdx3IXVeLqhkjwsFhSOoSJ/v+QbNRZ
         Kc3VAaZqpWGLCNpbPGDOhVO7mya5nY4V0NXHABH1ONeo+Q+h1ZecYkdaL7eH3xjWkHk+
         A/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780741374; x=1781346174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+PYftnEwTkOLQeoNu4nW8+o38nbEt2RMPyp6dfwToa0=;
        b=F7PmeDiM9DXP/mZ0Q3HHw9dkoZybglxJKDA0EqqJB4VMk5URZTDIcoco4KqZQwLkKj
         N2VoUJA+PHOwIZwYhscrhmEBOIYXBxD8QrMqITTjlg1dkBdTXiHzINOiKS9mlGMzldPG
         On7PgxQrTxblNXP7KbnaHcbim0M8zoZMFNEuU6JJIZb/Z9Bu3F8VLqpaamis2Z3CP+fL
         enotphTzcf7aOfiTuqXZ0altw1ZTzhjzceZvgXqMToC+ORnQsVh2+7beakmCqNL2jLa+
         /j8Xi0zCjaNbJp7JQDNpMj7xrvsNN0eHDt3q+YYtkp5xWO85BpZZzJ8iR6jq8kvI+rmz
         SDKA==
X-Forwarded-Encrypted: i=1; AFNElJ+vcRekd5bsh+2gxsfgvCEzgS5J452pWRdiUJkW2f/01ZeyoEL4BeFxxUwc+hXr9hEeYy4DGMX6@lists.linux.dev
X-Gm-Message-State: AOJu0Yxth2AfcJnlsAZcfgERYQw5tnowiKdv+ilBJduWFlCEWdwFFIY7
	NeHPqTVzLoZfgLK4r4zWF9HLDBHQup12CfKil4Da69p02pM4nmtrEJXA
X-Gm-Gg: Acq92OGlyD1Uqs72V9a7kGMPQWzwbjNqK+BH/ep+r4EeiRfVY7gK/hUUzTqIIkdY7Ze
	XdasHYJqYawHbhv/b9HIFzTg0HBziQ0x4tE7dJpaiIh7VKaDdwCBmSaN7I77V5bF9haxl4d5+VS
	3cVXi0KbRqtOOjU6Qv1+qdKIUcnJLsmRmqer7e1kzDRqdWl/n85gAVu3sOCPsawyntMd/23JNxo
	ai5uX+GeQRvYgmzbsmHjXvR5ha5G2neFuZ7H3cl57SvMCwsWjnMvA93PEgfRGD5tq72LIQxUqPR
	8IQxtK3o6ZBQ6JJJxHG9NFKOw1B2zAoP/rrowggUU4KTN5mH/c1vzk8iIbEVoXCOTtZliE6PBm5
	AraxXVK6eYBiORGujKqkc6VfPMWt3ADODoS8kRrMccucNow9y78QcZzsZc3qx0JJw1KU9Tjzy4Z
	tf1isjAwl39Zj4CvCBNlUEpFq4I9B2XTGuckB9F3qIWAYvIQtKgGBCZv9tSYrNbh6SF43DNRqtR
	Uab4uMYDQ==
X-Received: by 2002:a05:600c:35d4:b0:490:b8d3:5dcc with SMTP id 5b1f17b1804b1-490c25e4634mr128363515e9.19.1780741374229;
        Sat, 06 Jun 2026 03:22:54 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcae2sm35545066f8f.6.2026.06.06.03.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 03:22:53 -0700 (PDT)
Date: Sat, 6 Jun 2026 11:22:52 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski
 <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260606112252.3c70bad6@pumpkin>
In-Reply-To: <634c8ae2-3f1c-46b1-b002-1e2ac797dd80@samba.org>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
	<20260602225426.122258-1-safinaskar@gmail.com>
	<CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
	<CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
	<CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
	<512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
	<20260605131942.4584728e@pumpkin>
	<634c8ae2-3f1c-46b1-b002-1e2ac797dd80@samba.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jun 2026 17:20:34 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi David,
> 
> >>> So sendfile() as a concept (whether you use combinations of splice()
> >>> system calls or the sendfile system call itsefl) isn't necessarily
> >>> only about the zero-copy, it's really also about avoiding the user
> >>> space memory management.  
> >>
> >> I don't think so. Ok, maybe for webservers just serving tiny
> >> html files, that's true. But for me with Samba it's really the
> >> copy_to/from_iter() that is the major factor.  
> > 
> > Is that copy also doing the ip checksum?  
> 
> Not in my tests. I guess there's offload in the network hardware
> for this.

There will be, it is just whether the syscall checksum is actually
being suppressed.

-- David

> 
> At least at the syscall layer of sendmsg() there's no checksuming
> happening.
> 
> metze
> 

