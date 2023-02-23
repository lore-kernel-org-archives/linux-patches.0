Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC002F2A
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 18:04:05 +0000 (UTC)
Received: by mail-ed1-f49.google.com with SMTP id da10so46507964edb.3
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 10:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OfV3cj6WkoUxagcNB6bb7SMIfI10z38gFMomhuJjaq0=;
        b=eVfpkGFam+YRabRFrkEwHVvKKN3r7syztUN7KFC1ScERvdMXEAzeTGxNKhcNGFhDZq
         JslFqsDg99eaT6JRVWgcR+4bAhW2/a3EtaxQLZQFk9Sp/xbACshQ2iVMqEimUWFpmWhc
         2NyNHpRc/aWtBMy+9asms12Z3xb8G7k8jciu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OfV3cj6WkoUxagcNB6bb7SMIfI10z38gFMomhuJjaq0=;
        b=qAcBFeyI0QTD5CRnErYwCbm8fDN7JBI/421+RS3GUNOgsajzg0WO+5ArZ8rUgYdzJq
         yIekE49jeJGMIffReoYtrohmxJ6V1vAXxXMOUpE52NYE8/x8ebCo94nL2QQLdhjPZMUw
         6qNis20Jc3xowh9f69vo15VT+0XjA+uf2Xow3qpPPg+D49e2eIHlrvaOJe6fZ6/CYjMF
         2gPeUsUKYd/SUKbDNqvBynTBcJ3BRj8nfmXMIPCn0dc5MYN9D3YOpl+RnHVVd+CO69q3
         Pyqly4qH2gdr8QjHtYwe1b92+ZEs9wEQ7ITH/kDRXIbfOwyQZhnuPzuqhpdJAktVnjWq
         E+6w==
X-Gm-Message-State: AO0yUKWIOIHOy5W+qYSJLUOtjlPlDnNfDMy3xmBzNpkg62muOS9AKHh2
	8/pYLlN01D+cu6AqiBBbAu8ZAOELQf1SGhfVSHBvQA==
X-Google-Smtp-Source: AK7set8ESdrjp8CYMfeS3Tu1vQw8pPGLNDbQwjNn5tQWWxK7b6WLRPeeEC8rrW8bHeCx7a6EF4eIAw==
X-Received: by 2002:a17:906:2e89:b0:8b1:383d:cd50 with SMTP id o9-20020a1709062e8900b008b1383dcd50mr21883372eji.48.1677175443094;
        Thu, 23 Feb 2023 10:04:03 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id hy14-20020a1709068a6e00b008e9c79ff14csm1788331ejc.96.2023.02.23.10.04.02
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 10:04:02 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id d30so4042621eda.4
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 10:04:02 -0800 (PST)
X-Received: by 2002:a05:6402:5484:b0:4ad:739c:b38e with SMTP id
 fg4-20020a056402548400b004ad739cb38emr7772982edb.1.1677175441752; Thu, 23 Feb
 2023 10:04:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141542.672463796@linuxfoundation.org> <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com> <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
In-Reply-To: <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2023 10:03:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
Message-ID: <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 9:31 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> This isn't the first time this happens. I seem to recall that you mentioned
> some time ago that whatever you use to apply patches (quilt ?) doesn't
> handle executable permission bits correctly.

Note that even though git itself does handle these things right, we've
also always said that if some old fogey wants to use tar-balls and
patches, that's supposed to still work.

I guess the same "old fogey" comment then covers quilt too.

End result: we should try to generally not execute our scripts
directly, but to explicitly state which interpreter it should use,
rather than then depend on the #! in the script itself to do it.

In fact, for shell scripting in particular, we go further than that,
and use $(CONFIG_SHELL)

Of course, in this case, it's actually using the Makefile '$(shell
..)' format, so I guess it looks a bit odd to write it as

   $(shell $(CONFIG_SHELL) script..)

but I do think we should do it.

Now, independently of that I also think quilt should probably just
learn the git world order about file modes, because let's face it, git
_has_ taken over the world. Mwhahahhahahaahaaa!

              Linus
