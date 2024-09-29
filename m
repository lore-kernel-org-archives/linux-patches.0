Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C27817BEAC
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727624166; cv=none; b=khuFNpm1h85knj270/YjsFwaEmu8hwNOVAaBw1lIJyPk0gExb0ygYo81ZPr6yL/6nNJgNAXlE385ZpQnTi/+1uN6JjvczyJwVnNeP1ARMP0ryiCw8aFufpv+JQrTnsK/8ghT2IwiwkGJt51mNP7J92asY0Bvg7iET07ry1Yvp+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727624166; c=relaxed/simple;
	bh=Z24+oNbwDBYDjUFeXrH3yiHjyPp8DkpOlh8f85DEeEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pL0ld46IDzQvStnU18O5U4f7UUzw4k6uxpigGinoTf2jguBv9ldqy0bh4YFvdDzGgjIUc/MKc4JeUPauinRdkiszNIeNkrmpW6aTGWOOD7YSEzoX64Sl14z4+IymoBD42zR8iwPkj0+Zk+LDez14ObJ3jqu0xxRxNoW4aWc4iEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DWGfdiqM; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DWGfdiqM"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a8d2daa2262so412209566b.1
        for <patches@lists.linux.dev>; Sun, 29 Sep 2024 08:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727624163; x=1728228963; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7aEO2yZHG3E/MlCpO8gpWwrr+WlYuH7Zy33FEPXBtWU=;
        b=DWGfdiqMw8/7CFs62tx2umtmKbAYI0mf90+YXcieG8VrwgsolkJn8MdaigLH5yAvOd
         a+M7hO2jaJ62ROumefajvmwc8+Wstw7JgHk6+0ukI97WEFlM8j46h+TPcTjnFo0eRkxl
         QpTTwRhtoSpPGq/0qwtM8J/g2fHBIOU9SJ4ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727624163; x=1728228963;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7aEO2yZHG3E/MlCpO8gpWwrr+WlYuH7Zy33FEPXBtWU=;
        b=L5tlWMdb/h+tJZ2rJKuCNEYW6y+Z6DjdXK4SJDAQFstG5hkC7ZoO6QQZNjexY1UxLm
         mhRPBQQF5Yf2qTJfk4HRlUbcpg8mMnIHOnjDA/yPxp4yRVY0xYGbzBXK0mhQ41M4RckB
         rGPie7Ym15X76RDOcdLMKMTwvlCLvPEn82EOeyvy6ehDmDRX2aVzKlfMPr7uTRrn/59L
         86uEiSyPPaBouhWH6uGW44QxpRKfdy1mPGbHuBDxctNo7WfMN94y1+5MGrVOV7Oksk/7
         4MGJAbkdbR8Tl24RK9FAmadYn7ETX98ksdpr+H+GgI21FhDMCI1q/dM1X7W2jQ8uVoxU
         wK/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV3NaYnVlou5amfQCVKD7GE2Jtdd5TZx1W6AeAU8Ro8zO0RHzFWR9Q2FHWYDHJqgR88DUgXzyk2@lists.linux.dev
X-Gm-Message-State: AOJu0Yymyvk5SIV+Qw8z8+zPo3bjD9/I6of9Bl5yoMYB4OGhAxx0gz54
	2x/YGT/iIDjlUv2nRpLA8SmGaVjEaW51z6vmvxH4hpIyKmoWmoLLdfMY8FWpOvZYl1tbHgiJgO5
	EXsE=
X-Google-Smtp-Source: AGHT+IHxFvASG93zrWn6DfqLeBsXuuGAgX5uG6UI0tTfYmWvEfR7RWkdHP1C7EsfRksSO3G8nsHHPw==
X-Received: by 2002:a17:906:794f:b0:a80:f840:9004 with SMTP id a640c23a62f3a-a93c48eea6emr1044355166b.12.1727624162546;
        Sun, 29 Sep 2024 08:36:02 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c2998634sm384861366b.206.2024.09.29.08.36.00
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Sep 2024 08:36:01 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a93c1cc74fdso493319166b.3
        for <patches@lists.linux.dev>; Sun, 29 Sep 2024 08:36:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWl+qi0I3SkWNnGX0qK61yM2faNx8bR+ZmJn4NOKy7BJzn6R7s5dUxFVw99DVHt0l2ZNCdscPan@lists.linux.dev
X-Received: by 2002:a17:907:8692:b0:a8d:44a5:1c2f with SMTP id
 a640c23a62f3a-a93c48f089bmr904801366b.6.1727624160624; Sun, 29 Sep 2024
 08:36:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240928-fix-randstruct-modversions-kconfig-warning-v1-1-27d3edc8571e@kernel.org>
In-Reply-To: <20240928-fix-randstruct-modversions-kconfig-warning-v1-1-27d3edc8571e@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Sep 2024 08:35:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgdQ5TjbXX0D568GZebYnt5ZuhTW5-ffeim-aoyT9LnbA@mail.gmail.com>
Message-ID: <CAHk-=wgdQ5TjbXX0D568GZebYnt5ZuhTW5-ffeim-aoyT9LnbA@mail.gmail.com>
Subject: Re: [PATCH] hardening: Adjust dependencies in selection of MODVERSIONS
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sat, 28 Sept 2024 at 11:13, Nathan Chancellor <nathan@kernel.org> wrote:
>
> MODVERSIONS recently grew a dependency on !COMPILE_TEST so that Rust
> could be more easily tested. However, this introduces a Kconfig warning
> when building allmodconfig with a clang version that supports RANDSTRUCT
> natively because RANDSTRUCT_FULL and RANDSTRUCT_PERFORMANCE select
> MODVERSIONS when MODULES is enabled, bypassing the !COMPILE_TEST
> dependency:

Argh. I should have checked, but I didn't think anybody would 'select'
MODVERSIONS.

That's such an odd thing to do in general, but I guess for RANDSTRUCT
it actually makes sense (since a plain version check is nonsensical).

Now that 'select' statement is truly crazy and another level of odd
duck, but I guess it still makes perfect sense ("give me the build
coverage, but this is never going to be run, so don't bother with
MODVERSIONS").

So Ack on the patch. And now I did check that there doesn't seem to be
anything else with odd MODVERSIONS Kconfig rules.

            Linus
