Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234F72F6183
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 19:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761937926; cv=none; b=MY6qAPXOe5BbGnDSmfSsEb7j0wRdAwGQ8XVJ9iZi7f+UF/JYl76T308Eakd4stth+08xnAHnKIye3lQYGK7/fdIZuCt0K5DUav3hAO/9eUzCjKCpw71oBpNXL69iSBYAqMzIY7w2RcYLayr/nPLEMHLzd0MsUL6jg+Bb/co55RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761937926; c=relaxed/simple;
	bh=VW52jNshrh5SwG3OJpB/yIJkkVhz+nrrHyDT6wGQ7DU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpLyKrHl9QFC7DGWi1kQ89n1f97pR4ukJzPx/FsCocJvD7/kfKEfm9CpqOmh+hgshhHfd1iILeWIAYw8wuwMnltRgWcMWGcFxc6wcSUBuMulm9Z6CYDTJZZgOQBK37U7VoAtJY/jQ2SrC7bG9bZSC2TR6zvv17USWam+us1oMqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com; spf=pass smtp.mailfrom=ciq.com; dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b=Kby4/Ojz; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ciq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ciq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ciq.com header.i=@ciq.com header.b="Kby4/Ojz"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-89f4779fe03so243517485a.3
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 12:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ciq.com; s=s1; t=1761937923; x=1762542723; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yKR7crf4GwOivpvRLCbaBASd2D3y96XEYtat0+ID5i0=;
        b=Kby4/Ojz9pARIEGuENHbZiE6Spgj87UujJrx4wvzpz91Nu1rUhCRSgcIe3zaCGeVlc
         v4K6zCX7K0SO4Lm8oUbK7i/JU67snf3uS9QjeVLrWVqQp5OsAWfjQGuGZot9qNhdPxRA
         VAxPWtzt6VMiVqd9dkDEEoOgMCe3XlIQDz6D5gkwuJnpqqX3gp9mY+hZi1hpGHFTKfyP
         0gzd9sAJgbq5gmgMWx0Z/5g5+6HYxGngrKZAF1v6rLJcWQKF9Vd7xgM/yOWB++xfqAtx
         3a0+JVc9QBFtvLoe53mYjeI0dRQKY43hsUyjkupF0bI5sxkKbI7AxDyrZs9tLjgMQQkn
         vZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761937923; x=1762542723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKR7crf4GwOivpvRLCbaBASd2D3y96XEYtat0+ID5i0=;
        b=gZ6GTs5di/aZtSoz5+Kl6+kJeJrACfEsG8Vt8bH8a9HGJ6JIUW3BuhqkT/csc1ZwyJ
         G41CSyMj5oljaB6MVjSvirXK24y9RnSW6kQjWJZhiNYgZqukNiuMOOWxbyOMmzv0UDRH
         /7kvTkqQbuHgnTyP7OsWNGeITyYOM9uMNN4ZUk6mdUqnUAdRw4aW2X8pXnFTG8Bt4uGR
         yommc8dNnLInpvzpdEqRc0QPVtuDsmBYDOlp0mczkx+rSLoLoQp1EOV1Dnlenyb3UyQP
         AnB2NSQa9pPNCrsJ2kZM1tXUz8YNYehxZ+qtq5krN85WQ3nWfb6wUWKX5tjQHcUHNKkp
         M0Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUQGwNxKMcqsCLhn78KCCJVfFUShjEVpB28xx3FFuRyF37NLDOXsJQpe73//OZhmpeYkmEG/dWa@lists.linux.dev
X-Gm-Message-State: AOJu0Yw+JuSFTRjL0v/VQU8MCPodAVzl18CJLH+rIhSbfrakR00dPAqV
	ctgmXq8BDu+BFAahlZcBcZChKaieJKA4IZuDLT8nXxCI9NYUd3dEpfxzqSjL5b7XuHP6CFFo53l
	Fin0GuBwGloZymHY4IMJFeRLgylnaGpO38vC0nYUVpQ==
X-Gm-Gg: ASbGnctis1kkM/aVZwF9Nf7t7Celms8rT4CI7tw7UeIqImHntv+1iiGSAuJApYizVUi
	t4+87yzXKHTDlmtzvYMe74OCGK314DTz46/rC/ZFaJUo1MiDydDJbQbOrPLsRGPxiwK9wHgwy/2
	jxDHr74mHON48MqtL0qifiA2qBwMNp27yjBLe/RCT2nsDZ+y7gIExrM1WZ0nL4uq5kNOHH3EpWI
	IC407pJMjnm6Zo3JY26rffj3+RbfIyPkcGSESoZbNLx6H4i+o1WaRXmg9o9kg==
X-Google-Smtp-Source: AGHT+IG3iKrNw7U2RiWr5RCEwmcEiYiWNVXYOelNJaGUT4rwn4en67o6PjcX93opjYUMUdYHKXkmLkViJEygAirpqBk=
X-Received: by 2002:a05:620a:170c:b0:829:b669:c791 with SMTP id
 af79cd13be357-8ab9b2b5fb2mr518908385a.78.1761937922975; Fri, 31 Oct 2025
 12:12:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251031140043.939381518@linuxfoundation.org>
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
From: Brett Mastbergen <bmastbergen@ciq.com>
Date: Fri, 31 Oct 2025 15:11:51 -0400
X-Gm-Features: AWmQ_blubeC_F1ghhkUZnTlNc4Rapn6sY8JSKK6GBZ0QDFQnn6VHLBWB30ACz6U
Message-ID: <CAOBMUvhbgiLkKC7rhz02-+V6RySpirEd=6FzsBZDQQHf3ix+XQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/40] 6.12.57-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 31, 2025 at 10:04=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.57 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.57-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Builds successfully.  Boots and works on qemu and Dell XPS 15 9520 w/
Intel Core i7-12600H

Tested-by: Brett Mastbergen <bmastbergen@ciq.com>

Thanks,
Brett
