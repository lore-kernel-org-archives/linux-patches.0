Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BAE1F4FAF
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729533782; cv=none; b=qjIqZydDs6xu1ARQzPA4Qn2aDq4fxj8lp6LpJGNNdMon+IVwm8WdHSAI54OUfeJkcy+x1dAn2A4T0YPh8VDKvKZddw+dMbBMsOqbzRjYFuswckxjoBu1EMcZ7V/p/80dLC9tzi4krbY5LpwPqqSJsiaZkXY6D75A0dc02h8VnTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729533782; c=relaxed/simple;
	bh=J19MNiUHxjz09NagV6grcNTkv8J39PZzUSF6p8+6fn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBADYIacYoj9mqucGgcM0/eAbE0Oo+H4zD4roZRNFOJTxqpX2uZHl40w6MZLwLvCFFt3KH4eg4DscaRSJZhBM82JdGYUFXbIVdCHSh2VmMsqXT9TDYoyuKCz+lTyqesrgu8oQETFXhib//RNQTkcK4Y5uYKTpUYulGIxnWwn8BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=im4tPaoL; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="im4tPaoL"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20ca03687fdso24885ad.0
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 11:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729533779; x=1730138579; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J19MNiUHxjz09NagV6grcNTkv8J39PZzUSF6p8+6fn4=;
        b=im4tPaoL4u0QFuqs4fCIHGNBpytHdqLsR7J6OI2GvrSTkEC+WqjRIZN+prBdg06IMm
         ZrMLrNT/tcUs/5a2EOkJ/lSOFJ51W42wPx+aAb2lzRmrFeRG+8/tAzDHf6vzzdaIN/qd
         +600A/kmaZs1SIsY/s+tR13AcMV9kxDqWYXvRvxFQEj3mXi3u+2YcJXoudyJvE24Vy4N
         Ik6Cjk+sPPCRQW4ymE2irszhdh6vJX44bQwX4dDPLfpMpkbnyDZk7LTUCpUzQB9zbi4j
         pTPhJoSnaxYpeJTy8Vbia6MwoGlv494lUSBcCKDjX1ub/OLKE705GZa/DdPoGKuvxHEy
         rDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729533779; x=1730138579;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J19MNiUHxjz09NagV6grcNTkv8J39PZzUSF6p8+6fn4=;
        b=E9a+prWE07kRbcleDImgdA+QCl8EeIq337dljDBri/KNBhw1o8ZM603umS9n5dYRVl
         RcIj8K6XMGGazwXEpwZsHNlz9s0Tixr4gzK4njVADlbFLXO2ooDUXRKMTE1pyOFuWDCi
         uoQl1vQlJZKNTvLjChfFwLL1ngZu+MxUmz/Mftpm/7oRlgJCA6HAlt0e6uV/sagxql48
         pllaoeXOdBGUBovgk4APInazyjM+4MD8hx/fFjR/VGsBA7iBnQJK0ft1YO01YH3j90Oe
         9Thv0wZ6cE301Ur34M7BOqHnyFmjenlbWIoytR6wl0z5VyUQS3OnI8MFoYMecvOKbbP7
         2rtw==
X-Forwarded-Encrypted: i=1; AJvYcCWqDCTqZqon620XaanSZ6/J+JCOHa2V3WGihbOQVxG0Ydjd2pnOhzAvD3ekgXKw+USQFvEaAoYm@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7t04tr4nFGncZAHMio9ewDzk1bXFqRjTmmhsfjmxlOwCDRMQ6
	B2J0AIKYyX9WkeWr+FgeqG+9KaBuPGSu6foniSxVk80u97B32xPzPE/Rj4V7/AsnZmDUjjtAY/g
	GuyTxVW7R2twwI7sOlMN17N/ix47fiKI/hUOgm2pHf3vsKwgNFA==
X-Google-Smtp-Source: AGHT+IFmFhNHZRSDbSAMKnQuKoWQssmM8a8RblG05nG5RF0TSMjryrP+J2Dt9pQ+iUKjrbbqDcnp+2Y0mWlDGvok5/s=
X-Received: by 2002:a05:622a:586:b0:447:e59b:54eb with SMTP id
 d75a77b69052e-46100b99091mr204681cf.26.1729533766832; Mon, 21 Oct 2024
 11:02:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021171003.2907935-1-surenb@google.com> <20241021171003.2907935-2-surenb@google.com>
 <2024102104-paralyze-voting-973a@gregkh>
In-Reply-To: <2024102104-paralyze-voting-973a@gregkh>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 21 Oct 2024 11:02:35 -0700
Message-ID: <CAJuCfpGY+yucNvqoqebQX+oOMqCgN7T5EOGh6KWTbf5+95P7bQ@mail.gmail.com>
Subject: Re: [PATCH 6.11.y 2/2] lib: alloc_tag_module_unload must wait for
 pending kfree_rcu calls
To: Greg KH <gregkh@linuxfoundation.org>
Cc: akpm@linux-foundation.org, fw@strlen.de, urezki@gmail.com, vbabka@suse.cz, 
	greearb@candelatech.com, kent.overstreet@linux.dev, stable@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 10:45=E2=80=AFAM Greg KH <gregkh@linuxfoundation.or=
g> wrote:
>
> On Mon, Oct 21, 2024 at 10:10:03AM -0700, Suren Baghdasaryan wrote:
> > From: Florian Westphal <fw@strlen.de>
> >
> > From: Florian Westphal <fw@strlen.de>
>
> Any reason for the duplicated "From:" lines?

No, just me incorrectly formatting the patches. Please feel free to
remove the duplicates. Thanks!

>
> thanks,
>
> greg k-h
