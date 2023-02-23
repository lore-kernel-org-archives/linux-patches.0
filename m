Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FD4AD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 21:40:02 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id h16so47591529edz.10
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eu4dlgDvM7BF/2CvEqDDQA7UHs/G9uWjlrCzs/6VT/8=;
        b=OBJUot5ArA8AuZr5Am1iNpiGcg163grwYHt/S/lfdzEng2GEOmwCK61b4pdn9e1Rvz
         9ZdxgOBLRiDoqtPUUEXz/Z1CFCLXAhoMCcyW2xMALKstCSjCh62EgVAkaFd3JSDOIfp4
         63bQ2FerOD+OayzoALa+Mh6V67wCIFrWQjsEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eu4dlgDvM7BF/2CvEqDDQA7UHs/G9uWjlrCzs/6VT/8=;
        b=jHJ9ZnyOvpTz9comA9UBwW7UDWHxHFAl/kuAtWIxcdWxq6IzhQfw88/j0FldT8SWRZ
         /MzG3KMboqpx3yqoxlNRHNTU2ZW22nygtKTGnsSvKHNHaUSUZOvH3OVruRc3ZVao3tRs
         EXM5bAYHoTPWdALlLCMhVN5DiAunK2GeUZmSQmomaawmVC7HoY9TRDL6iFopp4E3Hcy/
         uWt+HmKSiQCQH86/grfwQcS843I9MdibgJpCt3dn53H4a66MhOh4DKdh0p51eRfsHW8u
         gCIrDrdeJdtCkWGfZJh8rdjo7PSMAB4P3m089+LhqYXmXC3P+FnLAIwmwBHHECm395Op
         Hvnw==
X-Gm-Message-State: AO0yUKUQTtFr7AZ/FKW/YiJKI81eEg6VSN+2qrnJfVEXSWgTKK1mQIq0
	olls/pD7rvmJICXiIfJIJctXQROsl+A2LtdTl+FnFw==
X-Google-Smtp-Source: AK7set8+sjSQctBtN5FpJw/4KD1+RFdn02SkI5QUeiU4k2aVl0MaLXfrGilbbBzUX61QTmFf58Pacg==
X-Received: by 2002:a17:906:f8cf:b0:8b1:78b8:4208 with SMTP id lh15-20020a170906f8cf00b008b178b84208mr22483220ejb.1.1677188400291;
        Thu, 23 Feb 2023 13:40:00 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id b19-20020a170906491300b008e267d7ec18sm3268714ejq.50.2023.02.23.13.39.59
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 13:39:59 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id ec43so46895784edb.8
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:39:59 -0800 (PST)
X-Received: by 2002:a17:907:988c:b0:877:747e:f076 with SMTP id
 ja12-20020a170907988c00b00877747ef076mr9516620ejc.0.1677188399093; Thu, 23
 Feb 2023 13:39:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141542.672463796@linuxfoundation.org> <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
 <Y/eVSi4ZTcOmPBTv@kroah.com> <cfd03ee0-b47a-644d-4364-79601025f35f@roeck-us.net>
 <CAHk-=whCG1zudvDsqdFo89pHARvDv4=r6vaZ8GWc_Q9amxBM6Q@mail.gmail.com>
 <Y/fC3d3RqoeawG0Y@dev-arch.thelio-3990X> <CAHk-=whkNnShBugM01Kzcypkp+f-uHeBWuAgtUiMpiSZuW+QDQ@mail.gmail.com>
 <Y/fZbQEEPBNZQ2w7@kroah.com>
In-Reply-To: <Y/fZbQEEPBNZQ2w7@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2023 13:39:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=whiuJH_DYQZw1hPtibDQZcNy8QYf1cZJCsezuPobSXCKw@mail.gmail.com>
Message-ID: <CAHk-=whiuJH_DYQZw1hPtibDQZcNy8QYf1cZJCsezuPobSXCKw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 1:24 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Quilt should be depending on patch here, I think it's something in my
> set of "turn this series of patches into a mbox, split the mbox up into
> patches" sequence that is causing the problem.

Well, it might also be that quilt just re-generates the patch with
'diff', and then in the process loses the information again.

We can happily continue to support the "we lost the executable bit",
since it sounds like Nathan is willing to cook up a patch.

I'm just too lazy and personally unaffected to care (and too busy with
merges - excuses, excuses).

            Linus
