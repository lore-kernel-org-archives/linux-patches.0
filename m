Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7F7F
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 01:39:38 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id k7-20020a056830168700b0067832816190so20103226otr.1
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 17:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WGPbBPdsp8zIf+EmFg/nOXV2cdecCkjYIO3nEraDq9Y=;
        b=MD+yU2XpDZkyNyPpLshmS3Cxq+jRFNJr4pec7YPTCQoUkwXce2fO92A5btzsgZ3myd
         GYqLETtSlQeZWmoUcHAAb25jk3f/utSVu5Vwmj6nlkPCyHhtiRXN1qREywdcaDQE5MQF
         aydvtCIuO/cu/kFsZEtIw6L3LC1/WbkIwQ+ak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WGPbBPdsp8zIf+EmFg/nOXV2cdecCkjYIO3nEraDq9Y=;
        b=MR+sNN66pDtn4LsCu/8QLOzPx/f29m+SjCs48dM9iqQS1Srnv8xAvRsZHgTOfVELO7
         IuhHozN4SU1/85VcxHOt+P2a3RNly6MH4luChFaAC/CMwgKbT4+XSvcwzZU1qXJhgO0m
         ZVinyjF+UokoLCArVuBMCrczkOD6Zg+yGF6rkFZ5dQyApo4RIFGbhQS7A2cMPNTQUkYD
         5u3mdKt7rLWdNPipHdTLUCEmEWtqFtwzXN/IQyu17kAE3yZWoZFat/cGkn3UNcRsCZim
         +GV9W5MVtvb2asJw9RQK76BVGuseYLFo16dv3Hm9kyTzaccV1Z1AwlkYmpb00CQVQg4F
         Am4g==
X-Gm-Message-State: AFqh2krUL65/I0oydGxyV6jSe8fo8ZcHEnpiR7y4olbByA9n/z/iX6BA
	BtxOaWmc4LavWud4WXAX5fq3GQ==
X-Google-Smtp-Source: AMrXdXvEQhWHLpe3ZOJFYnCQi1ouodXNJ8NYkBOZ+42TANe2SzsIG7iZ15RliSoUC7TvfiGn4247Mw==
X-Received: by 2002:a9d:2c28:0:b0:66d:da2c:c7bb with SMTP id f37-20020a9d2c28000000b0066dda2cc7bbmr22014145otb.18.1672796377124;
        Tue, 03 Jan 2023 17:39:37 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id w7-20020a9d5387000000b00666a5b5d20fsm15322435otg.32.2023.01.03.17.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 17:39:36 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 3 Jan 2023 19:39:35 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <Y7TY13wNr/7MQhgM@fedora64.linuxtx.org>
References: <20230102110551.509937186@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.3-rc1.gz
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
