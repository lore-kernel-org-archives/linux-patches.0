Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7D91FF5E3
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752096611; cv=none; b=rkxxiPUFqFX0bH7cd9ZAs5uQeO1PWycN6XbS2V9PPtAcqKt5Ua4CTeDiIUJd4sO/tuspqAYaOzJUTU0nye+tdRPlQ43SdxsNAf2ka4Hy7h3AcmK5ScP3RObY5Wk86epZ01vuq8E9a+umQk553sqcn1+ygooUpEWYzBlQsndTibg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752096611; c=relaxed/simple;
	bh=3AKXY6KIFSkR824wpfOMbdEKHzSAI9V2/86D74V3JQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QhSsIb3WaVQd2+qWFxpsyvvb0ckC9R/daaxuo346Zmjn+ozkbufp3e8Cpb8ABogE6JoK4kNz09C/ueO7tVjyak/RRrelREmhV2ySf4ABsdfr9IMqNjPe6PH7nKcP9qKqybN8SXYYskh3xgdEcQsXUwStwPlRsZ6SSkq6HcN7uXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=frame.work; spf=pass smtp.mailfrom=frame.work; dkim=pass (2048-bit key) header.d=frame.work header.i=@frame.work header.b=uznmbr+1; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=frame.work
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=frame.work
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=frame.work header.i=@frame.work header.b="uznmbr+1"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e8b3cc05665so233894276.2
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 14:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=frame.work; s=google; t=1752096608; x=1752701408; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3AKXY6KIFSkR824wpfOMbdEKHzSAI9V2/86D74V3JQg=;
        b=uznmbr+1y5AzBuZxcifnbtxyE6O+TNpmSYMN2q0gkp3kO1F3LT74I5uR7u3PkxGtJ0
         EyDkzAhVYgy/OoP7kfjvCGcPhvoR3DXr1yfhkJC3yEoedIeyrlJNMzqWMXuQaK9nbJtI
         JSK6G9NzD3PXksrNTo6oEj2tTCdGz5h7dKx9Q7EPtx6nXUzS9IAotl7rX2NiF8bYWjcD
         TMqIC4fhovasuudxBe9qyUsAQOUPrIgQRKoBOkvNGMzGSvCtUcMHP7fFYn/iTgwhf0ij
         rcIlIkC78iECCg0aGv6YQ4iV9r1TMbY4VoK6YRgsyQ2orw7BjkYNtXt5CwPn5Aq94uJ5
         iu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752096608; x=1752701408;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3AKXY6KIFSkR824wpfOMbdEKHzSAI9V2/86D74V3JQg=;
        b=kRVZVCed2Is07DgxVnu+n5OnzgambydsP2suWBJ/UTqwPn5GWiqDBssRx9NqCh5W6v
         dco5+o5szo2jDSULuwywwZisA3MQyftE6uGxQnaVzcTMoWgJBBhVjXcetuzp3npy2wwM
         tJPJG2id5RyOzLqeBO4tBAq68QtP8ci+WExE+pfoeZfOccv8QVU/U8NxVONLAJ2jCVaA
         viUmyugSGB8Y5F2X2Ix+VeZloHTNJGb858cS1vTZzzRU/2QYZ65uILgjpEv3VLttsyEp
         fphp6TCCo1pN2+zEoWBvg4kRHCR8BHMsXlyoop2zxxDILjxWIZvWMxhdEWjbuDDE1S7F
         iqaA==
X-Forwarded-Encrypted: i=1; AJvYcCXip1gG+UN5plK1zG1buQcW/gcOgZNvwD8DxIkMUfNSB6CruzTUB4+51O+1c+SHcLt1kN5oQ7qI@lists.linux.dev
X-Gm-Message-State: AOJu0YzbRnen1mdvniATFJQga0Y/JT/HQn+7vi+FdK9EMiZ8T6mboEfl
	SrMqRbIgUtC+gpd6U+emyhPGN6DLxdxjhJhNWp1V3SOWqB/LUgOIT+DPebMoNmPXhOIx1Lyhkcb
	pOh7FcITE8NtiLaCDME7P1rACtE+renbcgB0BnAyv1A==
X-Gm-Gg: ASbGncvOBWnlNFad0qzeb/+EwEFim5YBidTJw5boxlq1PolcRldCoRsWbTWh557xa5/
	mrJbWAg0NqLWGgEZ8QQ+oH62pX+UgCZMffniXjSDlD2w38W5+qgmqT9e7WyGUw7QRT+20sbiDJM
	yiJxAqM5K6P2Q8fCxcwAGt8VoWQQODtoXawAnA1YwPvw==
X-Google-Smtp-Source: AGHT+IFA/TyZV8EGMF9IO4hNKLPs7QqkYpSA7lLh6/jJatQA3DN6SKf0unViUObnrSN6U2H3b26xG3/2UTAwiVdEKWo=
X-Received: by 2002:a05:690c:640b:b0:710:ead5:8a95 with SMTP id
 00721157ae682-717c4652de5mr6850687b3.14.1752096608346; Wed, 09 Jul 2025
 14:30:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250708162236.549307806@linuxfoundation.org> <75a83214-9cc4-4420-9c0c-69d1e871ceff@heusel.eu>
 <2025070909-outmatch-malt-f9b7@gregkh>
In-Reply-To: <2025070909-outmatch-malt-f9b7@gregkh>
From: Alexandru Stan <ams@frame.work>
Date: Wed, 9 Jul 2025 14:29:31 -0700
X-Gm-Features: Ac12FXwEdWtlHSc6c1BAt6plMlo5XE4LaJAIba1E3cFVgzAQ_-C7cnhnPzezAR0
Message-ID: <CAORQ5J5my3cd-nb=6wJ68s8wJ5BPi+JSu1Mo7JdHiLTD+XnB6Q@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, linux@frame.work
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Greg,

On Wed, Jul 9, 2025 at 10:20=E2=80=AFAM Christian Heusel <christian@heusel.=
eu> wrote:
> on the Framework Desktop I'm getting a new regression / error message
> within dmesg on 6.15.6-rc1 which was not present in previous versions of
> the stable kernel series:

I debugged with Christian a little bit, turns out that particular
device ("arch-external") had a PD/UCSI firmware bug (which we have
fixed since). Perhaps the new kernel just exposed some more of the
broken firmware behavior. It does not reproduce with newer firmware.
I think we can safely ignore it for now.

On Wed, Jul 9, 2025 at 12:12=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> And maybe if my Framework Desktop would ever get shipped to me, I could
have debugged this ahead of time :)

Stay tuned ;)

Sorry for the false alarm,
Alexandru M. Stan (amstan)
