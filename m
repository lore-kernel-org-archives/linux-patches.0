Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F9537104D
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 22:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780526981; cv=pass; b=pPQ2AjakqnLPM44O7dT75HhBY0qlatMb8OnXQ+xfDV1kEsPJMnpaD8kcp2n94QDaThYjwC0qekR9M0a23s5UymNDhAvHzCDPvJmgCmSpqc7OMDhQOMznbcdgNrXnTOV+cokGhCpGekxl3gFMeDc+UPmZDQ9bt3Df6ugWsdX+NRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780526981; c=relaxed/simple;
	bh=cIMAt4SxZf1p6upEqoxHSHb7RfP9hev2musbsbmwNuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MUCbSImOVojeAatQBa1neDqwOCs/xSyLjWXkqt+gvkKha6lb+tuNReB4g9W9xIA6WjDBU5VF6MTo9g1cARbWPwdPpvsAEHTTJJurmcZFPiEOSkMEvz471p3xXmctEA6RB2pUc2qyBXNtRjt83EyFm8HhKkQRtmfV1lKRh8XcKNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net; spf=pass smtp.mailfrom=amacapital.net; dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b=noq7r70h; arc=pass smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amacapital.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amacapital.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20251104.gappssmtp.com header.i=@amacapital-net.20251104.gappssmtp.com header.b="noq7r70h"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39676d82b7fso334941fa.0
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 15:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780526979; cv=none;
        d=google.com; s=arc-20240605;
        b=LgAPOnrL73/XojXmxzQzQQQJ4suXqWzz2jDGF3V9Cp0g2x5A+s089jkNY+BeMen3AB
         Dq0uWq8BAx0Rw9ME0ydwqRukt/kGNg+o0t0b0/kaK+qx8RrMjUIPgM+BhVAMfpje8VRj
         qO5BFLbn/RpP6WVHH6bw9mgVOnFB+3N0bArqvusxkFCmV6Q4G5R5PENtEZZZBHn99WUH
         6UFLYWGbPSE+t+sOWuBkIMCkmmb3JDGQLj92D6O/wxfFdvdydHlFa43Yhw2pz0Vw3gaF
         YnyDBM/kBzQ0RgSz7cpKz1WOyEJch76InE0kJx6/s9ySnQW7yraTdbP/lDKvyC8qGF0q
         Ig6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        fh=B1VKNlZity7cIAltZ8pS+0irEPFvU0iwWq7vtBX359o=;
        b=Dd94JYbFnL2iqCwyO9PPGiQX1FG1LFb5QOUvRjjE9b3iLF2B1Gq4dUyEOvB7u1RXDN
         XgEJegFRTIe/D9z58klZdPH2FCRMA/5lTOeQS7wkNpbjmKK9C/Xv92S2QAsrA4JeGYtZ
         iPDyzDwVTrVkFrw9lhrimQ69FUnlgwpxguuqltGIR7Hnwirb2ouu7XS5LAyrhXfj3tsy
         KwcOPKyyjBdxm9k3FoPfgP2oM7onP6/wvKkZ2YlJZGz44kHVnBIKwi8xoA2S/eSXKydc
         MQvASu3ZO5i1Ipc6piw60YpmnSKAdDD5TTkfXpMy/2dmSGkadN3oMvTb+ZCrTMFlk2WV
         f3pg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780526979; x=1781131779; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        b=noq7r70hF1BFCWQPsVoZh6wHd/SooH2B0qK+kPX8EJMISX9+stXbj5sirfRhecQrsd
         znCr/lcHh/dx6VDl9oO0X8VZseDu24h3yFZqZWn2vImlUj+5C9bA4VxNJKoiB7aEmIWr
         I9MiHdpICZsboARGqhkLQyvpnIJwWZtWh/4lyuCnN+lJX/YCCDBhkm4fHpzrfjZSKVvl
         5Mu5gk7OqEZcawXk6jDB15rK2OmFDPDbg3tRNELYSTvk7IbMZ3foHKYm9+eUllxOfvEi
         NItG6/+SdEKZdPkcTf3+Rk2EpkMKHkCUZMY+s0oOncNUhmuOi5FyqW61rntMXGmxYBlU
         4K5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780526979; x=1781131779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        b=GPAgGer5InPV1Gqa388zRv0SUvLi6mrBVHZxolYWIvmRougZlTzx211bvTnIjxVUQz
         FCEXaT+XKN5mFooidRhAUN4C3Hjn7FLxmkTEwQSx/nMJ8rr77tmfxWyMmMuOOK43ZZfK
         p0UwRxoy9JjBTS4RTCbaBMUUz4ChsAZl54aZ2gBrL6FTPw8uNtSjfSDKnwg2DmPqKF5e
         ZH/B1xaEEzJOgHO8sFKLgGM1IB9EVy2yLdmRMDg3P83jnJVmaidomQ4qrGhbCuBGFXE2
         /bS2QR0WTvl2RmN0675ZJw4CING9uGasLv2LxfhpLjlfrm/X/MotlZDxzrBweiH4Ui9f
         qrGQ==
