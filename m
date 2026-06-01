Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58AD53451C6
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 06:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780296091; cv=none; b=BXlkkQDyPSu8Naglyqr96kJTKhMgyloM3WYV5jZgNW3mCd0tkcj2KuCBfunQdJqLUIdElCv6GIhhRn8y/vf32WqEjdSmVddG2Y4YtQCzzcyvzV9czpoApoKobHOYtd2k6qw50bZWI6JfFuuyu0c1W7FY7vMhCTf4GhQmSLuRqN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780296091; c=relaxed/simple;
	bh=JKr3Z0kvyM5THXu2zQIiY1on4STp7BRu77YEIZYjAyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uwo+uhoPtfujONqoWkoJT4P/QB/ESiVzmUNwc7VpXS3K1B+1M97d5JN8NdMKBNJVsIecqKoKlyMu0ZS3ABLXwWssDUAXiERRcUsGh6OUmBw8wcWNoRBLkvuKjBeld4sK4IWYBEc3kssT8vwqLo9xti19uyVGsQM2hKi/K6DRfLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=HsG3x0Dr; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HsG3x0Dr"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bebac79fff8so119017666b.0
        for <patches@lists.linux.dev>; Sun, 31 May 2026 23:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1780296089; x=1780900889; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=grkecyCDjbFeNTHglTGH7ZaSe0hCCHo9PMK+wzDd0Ts=;
        b=HsG3x0DruvEp8hpYgfqB+8xHaKJ3uEOiKREg8rBp2iVAvErAmke42WH6mt11pU4eTv
         zR18HwtixNOUaV/SNYgd/zjyx+/0p8/85HBCaqSH9UHtJm7ybpUyIRPJMSR7ZBGIaYMV
         YkXdl3v7hkSfr6Vintzrh4Fq7ieTNhWk1l+ZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780296089; x=1780900889;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=grkecyCDjbFeNTHglTGH7ZaSe0hCCHo9PMK+wzDd0Ts=;
        b=tYFB+0e7/X3h3pFt4nBavRWdk7IdiZvXHTpztyWQCwd/OMnuI7a4Xl2VZw+LwhJaC9
         ZuxhbSE2cIqdPlkDlzAPoq/hoL9Ga7X7PlTIqySZwnkFDRQdgVYgxxWo3eXIsKlCdv8g
         P+JOTC2CaVPh0oALVeOTh3sfT2xINNJbeKVlAuLohBqqYvKgyB4qpS6zZ4wBkEOjVS5L
         qanLjLXYwZeIyyGlYRdUwjSZPFDJeCUG8xTDqJT+H2GQXLlhU6dxWKWvwMXs5O/OOhzO
         OVDW7YVyE69DHvPnYOJb+K9oHR5ZF21bsju69E9NDBocJVJyC7gUsJy3kOSRZoc6X97Q
         1TFw==
X-Forwarded-Encrypted: i=1; AFNElJ+43m8WaciJEif+ms1pgZb3LwV1mDi8iA3U9BTmm9VcFvwz3rHM/Ydu0QGN7eLoS/VQJZPebcPZ@lists.linux.dev
X-Gm-Message-State: AOJu0YyW6lFyt68vNdntxJhAYt6hp3vSVSntTNdlOHn+a67ZGwLIwWLc
	X2jd9gsTogN9VEBz5FshFnIeS260GVvquUgDPQIH7YWXdJF0lPcNkJJpe0rOwkuJgbDCCyynlYG
	LsarnRg==
X-Gm-Gg: Acq92OGcTnVsKW/grEFCR6b5Ap9bM8PDIC/wA5fj3BZwiyP29i7n123PTRQoxEWgJ4k
	HpQOPoAAOBdyog/SnQeDIfGjLArHxPoDN/oeLIw5yYg1FldxHys5bulNKEQd6oy2QfeTkYTiPD+
	gy57M2MaVYp5eyih8EToWGaSz/G8zFZnpQoh8cc4MtGivdt5gTnpUufaBrYGKl/kXE1a8W2M0Fz
	rOXkPMO9FnVf5oMEcRte4ahfQk2dseXlnucasxwRt9g6Rwks9lQiwyetdPgzRXJP5yHnX3QEKib
	VkJljnQZu/W4dPaWxa2E7XCCdHevoQQHXB/tB8frLtDtz11wEB+uCMsUBE/WyZ03UhvNFUAgHjD
	xcf04UBmg0yC5HO0aU+TzR1VdYthIwJUyTqwVT/Bo52jpTwLNvB5TcA791yQbeDpOiYbfT4yrcS
	zdk02qTKWh0ECEbO8C+L1Ko/fuAJhROwaTSSBWEFj/aCvp9g19QuH8dm5XgZKehasv0qwu3a8=
