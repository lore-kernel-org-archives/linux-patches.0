Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349F52F27
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 14:44:38 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1322d768ba7so43136664fac.5
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 06:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caqkfLJYxEQD3n7JinVpvb0wb3kUB4I2X5RnurYG5uw=;
        b=NNxupWvBG+JgHxJyEF7pjw3m9rgtzzWP2GABvqweFuP+l4pUXiomlAyYmkOKD011kl
         Jj2T9MZF7dzB/lAb0Ab8JVXqwY07HCGi1Qw0k3oRcY9INSZtoZmODVhMi4BS8B5xN5sk
         FAmSBgQrotoFJZzFRQTY8IdX2+zrLQKzHZd90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=caqkfLJYxEQD3n7JinVpvb0wb3kUB4I2X5RnurYG5uw=;
        b=JZ2Iy47qNi45OHighXJfs4/PLa/93Y4F9TpHW22ikUhaZUE3X7jGIoxMvD4+8/f1uU
         jxuZqzl7Z47vjntSek0gz1kLW3ImYleRLW7H8Xb+YmnLUWKpUatcvjm2jk4bltijrGZF
         ZL5fWdRlHuRCo2if8BYS14xtbdRoekupyWeNSmCM1WKHldT4USHDqSX4rBktiMtbGyun
         csXE5v/BibGw7ypUZKmJZIdfT2V3JeWLYt92k9vQX386/WhM81yGjUTW29vB7R7ceRnf
         d63/jRES7ZFwtF6If7ExaEqsT/EVnW8lUjBmWpdKJG2dxuA/OPssj2ky6vkS5BOCjntE
         Bkfw==
X-Gm-Message-State: AFqh2krs+ZMhBHeNSx02YjXDFHDn/U0ZBDvt4+XWVAawILic7kr0r0Lt
	uhszyJux/ugKU9vIjdBYNlyD7Q==
X-Google-Smtp-Source: AMrXdXv8HPBhbJtxCXaO7Df7rsRQdxEn97YzKYKeFtWDbSiyIIbJouVucNhWdbdV20QoqZT9bpTOSA==
X-Received: by 2002:a05:6870:9a14:b0:144:7a85:63ce with SMTP id fo20-20020a0568709a1400b001447a8563cemr29773594oab.54.1672929877087;
        Thu, 05 Jan 2023 06:44:37 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id ej18-20020a056870f71200b0014f9cc82421sm16101474oab.33.2023.01.05.06.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:44:36 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 5 Jan 2023 08:44:35 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7biU9SSrfgV6iHF@fedora64.linuxtx.org>
References: <20230104160507.635888536@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>

On Wed, Jan 04, 2023 at 05:04:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.18 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
