Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E05D2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:22:07 +0000 (UTC)
Received: by mail-oo1-f42.google.com with SMTP id j4-20020a4adf44000000b0053e8b5524abso2650169oou.2
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 14:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLtXm86nIpV5O0iZuPwpTb/HuHq3oo/rP7oXpg4owkM=;
        b=LCwhAtP1n8BdQUor449EVn6BOH1cKJn11n4bhzyvQ3c/g8nR7cPLJzvQLZZAiR2Lpq
         bz9WfWTf7x9fWxdu30PP2g9PnEbJZKyqmqY+1RH6s09PyFp2diXvN4hs3Yb2eeD7RQC8
         DpeyKvdmk3U1W+6G70P0N3jcjISelHrkKekrsQBLCQv1Gk3K4g4/DRIqipvzusaVTvoR
         5EPL3v0/K2pJfPaxWQwew+l6EweMcP7eWCwvLhIfi9fBx5ERaDBiGT25GA1ZH8Yftn0z
         0ZsBidjGkHNhqg6EOD+cXydVPiJPkKKekSJT8PD8UA/UQEcLqAqghFnDxRbKj3TOusoj
         ZpVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xLtXm86nIpV5O0iZuPwpTb/HuHq3oo/rP7oXpg4owkM=;
        b=DHnnTLt7jRNdBWjdAEmJRbn+x9Gl61HmO65PDEQmTIugngwbwyf25+gambIs5eDvjz
         kdyRfHbGpKPQlO11Vt9LeRn6mjS+z7+n6naBxk/pBKxptR+ugU84nTrAWXlmuyjkgU/+
         kdNHKiSCWI/8L9tc8cGi/sehk/iICU6g7e6rCHZtJkiK/dUqazZWoWf1AAcW4IW8Urh2
         u+ONzvWlYV7x4/iEqJ6eorJSFSTSOUO/K3y0Xf6YMLqVh6YhE2HNLfS1OMNyz6i3fecT
         cWnGrPOPbbXxsivACEjTwW4yb+JUWHDaf5nCKqi3ArNtOUm0AIeVP55mrmQdPbtqX3y4
         E2eA==
X-Gm-Message-State: AAQBX9f1iXE/pmiqzDoMpaq7T5dWNyZydMq+6DgkrrybEz50nnKTqJLz
	kg/KYqbGzpR1D/K0jC8ICYM=
X-Google-Smtp-Source: AKy350YB41lBiTY3+jKqRDqp6yP0x9B9J+Wif0a86wPc48UhwUI8K4du3u+miOgnH+TEG4JDLP2VVA==
X-Received: by 2002:a4a:45d8:0:b0:53b:5510:958d with SMTP id y207-20020a4a45d8000000b0053b5510958dmr479838ooa.0.1680643326778;
        Tue, 04 Apr 2023 14:22:06 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d11-20020a9d5e0b000000b006a3170fe3efsm4243878oti.27.2023.04.04.14.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:22:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Apr 2023 14:22:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <d8f3d6cf-e1c7-4f00-a452-1ca945d5a580@roeck-us.net>
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

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
