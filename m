Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F3739B4A5
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 20:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780950971; cv=pass; b=IN71DmmPRxoPWdv2NU/QMUcWr1Dtb6ylR3iMaHwArRxC7WPnKlfOK2GNyFI/rax7r6FSUZo/cgKLTyEHfsMhBcKJTwzFbh8To4GzRt5pSoveDhhEs5/6zf/9hAWlZE9DgyhdbG9wzWE/f5xDvBrYLjOpDnuVPl3Zu1c+HWwq6rY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780950971; c=relaxed/simple;
	bh=B2tN+Ldk/5pCXIYwJUJf0VGuPcRdSjXr3Cs1XxacmqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b1cCsSdF0iByClLBc0smPUOdX8jqWp6woKNNQpCAEVcAPXU2I9XgVHfhdOYuDBOK7v89FRvj0crcLQ++v7eFSSh2y9gJMRhw0L6JgsAozyVN635hiMrHU58oz2OU7P/GwdAE4s4ajkk57Kdb4rNlNvsSkqs/1aqSE59UNhzmjkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b=Tk7TNslX; arc=pass smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mojatatu.com header.i=@mojatatu.com header.b="Tk7TNslX"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8423610ec93so3726222b3a.2
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 13:36:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780950970; cv=none;
        d=google.com; s=arc-20240605;
        b=J3JRm7jy9XbsTqWNc6ZYIoU5WKJt3/vbRUTlDNo0BpYImdsqu9pLORxMmZInCj6YX4
         H+6gFop0jeODRyDgKelbjDKTEgs8ZUzVusXdSdOogSQ0gqDDKFNu8kIV+GdHQtjNzFdx
         +u6SQbK1bAXQJe1fN5VEc68oAL0UANA6y8LOhqZ9wpbmVfr48d5+iCgN2Dotyaio8WZo
         KU3p8BlTlOTvguHmtzmxvDREC+H+XOjlc17ZWgEmpC9LRWY4IIP/F2yx3za8SXJyqFio
         G6S47KH5zILJF82R2wP2y+xW/QFi8yNG3WkdnA636HUT0OBpuzmZ89z4BQ/B6aUkUoqj
         XaEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oVe+ITC2ml8n3gt+xHvgBn+FPMhVSI7g98/qjcMm7ZU=;
        fh=hLYRZHcBmx3E8RZbSyVPb8fKI0JGZsAjAEXdVxFGW/M=;
        b=eOc5XpwRwqcmI3jYR5U61NBXz+la9opb89RqRAfUeDE9oWfOKgaVYXGoJA/61fvVu3
         HE+/qQqfyq3dNEgjt7WsyNSAMKwHq65njE6487dOa2JTM9qGc6lnGWSvWGi881DPHGP6
         lZM4ZE95kc/d49x3VwiKC78J2hrCBs+X1FYeE2b8RPUE0uEXhnnKKqPA4IF1S3UphWVB
         vqcnlEUhP3BrMBt7wbNE6GFyre7KufqdV3oA0KWQsgtOK0YtCc/URFAuLFa3cWuLJGFn
         y8DHIfKnana7vZRwZHFQ5qiQkgFL94XiDHVLnFj/063ZBtshPQs3bcbHV8iomMdsg3JN
         SwaA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu.com; s=google; t=1780950970; x=1781555770; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVe+ITC2ml8n3gt+xHvgBn+FPMhVSI7g98/qjcMm7ZU=;
        b=Tk7TNslXCcKFB2h3u/3WFbydA0u2D33VG2Q2L25TNDHnGMcBl4NZyLdatnb36vEsI4
         RhALp8UKdqqKIkrti41NvsZcAc47GLTtOoI5kLk0uvBZLXa+OxZRNIEVkiwSfvqasfYx
         lymFPHj0baoH/vGiRLl0nL6jGpwsthDGVCub8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780950970; x=1781555770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oVe+ITC2ml8n3gt+xHvgBn+FPMhVSI7g98/qjcMm7ZU=;
        b=LXUiVoXUv44eS0UyTHSABBZOP7FxonrZjC+GgZQxXTLf8YVHcFXpgaIydO1UYXfLH7
         9qX8l6Q6fWQy9PcIWtX8B8D5iygafLtHUzQ22z4M9sZ2R3HQcYjUMWItIK8/k8qUVwCE
         vn6JDi0XGAp1er6YKCcF5ykDCfdD505vvo7zD3GNiZ8nGFKiJpVYkabxAvDxm8gkjV2B
         LLLLESjmmpw/SsAA4ewYE/Lu2/LjgACdhV/vJf+hTaWxzQ6t5ptlJ5q9d4SIerWfSeYW
         Hph5YQP9jEYhoxpZVk0AW3lz4ro22J83QCaDU6ywtSsOAUFmLwOhnwuK1rUjQ/lRvX2p
         Xu3A==
