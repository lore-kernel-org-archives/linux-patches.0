Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A9115A0
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 02:05:41 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id cm26-20020a056830651a00b00684e5c0108dso3362593otb.9
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 18:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gt3lu2Eo9scEd1w/hLxcrFCpQl1y6EBw4SedxjGpoHg=;
        b=hIf/bK6KpisdKpn0lutY+ug0qSbaAr90xwrHnj4VQRtv4Pr7phmV4mZxbmi/2DPfkq
         sRr2eLSJUfgSAp1DCLEPmyRCqaPql2N3rhvL+Gxdtsr3P2s5/PWf1jBqMAH9H19dEVqM
         LX89U7iXfVS9QTfaj/MPzamrdXBz/0hGEnCWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gt3lu2Eo9scEd1w/hLxcrFCpQl1y6EBw4SedxjGpoHg=;
        b=GOoOVLQEYflyEMVFAJ1LfVFUEJivQH5LkqnfpwkVZeQjAJngBnPAOZPvKCy9Acf4o5
         Tom2n4fN31Suz4KytMQHhfo/Q9HF2sXggHdx1pQsDFGGTGO+s61Sp0ca00BX/ZJLq5WU
         eHQbAW7GX9Sa1RpMXFqwKxfZO2h3Nd8JbOuK4auDEk3mvPnqvF3y5LQjHVdK/0OA+1CE
         3cdUaJRKCdgvW0uzjq7JbE+EXsq1/kQI0Rb0Q7ecdKM04+U0IDtue6Fz53lNVqFSs8xC
         pSl+QQzyeUHTnsVSZ+kjaG3CkEKoUQcUvwNqqCDJF0fUxEesHTd6kufL4ivtRZ1PaYNR
         zOfw==
X-Gm-Message-State: AFqh2ko4jngCHOItx5F2Ax+gdrNjxQ3IQDtZd/LFImPd3NVhXZtyf8nV
	JqjfKyMPmSgqKqr79FQmS7l9fQ==
X-Google-Smtp-Source: AMrXdXu80sZ8VGqMOHuCEol8vjyQr1hDeoh+HypB+EmkOjHM1dNyPMRxPszGClP+QDnZNueqcHWrYA==
X-Received: by 2002:a9d:72da:0:b0:670:a09e:c7d2 with SMTP id d26-20020a9d72da000000b00670a09ec7d2mr12981255otk.30.1673921140445;
        Mon, 16 Jan 2023 18:05:40 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id v4-20020a0568301bc400b00661b46cc26bsm15400639ota.9.2023.01.16.18.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 18:05:40 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 16 Jan 2023 20:05:38 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8YCcn1aLoFqI7SL@fedora64.linuxtx.org>
References: <20230116154803.321528435@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
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
