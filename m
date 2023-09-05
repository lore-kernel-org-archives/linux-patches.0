Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A68FCA7D
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 17:11:46 +0000 (UTC)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1d4e0c29028so1460283fac.3
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 10:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1693933906; x=1694538706; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aKkV/gdpVbXWeDor+5ZiimyzgnnKqYGNlXMHbycLo6g=;
        b=hN1/IQkSgbSg0flads5p/HbmEVaY8MqmzlXcu+cvWofjSvVqQMNp4GbuKdzITtfqIV
         WPtD4IJ6IAte3oYvHSuY/AJB/vwlv8/wPzGMEpu/kPJRjGtxTS4rYLFc7sr3r7yslL0t
         wEIF4NL0O4b5G2xV/iMBuzrzDMJUFH0K8MuiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693933906; x=1694538706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aKkV/gdpVbXWeDor+5ZiimyzgnnKqYGNlXMHbycLo6g=;
        b=UaGAtvJrcnInF4hwD+1VDZeg+6DqW/qhaIYfgFZEldvjGzhUmd0QOdkdLLi1VB3Rnb
         Jn8fegUSvX8pZLmDgzaeiFo8OEFpx+VVKJ08QeDvOXolyyoQInOU+NviAr02HV37TC3K
         iDxc9WaZUv1OE/3LLVuVUCthkyBxtXBbbX1PBfInOZl22UK5Hp+fpPtjFpQ992tkMmAi
         sX1K0Ig4PlP2PW6uJzrxEjMI7RsomQdgyELTHHnwSRivlA4/sGr302BR7NwOr+BKIqbA
         UyrfVak1ce+vcCN3w8/iUA34XYZEqtjuoohPMbadoAiOXTcKLFZs81kica5vg0/ef40Z
         rhrg==
X-Gm-Message-State: AOJu0YwSu2fp2sIXEDeQMJPiHxx5n8XN/f0AYubkVJW3m8jlgnKITkTB
	DTsO0+GE5C3u2GA/MpusTS/e+A==
X-Google-Smtp-Source: AGHT+IEzhtU1JZMoj8kA++Rihq9U3PC0Oyza2Z9UchGDwNwhqqyrJHcKEMD0nUuF32FRQAGsyfAr5A==
X-Received: by 2002:a05:6870:78e:b0:1bb:9c27:c7e6 with SMTP id en14-20020a056870078e00b001bb9c27c7e6mr16121041oab.41.1693933906036;
        Tue, 05 Sep 2023 10:11:46 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id g1-20020a056870c38100b001bb919237cesm6736729oao.3.2023.09.05.10.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 10:11:45 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 5 Sep 2023 12:11:44 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
Message-ID: <ZPdhUB3R/vYp+zxz@fedora64.linuxtx.org>
References: <20230904182948.594404081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:29:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
