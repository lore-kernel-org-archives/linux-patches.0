Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D4F1AAAE
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 18:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709664754; cv=none; b=d3I6FynQ43KIdUnwUK+lsZssvf6BMuaU+y4D7HCawx3E2fQYoMJnW0Ylz/yNo7pMKUPqVxmvBQZIHV6wX6Nm7HkvIH38MMdqwYhckcIjqxP6vDkMdY+qkrkSOfWxhaKo+ZwF9l+jSMEzFGj3sLICSYWgnFceDZULM+O3J8XMpuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709664754; c=relaxed/simple;
	bh=LJ1VyEzT46GGcGZdysuPBEKZgskQ2Uy/0HABi37DaHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MbvaaN1R4wJiChO71aRWEmyG6HL+kd5vpuL+Xcq1/oBiAxWbiugY0fQcGpaU5gdj4MWuAa+VgRExxPpUJijpgBfl5ML1hvovnWah1VGmAj+QiYl56TZ17A1SAUTAfTlyCP8S9T+7Dtn6zOAcXtXyXncMFcE7FAWiiTM6cevyYSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yCZg6gnU; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yCZg6gnU"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33e4c66a090so837881f8f.1
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 10:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709664751; x=1710269551; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJ1VyEzT46GGcGZdysuPBEKZgskQ2Uy/0HABi37DaHg=;
        b=yCZg6gnU7BN8JwqEnV85+8P/qf2FZXNj6HgRAU5ptn4JeOtrT2qkbru2ZboxTTj/gf
         9Ac0VcyamN9wTkm92fRvHI+IGo8l3sYYZV1UAJXJVvlKU9bVBQ36uPhWdsxmpthjZPhF
         DOvmJq/swyJhFKQ9/B8bgBpPqrRQMXuiuU0uC1v+LQkRJKF46v/wR5TMUjfFqhLLVBGJ
         mQ1523ACldWPWbpQ8MKHMK/vlTFGd5V5UlIq7pHYqxRw+dqQG8JMJYyTrKjBZk0S4Lfh
         FiIIgTIRbeVCKZFi7140XRUrDhyyZBoBPlb+kSG3+UgoKLTFz8e4Z5s0GJa5QxvtkPqD
         jGQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709664751; x=1710269551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJ1VyEzT46GGcGZdysuPBEKZgskQ2Uy/0HABi37DaHg=;
        b=J7yt0iCBZ4BG/zt90AzXjJ13M1mz2zyCMCd7DVJGBnlgaa+AWYekNHU4oUlw0bdfNy
         Z36SeGbBhBM9EfzdyVDIKXzz7oNp1cnSvFJoq7fDTM8csJZZAs2QUpraMq3yHBKttqgZ
         NOSYgL4kiiLHhDbgtQ6XdkVZsVWA48ajlpedQSmFbv/w/H3Z8GNAK/QtyzUKLT+Qdj0r
         zw2+285P5B/h00lk+tLbCn8iITUsXK0BmjuXJMIf5TJ9qMqPXlOJVnGr0f64dfL2di/w
         i5eEi50UvkihRVBblm8okQc2GDpFQkzmOYSmOIcNefy/ijD6LBuPpgWZ+k88eYbs2CbB
         HkkA==
X-Forwarded-Encrypted: i=1; AJvYcCUS/+BAnViDtzH0+kkhurUsc+cM1kuFcgivOavDvECYSMFHQtOKbxe0t8qZQ/CzVIyC/NQgNz/YLp7pYIZHmZfVr08yMrVQgw==
X-Gm-Message-State: AOJu0YxQEDJRJjHO0OZ7CANstwRRXrE98zcR0tVcnpXLSagMUBGVC7gK
	Ega4L6r6nbpd9Lv91+mY97RuB2v89wdeNvAe54O2e00TxX5/sF1BUK3CupUZzOdDqL2R/3l1xFm
	Q4xX+51X+b2EC970VowCyz9Yy/HGK/XUxaTM3
X-Google-Smtp-Source: AGHT+IE6iTVsszmymc0NXm8TpEIVOwbLQKCaadELBnL4QZrR9C4Q/dxgWr+oVGwQntbPMh9rJoXMRgKZMzGcc84yKvk=
X-Received: by 2002:adf:fdd2:0:b0:33e:17fd:47c8 with SMTP id
 i18-20020adffdd2000000b0033e17fd47c8mr10226695wrs.1.1709664751234; Tue, 05
 Mar 2024 10:52:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305-disable-extra-clang-enum-warnings-v1-1-6a93ef3d35ff@kernel.org>
 <57abd8e9-3177-4260-b423-38d5cdcda44e@app.fastmail.com>
In-Reply-To: <57abd8e9-3177-4260-b423-38d5cdcda44e@app.fastmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Tue, 5 Mar 2024 10:52:16 -0800
Message-ID: <CAKwvOd=V_Qtd2pK8AKc6bv=zMPnAaCf08=QO74ckqH26A3sefA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Disable two Clang specific enumeration warnings
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <nathan@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Yonghong Song <yonghong.song@linux.dev>, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 5, 2024 at 10:50=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrote=
:
>
> On Tue, Mar 5, 2024, at 18:42, Nathan Chancellor wrote:
> >
> > As the warnings do not appear to have a high signal to noise ratio and
> > the source level silencing options are not sustainable, disable the
> > warnings unconditionally, as they will be enabled with -Wenum-conversio=
n
> > and are supported in all versions of clang that can build the kernel.
>
> I took a look at a sample of warnings in an allmodconfig build
> and found a number that need attention. I would much prefer to
> leave these turned on at the W=3D1 level and only disable them
> at the default warning level.

Sounds like these new diagnostics are very noisy. 0day bot sends
people reports at W=3D1. Perhaps W=3D2?

--=20
Thanks,
~Nick Desaulniers
