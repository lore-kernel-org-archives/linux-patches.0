Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC2D36F901
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 21:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434774; cv=none; b=HjR+cUcR45DXhjnDIJAVf00FU2QyWC5x+5Ay2axoYieCRr2DAZvqkOuQG1UOtOqaGtnwRl9sl0j/74m/fWBykv3wqRmRlCCP1ws6sgzoekt5Rd4OKmfijjciazQARQf2+V7luPGZeCF+IB+reBGLh20erdFwOTGN3RM2yoDgZuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434774; c=relaxed/simple;
	bh=uij0fPrYXhiLn/hkkJMC6Jmrz2271TCJpQyuyCz9648=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+bJdPotSOct0lVlffZ9TqsodZ7nwy6SyjeBB2wAZpdnipZOCcybq98cM0uEkBZA1I0VAMfCB/iyD4OU55nqi1EVTae33o+Wd5tFVQVKPUnpFuflmM1+5WwWvexqmg1+Cb7kXBYXmlPQLUv3YNH2RB4ZPLipzvktRUUOMSxgiyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Go73P46Y; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Go73P46Y"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490abf12f0fso65905e9.0
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 14:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780434771; x=1781039571; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9XdL0UcpSaON9fzpANOcoqtpqZ13Zvjis5WLumIDqM=;
        b=Go73P46YiksfQ/BZoAAFjKHZkDEhL2zXO0uUXK1eiRCegNvAa+hRFIBQeGhVml7pnT
         uymFfMbBKjM42dYKrcjf3rflgWeysJv6DDs07d1U4QZCWjXSNd9k70nGaJU5YqPxA+08
         y7QTI71XCvqKxyueh9Wt34M4T68TFevWSULcW+qZjrwc1Df481bTiVy1/clyVPZ5kH0r
         ZriGasWp65gSeC4500ix3gd2ECv7QaHPuPJbmNhu4Khb/dn1lTvdWmlvjG+I1dEsi47y
         jbXqbv07vrae1c3QQ9CrUjIARQc+BXyUvfHwDlSNAYWn9FHUyo8XKDNau1/VFcEQcpK+
         Nydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780434771; x=1781039571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z9XdL0UcpSaON9fzpANOcoqtpqZ13Zvjis5WLumIDqM=;
        b=G+vrhBSM0HE5VoLNHRCj9tmFLM5WgNx2F6xH6jcN9gu0jY9Mfwh6DydKtW6Ic1Dqh1
         IJz/CLmwI0xiy3kRBnrHeAqU0gKEC7sr77eNU4AFgpYyHo/c0bB0zWloSLx9pGiS4+ho
         /4KidbBAccSww7qItD3BdvS10xeP73vtS+KKe8bqdTF3ODnf8Llssto65X4mrJzyXxnU
         XjY40sMULebpEKLJRLHecr9c8LIDwrqUdPHaOp/d415hzhtc5Vc0bXU3B2LVzDRV008M
         tod76BYYsO6eqROx3TdrDReiX/izGlCfJPEbZOG48yHYifBYCVt47nA2mIUbTGevIMHY
         2j3w==
X-Forwarded-Encrypted: i=1; AFNElJ/kGnrO66mwdJCsTgEr8vrcvGWDadLa1C21d7neebGRrYuoERb8LQW/MWCi7gB3FWvYiHXfAwfH@lists.linux.dev
X-Gm-Message-State: AOJu0YzKPcsSTvR8djhtHG9SXB7K6zzVPgn5skMDxyShIcQCHOF6SQVu
	GsfcEP4piSWYNeKen80O13bDVvlzfEktHBNbSht9aqPNuvX4C4+wssWe
X-Gm-Gg: Acq92OH5LeYOo41+ve5XTeBH5l7klYqx1MV5Ljm/0bAZSrsQYLq3ODADvU7KsZywpFk
	ChYC+G7MxKMDanNvg3HZcUwGZ8AZqcWsnG2DLn1YoJkYK5ZTpexkOFYr5o+gIcpUGq90lx9ltGD
	Oo0k7IBzGN0R1OpEdqxQBQAZSO7ckQ3NnungqExPm1jVUANk3jX+36COAjMq45Ms4gRQaUNwSiy
	VvtL8fIXZhhyIB+rmWCFuEzdjI4vlhj3zKQvOx+b0MsRAHlS1gs7x3n7ijLP+VUK1ZiXaUZLKww
	MIKhEydKJL+JMoKqu9axycT9h3wx3P7a24HZcWRn57I+u46KapItouI2vKmZK+JlQBw9AW/IOGp
	HSpgbPxzkQ74tzq9Ft//rXLQ8ZQQbSFK2yDKD+g+1aAyp/Q2o4503dumLEEDfFaeZq85K2CATYI
	xcE9GDm6d35EPf9Q3iSPip80EtaeQgrQ==
X-Received: by 2002:a05:600c:3b98:b0:490:b11e:e4be with SMTP id 5b1f17b1804b1-490b611105bmr5959595e9.3.1780434771026;
        Tue, 02 Jun 2026 14:12:51 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b0e13f91sm111429715e9.3.2026.06.02.14.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 14:12:50 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: pfalcato@suse.de
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
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 00:12:42 +0300
Message-ID: <20260602211242.13870-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
References: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pedro Falcato <pfalcato@suse.de>:
> On Sun, May 31, 2026 at 01:01:04AM +0000, Askar Safin wrote:
> > See recent discussion here:
> > https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
> 
> So, you took an ongoing discussion with an ongoing RFC patchset, and you
> decided to reimplement part of the idea on your own, as a concurrent patchset.
> 
> Riiiiiight.... I don't think I have to NAK this, do I?

Okay, possibly this was indeed inappropriate.

So this time I'm asking explicitly: is it okay to post new patchset?

I want to post patchset, which will remove pagecache-to-pipe splice.

-- 
Askar Safin
