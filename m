Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C953C38
	for <patches@lists.linux.dev>; Fri, 25 Nov 2022 17:18:37 +0000 (UTC)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-13bd2aea61bso5904640fac.0
        for <patches@lists.linux.dev>; Fri, 25 Nov 2022 09:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7x5BBj5fBLX/5/DEcV6SvhEuCMk9BiFNrwgWVnByZg=;
        b=aeQEdLl6pBOWT8hSwQ8jK8lMK4i9lzz3gaGUob6rWROi/4evSRD3g4xv9zBe9gIpih
         ETNw6gyJaZ/On0dQsv4l9AlsnlsS9HrF1bELcGvj5m2nxIgo1ldMaeXDImbeEmLMmqav
         bEe7nv2t1ZQO4Jy6MyZ4WLMkmFy9iz9K3BLRuxhLe/ZsnFovSjyG6HcMtji76BrG2cDZ
         r2ATnjFS0TCJzfdBHUQu/GT51jHk80EPro5uV8/YvmwhUJF/3tyfJ2wvLGsKPvsP1lT/
         15b2NXbDJ3Ax33Pqnm/4tTWTg0BHD+xArvLaG0obj3dRIru8x4bp0RycYTG9p+vgEF6h
         7ZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7x5BBj5fBLX/5/DEcV6SvhEuCMk9BiFNrwgWVnByZg=;
        b=V/eFKam5KO3I8rQFCKvTBvm8d33MO+VCWgRWGaIyY4t6vBTs8UcoYPsqmFKt82c1UL
         m4iQ206x6b0qVCE7Qmz3aUFG0WfNw4hIGcMKpLhNjIsCLwjBVomb3HWyNBY5G05RJ1aO
         0Ex2bBQR2VFsbw6YNjl7y2ZnW3r5hg0ArNTv/I5qjgLXX9GOlG4tHLSWaWfR5A3aKGxX
         B8Zx4HjEzJgITg1hdJdfwgayXW/z6dvhHJXFB+NBmF5lZoSUuX6SvuhRZKp+JFxf49kM
         cqR9rhfg2hCVPafjdGJxJxo3dksTlhAVuJ0cKfOa1qnDPrjk5suXGZCmn5yIM1Y5gaOY
         sClw==
X-Gm-Message-State: ANoB5pkUp/yHqX+ZvjCqAODIHnvC2jksBr1iRzSNNqbpA8gjuYfxTPzo
	x3piD8pB+V6WdX+lloHR0vM=
X-Google-Smtp-Source: AA0mqf5HOtSMBhsfSc+27EtISyyy9Jr09IyMh3qKXAM/mvSAyEX0iHF6yEBFNrHylI+9AogHN3BoVA==
X-Received: by 2002:a05:6870:5896:b0:13b:d2ae:ee0e with SMTP id be22-20020a056870589600b0013bd2aeee0emr12431501oab.19.1669396716658;
        Fri, 25 Nov 2022 09:18:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n30-20020a0568080a1e00b0035b451d80afsm1687547oij.58.2022.11.25.09.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 09:18:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 25 Nov 2022 09:18:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/180] 5.15.80-rc2 review
Message-ID: <20221125171834.GA1205540@roeck-us.net>
References: <20221125075750.019489581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075750.019489581@linuxfoundation.org>

On Fri, Nov 25, 2022 at 08:58:52AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 180 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
