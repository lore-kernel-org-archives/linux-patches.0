Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676A437D12E
	for <patches@lists.linux.dev>; Fri, 16 Oct 2026 09:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792144396; cv=pass; b=QAUuDdJEszmUwH1hi1V8O5hfXkCKGFabyUVIGC3UP62VFy8sejl0YuGSoGwqrOyAbnbl5vRC1sqwn5tTGnNWuUsle5So0h0qiK6HZU6sdA/Dcs/VDgHqcWFyBDGuEbAPEdi6DUs4S0zKSPduuM/5p+g8aOcq0VzM17t9QLOZf+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792144396; c=relaxed/simple;
	bh=xqN3pfb0UkR3DIFYcIuV6kM3FHfjO1La5ULm2s3cbLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kfttKUBrd0MYcq5x3aWMIvXfjg5Bp1CFC1Dc5cZ3PFqyYPZ1MDgy87HH/cvzFIAv+MBT/m586+Luj5DX/FSDJUCQEa4lxORvmD/YxrBaVYeptCyUoXIP2CIS8onTEMHuLTQpv/Q167dF0wqn6ecHUzCjS6fpErYg18RLLMyGjgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ODd+PUxY; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ODd+PUxY"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-486e70f2457so1160657f8f.2
        for <patches@lists.linux.dev>; Fri, 16 Oct 2026 02:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792144394; cv=none;
        d=google.com; s=arc-20260327;
        b=GO4bTIPw7EiGGAZpVNCpMxszvffgoF6AEhpfIB7vm1L01yirYW4tQF7XkdD7B1CzvJ
         8Ur+gxG537RqPKjc6u4MiLU1fS1ZGcklXf59Gan62uHdRQV5bx9sCz/aeeIl4AmHdwZr
         RktoEewSbdwMgmkruNwp+XSymhNDxZH3Ym0EFF7MNYD3kOa51jNWCUWQwpN+qBBsA/7q
         l0SZP/WWGz47MCyKgApD1gi2Ho4gZ42npT1GbYHQ3xa0BhQJhbNrf9fD2M+YW/8KVVMG
         OG6JwLEWMy4eZ2Jo0ZV471nrdoyuta5bEyHkghkNTdqBEHgOhIJvglv4we0KMhCF1s7V
         6Qew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xqN3pfb0UkR3DIFYcIuV6kM3FHfjO1La5ULm2s3cbLs=;
        fh=n9cfsakvbKwkDhYqdVkt9A8qD8X1hgqIZswXE1skOM8=;
        b=fAg9dHdSoNn7gEDfme0HIF19vNZVxPQd0q1LDuoo5H03WSa2gmXpv9SMGbCFVYJbMW
         x1r3RSuOUpEVAPHK3GegSOjAFtZilDYjYf963+NzTFZdTKNxR5W1rsW5Z6UeJn2DQE39
         rzTKxe6MUcKnvroQTaKqNHhe604bSclBRsl38HBRDpp4vMB+cm+OipDJo4i+qfBkaRmG
         ehxEcfmQ7kQqARnaQbjcaggREbdnhWjAv4M0MlmlRtFYVwQI9H+135Oncv3ljRB6+Oma
         cjDhTQ0uG88u1egqW/V4he34+V6KHGoJV7OnS6Y4oX5np0iECUFZ9RLvgbPp553l/NHh
         auYA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792144394; x=1792749194; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xqN3pfb0UkR3DIFYcIuV6kM3FHfjO1La5ULm2s3cbLs=;
        b=ODd+PUxYr7iyfbb94QWkgH4UgHP2ZAlakfm1KxLLgWrGzn989hPS+dcxqPzMbUItDe
         6BWik4X8pIMMWlRbezP/gpVnQ81xKubp62m/EWQQCFDYnbbj0dFrd9LMtvwjYBURWjN2
         AQ37mEZMOeKA6vyJ+8d7B4ht9UJfM6DZsM+kVBu+Dog/pWi8eCcIQQmNvAFZW1tZ7eVX
         0NyHKiuvp6XxD9taGrwjW9lksrz+zSWEtU/1j0pDHMBJvOXet3zGtpcVX4PmhYxpfMzo
         Nk4JOqGCfM8aNyeEiGSM5e6qA6MlKXp9VS+CIn31KMfd/aZX1zHHUYOMxVESaayLYAMW
         3Mag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792144394; x=1792749194;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xqN3pfb0UkR3DIFYcIuV6kM3FHfjO1La5ULm2s3cbLs=;
        b=evSLyw3xggx8k9AIjnmsR47RPeikxeC6d+uE35h41D96RlAtq+cU4HoZuA02eEYEdu
         nuHP3bpEYUccmYMDA9l14RbxypDLdw4hdbvWI7BnktTAb2i+gnN7YDv2d60579r9vMaf
         QREHJK8Q+8WEvvfh3r/5iSDv66qkOyBvnPJW8HGsGxA/9eU33j5ZYIoZC8CsShVmJj+i
         TqBMt95xZ1LGIY0DGyx9PyboYL8ASManQlIAkxj9p64g1awZ+SzPk+2acLfQQVR0I6KC
         dSM8GW7mZ8CTA/37vJV+TpvMzdpRqYj4fFTCDvxZMwzbgxjeccjDvGp5gYiq2mqYxL7G
         ZNmg==
