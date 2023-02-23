Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1423EAD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 22:02:50 +0000 (UTC)
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-17235c8dab9so13434796fac.7
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 14:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zvydFY35LBk7rNt/h/MORLJxZ1FtIClaMPSTPLJ7SNg=;
        b=KUIF198p+AdXAtvQeCvgTKWPFoCDz6ym9UfJ08/eDhIdUXH1weWTAel5gYLAJGVzB4
         YxJGbtz+2mOSKs1BNs9viRlAO28jj+9km++q9doTo7ECpTvViBjDwQM4CDN2PPGhOL48
         IgXa22NAI+kXDrCjnzmPfMeDTxDbYakFePYnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvydFY35LBk7rNt/h/MORLJxZ1FtIClaMPSTPLJ7SNg=;
        b=huQxMhYXBROA9d47goeQPJaRiA5RaTh+PKlojSx2S7QTRPw7GQQeyrcarLCfEl9uOO
         lkzWZUL4kn3+WlhM+Hpd/S0FQPQ2YIZnF9G1lnl/1LzdaK3ef7SwtGhX1uGQqDYQ9tIt
         JpOB4c6A/o+tsL8OqaY7gSzy3Cs7AumkXIOWDQb3qSxkEs6yXRDVaBVXmR12vuCd2Z3p
         BANRFvB9gM2MmOoktcY4oK1Sf/Xowuv3pbvGXtC27HzGsaHxEsJANCPyzgj1ootDLk/G
         wDVqF835K/Q2Y2zeSz7LfCsTDqA5RRMp+FBShdNFJeRhgepHGt/pab1sH4Fdgd7FRA8q
         XqcA==
X-Gm-Message-State: AO0yUKW3/hofQ4qG5ZXONPoqz9tAl9zR1IV5KNnjgAb/xLYvMVNWnXlx
	hJoHD++VopRSR0lAxq/hvUGP6w==
X-Google-Smtp-Source: AK7set/772vBfteGrWHqqXY5znI9DFjNRUvpnHi3krCHidb/B5GX2FvQtSkW1ApRhVNF64BPpRj2AA==
X-Received: by 2002:a05:6871:b25:b0:16d:dd7a:d13d with SMTP id fq37-20020a0568710b2500b0016ddd7ad13dmr12604155oab.3.1677189770061;
        Thu, 23 Feb 2023 14:02:50 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id r1-20020a4ae501000000b00524fe20aee5sm2924839oot.34.2023.02.23.14.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 14:02:49 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 23 Feb 2023 16:02:47 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Message-ID: <Y/fihxWNdr4ejNwe@fedora64.linuxtx.org>
References: <20230223141539.893173089@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
