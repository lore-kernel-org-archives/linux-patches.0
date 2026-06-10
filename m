Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A35F289E13
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781101091; cv=none; b=bZXe7mAYv0BQDVAWGCKBv92mHGgF5S6sykr2As3w/NXgWJjGbza0SXiV0h0hcSjy3hlflXUMy6W9Jo1B852zT54qiPOrIsDtF4yE7xuDjdI2h7e0pM0xGb6yk1rxlz5UtuSDvNav2nxOUL5te8lauXUNwATbDcruKGcsVhlZ3Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781101091; c=relaxed/simple;
	bh=BJ9c/ol6w+Ube8nVPNM3mIfu3An8puBsF+RZnr8il0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tvz3VGof2iriulayIEZaN2Id2JjssCgbZLKwTk2H/ruHaOUTSOHJ82kWAqAjBWO/F6IIrhU3tk643PaSJbTmzVKJsHpG4LamZI1I53WYgGQ4fdONfo8bPBuB7Y4ngGk4WsglAG7udTYQzKsYOWl7GJYUob6NxG2uAJI+2lRId7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=akK8rF7t; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="akK8rF7t"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8423f52af13so4759854b3a.2
        for <patches@lists.linux.dev>; Wed, 10 Jun 2026 07:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1781101089; x=1781705889; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TtsvHh9Pn+Rylz6+XRT7TQz3RFIWkIYkOyPrXmDgVAQ=;
        b=akK8rF7t/an1vt8kY4c6+fUg79XEM4stxUI0iEIn+OXpjgrqoftNAG+Lx+mTcOYK3t
         w33XI8QyRT8ByqFzbzMVYpNsFhHMVrQD7AyTVW7Xqr5McemmDctrR2xwyZVnsTnguHrQ
         oaQDL5wh8onF5Ox8KZNoUxjemTJxVoOX9JuG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781101089; x=1781705889;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtsvHh9Pn+Rylz6+XRT7TQz3RFIWkIYkOyPrXmDgVAQ=;
        b=G6lVD844CA9L38tCbEjHPkjU7srREN4Bd7LGV22y2iNfckp6eOmV33nECbORcswVNB
         ame+RwZh9CgKhwD2IMxHM/NhKJKFzv+XuYTHibceaXm1G/I32THaNotA6SE9FoCaG1nQ
         FcbOhn/6eGznnHPFB1FbKugyuLwqYzy2u4RGkHqKs19vsbbaF+HbrndetboM8TWQGZWC
         OAKRzjjff4Ykv+IptDbKysE1LwaLIV8h9DU6dSNcQhqnpQQmcPcVOfkhVW0j+HZ0pSu2
         cInW3LBim0wllcjUrXpz48iLeoaYg4OPYVXRERobywLOjRg/hgFV5Harq0v4wmWYwhmk
         zPrg==
X-Forwarded-Encrypted: i=1; AFNElJ/imVOmKR+dVZjZ1b2mwDM62/UbSSBT7XmsIg8GfhTWW/28Ab6hPyDAFFcRYwymDQek6tbr1hGs@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/fMQaZ+n8CvcyP/yCR5l1HqrguMXgDWafO0Sx+O/GiN51YtGz
	7J9HRjo6mfzZ/IyHyQV7KSuIoPc1HyeDMh8il0LbLnaehElttqZ0YL+XwPaWiT+5dRwoYRk7ylJ
	qJtrauRM=
X-Gm-Gg: Acq92OFdPz6c+gwsJITqlfD0+D/vS8kaGl6p/UugYhZhwCLPIvUX8fvbdkmBfRd1hrg
	4RE2Zwr+fMMQBIBlGSrh+tmZR0sk9chsonlfv+L8OPM55kjqN84y35ODscIBCSfQOPgl9gEwweI
	2Ss2E5unsOi0aErYGOXmvGsxW664hvi6OmDkBTDYxBo3x/KWaB66oIhIElgpPfAKm7qIIVKDTkM
	X8YRNcYKDkW23tsqqeOQxNj5Si0EaESVfBpwqRmLELFmpGDlO1wwfkARjaW2tp5xh9j+f0e0cic
	BfUpDs55eera1oAR7r5RmLm1L/7pvnhDqEOLj5VN8kWpDxEGYQS5IcVG9a3Az2hUwybO6p5kVuc
	oB5sgsh6uPIQ2AGeAWt4oCi53/xkQ+aVEwzFNt3efxCPflDCmjbRLY5duOPOf17tecmXtf1BhiJ
	8D/bgjpr8+/VY+UgzTkC+2aRSRMKbTUkeF5R1isGoJNcI0zRutV3k+Qql0Wl+VxTmH/MWw9plxQ
	EoTWzyEIfMCgNE=
X-Received: by 2002:a05:6a00:4c0a:b0:842:708f:39a6 with SMTP id d2e1a72fcca58-842b0e1e208mr26244552b3a.10.1781101089493;
        Wed, 10 Jun 2026 07:18:09 -0700 (PDT)
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com. [209.85.214.173])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428288217bsm29061313b3a.37.2026.06.10.07.18.06
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2026 07:18:07 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bf3781ca51so62517705ad.0
        for <patches@lists.linux.dev>; Wed, 10 Jun 2026 07:18:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9YGifKO73+ni8Xov6aAEkhdOUNQ1qINhX//A+mPBkKOQzk5pNgTb6lN5GxuhDMfheHcCxZo+Y5@lists.linux.dev
X-Received: by 2002:a17:903:244e:b0:2c0:ab92:584c with SMTP id
 d9443c01a7336-2c1e8209b98mr287326215ad.25.1781101086478; Wed, 10 Jun 2026
 07:18:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=whL0oLvmh3FO9SapDhgrXMT_d6qkP2V3OBjysOWXod2Og@mail.gmail.com>
 <aijyuX14ahOf53zM@gondor.apana.org.au>
In-Reply-To: <aijyuX14ahOf53zM@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jun 2026 07:17:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeLy2n9H82_THob=wzOEfsQT_yP05ZH9qY7NTWgj2R_A@mail.gmail.com>
X-Gm-Features: AVVi8Cf89LEbA8IWp6kUXfdfvHtLXSvqRDQpEPExTR6LsZaq3LaagKRbHX8i3Yg
Message-ID: <CAHk-=wjeLy2n9H82_THob=wzOEfsQT_yP05ZH9qY7NTWgj2R_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: metze@samba.org, luto@amacapital.net, safinaskar@gmail.com, 
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Jun 2026 at 22:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> How about using write access as the gate to zero copy?

Well, it's too late now - no sane user would open files for writing
just to read from them.

And if the file isn't opened for writing originally, it won't show up
in the fd. So we'd have to do some after-the-fact "is this writable
using the credentials we had at open time" thing.

Which we do for some /proc stuff etc, but it's disgusting, and it
isn't how any of this should work.

Plus honestly, in any *good* setup, the normal case really shouldn't
be that the source is writable anyway. In benchmarks, sure. But in
real life? Hell no.

If you're doing web serving of static content, your web server simply
should not have write access to what it is serving. If it does, your
web server setup is simply hot garbage and probably riddled with
security issues anyway, because you clearly spent absolutely zero time
on any kind of "minimal privileges" model.

(I'm not saying that splice would be primarily for web serving or that
serving static pages like that is an interesting load - I'm using it
purely as an example of why saying that writable files should get
better treatment is crazy: it's not how *any* of this should work at
any level at all).

So no. We should not treat writable files as some kind of preferred
model for performance. We should discourage that kind of behavior, not
encourage it.

                  Linus
