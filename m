Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F4E2F43
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 20:42:52 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id 17so17103471pll.0
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 12:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vMsaXK9Beaf56plb9rYlZa5RR76GtIlbV0IfKq/Pvrg=;
        b=tikSzuwx222LNN9UwQqm6TaLNsTzJ/hxxiUqQHkf37vFAp8iiMXLmQuirC9lh+z6KI
         L8b6QgRaN0N/IHSmAlMedkiyrSjYOwxYaqXH0PW2ibuk+Wi2hP1Es4K/qWRzVKtyqCMX
         AqgI4v6PWQk17OM8Z/0vpHO0mx5wVD2Zm8Kb01VFQpv6SuyeHTw/gkmAwJVp3jBgwbEI
         M7eim09dhJmVEdbcbTKSSUvzq4M0LZQzJ4P86XJWshIiv6Rq0+MmTz0Nq+/1re6s6Cc+
         v4Srm2Aa8puDlWZQhS49/AXGNZW1HzYhuud0IHMwFvD9/KMj6Q7Te6rcd17NveQRKDO9
         T8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vMsaXK9Beaf56plb9rYlZa5RR76GtIlbV0IfKq/Pvrg=;
        b=PFb/TU5RUrKoSrRagRPE6CApqqErYOx/73LHwtmI69RJy2fxIY/TcZBFI3E3rPZcV+
         I6G6p+rVqRnJtAii4RgVYP/XJUb8eDAWnLijVGeo2B88xPli5YPSTxpXNG8ZfCb6cEU4
         o/ojO4UMBE9iO43FVHsgH9BXNCWJmSovcinPPd4mbzBO1k0DnnvYTT+o+v2TQWUANZCv
         yQotYQCw1aLG1xIXy5HohVrHdrmBqTLee5FVfwsUyxfRAhR7FkFb79Bf8hgf2sns7ElD
         kH/R+dgSTekzUZeFAQSKs+vp0nM3fwLwsSdhygh+IwbOpz4ji3WjNXHCGFQnHPzoOzXC
         ETxw==
X-Gm-Message-State: AFqh2kodWflOmoz9EZcUXccPp+FwNeEmQELqPdrosdXt3XQufnuj2D5z
	ygriu5T1Ksa+gQQQa9xu5rTpFBQaWR6zfGtEX2frlQ==
X-Google-Smtp-Source: AMrXdXtOKe9vay3WmDDbJM/w4sMxGaPGMLz3qsGF1bCBXxFqMMzfTQW44PhLBO6+McFoJnLoh+1r2AkV6Ha4u9Cf8J4=
X-Received: by 2002:a17:902:d592:b0:187:2790:9bc2 with SMTP id
 k18-20020a170902d59200b0018727909bc2mr1547907plh.61.1672260171889; Wed, 28
 Dec 2022 12:42:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221228144256.536395940@linuxfoundation.org>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Wed, 28 Dec 2022 15:42:40 -0500
Message-ID: <CA+pv=HPhmb+JtYvn45C7xdLcy+GfAiR5WeAB-NXp7wOadm-13g@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 28, 2022 at 9:44 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.

Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
