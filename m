Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CF8256C61
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 03:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780283510; cv=pass; b=YiWKOBid3R788+IKtLqGEcwx8arDOiDs6HLDuKtOXho2Jh3//wDskS27t/Hma8H+ZlnrmQEt7B7+8tRyCRWd1pV7x/eS0aqgqRbFJ4cSAbiBODsi1d9giFnsXbcKAqd1u0Y5Xg5K9Aka+JP+85m76+LWSq/LyYjnnv98Rr1ZhPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780283510; c=relaxed/simple;
	bh=3MMmkUu/YfzDJCqhb57EOJIut04O28w1bNQaD8zFkqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q62GkQPFZ+DYu/znyqyyHT91YhKUaNyNtGwMKKnyxn4zd7Ue57bd4zl6Vs8AdZAAkqTHvP/eWlNEw2r3eAJ1/uF/HuUy5wbsMqxf+ykFhlqU/V5akxjhUJIi0sf8JGJCoYTYrfyaPSq1KaooJvx+v7pOUObq0bk6M1Pe4sG4slU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=O1kxGDjg; arc=pass smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="O1kxGDjg"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aa68dbb38aso643587e87.2
        for <patches@lists.linux.dev>; Sun, 31 May 2026 20:11:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780283507; cv=none;
        d=google.com; s=arc-20240605;
        b=gFYBtTtXl4wzeQQSKZ1bvDU/sf3tg7XtCssUhMmOIpgAAsmIHe6FX0FVgnGnypsSM6
         zS9e7jEDOUw1bIOkhbWhWOaYWe/NpA8zZz7IhP2zpOaKVbZMmqCByZJl6/Kx87HrmZjL
         aksi+WAXIXJ7as5nO/J+n6TGiCnu2vHBm8qqnKX+ax8nJTNJCWl/zKvy6RuQsio7ZWjU
         Hyk0+6k0TmFKiYFjjDh4Yx2R2wf4gSN83EA7nWDKwwXj52X24WKEHU81RllJ2+blN3YL
         oXEP/G3qXGHRMS7vzR+7wkrpWbBBJKzF5AiClG4nHJkkHNEoExYdPBx5RGALZME0/Poi
         QrpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MuDntok0/7oP3h0HaSkrbvB8I/WbSdzhW7ajx8MOkQs=;
        fh=lrHP4yQAvk++NNtiRa6uZzuo00ApxcSPEXG2nO8BD10=;
        b=XZvB6jUxZ7dQBP2g+ptGHpNLdpQcF4+5b72VCasvMTV/YIW89pQHdPK1IilmPc1aa5
         nWDP9ASMOqxiZ4+gRubmJSLXfhzA87gkIKR1krDPp61GyUEIIYW2Fq4PDoy67oD3Ac02
         bg5URMm1R6n9oOOMGB1yZQZx9l72B3QogUsGSqHD0PFUtJnpOW/JlGa/lDcRin5xuABq
         dOOVCIiNTTrYlO8ulOtM/btQb0oLmTPce9gb5x6r0LFYl3S9abUa4SpyZC7UUwZgKaIS
         US7A7uUisCILETd4tvuE4m3D/pv1WKKqFr2dFwGN78ytygOCyPZaLq+y1KNJgZTM3R3w
         0hVg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780283507; x=1780888307; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuDntok0/7oP3h0HaSkrbvB8I/WbSdzhW7ajx8MOkQs=;
        b=O1kxGDjgI1I+4S1fWdNwvyGqU0kOA7+SFDAOF8oh1qv4s4Ihy5yheLPLnErCWqgZ4V
         HLPTRkBOJ50BkXDpEf6s90AO0LvV3DhXxDMg56yfSYjm3ZFb3r+v57Wa7FyUARznxY0s
         6INWzoIxNlBeENHgOVLAOrgSaGkvk8MWNBaiKAxJLVHunGqphuWdcfw8Sf+KZMp8MVQb
         dxQdqETNaIT84oDsMEy8K4oVdfh20gMgqr86rMKMoudBREcNONyVxSUp8OWxw4Xx5fAF
         HTqBcA5ApTD/CwSdGSeHV46vWkc6XdJ00wjfo0nKjQGq8gE704u8o/KiPsPChI2HOQu/
         1n5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780283507; x=1780888307;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MuDntok0/7oP3h0HaSkrbvB8I/WbSdzhW7ajx8MOkQs=;
        b=SVia53TZ1ZAk379OfYv4AnRFqF5jnzIsanH3isPAAMPic4BG/PV076/ZpTEynOI/xW
         eCMmtVOcu9ZTMDPwlpCn7GwUdsqmIp5Rvvog1B4qebl2Ay2BCVyXHfdfOmJf0ct6n4ZO
         aJwFD+B0ho0PbHb5ZD+WTXapH/0yfTOpiNlbW4z0REGQ8RrL6e9TUVqD2kEhH8reBtuC
         GL9JbMiWiZnuc1SHHlTqiD+6X4l+quPp7Bj9SIubumRpFNYcpj5ZFogDZ0IanZrCRLpL
         X/h1VZIHBDS0dSv3H2PJsTF8Xj8czlRSQYNYx/+mnbdNooRJp3G6LOzkDy4axk0g6gp5
         Ukgw==
