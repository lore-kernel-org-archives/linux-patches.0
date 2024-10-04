Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6F71C304D
	for <patches@lists.linux.dev>; Fri,  4 Oct 2024 15:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728056496; cv=none; b=E7Xcw0KX6gFC8R3or6XubkKQxuACivQNO7X9mkFK2DNR9+Z8k2oj6hliRUVeQ/Zy+J/aJu0gaYY6xH7+0tw40Gahzj7vW1crzpNL5xtkEo2nqEnRYEKRcCkkdmDmN8MxJIaumUkjNCbzGinyplTzVJcBsggRJI17IS5aC09JSgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728056496; c=relaxed/simple;
	bh=dJqcYDoZdMv4SCtPkgzGtLXt5PcyPXiz75/oxa/aADI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I90kkje4KmQIrLOD5hErE3heDom8lJKAOsPzvIM3SpDN2bl3r5nu2iWBI7PLZcnA8P2M0jpSiRDm6Unmu8BAW0RpdECyWjGRQu4STqYQjxXb8YVCRDshRswLyJF/gpJzhsOXlidj3Te1UP5uBz1Mo5dv0IM7L7jXFXKiKU2HeJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNgD6Ih3; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNgD6Ih3"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6e29c50ccbaso21025777b3.2
        for <patches@lists.linux.dev>; Fri, 04 Oct 2024 08:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728056494; x=1728661294; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ld53TKEHT8b3TSuRD204fFYTz9ezn3pJ8reFZpiI+8o=;
        b=eNgD6Ih35a+QlCM3wBP022qD7gvOIbb5qCwRQHSM2117f7BJ+pTrpuUm6Mwx5gaiEK
         TOzXLKcr9ShHox7X8jRBq7k+xGc2jJfJNactNu1zIokE0v1lRB0yZu9iIgT7PgBCcCOr
         bkcGMwCsSSeSDd9fvzzYampLyG4kTVEJlHLIJAJuIC1OaBeWREJ3nSY02rn+ohFnMiK/
         hi+FaHJQoC4b1bam0FtIokBn9YOdKB4YwhCRflArOAczTwIQtCNJsG/Zciev3xO0UXgl
         XE1wqt8gGftKoZEmWiK1aOuf+UxAV5pLJlO3mFiZD3mU6w7S1a/w5MdGiNJoJGo0NRAt
         6MTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728056494; x=1728661294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ld53TKEHT8b3TSuRD204fFYTz9ezn3pJ8reFZpiI+8o=;
        b=Xccq0DCyR0tuSUPYp3AZcNxLWmlOsOoH0WK4c3JpSSqQzx98XegpAoR/ya2sJDuKsR
         UMrTihQc5RW5wlw1FV0aL/BcL+quX6iFg9z5s01KbZFaxRgLSO17XFqzT971n3+NSzFd
         RIouNahDaNRjfEhvilg6tATfW4mpCWr3kTm2QsajLrH51wIZhS7Z5kB+EM4fbhpH2feD
         NTI8Kus23RJPMWWMGwPyTFHH1CqyOcwOxZ2dg94fCZpE/+Z5Bl784xnlnohwYAogJ0s/
         eUFXJcONWBMDiHs4ww1e274Yq2Xfd27negCOCflSNf3Zcyj+U2V5PCPTMqrSC3/RfFbT
         +0PA==
X-Forwarded-Encrypted: i=1; AJvYcCWPdbeROLmYKYAoXms2TZQvaF/zIb4qnsxZR6xw+V2Xa/ZBJwimu32o7bSRUoSS9hePj/Ea5MNh@lists.linux.dev
X-Gm-Message-State: AOJu0Yyz44QywiAY8/18EaSorFrc+lgrK4SFFUkPa2mYNdeSIvby8iDi
	qQr5J+Qp/kpXlPxGlkk9LS1VAGZKloE791c5C5mEoceNl7dvHIML2E2/ojAskNbSJ7XhRitLWLl
	ih6PddMOm0d45q3jKuwJijhWXHoQ=
X-Google-Smtp-Source: AGHT+IGmAHX5qOJKjfePGvgyCk94mzcfv68CQ5ZqvNqlsIkB21J1eW/6bT6b0FMpBRoy3DQZDXAbMHouQVFazdiqulc=
X-Received: by 2002:a05:690c:d89:b0:6de:b23:f2c3 with SMTP id
 00721157ae682-6e2c72412bamr31532787b3.7.1728056494214; Fri, 04 Oct 2024
 08:41:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241002125822.467776898@linuxfoundation.org> <20241002125838.303136061@linuxfoundation.org>
 <CADpNCvbW+ntip0fWis6zYvQ0btiP6RqQBLFZeKrAwdS8U2N=rw@mail.gmail.com>
 <2024100330-drew-clothing-79c1@gregkh> <A8D6C21F-ACAD-4083-900F-528EB3EB5410@oracle.com>
 <CADpNCvbKGAVcD9=m_YxA6qOF6e0kohOfVsKOqJeVmrYaq0Sd8w@mail.gmail.com>
 <2024100420-aflutter-setback-2482@gregkh> <CADpNCvYn9ACkumaMmq7xAj6EQuF6eYs174J+z81wv5WqzdWynA@mail.gmail.com>
 <2024100430-finalist-brutishly-a192@gregkh> <2024100416-dodgy-theme-ae43@gregkh>
In-Reply-To: <2024100416-dodgy-theme-ae43@gregkh>
From: Youzhong Yang <youzhong@gmail.com>
Date: Fri, 4 Oct 2024 11:41:24 -0400
Message-ID: <CADpNCvZTdxNsrqq-xOga38unKWCC_ZwB-+F1VprJumXiCmTD6g@mail.gmail.com>
Subject: Re: [PATCH 6.11 397/695] nfsd: fix refcount leak when file is
 unhashed after being found
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chuck Lever III <chuck.lever@oracle.com>, linux-stable <stable@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Jeff Layton <jlayton@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Greg. Yes, if a complete fix is concerned, it should be
backported. I had no problem applying those commits on the top of 6.6,
but I am not sure about the earlier kernel versions.

On Fri, Oct 4, 2024 at 10:35=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Oct 04, 2024 at 04:26:39PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Oct 04, 2024 at 10:17:34AM -0400, Youzhong Yang wrote:
> > > Here is 1/4 in the context of Chuck's e-mail reply:
> > >
> > > nfsd: add list_head nf_gc to struct nfsd_file
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3D8e6e2ffa6569a205f1805cbaeca143b556581da6
> >
> > Sorry, again, I don't know what to do here :(
> >
> >
>
> Ok, in digging through the thread, do you feel this one should also be
> backported to the 6.11.y tree?  If so, how far back?
>
> thanks,
>
> greg k-h
