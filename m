Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A83BA954
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 23:43:20 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id bm2so23079870oib.4
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1680565399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+kZVt7LtKE+lA5uejWYYqCOFw5NZiSEn6sJt5bKfW4=;
        b=TUawIrXcpmq/iw5q9PtohrAmgkDgEZBYtVVR96KdKQQNNkBJYHYHmdicMv7agXuQeF
         UrB5riSK32nY/uCtqoztRRSJhqkVZgHpwVmcT7/6ft1XweGjgOMfJtJ3bqlvwZ4Bhcgo
         nyvIEs3mMy4Gd4FyrpYwagE6AAk7GARodPbEo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680565399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j+kZVt7LtKE+lA5uejWYYqCOFw5NZiSEn6sJt5bKfW4=;
        b=QhkHrHdjC0BNI1E6pB+SbfNKeGWb1Rgq0DdZK5pmgaw9TvPuiNJc0Oq4Xy1aayXEbt
         pY18rq7qiyhSk9W8CAq5Wel/SHAOzMqGXWXX58fjW4hLMEh/RSHaWspYaH0wXAUvdajh
         TfZfpzVa9G5QvlvX717VmCQYD/4+i2CC+d67MJLkQBh12p13/Nfea2Ko1HPUR5wNrV5u
         GLEEH09GArgedz1uCTfekqVVPBuR0cT4iPjuqXMWy7+EdnNNroRldHyi0rguXoikArSO
         PRFc46Qc9B0wycTVzxVUot5tHwlwdM+fl5c+RKzJiV6HyVvL6X+o51DWOcV2Taj785gP
         n1Tg==
X-Gm-Message-State: AAQBX9dDfA4xc7lX1lE90jhqJ+oofpRnb8qICJqI3/lp9HfPfppksaNo
	Rbz8VARIFTzrcXgiHzOBCa3U+A==
X-Google-Smtp-Source: AKy350a5pL6MDx68qE1GhzBon575/IUkWBkCH8YZMmi7kAVkxJvXGksTgIBibZWQCKoe5kDiwSMiyA==
X-Received: by 2002:a05:6808:2104:b0:389:340e:be43 with SMTP id r4-20020a056808210400b00389340ebe43mr638647oiw.48.1680565399370;
        Mon, 03 Apr 2023 16:43:19 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id w10-20020a4aaf0a000000b0053479edbc17sm4609530oon.33.2023.04.03.16.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 16:43:18 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 3 Apr 2023 18:43:17 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <ZCtklaEG7OmJgFNi@fedora64.linuxtx.org>
References: <20230403140416.015323160@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>

On Mon, Apr 03, 2023 at 04:07:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