X-Received: by 2002:a17:907:6d16:b0:bec:bd4f:e495 with SMTP id a640c23a62f3a-becbd4fe861mr237107966b.12.1780296088588;
        Sun, 31 May 2026 23:41:28 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-be9d6cf9adfsm307844066b.62.2026.05.31.23.41.27
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2026 23:41:27 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-68d2342c5e6so1332303a12.3
        for <patches@lists.linux.dev>; Sun, 31 May 2026 23:41:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8TXIC9BlnVQugi5LGZYScYl445mWBPwxeeCDYISvwvGW3cp3WpPD50LdlQ/XGXTV2/kxssP4fY@lists.linux.dev
X-Received: by 2002:a17:907:3e0a:b0:bcb:66df:819a with SMTP id
 a640c23a62f3a-beab1e809cdmr487255866b.40.1780296086476; Sun, 31 May 2026
 23:41:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260530160224.570625122@linuxfoundation.org> <20260530160226.496219768@linuxfoundation.org>
 <5e2ac444-451c-4220-8013-0e6382b5f165@pobox.com> <136f03aa6f51bdfecc786e5278f5fd03b4a6966e.camel@decadent.org.uk>
 <20260601015021.rc-uvcvideo-heuristic@kernel.org>
In-Reply-To: <20260601015021.rc-uvcvideo-heuristic@kernel.org>
From: Ricardo Ribalda <ribalda@chromium.org>
Date: Mon, 1 Jun 2026 08:41:14 +0200
X-Gmail-Original-Message-ID: <CANiDSCvh6u6AWnarEtso=zKPD3upEsaJBMOm1x35fHyPMaEMyw@mail.gmail.com>
X-Gm-Features: AVHnY4J7eEIEPEY8n4veiWY6QsIg61l11iuaxssDhuKBbjpiPm_kh5n0oDz1rwY
Message-ID: <CANiDSCvh6u6AWnarEtso=zKPD3upEsaJBMOm1x35fHyPMaEMyw@mail.gmail.com>
Subject: Re: [PATCH 5.10 072/589] media: uvcvideo: Use heuristic to find
 stream entity
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Angel4005 <ooara1337@gmail.com>, 
	Hans de Goede <hansg@kernel.org>, Hans Verkuil <hverkuil+cisco@kernel.org>, Ron Economos <re@w6rz.net>, 
	"Pavel Machek (CIP)" <pavel@nabladev.com>, Brett A C Sheffield <bacs@librecast.net>, Mark Brown <broonie@kernel.org>, 
	Peter Schneider <pschneider1968@googlemail.com>, 
	Francesco Dolcini <francesco.dolcini@toradex.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jon Hunter <jonathanh@nvidia.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Vijayendra Suman <vijayendra.suman@oracle.com>, 
	Ben Hutchings <ben@decadent.org.uk>, "Barry K. Nathan" <barryn@pobox.com>
Content-Type: text/plain; charset="UTF-8"

Hi Sasha

On Mon, 1 Jun 2026 at 04:11, Sasha Levin <sashal@kernel.org> wrote:
>
> On Sun, 2026-05-31 at 12:53 +0200, Ben Hutchings wrote:
> > This doesn't properly fix the problem.  Commit 3d9f32e02c2e "media:
> > uvcvideo: Create an ID namespace for streaming output terminals" (which
> > reverts this) needs to be applied on top.
>
> Rather than carry the heuristic and then layer the namespace rework on top
> in 5.10 only, I've dropped this together with its regression source
> 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id
> UVC_INVALID_ENTITY_ID") from the 5.10 queue. That mirrors what 3d9f32e02c2e
> does upstream (it reverts the heuristic), and avoids exposing the
> 0e2ee70291e6 regression that would otherwise enter 5.10 in the same batch.

Are you going to apply:

Commit 3d9f32e02c2e "media: uvcvideo: Create an ID namespace for
streaming output terminals"
?

We need either that patch or this one: media: uvcvideo: Use heuristic
to find stream entity

The namespace solution is cleaner, which is why it is the upstream
solution, but both patches solve the issue.

Regards

>
> Barry K. Nathan wrote:
> > Comparing this patch to the corresponding patches that went into
> > 5.15.203/6.1.169/6.6.117/6.12.58/6.17.8, I believe these Tested-by tags
> > may be incorrect.
>
> You're right that the tag set on the 5.10 backport was over-attributed
> relative to the other branches; since the patch is being dropped this is
> now moot. Thanks to you both for the review.
>
> --
> Thanks,
> Sasha



-- 
Ricardo Ribalda
