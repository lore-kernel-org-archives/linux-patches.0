Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0AA16CD39
	for <patches@lists.linux.dev>; Thu, 11 Jul 2024 19:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720725482; cv=none; b=VGZk6U/rO95xQQ0vVM1nnjjcpgCFeatPtpiyLnOtHEkWhEQrRIQx5twPeizh8PwUkZqaTZUR4rMZDJA0kqvJmDCSuDPD+iuRHjpQ+5K8Wx4X8jj7VvL4yXNxoWK5VLPLBTV7Hg83JOUzzUjRNEnbM72e6yapniVy4cu8/79RuCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720725482; c=relaxed/simple;
	bh=jml2mH5xPX6WLHw6QUqvLqc4gm8iBoTV1e8ILzGXDOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZFaMIb3KjcKd4nHEYr0Px6X5Q7Cymmq3EHVGuoetJJZYy++WDVqmDiB0dGvYB6i4bI+Zyh8srdcN6RUDBdhUzKyyWC071lTtBg//a1cpoLjKuUP54Y1l9Cjp3w01ZscfwUpvUjnU2H6iUe5AA94HYK8zVFUYRXqnIfgUquoFoVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IKLDHp0I; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IKLDHp0I"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a77abe5c709so163450466b.2
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 12:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720725478; x=1721330278; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PfkbCy6IC8MM2ShGGRIr/7yv5osfVo7ephGJ4Ll7hD8=;
        b=IKLDHp0IoiEnFrllPdu+xeT4zFeABx/+DhAsZSbM/gvpaPZeMPUy27Z0fk5W4xt8Py
         XhgG26cxc0jqEjUvrgWweMSIo0Fw0Dy1hJAoxJuXlLrU3+qTjXewCxOsVbQVM5DV7T6E
         NIChKYWakCtLSMIpVlcn/VgMrPX58pxKQaR3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720725478; x=1721330278;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PfkbCy6IC8MM2ShGGRIr/7yv5osfVo7ephGJ4Ll7hD8=;
        b=OmTR7HACcJ+4Gno71Q/MilcxQRWN4i57Kx2Bp+TKoy7Ptnc2LBqmZoIDbmB/77n8Hd
         C8minIriCX1NamYNsTFbYC9Cr9qZn4cyn7x93/E+ZOXYivl2jEIc1y4+QXCgd0JEdS0Q
         SPse5hrPbW73f+tsRwu8wLnTvhAHmD7xgqE7pAQdKNYwgGZbfhNArTuRYW1C20PnQh5E
         oQdIK7N5fp+xEor4ewHlSiEoyq1zrRyGT4vi1JD3frANm+UlhdfxQKZ0hIoCubQ00FBh
         v6Bw+R+e4slLfI9ylAg19R0RAA1KANd1vMzCO0uzHPFjsyx1ikJoLz/Ba0I6gHqY2ZIj
         M2hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNk7Z+r9fENMyEpfWJeAJV9io48EtwPj6BuJyN0tiY3cl0Y4tsOrtwLOKRh0sLrM8bOz/cnidjMNEN+hFYyVn5DJFuBx1WTg==
X-Gm-Message-State: AOJu0Yxut0jaJwfn0vUtyFz2tbZw4Cto2bz3SX46XkniS+aE6pVWTY1k
	2UdyKbZIKfBSz2Ju4KLeNX6atPjkIrBLCmEVylK4KQ4MUAudXucsoe3q6O9bW9Mj9PrLhycWdOB
	syuRtsA==
X-Google-Smtp-Source: AGHT+IFKmDK2/3kuyO/4rio0prqkmomqDjQIx5MzIaNgxYUGAh8eHgJDuJxmGq5voP7jP2lqeh+28g==
X-Received: by 2002:a17:906:2bcf:b0:a6f:6803:57ef with SMTP id a640c23a62f3a-a780b6b1b8amr596472566b.27.1720725478682;
        Thu, 11 Jul 2024 12:17:58 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a6bc86bsm279263466b.31.2024.07.11.12.17.57
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jul 2024 12:17:57 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-58ef19aa6c4so1597893a12.2
        for <patches@lists.linux.dev>; Thu, 11 Jul 2024 12:17:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXvKpKFxnn9/mmE+QyzfnPcDvcYkxZ9D1wuIj7olyl5SeN9jmVdI5GDacZ8DSLVO6L67Ya/NXyWeY3rrNhqxpcBfN2rSkzbXA==
X-Received: by 2002:a05:6402:2707:b0:57d:10c:6c40 with SMTP id
 4fb4d7f45d1cf-594ba98e3c7mr6937905a12.7.1720725476855; Thu, 11 Jul 2024
 12:17:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709130513.98102-1-Jason@zx2c4.com> <20240709130513.98102-2-Jason@zx2c4.com>
 <378f23cb-362e-413a-b221-09a5352e79f2@redhat.com> <9b400450-46bc-41c7-9e89-825993851101@redhat.com>
 <Zo8q7ePlOearG481@zx2c4.com> <Zo9gXAlF-82_EYX1@zx2c4.com> <bf51a483-8725-4222-937f-3d6c66876d34@redhat.com>
 <CAHk-=wh=vzhiDSNaLJdmjkhLqevB8+rhE49pqh0uBwhsV=1ccQ@mail.gmail.com>
 <ZpAR0CgLc28gEkV3@zx2c4.com> <CAHk-=whGE_w46zVk=7S0zOcWv4Dp3EYtuJtzU92ab3pSnnmpHw@mail.gmail.com>
 <37da7835-0d76-463e-b074-455e405b138b@redhat.com>
In-Reply-To: <37da7835-0d76-463e-b074-455e405b138b@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Jul 2024 12:17:40 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjVc6cpSCJwAqrhPvwBbcQEOL2TEnCELfadhA=n1GN4Ww@mail.gmail.com>
Message-ID: <CAHk-=wjVc6cpSCJwAqrhPvwBbcQEOL2TEnCELfadhA=n1GN4Ww@mail.gmail.com>
Subject: Re: [PATCH v22 1/4] mm: add MAP_DROPPABLE for designating always
 lazily freeable mappings
To: David Hildenbrand <david@redhat.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	tglx@linutronix.de, linux-crypto@vger.kernel.org, linux-api@vger.kernel.org, 
	x86@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, "Carlos O'Donell" <carlos@redhat.com>, 
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <dhildenb@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Jul 2024 at 12:08, David Hildenbrand <david@redhat.com> wrote:
>
> We also have these folio_mark_dirty() calls, for example in
> unpin_user_pages_dirty_lock(). Hm ... so preventing the folio from
> getting dirtied is likely shaky.

I do wonder if we should just disallow page pinning for these pages
entirely. When the page can get replaced by zeroes at any time,
pinning it doesn't make much sense.

Except we do have that whole "fast" case that intentionally doesn't
take locks and doesn't have a vma. Darn.

             Linus
