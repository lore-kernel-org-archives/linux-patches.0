Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9812B3207
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:34:05 +0000 (UTC)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-51d91e9b533so1611131a12.3
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688106843; x=1690698843;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TpIIQ08qfNEuob2XBLG/PQlcqkOfTkfohi2v2vX8ccE=;
        b=M2TBpBxIoHxKCHngKt32vUluBC4EJdqoYOVETJ7o+8oH09CY6BShREL8qj56C6356X
         5q3XGeGw9IJacNLJzP0IKB2VtPNs0Bg8sJThD1TefnyJEjI0iWLHlryGHkNUmFHM1S+w
         BtATWIITfAqQhH/6AQDQTS9JcuwoFVpAEkFnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688106843; x=1690698843;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TpIIQ08qfNEuob2XBLG/PQlcqkOfTkfohi2v2vX8ccE=;
        b=KjCcvYtL8G4ANpLrP35rdx6Q+wAI4Muaw3iCMpKkXwtfvvL5zbLQNSgIoGUh7UdhlF
         ZgpoURAeWti3uPb2J560CZK5JlSf+A/gu579UZ6OB2i8Tfqke/38RkYAU7JB+YmEFl6+
         uLZZFx7ULnl5QH0lQNuClu+QTFjiXTgx7AMl4iILjiqa3dH1Tz538JsrWLvo5Inf2FCy
         F5vOAeOq7Ui6ZM1jVYcHcD5yXlQsIYjLDEv29CryKYHuK6+SUli5SWH5oaFWz9N7AHDn
         l4BupEsITM1HAyM8qEq/IvXwAiGSPNitMUtuisCQHog5jvVLeodxGlNPsT7Qj6jmw1lj
         T+ig==
X-Gm-Message-State: ABy/qLYIqzrpEUcd0GURgrd0xQFk3dB0SiwdvT1IR6FFB/Fafo45XEoS
	1U99zSXwHRNW2DFvtZyZ7vjdT1CrAQar4a8GeKNfvb+z
X-Google-Smtp-Source: APBJJlFGalb+uyD8AMkonJdO2gzhf8hULhAPyG0bf2J4yhFQVs8wvAdVel5sNfsp74x3/17DLirwpQ==
X-Received: by 2002:aa7:c152:0:b0:51d:e4a3:3c8a with SMTP id r18-20020aa7c152000000b0051de4a33c8amr865773edp.3.1688106843592;
        Thu, 29 Jun 2023 23:34:03 -0700 (PDT)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id be28-20020a0564021a3c00b0051bfb7de166sm6432000edb.39.2023.06.29.23.34.02
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 23:34:02 -0700 (PDT)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-51d9890f368so1621169a12.2
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:34:02 -0700 (PDT)
X-Received: by 2002:aa7:d551:0:b0:51d:af77:d201 with SMTP id
 u17-20020aa7d551000000b0051daf77d201mr909491edr.18.1688106842535; Thu, 29 Jun
 2023 23:34:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.888604958@linuxfoundation.org> <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com> <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net>
In-Reply-To: <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Jun 2023 23:33:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
Message-ID: <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, linux-parisc <linux-parisc@vger.kernel.org>, 
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Jun 2023 at 23:29, Guenter Roeck <linux@roeck-us.net> wrote:
>
> Did you see that one (in mainline) ?
>
> Building csky:defconfig ... failed

Nope. Thanks. Obvious fix: 'address' is called 'addr' here.

I knew we had all these tiny little mazes that looked the same but
were just _subtly_ different, but I still ended up doing too much
cut-and-paste.

And I only ended up cross-compiling the fairly small set that I had
existing cross-build environments for. Which was less than half our
~24 different architectures.

Oh well.  We'll get them all. Eventually. Let me go fix up that csky case.

              Linus
