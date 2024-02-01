Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EFF8665B
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 12:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706791442; cv=none; b=Oao4zSA+1Xc+imKxcVdQ9w/GDJ48P7YZ51KXwqhgJEPSL3WY7iG/9lODEbCUCFScNzxJoQJjlu8uzTwS4tOl9slKl+MgpSPwtQGzndj8Z6Djou/HaSHEiainibFgfF8J0wRPDk7hzVpIGoIs48WVoWlFJ/qzKFwmRYDDoU/gwNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706791442; c=relaxed/simple;
	bh=dEL0gc6v8FtcF06YHB8recoHi6yic+HuArz4FFcZTwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KbO7SgXXF/XMbIyOlGIKdnxMo3A+uDYZRC+UzYXGP4NlmGv2cbd4QsJx3Vz1WE3pvrP7/h8a4nkM1pBAIrFuzrgGafh1cGxaF5IO4xNPcftki5t5FnN8qj9XEBRZE7KHkE9FUUl/R70ZvIe8bYOluE8O7FC+gpkl66BEYpIOnIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=pass smtp.mailfrom=linuxtx.org; dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b=hiZn260D; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="hiZn260D"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-363898391beso2157815ab.1
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 04:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1706791438; x=1707396238; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkVTb1L2m6NuCmMShY81C/HsZ5E18+lzrF+Dzoy+HMg=;
        b=hiZn260DO9Y3Dt3opfpVO5gSxBbRUub47pj094nslz3A1V+jgJ5LGShUfC7d8KmwAH
         HI8SAe6Vc2PglJrNUqgoATGB1zQin2J5EI/4KSIgSZKAxBfWPku8JE1oRHArnzxTmTNi
         FOj1XBLUnq56mFSiP4SgvZj2qBSlLvAslzrfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706791438; x=1707396238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lkVTb1L2m6NuCmMShY81C/HsZ5E18+lzrF+Dzoy+HMg=;
        b=CkDEp76RfHRXhZTBisELQSAJz+df4Fp/6QnGdU+VtvhabOtmAatBBsZE7jWeLcWxC8
         GoFlD5CCnG2WRUsuziT3BlpVGir5RwrDYYR677QiEf/PkXRBJVaykbz8t5LsnF+Myp9d
         sRY0+lqpC9BcX8PEbXn/lG8Xkin55t2QqQKuU5VlhFjogIyAqJSPn9Z+zG76Q/ucPmxo
         C9Hj+yrSI6rWYBRd0rZZt9irzuYdz9ZkP4mGp649fN3caqvYYXlvrXcsuCdCSew7HDwD
         bwccQ3oWGZkfyHhkaFLA+CbT5dujdYToPCo2dnomwlBF3K9HFndGLPGC5RkORMpchIs+
         hVlQ==
X-Gm-Message-State: AOJu0YyaA31dcJ8BUZgscE9QWKUpBUBy1sBVufzAWtIA/5sy8pv+fjiC
	mfU23EJsuE9hrhZFrkYseFNL9ALtz0xx5yCLmKLNFJpJp6TwSRJ7KTj4k5GWwuxlA3TZvyHRdaM
	dKT2D
X-Google-Smtp-Source: AGHT+IFcMD8AhZqsPYeo/eYJvrzqkIjG0JkY+VNTvrNHttGydgbMdAuiS7HrkkWfeafwhwWdVD0dOQ==
X-Received: by 2002:a92:cd8f:0:b0:363:8e0a:83e7 with SMTP id r15-20020a92cd8f000000b003638e0a83e7mr4654628ilb.15.1706791438543;
        Thu, 01 Feb 2024 04:43:58 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUTcz28zl8MOhHJhE8Pj3SUIx7dGM1M1e9skAC5BsfQ0auoQOH8phfOXuA09r7idY4YDwrpoum3UkrkH9Ti8bQrrUmhMESpdg==
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com. [209.85.166.177])
        by smtp.gmail.com with ESMTPSA id t8-20020a92c908000000b003639d3e5afdsm665417ilp.10.2024.02.01.04.43.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Feb 2024 04:43:58 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-36380db83baso5329395ab.0
        for <patches@lists.linux.dev>; Thu, 01 Feb 2024 04:43:58 -0800 (PST)
X-Received: by 2002:a92:4a12:0:b0:363:7f58:ceaa with SMTP id
 m18-20020a924a12000000b003637f58ceaamr3070531ilf.10.1706791437923; Thu, 01
 Feb 2024 04:43:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240129170014.969142961@linuxfoundation.org> <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org> <87h6iudc7j.fsf@meer.lwn.net>
In-Reply-To: <87h6iudc7j.fsf@meer.lwn.net>
From: Justin Forbes <jforbes@fedoraproject.org>
Date: Thu, 1 Feb 2024 06:43:46 -0600
X-Gmail-Original-Message-ID: <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
Message-ID: <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command injection
To: Jonathan Corbet <corbet@lwn.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>, 
	Vegard Nossum <vegard.nossum@oracle.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 30, 2024 at 10:21=E2=80=AFAM Jonathan Corbet <corbet@lwn.net> w=
rote:
>
> Justin Forbes <jforbes@fedoraproject.org> writes:
>
> > On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrote:
> >> 6.6-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >> From: Vegard Nossum <vegard.nossum@oracle.com>
> >>
> >> [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
> >>
> >> The kernel-feat directive passes its argument straight to the shell.
> >> This is unfortunate and unnecessary.
> >>
> >> Let's always use paths relative to $srctree/Documentation/ and use
> >> subprocess.check_call() instead of subprocess.Popen(shell=3DTrue).
> >>
> >> This also makes the code shorter.
> >>
> >> This is analogous to commit 3231dd586277 ("docs: kernel_abi.py: fix
> >> command injection") where we did exactly the same thing for
> >> kernel_abi.py, somehow I completely missed this one.
> >>
> >> Link: https://fosstodon.org/@jani/111676532203641247
> >> Reported-by: Jani Nikula <jani.nikula@intel.com>
> >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> >> Link: https://lore.kernel.org/r/20240110174758.3680506-1-vegard.nossum=
@oracle.com
> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
> >
> > This patch seems to be missing something. In 6.6.15-rc1 I get a doc
> > build failure with:
> >
> > /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.15-0.rc=
1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133: Synta=
xWarning: invalid escape sequence '\.'
> >   line_regex =3D re.compile("^\.\. LINENO ([0-9]+)$")
>
> Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Python
> string escapes).  That is not a problem with this patch, though; I would
> expect you to get the same error (with Python 3.12) without.

Well, it appears that 6.6.15 shipped anyway, with this patch included,
but not with 86a0adc029d3.  If anyone else builds docs, this thread
should at least show them the fix.  Perhaps we can get the missing
patch into 6.6.16?

Jusitn

> Thanks,
>
> jon
>