X-Forwarded-Encrypted: i=1; AFNElJ9jeDP2a3GMTkN5brGqorU+epsSyli0beHg/iphU1M44DD15pbLt+dG/gnuvzTWoldR0oKvf/ug@lists.linux.dev
X-Gm-Message-State: AOJu0YzNXXMUoSX24pZNeUupSTSlNOjuVsKwx+5I0OfFCUBk0fil2pAl
	Y2+todgyBz9kqBjW0+4CLUiYYMZvREPFeHHBSViQfRWLBvU52n+zF6T7EILaHxzuuVyg06sQ8JL
	B6rjYK96dYNL2GQOx8bkDZxwt/M2WYRbkgQDE6Oad
X-Gm-Gg: Acq92OGSWTNvdNeB9qrz5xh7DFrecmJti36NFdEePsPVQaDLECBww8YJpbYy7JSf+8s
	Say+XtQXS8WejWEaL4DD9DFA0ny8p+9fsedPA95DRt4cbcN5VW9aH0FTe4oSTmoAN9Pt+rvN6HH
	Q3D+emiVft+5pZpbOKMVyp8ILw4VdHzScvEmhhpz6J+lltNYr6y9QX+2F16K10LjXuNTeWgl5Pd
	oMOsymlAQdoQRyDQQirlXkI/BGT7ZLZifmc9Cq0KmXqRYQnTBAOGV/HY/L2ok90PfgMmkEvaox4
	e1+t+SV5/TrdJ44=
X-Received: by 2002:a05:6512:158e:b0:5aa:690c:662f with SMTP id
 2adb3069b0e04-5aa690c66e9mr1347657e87.23.1780283506595; Sun, 31 May 2026
 20:11:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 31 May 2026 20:11:34 -0700
X-Gm-Features: AVHnY4JXGlP1eBaFLieX9GEu2QC7fa8YTkX6sK3P-yG-Mx-u9DLHduWiKUrWdA8
Message-ID: <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 30, 2026 at 6:03=E2=80=AFPM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> See recent discussion here:
> https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
>
> For all these reasons I propose to make vmsplice a simple wrapper for
> preadv2/pwritev2.
>

I have no comment on the code or the history.  But I'm 100% in favor
of the solution.  vmsplice is a crappy API, and would be incredibly
complex to get the implementation right,  and it should be removed.
But it has users, and the approach of just mapping them straight to
pread/pwrite makes perfect sense.

(If anyone wants to contemplate how bad the API is, contemplate gift
mode.  Or contemplate that, if you want correct results, you need to
avoid modifying the memory until the recipient is done reading or you
need to avoid reading the memory until the writer is done writing, and
vmsplice *does not tell you when it's done*.  And there isn't even a
caller specification of whether they want to read or write.  It's ...
crap.)

--Andy
