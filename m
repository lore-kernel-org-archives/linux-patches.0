Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762EAD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 21:24:49 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id bi9so1327204lfb.2
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o5EaUMxUu98mAPL68+dXX7WmuwtBVQHznLgjebwlQ4I=;
        b=Pl3dZ9xTbzURMJzx/eGGIQXnmfoYM03pN0WhMPpwPgnrLPDyz+genkT2s+ds1BpkV6
         twgQRI8jT/MQAGxLGHvJ8M2g8/XP/ZqA8moBtTkD1S/r7vQSfaSuRiHAxK/lkLQc1hyl
         4pyuSAjtf+qu+jr1Ej+LvtHyHtN7af3Z5Hg1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o5EaUMxUu98mAPL68+dXX7WmuwtBVQHznLgjebwlQ4I=;
        b=Y3COmVyvNIc9s9xG4HfkRZBJbD7g9MOe5hsOo2M8ZeJg9t6fX4SDWKCPdh7k9eIXd/
         HVmQ6E3Mz3IzSXuz2VYKWEtRIna+7I+BcPT/MO5VUrA8yPmH4UZOcT4MmswCAa96T7Hu
         yEE0tq540aiVwGzDRzUJoRy8JJq76fqZ09MO/7pLxwbIsow/eHU3q9RLyy2WT1C0pwC2
         wZLzLsSBLMe9aLCyA0AGOsfj1LeQiUOtsd1MSW0/1bRSCzNhbjNOfHWZWdR5pftzlZKJ
         KdOFVsyd5JYlNA04D7poVe35SeGwNhjekG8c8Rw2N1dT8Mi917o9NK7ZVI0LexM94L/i
         UhKA==
X-Gm-Message-State: AO0yUKVuX17Xy0Hu2VlLvuYXoBbjyFMHUZ6XWMfl1WRtaBV+MyB5ypzE
	TA+Exx6B1xeja7WuBeLkA+LBinSjG33nSslCNETBbw==
X-Google-Smtp-Source: AK7set+lUT7S3Asj/CZvEsOX/OED1QSsPG85klzou6N6oqsOxEiksFpwbdMTdrbC/CdZE6s9WcS5tQ==
X-Received: by 2002:a19:a404:0:b0:4db:183c:479 with SMTP id q4-20020a19a404000000b004db183c0479mr4562765lfc.32.1677187487471;
        Thu, 23 Feb 2023 13:24:47 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id n12-20020a2e904c000000b002945bbb83b9sm851369ljg.89.2023.02.23.13.24.47
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 13:24:47 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id b13so13173463ljf.6
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:24:47 -0800 (PST)
X-Received: by 2002:a17:906:8508:b0:8d0:2c55:1aa with SMTP id
 i8-20020a170906850800b008d02c5501aamr7232357ejx.0.1677187129340; Thu, 23 Feb
 2023 13:18:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141542.672463796@linuxfoundation.org> <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com> <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
 <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com> <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X>
In-Reply-To: <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2023 13:18:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
Message-ID: <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To: Nathan Chancellor <nathan@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 11:47 AM Nathan Chancellor <nathan@kernel.org> wrote:
>
> I can send a patch unless you want to take those changes directly, you
> have half a commit message there already I think :)

Not being one of those old fogeys myself, I don't feel hugely motivated to care.

In fact, I think GNU patch implemented the git patch format extensions
more than a decade ago, so we might even simply decide that it's past
time to even worry about this at all.

In fact, with all the base infrastructure supporting git patches, I'm
not quite sure just _how_ quilt is able to apply patches without
dealing with mode bits.

Does quilt parse the patches and actively remove those lines before
applying them? Or does quilt have some actual built-in patch
application code that doesn't depend on GNU patch?

(Side note: GNU patch may support git patches, but I don't think GNU
diffutils will generate them, so I guess not all base infrastructure
supports that fancy new "mode" line)

             Linus