X-Forwarded-Encrypted: i=1; AFNElJ+bqnMkfxCrXQ2dWk+lyTwhYpgzwZTN7GYC82agXzhKlvQLDF7gV5Ahzo6RF/aHhPkdyJjUf/KQ@lists.linux.dev
X-Gm-Message-State: AOJu0YxXKEMdlQ2rkWFo45n0iESiXTIVcZf/0WSNNjmvqQ2ehdP6bvct
	2yZ04BqhHpDooCL8AnwO6ym1nIqYbyEr1AYMJ30FJVJ35PYqRhjlR3oqOr6s6g8q+JK2U1RvwpK
	9vVQ4tjmoMFqsxyc/O9cXeldnHXAXXYj3Cv81qurE
X-Gm-Gg: Acq92OFwKGSQKfba+TtoUZ5fkiYIRKtwiaUdbedEP+MjEOpWOew3LNXDbSPV/s5kXNe
	Hs8LAvQXYhp+zL5d4XaeU9Cs7ATjJUaLSDoskhfPsCsqrOzLv5layPl6rat8VTaYvI7qsYboATk
	tknGMQMJxY+5TbMQOhkrhQL8IWw1fswLTMoBfP6sJ9JqaNc1v7p//oR1PhUSr6tVT+AV2uig+P5
	x+h+L4qoe1hPTzWozJkQUn5hQz6HDNymCb5bezEugdo4gsvITnRve1KJCZc4OJuGZcYQPaz2d5g
	I27ieV3A7ovdfxg6iq8=
X-Received: by 2002:a05:6a00:4b04:b0:83e:d427:9817 with SMTP id
 d2e1a72fcca58-842b0db7dbamr16329172b3a.11.1780950970140; Mon, 08 Jun 2026
 13:36:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260607095727.647295505@linuxfoundation.org> <20260607173214.92693-1-ojeda@kernel.org>
 <CAM0EoMkszTXv82To=KnEYTgzQSmEdRW9XrAMVtJsUaDn=Akf6A@mail.gmail.com>
 <CANiq72mJNbNzYO37VK7s=ua5v31xBrRp8EnHDvEnKF8Z77jDmA@mail.gmail.com>
 <CAM0EoMmHd10iivCpDoEd3h+eae9fSnoGWAH_AkwFhrnS6PN63g@mail.gmail.com> <CANiq72k6J7FYT89svtX5qbCUWg-MKuhUHaT07cjk8o7PqaF8+A@mail.gmail.com>
In-Reply-To: <CANiq72k6J7FYT89svtX5qbCUWg-MKuhUHaT07cjk8o7PqaF8+A@mail.gmail.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 Jun 2026 16:35:59 -0400
X-Gm-Features: AVVi8CekC54iinBDQEVgU-dJ9AL5uhMqEzLEARHoPqKy0ZaeCQmHeP3rPtW0Dmw
Message-ID: <CAM0EoMn9EA_TS80QzXsTscBpCgfJHssq0GHtiNbrMU3FAiP2mw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, gregkh@linuxfoundation.org, achill@achill.org, 
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, 
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com, 
	linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, "Kito Xu (veritas501)" <hxzene@gmail.com>, 
	Victor Nogueira <victor@mojatatu.com>, Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Miguel,

On Mon, Jun 8, 2026 at 7:16=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Jun 8, 2026 at 12:57=E2=80=AFPM Jamal Hadi Salim <jhs@mojatatu.co=
m> wrote:
> >
> > I believe this bug slipped in during a small window but was fixed very
> > quickly. Probably some fix never trickled to stable.
>
> Yeah, as I mentioned above, I think commit a005fa5d7502 ("net/sched:
> act_mirred: Fix blockcast recursion bypass leading to stack overflow")
> is missing (at least).
>
> I would suggest reviewing the entire chain to see what needs to be backpo=
rted.
>
> > If you can point me to the exact tree where this happens i can take a l=
ook.
>
> This is the 6.12.y -rc tree:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t
> linux-6.12.y
>
> The stable kernel team puts the link to the repository at the top of
> the thread too:
>
>   https://lore.kernel.org/stable/20260607095727.647295505@linuxfoundation=
.org/
>
> > Still curious: So only the arm compiler catches this?
>
> It likely gets caught by other arches too, i.e. I just happened to
> catch it in my arm64 build.
>
> This is Clang, not GCC, by the way.
>

I think it was too early AM here when i was looking at this.
The answer was right there all along in what you said: The missing
piece is commit a005fa5d7502

cheers,
jamal
> I hope this helps!
>
> Cheers,
> Miguel
