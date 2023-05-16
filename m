Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999521C26
	for <patches@lists.linux.dev>; Tue, 16 May 2023 08:35:28 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-96649b412easo1813729666b.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 01:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684226127; x=1686818127;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P8e4NHYJl0ojx/fa43Z8pAIL3TomPVIv+YLhEdD0YsE=;
        b=MIvVQBlSFw6cKp8JrUYDItCgBnwdr++cjK8DsRaCR3avEUKQ5+59oc8fk2bJ+t0jmf
         rvMV/pTTcBwK9MyFjCUNPmLqRsMU4ttaFEZVMm9SADp+7XrPGRXHerKFfPoFEwbz04nc
         QnKmdJCjeCB32/OGwZC5RGoUxh9cYQt8vlVqYFfLfL3bYi50lCZbMG9tbL37hzEPoIZj
         63tq32DQDu8ArbxUYd6uEF5j9nSPj8eoYVxfG0GV8FlBLiJ7N/B6njnStgwNxwjh/0e/
         AX1GxxILtsC6cN3lm9iqVwoOevKFN4tdyeZZWdK4Q2d7PlnUxSzANEQbR7C6pW+fomOi
         tcIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684226127; x=1686818127;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8e4NHYJl0ojx/fa43Z8pAIL3TomPVIv+YLhEdD0YsE=;
        b=l7LUjTR79e1A5iKxPQYIMJUdMgRWjYTNlOoZM1R90FFnfinFlGJrBsUX0CBLmRnqLN
         hC2wb1Ih9HzlQRtbGA/+lfdIfeaI17Ed3jjpXreb1hazn1jNYYMLqkEdIkDGMrvomoc6
         xXvxVb7DdFg6ZdZTRe+oQL1gQwDDKkukg9ZrmbvyoDkdbB83DKQGLpaBMKCPo7K/DM4N
         Epk4YEb3j+bsTDRwmskOjMyRNh0K7VLl89ZDcJcgSR/j6o3u2E5qO9/cgxdb7CHbdTPy
         8/0/ggjQP1oZMYsxnFhInUBFaHmGpPZ1/n020DO4Vd5fB2OwKqrT6dbVfP5OA/IMwcqT
         2L2A==
X-Gm-Message-State: AC+VfDyu4cx+f5ctWJxs1zrSaC8v/7GRN20GGnMO5RcC7DKKGC/bh1k9
	5OMdtxiW12B4KYuVmgeI+8E=
X-Google-Smtp-Source: ACHHUZ770YWb+27ocY0i/HufgaFXPBUzmRTEQY6c6vHTnhLHiM0YjdJifL5YooavC4/oGYDzNSv03Q==
X-Received: by 2002:a17:906:6a24:b0:96a:2b5a:f013 with SMTP id qw36-20020a1709066a2400b0096a2b5af013mr20490261ejc.62.1684226126482;
        Tue, 16 May 2023 01:35:26 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id ib8-20020a1709072c6800b0094f67ea6598sm10659250ejc.193.2023.05.16.01.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 01:35:25 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 6B030BE2DE0; Tue, 16 May 2023 10:35:24 +0200 (CEST)
Date: Tue, 16 May 2023 10:35:24 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
Message-ID: <ZGNATKe3U0oXHICX@eldamar.lan>
References: <20230515161736.775969473@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:24:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.180 release.
> There are 381 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.

The build fails here with:

sound/soc/intel/boards/sof_sdw.c:187:6: error: ‘RT711_JD2_100K’ undeclared here (not in a function)
  187 |      RT711_JD2_100K),
      |      ^~~~~~~~~~~~~~
make[7]: *** [scripts/Makefile.build:286: sound/soc/intel/boards/sof_sdw.o] Error 1
make[6]: *** [scripts/Makefile.build:503: sound/soc/intel/boards] Error 2
make[5]: *** [scripts/Makefile.build:503: sound/soc/intel] Error 2
make[4]: *** [scripts/Makefile.build:503: sound/soc] Error 2
make[3]: *** [Makefile:1828: sound] Error 2

I did mention it in
https://lore.kernel.org/stable/ZFuHEML1r5Xd6S7g@eldamar.lan/ as well but I
guess it felt trough the cracks back then.

Regards,
Salvatore
