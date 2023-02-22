Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2185910EB
	for <patches@lists.linux.dev>; Wed, 22 Feb 2023 02:36:59 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id y8so6557811oiy.6
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 18:36:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SKmcGsNQ4fhRrMcdXSSRjVajCI4KB45b/EODQuEUJ6o=;
        b=EiBnREc+YVTdZou6w9ZUQ+E1ddVihBHRah8AACvFOaSKA+k3uOiJ2iWls/5bmzGYGy
         Ko33dd0T0sq4VFyvmbj0FfX2dG3pzb9bVqa8T0tTjn3tYkr2WkzKtIvddfryWtrgSLeL
         sbV1h4XlxAUJNf4OoJji/wnV2Y9KjwnXQGdNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKmcGsNQ4fhRrMcdXSSRjVajCI4KB45b/EODQuEUJ6o=;
        b=w2dtqo7fpH6SQSiuZk1zBIwT3Fcfohj9/9FtbeKYuUNJZMH2NbVVme4bAE1cTtu+TG
         N1IJNm52lYpLkv3BIJpBRnCJlpJ8wdGjwExsDxvsYcQoR26J4PF/9q2FPpe2lX3d0s/F
         m5bBWJK7kCI2v9VjBP8juWzAvmyX/7CywqyY6f40Wj4UmAzhcelAorBzoF0upM7MtdIr
         o3upXnW+y/NbybNFH0Akbo2Uor7h/ayHB5zvTvmqtR6bBSnyIMvts532m4F5axC/8/g6
         jb0SUZ7LQ5TlTEAfcx2qkT/M5AOMJDsAZ9zPPiwDASWyH+pa4Ur29vOrexLLnAlOXSOt
         GQ/Q==
X-Gm-Message-State: AO0yUKVJl8W+Qn1zukUD7kYxMgDTAhuuEnVI8DB/UntERKlNuKRmx/Se
	oG0nG74VmwFGA8o6QFCDC1RgbQ==
X-Google-Smtp-Source: AK7set9ywrkVYLikZ7VBGdXshHd74At4agEypcKsPCYfCyAxbVz5UaR4M3Nm7uYG2rSL8VNixzM95Q==
X-Received: by 2002:a05:6808:347:b0:378:8516:5c80 with SMTP id j7-20020a056808034700b0037885165c80mr7524686oie.43.1677033418886;
        Tue, 21 Feb 2023 18:36:58 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id w187-20020acadfc4000000b00383b371f2a7sm1456578oig.42.2023.02.21.18.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 18:36:58 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 21 Feb 2023 20:36:56 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
Message-ID: <Y/V/yFI7N3BlvZ/k@fedora64.linuxtx.org>
References: <20230220133600.368809650@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>

On Mon, Feb 20, 2023 at 02:35:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
