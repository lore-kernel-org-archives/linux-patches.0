Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06E83A451E
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780329022; cv=none; b=Xana/EFlBdh5XMd8UNrbjcWzM0vy+8CA2dpCscPAY9VojUB4xdu2ZumZd+KHXQ7El4ADx/nNGkCJXDUMiRrJf26fAqNAGR2ecw0eYXltGGQ3C6gTvrjYBR9km5ytowSaNdL3DKEv+P1XbT1YXw5rpKZh9Dy2/twjv8kYy0EUfzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780329022; c=relaxed/simple;
	bh=nTXW1aszJ7vJwM4JLdG9/UwnGyXjFaGyj9QAS58OX2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qUYdlV9zjKFN9DPCv6vIemoe9Y7VzB+DhziPElGX2hKiBQ5ykqY1FSNxHiVbx0ZvbyZkozu8voi4s6LMbZ5OtcoxmfDxvpXDJccrnrL2RRvv2Xf1kbYfCdVU8fEPmIs2bg4tUUh/pGEkNRoENULGdYa/2048GZwdSonZ/jHYxyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bJ/sl+s0; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bJ/sl+s0"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bec441e4018so176121266b.2
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 08:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780329019; x=1780933819; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pJkQdYMeeClMSzcCqfeyFg/QAKx7SzNPdhAZ0oh+sp4=;
        b=bJ/sl+s06wYIgGuwuNuTeFXa5xWg/Ir1jg89gr8g3MdHptNNWV5Z/x+rQxw1BjeSuL
         FuJNtp9JVAaqd+CC/qLFFcjZAttxr6XBwoOvVZU127el/j+3DEki93CtcaT/Qba3p3GY
         SSy5+94Vjd8lSLV3A84yNKESykK69o6tXs+tc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780329019; x=1780933819;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pJkQdYMeeClMSzcCqfeyFg/QAKx7SzNPdhAZ0oh+sp4=;
        b=LsLDH/w7WyJrKol105s0Yz60lpbrFv7VSzu1ytH+LH3EV68VlcZBcEPl5ICCWSZvK1
         WHS6nLSqhvA2gIvLdQrwMpxMsrB4HNdtti0wIl0nckZzuLX1VFjRdkka4AXUcpr8qHLk
         g1QvvT/hICnkSZVq6IV2OvesboNw4dF5hcFra/d2bizlaLdwKCHo9ELiDdz1heSuJUZq
         dlLLtzlfgYMK1eO+T4NzWKfZ6Z2Z3UDW38bjtLHNAMNBx8AA/4FW1uosEGimFa9VQpmg
         n2jL9FvjxbxptzRDfF9nmZyKd2yb3t6qr5BP+6DF7BLSzQEv0ot61lvJzt8jpaRsGXjt
         w0Fg==
X-Forwarded-Encrypted: i=1; AFNElJ8+R3XOw0qIYnV3FL5zq15ZE5VqsuqfiFwWyIk4ot+CtWNBS3WaXNxlFnYq2OvcmP/LvOwmKlAp@lists.linux.dev
X-Gm-Message-State: AOJu0YxLapI5F2l/tNIOPAnKKYJeXByHPtqW4hiZvKuy7fdxMk9mM+Wh
	JEcAimASZ8WgQUvqh4f1thdJLXD6/u4vCd6iAEXyvQOQdeA1KEye1WbcUEOHyqTvPIaXTjX5+ul
	bkE+TDzo=
X-Gm-Gg: Acq92OHIFuSKMWCJi4o9UsflMd38r+KlFKoArHLxVwH15EyZU4Js5tbTksHzjiGAOPY
	GK6W8iXygRcBei7bUP3mORj6Clo75u5juaIB5vYD+FnBO5OWOhwnHAVOTcu4YaBhKVtme/rlybE
	UZKQOHW5gbvqh5ObOf5SLhRYMC6vq5D/beK7CDObkeBUYNND9gZbXdPwXPqOQOsGHKtcTBXquMd
	kZxveIIVRZp0rKoLO/1MtNJ5JVpxXjBCBBRXOOSNbxLoG1JFcKjVuBx6TRIGE7rCbVxbEHXcZog
	Vz8U7KjiLPgPhXQCGI6ld81dDu6zY6MxU3kXBtwV7ummVF3l3+SddlgGhtTm8kFAJ/EF9w+nLbS
	5bdDPmV1W+yESFexmTvub71WM2haprivyn5f4GL0rjPjcrvTDV6joEvNg2yXBFRxHbxNTvcF27e
	rYCiSSffrxP1DU01/JvWaV1ds8P+cLwJDpjHtLUVGoWgYzjakwaLKztfk03jO+WBW7E/AKx/siI
	toyoEknZB5KQCZpe5uw2w==
X-Received: by 2002:a17:907:6d16:b0:bec:bd4f:e495 with SMTP id a640c23a62f3a-becbd4fe861mr405596766b.12.1780329019017;
        Mon, 01 Jun 2026 08:50:19 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bed3169e2c8sm138468366b.1.2026.06.01.08.50.17
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 08:50:17 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-68d2342c5e6so2171774a12.3
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 08:50:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9J4xCRn87j2bSRStKvyXSXeR7Ui4YAcw+O8uZfhXslkE2JscLdNcz04CokNPCg79n6rOTqc+IL@lists.linux.dev
X-Received: by 2002:a17:906:2929:b0:bec:203f:7466 with SMTP id
 a640c23a62f3a-bec203f7742mr316403166b.8.1780329017245; Mon, 01 Jun 2026
 08:50:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com> <ah2nBAdsE5vVJ2PL@casper.infradead.org>
In-Reply-To: <ah2nBAdsE5vVJ2PL@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Jun 2026 08:50:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
X-Gm-Features: AVHnY4JDfRzuLw7CK_4gSBHmXbq5FWvfpfspaVnl7J1jkuJC1SncFOzqHbctZiE
Message-ID: <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Matthew Wilcox <willy@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>, 
	linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Jun 2026 at 08:36, Matthew Wilcox <willy@infradead.org> wrote:
>
> Can we review this series properly?

Well, since it pretty much is what I suggested a few years ago, I
certainly won't NAK it.

And the patches looked very straightforward to me. Just the final
diffstat is worth quoting again because that certainly doesn't look
problematic:

  7 files changed, 33 insertions(+), 204 deletions(-)

and it removes that GIFT flag that was truly disgusting.

So I'm certainly ok with it from a "looking at the patch" standpoint.
I didn't _test_ it. I don't have any workload that might remotely
care.

I did a quick scan on debian code search for vmsplice, and after ten
pages of entries that weren't actually *using* it but had lists of
system calls, I grew bored. So there are likely users, but I don't
know what they are and how much they care. It *might* be a big
performance issue somewhere. Unlikely, but...

         Linus