X-Forwarded-Encrypted: i=1; AKwUvBwj/MsSBtmBQiZKmWyuCYih11vHrRXj9NfzrLHnk4vKfN3WlL2DQ5K1jazLmQhYtFWrZHEcHYm4@lists.linux.dev
X-Gm-Message-State: AFq9FYKIyDAM5zKu9Ydv0NgR3XY62kvook1GRDpheojbtR15kBDaKk9L
	f9iFTGXEH1XdERwKrIeliTWLJ94uyFyWbjkRXWvPDYyX/nY7dhyZ7vQNeSRnM7AUAbOYrkgAsIL
	Vt/dlU40xp9PVV1VgfdNklRfNexWNohqMZbBbiEEL
X-Gm-Gg: AYBFou3zua//B6+aGstOxJRtbRPdj4NZCeee2mpXrX/2p9ylCOZ/72USwDJQ4yvyTBr
	hmkwG7w7gqE1I/PegKdxTrNgujXSF/X9qnVZJuUgl2ybE3ddkswELcn3RBuX7JzdieWRGDgVPtx
	pwNtBBs7wO8NNeFflRsqNpnsBs14XYC1PhFxQ5Wiyk2L3TAqhlfRYVcxFhwV5xqXazUP8pplXs8
	Mh0EKrN4FP9fDdnu4tLrCXdJud89pw+5MeelIRAf6enLvooSLhU11EWqq7lXaJkuEYXLR5EpPEE
	PTsDA8GOyof5hOuWg7aEJlLJ+IChr8N3wUwKOFmW1eGBEbFb9bQWYtBduXoiuk1NGaashurbEFR
	gbI4WQmWvMYiE9Qed92ET0vLbg/JjeXPW3H+fAw6f/lGRgDf+ffPO
X-Received: by 2002:adf:e64c:0:b0:485:8ee5:5ffa with SMTP id
 ffacd0b85a97d-48dba9de8f4mr35213414f8f.38.1792144393256; Fri, 16 Oct 2026
 02:53:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20261009140946.008206689@linuxfoundation.org> <20261011111313.27648-1-ojeda@kernel.org>
 <2026101124-rethink-craftily-cb25@gregkh> <CANiq72ndhLush3bugar1YGPnsein8min1k3_NucBxzFwCWe9Ug@mail.gmail.com>
 <2026101103-fling-stipulate-084f@gregkh> <CANiq72kjJ__OnsTjmsuQZH8+U-cRDCNnRpSuHU3PwYYT07Xf0Q@mail.gmail.com>
In-Reply-To: <CANiq72kjJ__OnsTjmsuQZH8+U-cRDCNnRpSuHU3PwYYT07Xf0Q@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 16 Oct 2026 11:53:00 +0200
X-Gm-Features: AclHuK-KZrzl8buAxw5--JIrQ3Q2GlG4ZFRpXT7mWgEiCKlqaDvBAHdKaEgr_aM
Message-ID: <CAH5fLgjjPmL-hiQ7R5zFG9BwWbxm6j+GnahoC11AiNxM7iyGJQ@mail.gmail.com>
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Miguel Ojeda <ojeda@kernel.org>, achill@achill.org, 
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org, 
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com, 
	linux-kernel@vger.kernel.org, linux@roeck-us.net, 
	lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev, 
	pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com, 
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com, 
	torvalds@linux-foundation.org, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <christian@brauner.io>, 
	Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 11, 2026 at 6:39=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Sun, Oct 11, 2026 at 4:17=E2=80=AFPM Greg KH <gregkh@linuxfoundation.o=
rg> wrote:
> >
> > If that works, can you, or someone else, send an updated version of tha=
t
> > commit for the next round of stable releases as I dropped it for this
> > one.
>
> Done (I didn't add vger).
>
> Alice: please double-check, thanks!

Thanks Miguel
