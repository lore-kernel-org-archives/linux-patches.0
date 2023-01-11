Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFE933D2
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 17:28:17 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-15027746720so16215327fac.13
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 09:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u54AezqJjjpM+HGr4IJs9A+cPR+RvkDqVZbwor81vek=;
        b=LAPsO9RurEB0r9THrmxm35xrP8vycJrtwQDDWQYt68C1TFRc9uKOfrPgCC0/xvGF/K
         j4h41s9nRZDT44jVc9HBVh3hSFEE5elJV5BFIA+Ij4kAkkPPN94wMfQD9Op/QolgYM2q
         wk1g+HG1Ti5OoEOb4bBIKwwWslh6Ypfeja68c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u54AezqJjjpM+HGr4IJs9A+cPR+RvkDqVZbwor81vek=;
        b=DgnPt0ySRLZLKgCIf3/S/B5PShFBUFRjoU76TvPMRWUH45fX0PTcP0sNe9FoFddSts
         mh5Zfrm60lBIR3BOZXw7eg7wqDkuwozG0DpOXaoFR4zLzCFYQPjIrhaftd6NybQvAz9Y
         OIav6ye6MZQQdnDIZgF6Lm+SHTfzz8YBpo9lWW4qTzGuNU5bA5SoXGaO012Gf0hCzznT
         Pj0wMAVuV4u2ee3ET8OX25bTc3wkUFxd54xNahrqrCKS7hxoMdA17xl6DaEdhs5u6CbQ
         VuQINWe1wdkyUpuFqYXFflOl2pH7vdy6Z0e2McBftEWZuevz2WP1wIfR2yjNECbXImB3
         +8sw==
X-Gm-Message-State: AFqh2kqG9CQco4SGbOw6kPfpyaCebha7kVuoRnqOSK9fW55bIZcIMpXV
	4D2Ux2fegpx/0pS2ihIPEMfXbw==
X-Google-Smtp-Source: AMrXdXux1df1fFmYjJ7Bb6xj79MJxEeW8UUn9KvAGsRK1VijyG5s4AkNRcRQyVoNAWocXDr3l5vyWQ==
X-Received: by 2002:a05:6870:5b85:b0:14c:7959:8c2e with SMTP id em5-20020a0568705b8500b0014c79598c2emr1742032oab.2.1673458096651;
        Wed, 11 Jan 2023 09:28:16 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id y9-20020a056871010900b00143065d3e99sm7638241oab.5.2023.01.11.09.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:28:16 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 11 Jan 2023 11:28:14 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <Y77xro03HZe/+DyP@fedora64.linuxtx.org>
References: <20230110180018.288460217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
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
