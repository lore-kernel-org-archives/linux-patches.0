Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533FE2BEFEE
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780330997; cv=none; b=bqFywLfVDqH47oCm8HgRj7TwdaYCfOVGlhvTcQb/blZLKqEUEkDkQxdRPUnwUaMtrPfKlcEiSb8QloipBjCaY1xt4ll0fL/cUJu9Ss9VwDIuvRbeFuE+eoHpoSqGaHqQP8UUfMIVBjy1jnFs9On8Ayn/zNCw3NpbUUctnxl6vAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780330997; c=relaxed/simple;
	bh=JHA8A2LqDoxqFwpttDeYSscr29A5V44SjxGPurj2m8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fCDxIKWy7jiiR0mzDs5bNjBZMSBBPHiQXjDMH8+SumroolLXedVHkJo3XNgzsAcECMWIt6xtuZGEOjBBygkm08koX5evq7OnM1E+GdG5ir7zmR28jMGnhBLqffAHUY9LIsTdxnjtC2OfyGfL8rGtBdlSWRx54hF3nHBm76Lu65k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ksxg2Mgk; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ksxg2Mgk"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6896c54a7easo9860311a12.3
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780330995; x=1780935795; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K5aZ4vAk82i6DVnbVmOCwCzllylMU3ucK3p4smWm5Ow=;
        b=Ksxg2MgkQ72ZKUvweap53hBgV2pprvEfQKQ6M03uNBQ3I81eczcX5WywDXQJueWaH/
         ZtmNQAnqTdhshNwnZ5sbjNgjrEheNKFzs9YvGv0tNYWMrUWWxeZon4dr++MnHEpxvHtD
         ttaKuxeDXOMA8yUSLM4tY9s+swGsBLiwapQQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780330995; x=1780935795;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5aZ4vAk82i6DVnbVmOCwCzllylMU3ucK3p4smWm5Ow=;
        b=UMk3LfZ9CJqSLYzIp2icCtnjE5MxbDdyLXvk50kimJK/GSBIs0RMFfDGlsiadc9HiC
         WpwkQT0l1MlGkG/ul6Apsa25b8/yBsY0keZe5Ky2K4Vr3CJ0MEs1w+o0X6Z9S0DTSpvX
         EQlO7Z8dvf/M+8mNRMFdQV1tPKmG0Xo1hvibcZtclPCWIRrLuOmvNJdGM6Lyz249gvVr
         PxU/xlWJLiIMVGKisUmM83LulUaL6B0GztxkSzPYsYdkXUYawRkE4tTh3Ma6eEfUZt0k
         N7nyLinFA/cxUhNuWWuJt/N7k09axuTVtxWyuGa3GLKMVgrAh8snscsh9FAu+9t04Uad
         cl4A==
X-Forwarded-Encrypted: i=1; AFNElJ8z9ndY/M1mOVKdsKBM3QMx1EjDoioQQdQzNNrDXHXer6Aiy6zcrLsGq33GoUbA7Gvf6DOYcCJP@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4dLC9qEFHlxBxQNy4w4bDBogsoJ3aTGphkVVkOp7DrOr48qjk
	gip7L05fqs02qk44rYmqXgJYlrw3JSM54rxTnUtIUoNmf481GqLDQ/Ni8oL8p5NWmQ5k+Q3/lOI
	HBT+9+Bk=
X-Gm-Gg: Acq92OEc/TyFOx0HTOImDwlQKFSGb1WE3tyHPCrtLdn1mq02oORNm7zv7zpjmj/wSy5
	JXMbziDDwniFoYnQgLSpX+KuKVYjUNJRnl8meHBg41KqjGQWau4WrHG3YlmWpgTVxu7wAMzMffw
	X+p6tTzXO1oEmj/mJZPs93luN7csoNYnsq7qrqW0aR191vO2kMrZ70J3iylWAKyn/UKNh9PzZ0A
	3QLy5ILXj22i5k0hsprdrYwqAemzJGkHPugziww6hZFRi8QYOMU4LTa7UT8exmZn7urj5wt6NFV
	xBGBh1jntyqNbHmDBaEVEROT0g9nPKgxzCE3QiNDsTwtCeI72XqGXZNSgQ1GqAIdzysY6auF7/K
	9iUiCaMub0Mb1wnubV/BIrSjmZlIhw9QbBVHXhFx1JsUtbZUJTqm0W4/I/ONKu/1OJ2fWovMKGR
	zeN6Yek1hjn9GrxBUEH0zsyOQE7CGHONLhWUjtQGZKpgBMVt5Z9xdKwS9zmT2nr0mySYWOBKkjM
	tSUEmQnufI=
X-Received: by 2002:a50:cc05:0:b0:683:1cc8:84a0 with SMTP id 4fb4d7f45d1cf-68c8d10082emr4397761a12.21.1780330994511;
        Mon, 01 Jun 2026 09:23:14 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68ceb85f9f8sm2308508a12.24.2026.06.01.09.23.13
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 09:23:13 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bebde89cfd3so240070966b.2
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 09:23:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+bDkGlIixkKbYzehnZPZcUL7nhDPuI+s5EubWHQjj8cKF4XoafosdCvX4OLMftsRIsq+tVXjZG@lists.linux.dev
X-Received: by 2002:a17:907:3d45:b0:be3:b3fb:e2 with SMTP id
 a640c23a62f3a-beab207a691mr724400066b.32.1780330992765; Mon, 01 Jun 2026
 09:23:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
 <ah2nBAdsE5vVJ2PL@casper.infradead.org> <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
 <20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner>
In-Reply-To: <20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Jun 2026 09:22:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1dSKpF=NMJmm9d-7kJY=BEVkchTaxsL1LGL3n89KtBg@mail.gmail.com>
X-Gm-Features: AVHnY4Kn-EiKMLw7r2InJ00RsvMx_ZNQz4aALUAoaty1wqi8l1c2ToY4hj4PgVo
Message-ID: <CAHk-=wj1dSKpF=NMJmm9d-7kJY=BEVkchTaxsL1LGL3n89KtBg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Andy Lutomirski <luto@amacapital.net>, 
	Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Jun 2026 at 09:17, Christian Brauner <brauner@kernel.org> wrote:
>
> As usual I would argue to accept it and revert in case we get actual
> regression reports...

Yes, likely the only way we'd ever find out ..

          Linus
