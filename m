Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7784E1BD4F7
	for <patches@lists.linux.dev>; Sun, 12 Jan 2025 16:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736699492; cv=none; b=jtOcSfQsxfU/gwp0qWJEyLmq2Ww2A0CuhDEGw1gLmNmhqK6H81Tm/5DB9nTyv9TGqI9ReFszHbUTL8eP+pCkRWivTS29O7EYNLco4+qENzgfWxsPIHiEULPU88jt1TazIIhI47zkuf3c54ZOQImXZ/ThNPPjoobO5a+XDPGvZXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736699492; c=relaxed/simple;
	bh=sNhMBhyL5w4a7WceXmC4Y8SPg2Un1Y6l1A1LurqGZGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y+2T54KQbpLU76R9Rkbmeq1joxJ7jYDJBnF/ohuzDg5W4yG7kxzITGR1oEb40Wcf+qNyBBt9zW007KSklYh8C9dh2NqjRz+agh52Kyt5MsxXkv47ZLTdVV/gtbMawTfuK5d8rIWumFSrxWX8vOu+i3P2tbmAji8n3HT6pt+kcF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QQWOZ/up; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QQWOZ/up"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ee4b72d4d8so749439a91.3
        for <patches@lists.linux.dev>; Sun, 12 Jan 2025 08:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736699491; x=1737304291; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJZjA7ddXBzmeJP3TDfTjmPEzR8WOsxrozUuiF8qE4w=;
        b=QQWOZ/up987RU8xXO3dlV1hmo0JPdzblTFrjXdX6DCnCBLwvHInTRMjxKhcA0h7CPf
         o+G8ZxkhjnwV01xpuf0shK9gEV7+JC7Q2zR9vIFTDuXEZ1aKLY0qLIIsUyqd9GAKw3/I
         axoLB8apkXAckhL+SUSIGS9lukAtn+659be2R/S87TYhKTliB5Jj5TsjHqq/ShKQumpM
         49cBMtp2Cb7UrnyQetzrINp+L1O73axXAnEzTwkXKqKtRwRopfossBtkEeuccLsJK98y
         zNd0jygOEq9z026rHHqjXUOOnQtkAMXN6n/E6OaNCGjleMJZ6MdvUV0vJwDx+X8DRtOC
         iA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736699491; x=1737304291;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJZjA7ddXBzmeJP3TDfTjmPEzR8WOsxrozUuiF8qE4w=;
        b=W8xIuLE63w2zGV4XF97fDEN7SCuTRV9SPyxbyZ0/ZmSh05bMWAeIRdze4Ce7sYq2p2
         nEe9HLwGT3pkj1Nr3IPg1Z09Oy8NXoyKafrR2od7Xs3uQrNiPEF7WmTzRWu16DKDDe69
         8+iWXqbtpokGfXq3HR+ojxY0wTl6B0MZq0pLTPDFl9vRFKvyn36fUvfdb8uq7y1LbSK1
         Rq74bwDQoYvhcwZKYxwVN8dGr26YUp5G1ZhCJJ0V8YBTJFO6C/MW1lWbvyWsuQo6Fcit
         QbFbLmV/FCxZ6hNhjir0kfWAePrBHHJaASof+rQ4Ej92KqDin5WTlFDLUa41a9ttitJH
         9adA==
X-Forwarded-Encrypted: i=1; AJvYcCUMFarWzfHSJIo/KHBTWEhZxbGqno6ZRD8rBO1EJ2od7fTNc30k/OFZ4UUAl3gnjKdLQ+bKnqTO@lists.linux.dev
X-Gm-Message-State: AOJu0YzFV7OpMZAK2RovUqVIbBKnhtxFq8t919ttK4NxsywMte49TMi9
	zQQ//P19ftlZ10UlUF4rK+cvRERkewrfyswdZBoYL8caGJbTdK3LS6XV8NWmJbi9kLmmrke4Kj7
	my6nz39fyNBYTxhxF7pJ5JbTt5mY=
X-Gm-Gg: ASbGncuwoaYs99Vwkob/XHsEy83UWEKkCcgrfjEEGeXCl2AghfXa84Co4tLG+F0B6wq
	nSvy2R2BHpXt2X3axx3tRpHkp8556VdoDu+frPQ==
X-Google-Smtp-Source: AGHT+IFvatJdCQrTlZmglBTHxzU5RtyJmkJmF3ypBMnAlLF8B+1fvlW2IreBFOBIelSfosCLqmMIfHeK3qQGFTqGaRg=
X-Received: by 2002:a17:90a:d645:b0:2f4:f7f8:f70b with SMTP id
 98e67ed59e1d1-2f5490fafb1mr10145767a91.5.1736699490780; Sun, 12 Jan 2025
 08:31:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250112152946.761150-1-ojeda@kernel.org> <20250112152946.761150-3-ojeda@kernel.org>
 <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
In-Reply-To: <CAEg-Je81VAYecajUjYVJKBJUT+YqKemWsWEoWFgOcF=vtfPRPw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 12 Jan 2025 17:31:18 +0100
X-Gm-Features: AbW1kvbRZqfo4lkp-4yUh14_r0u0RWQWyiMu2o_Vji7wu_AsRhSzINSQxGt7nXE
Message-ID: <CANiq72kQOrvi5=1RUScEpov79RNzA3vna9KW6MoYmj8XJZhpQQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
To: Neal Gompa <neal@gompa.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Sami Tolvanen <samitolvanen@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	tech-board@groups.linuxfoundation.org, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	"Darrick J. Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2025 at 4:51=E2=80=AFPM Neal Gompa <neal@gompa.dev> wrote:
>
> This doesn't make sense as a distinction. What defines "thoroughly"?

It is a call, but when you give a Reviewed-by, it at least includes
what the "Reviewer's statement of oversight" mentions, unlike an
Acked-by.

> To be honest, I think you should go the other way and become okay with
> people sending Reviewed-by tags when people have looked over a patch
> and consider it good to land.

I am not sure what you mean. It is OK for people to send Reviewed-by
tags. The original discussion was about Acked-by because that is the
one that was usually used by maintainers only.

If what you mean is that Reviewed-by should not require an actual
review, then that is not the purpose of the tag. Please see the
"Reviewer's statement of oversight" -- its first bullet says:

     (a) I have carried out a technical review of this patch to
         evaluate its appropriateness and readiness for inclusion into
         the mainline kernel.

> To me, Acked-by mostly makes sense as a tag for people who *won't*
> review the code, not for those who *will*. Blending Acked-by and
> Reviewed-by just creates confusion.

The sentence about "thoroughly reviewing" in this patch is an example,
not the only use case. The next sentence gives another example that
explicitly says "may not have carried out a technical review".

This series tries to, precisely, widen the use cases of Acked-by and
explain those, so that it can be used by others who have not actually
carried out a technical review. Still, it is not meant to be used
randomly -- one is supposed to be a stakeholder in some way (please
see the previous patch).

Thanks for the quick review!

Cheers,
Miguel