X-Forwarded-Encrypted: i=1; AFNElJ+DUTRAUDQtThbYeVcHXFSLOnz3tH2Ryxt/0ogdN5C6iZ7954LPAbCnzTzTyWmA77P7U4ylSMph@lists.linux.dev
X-Gm-Message-State: AOJu0Yzfk7VuHLmORjaIPQOs2w2yuZv7nwCZDGz34GqCrtgwYSSokDaX
	60khcbnA5HZdUOCIfjanPhFpDxy4oY6SjTmfpgDCWwRPtGaFwNa0A73pHEn2yHzDpyfvX/vzYjP
	RI+fQCtj/REfH+lUrn0tNQTCvvEoK7Jcs1UH2QOj9
X-Gm-Gg: Acq92OFzl+GU1CLsIRyUpP2MNKpJhyi4UPhWrgqJIipd9DUeTLPNL94w+4t3Xpxyfkg
	S8t930ouMEZIeCZ64bHyxgSWefLCKbfDrqyvJk7kQaOxblvKVDbDg71HcH5TgyvsXi8td+mG0gC
	lMXSYw63hqceferpei5yOvAmz2NDpk49184aqsiTukKi3yDwf+iDUqyjV6bDVUWsmX+toF56YnC
	IEFrDnuTSmmbX7XZxrJeMZEDe/Wwez3UxFg2M8yKoykrcJ79Fe2QxMGYpPWOcu8+OV+11PFeuQV
	zgH1gt8IaArVS1oIz+s=
X-Received: by 2002:a05:6512:a88:b0:5aa:7126:c661 with SMTP id
 2adb3069b0e04-5aa7c06347emr1703733e87.7.1780526978614; Wed, 03 Jun 2026
 15:49:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <20260603224311.834796-1-safinaskar@gmail.com>
In-Reply-To: <20260603224311.834796-1-safinaskar@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 15:49:26 -0700
X-Gm-Features: AVHnY4LigDaMGEZAFdtnNoXIyXd96f1pywv43JDsz9J-Er1-wYhHVKm162Sc_xY
Message-ID: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 3, 2026 at 3:43=E2=80=AFPM Askar Safin <safinaskar@gmail.com> w=
rote:
>
> Andy Lutomirski <luto@amacapital.net>:
> > Maybe we should keep an API that does an optimized copy, from one fd
> > to another, that can send from a file to the network with at most ONE
> > cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> > for one.
>
> Yes, this is what my hypothetical future patch will do.
>
> One copy from pagecache to pipe, and then network uses that buffer
> directly.
>
> > But splice_to_socket involves
> > MSG_SPLACE_PAGES, which I think is a part of the mess that you
> > dislike.  And the path where one does copy_splice_read and then
> > splice_to_socket has to be a bit complex because of tee and (I think)
> > because splice_to_socket cannot assume that the incoming data is just
> > ordinary unshared buffers.
>
> My future patch will provide new guarantee: pipe buffers are always
> stable, i. e. they will not be externally-modified.
>
> So hopefully network code will be adjusted to use this guarantee.
>
> But pipe buffers will not be "ordinary unshared buffers".
>
> They still may be shared with other things because of tee(2).
> (But they are still stable! They will not be randomly modified!)
>
> But network code can do "pipe_buf_try_steal" and thus ensure that
> these buffers are not shared with anything else.
>
> So, network code can be modified to use "pipe_buf_try_steal", and you
> will get "ordinary unshared buffers" exactly as you want. This will
> give you in total exactly one copy.
>
> Also: as well as I understand, previously, pipe_buf_try_steal was
> kind of lie. It may return true for buffers created via vmsplice with
> GIFT. (I did not check this, but I think so.) I. e. pipe_buf_try_steal wi=
ll
> return "true" in this case, but pages are still shared! But, thanks to my
> vmsplice patchset (which is already applied), this is no longer true!
> So now pipe_buf_try_steal is absolutely safe to use!
>
> Finally, we can degrade tee(2) to copy, and hopefully this will
> allow us to always be sure that pipe buffers are not shared with anything=
.
> This is possible future direction.

I'm a bit nervous that, if I've read the code correctly (a big if),
then iscsi and nvme will still send *shared* buffers via
MSG_SPLICE_PAGES, but that normal user code will not be able to do
this, and that something will bitrot.
