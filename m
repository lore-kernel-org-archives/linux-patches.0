Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3220D2F27
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 14:43:28 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id c133so32159354oif.1
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 06:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EdNIzr6K79WGrUyV+pZ/Ft7qJJmll5v3NGysEKK7sJ4=;
        b=hV/gs6uGEhp2/BqwXHHWgvEpjroUzlbH5ZC972vJ/UcAIGkZD8KViT/iwG7m9ZfKVL
         4p9k5lNOY3ZDmRf517hnQLx9WH5EIK2P2gDAOBbbOlFc04N54f2ZwtvGyUfWfQUcuyUc
         lMnhJ/6husUN8ZqIPXO5e6DdPwmB40nz/jetw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EdNIzr6K79WGrUyV+pZ/Ft7qJJmll5v3NGysEKK7sJ4=;
        b=Q3MnqRIeRZvjYcLRDSQElYWRB9iQRc+GCNbyoXOTwpNB9mRhQsArxL6JSdNxfvioim
         dnHFECcR2ErJK00jXV7BlI0xXXEQsOKQzCs27fWYE8jpfbISoz/Z8Id+KMfSPwIyOGSl
         nQHVNBCAa4yU/+RPhg5N5GXwyqaEN5cNY3ZrsqycidI9E1inNV8n9Mv/rIUxEb1rei18
         jG4dTijkr/D8Ux9M4F/F7E0Xcodxfu/WPSZ/NPuTRI20RmwNV1XjFP2VMGaRAbdik8QC
         3EqhybQrJ/ZCdybYLT/YqsmDt0L+1xrR4VF4IFNGxxOH7TqLV2nccqnmrsasSn/rEIMw
         SLfA==
X-Gm-Message-State: AFqh2kpDaED6fN8wYL5x2CU5tvzrRqvwXpo5MsW/7XhdScp9i6x5QCO+
	MIrgVJ2p42eyyE56h9YCqStFnlVblBE8LRT1BBijtg==
X-Google-Smtp-Source: AMrXdXs6IuHALNc2iJnYamsaDTWMfvdsNhCSKvmYJvtEl5OJreiggIYBSep+IOTVbeYybTh5KI2NKw==
X-Received: by 2002:a05:6808:309a:b0:363:aeff:9969 with SMTP id bl26-20020a056808309a00b00363aeff9969mr10397466oib.13.1672929808065;
        Thu, 05 Jan 2023 06:43:28 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id n67-20020acabd46000000b0035b451d80afsm15375146oif.58.2023.01.05.06.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:43:27 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 5 Jan 2023 08:43:25 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7biDVBJ9ZR8BSfk@fedora64.linuxtx.org>
References: <20230104160511.905925875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
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
