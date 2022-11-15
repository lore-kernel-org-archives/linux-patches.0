Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18E21FA0
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 11:49:54 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id b21so12919963plc.9
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 03:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6nI90SEnhZlekShgEiB+0Ge8+V2Jx/PCkyDouTkqJA=;
        b=BaPv0r2Q29YXpFOYUPcwU17sK2mQRunwxxauGsy1K8ZxRsNAjexFESeb0wF57irnTo
         5hH0uFnR781W8tCXDWRVi2oSH0V7gn7eJOvNEIzmjnWQs+mr/fKH2+Y3B93Hl+/FDugd
         WcPPtDmjyv7NvFLiSxuOiNW2lxfu5x5/f9l8Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6nI90SEnhZlekShgEiB+0Ge8+V2Jx/PCkyDouTkqJA=;
        b=6gc3JS3e/5p/7bUwxk3fi5a3T2VfbU68nv/vqhWNhMrh7VQ4y8LAoEpaimo+ewnvnb
         0VNRrajyqQvTtOqxngtEPyv1aIbuzfte979dFS+RrwGg0jL6mtAYoYGjW5J1KalUwse9
         Jc1muZ1BHl/aFTxNVt2oLANRl6Si3gYODpyxOM/F2n6ZTibuLgoauaxOavqn+h0OJevB
         UZLNdJh5PQsTS5znFbc75E1LQUnehHDZyCNF8PPgOiSUoPrifxi+UuOKmSP1sSoSHvri
         sH8kL3xlVgQiVEqDcqlX7yLii9Box2ubVmwaiOFoKY8gKbZ2wQFTFTMqtf1dUQhs4yDt
         d4zg==
X-Gm-Message-State: ANoB5pl7CDlyF8iK65XJ/LedeT+9M/cv4jCAcMyHdxCZXrkBuj93TRdB
	HxPgXKyCfPCYNugMJ1pfk5tU9w==
X-Google-Smtp-Source: AA0mqf5tN98HeEjOYKzpslHF/AITY8OfQ0nYfgBTm0Z0n9DM4DAQ7jFzAYnaNkPwY2ogoQ0Y2vnKAA==
X-Received: by 2002:a17:902:c389:b0:186:99e3:c077 with SMTP id g9-20020a170902c38900b0018699e3c077mr3560983plg.161.1668512993983;
        Tue, 15 Nov 2022 03:49:53 -0800 (PST)
Received: from d5d3ab63aed3 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id w193-20020a627bca000000b00571bdf45888sm7524215pfc.154.2022.11.15.03.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 03:49:53 -0800 (PST)
Date: Tue, 15 Nov 2022 11:49:45 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
Message-ID: <20221115114945.GA279@d5d3ab63aed3>
References: <20221114124442.530286937@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>

On Mon, Nov 14, 2022 at 01:44:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.155-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
