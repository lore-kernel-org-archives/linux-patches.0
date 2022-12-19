Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34D879DB
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 22:36:41 +0000 (UTC)
Received: by mail-pg1-f175.google.com with SMTP id 36so7153990pgp.10
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 14:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pJLcLAIWjT3AbAwa+yUACoDWvr87LtfOapEiRZ3XG00=;
        b=bJSrWtMm1cvqM7vvB2RD0G6l5waC1sCieeY9+JGOdwVnPClrw3FHtkPerX9L8nJsSi
         4S/ibHP/dCXfrLS5J8kD4yVz1DMDt8ZU68nf1G4iO5BxAvLkib5avDSUaaag6asHqkil
         EL0jLOsHO1OUfCUR/inH9zEgWegukYi0C+DZSk+4W27hZaPiXx55tIgyp6WNH6ldmt9C
         kzgK0ZopXE910+QAwH4Fgzdi4iZbMJ+Li0n6HI0/u86euaPNdb+5b0LHCugO3Xfydpck
         /qAdE2LxHr6hECV01Hk4M7Jffyb0T70iMp/uogdvI55nmQgBoRBeO+fi5KOw7KKuxDY2
         oO0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJLcLAIWjT3AbAwa+yUACoDWvr87LtfOapEiRZ3XG00=;
        b=O0qEEmkKOGriEpABbjZrNAxnJ6DATVjE8d81KZdpaQJo3uA8b3qXSDnAo2Fvr+E/id
         9H3O5csBC0+wOf8k405ySCYm0pHtGCJFXvyMBwlY+EBztFI5f8/ja/DIQ43TAr1MplyS
         ESfJghxhUXBRZjjeY4JL2YjAK/kb8xF1ZprHSQft179vBSovEbj5odN0SVhN8yCNmCT/
         MdoNmNvPM/dlxmbl0jKuw6iJ2EVGpGYyvIvyk8NdeO6vHGBLuqsuE8zVFjKIn5HAVtpb
         oEGc3bmtUIVl12YXtn2caGo5SPavlT9zKtlTGcWlvgnROlrzAAQTYbDAMttzIBz77bhK
         XHaA==
X-Gm-Message-State: ANoB5pmRMo92o2KDqLLDxE8fFKoPhR9ryzu6uUhefoJoalLcUE8iIxBw
	2R0mjKQB7fu31P7TLyy1r3LVrgyD/7sKoEyB4Pkrig==
X-Google-Smtp-Source: AA0mqf7JcbOfcsXCrsLrkkWDc913LEYj2JTFH09eq/X+rLDCOCVY/5O4RcseS0xG6QmNdsyFSj3/8sE0xy07Np7YtRc=
X-Received: by 2002:a63:ec04:0:b0:479:7f1:11a1 with SMTP id
 j4-20020a63ec04000000b0047907f111a1mr5249389pgh.412.1671489401081; Mon, 19
 Dec 2022 14:36:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182940.701087296@linuxfoundation.org>
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Mon, 19 Dec 2022 17:36:29 -0500
Message-ID: <CA+pv=HMdmd5E=yH-1_dbF316EQ=KkriAPgLg8e+7m6wbinchaQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 19, 2022 at 2:28 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi,
Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Yours,
-- Slade
