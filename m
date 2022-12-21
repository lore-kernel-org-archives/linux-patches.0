Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B199D185D
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 01:19:00 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id 130so9672812pfu.8
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 17:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bAITO3y/ju2E/+p9GTxr9wsk3UMDCPB8LrqMLu/DxU4=;
        b=aaR0yhDR1arVKz9UQcdkfu1yGghKA2d2lXbz/Cn/BqodlUjjfi3OCW26wJtpzDeGk3
         bCaPIfQfvFQl2mTdqe8hv9EV8QenxNPJ4/R6cYOX+ukofz46aSIxI+zoiAKqJTkKy+Zt
         RuX+ycRwOEPUOKg4nHusyucYQIdjA07axDoFxzJF01glILrSPMhaHlpI1pFaHRfgZQfg
         xh2geX9EOJ2ad93Sdq9+NLZo3afz9NB4MbOiguMi/vInckRPFZadMGZhhGivuxWDI6Oe
         otblobrKwemL8pruCySEOPyagZrZDEMzLY8Yyeo5lkHiuD4JkLNIk0Xujb7K0eDSQp3p
         77YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bAITO3y/ju2E/+p9GTxr9wsk3UMDCPB8LrqMLu/DxU4=;
        b=42/dYY4zEPzEJEasitH6eaPQCk0qWUS2BceLwl0fQ5RAP/83VQy2Wp0Q/jf8AQoS5x
         nrsVgqLRscpKiMYlDm3MK32G9lTx8P6XFBgkfKGPqtyxifHQsZxFMx9V6FlF0DAxjutl
         Y7Dp0y2wNMli0ruNWM0vVShDCUkBPNvsy4jJ1evFdQF1I1vt+k32uPSudEceGyq95fCg
         VIQ9ejOQRhnGtKiGoOZ5YcOp/RRYZO75YL81P0FWtpd61aXaEya0zGnswyi8izDYHitd
         fybVKq90xSlcWuDqxdbysygXqHFEEtDCyM4TuizmtmX916uEPSV0MzPiI9RA/+kb/wAF
         n5eQ==
X-Gm-Message-State: AFqh2kqLrb/kRTvaIylb/Up84f2nkjU3Dh7nGRtSvO4Coum3Y3Did0/U
	7o+0H8lH68afJ6xNOwjNB/JS6GTHs3o5rJdyrErHdA==
X-Google-Smtp-Source: AMrXdXuQj6iDU7ydKDNX2WXWS08ZB8AjLM2GmHfB3McWYiawQPSS9mrhaOw5Fb4C64BzytTsKhuh4PfhqlYK1PRCf60=
X-Received: by 2002:aa7:8887:0:b0:57f:fc4d:f773 with SMTP id
 z7-20020aa78887000000b0057ffc4df773mr21306pfe.3.1671585540202; Tue, 20 Dec
 2022 17:19:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182940.739981110@linuxfoundation.org>
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 20 Dec 2022 20:18:49 -0500
Message-ID: <CA+pv=HPtWrkHhjNu77bxHzZ1xBJ_1vhocbiQYuaNHnyF9ZQm2Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 19, 2022 at 2:27 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi,
Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
