Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA56D2F2
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 21:20:21 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id a30-20020a9d3e1e000000b006a13f728172so14902308otd.3
        for <patches@lists.linux.dev>; Tue, 04 Apr 2023 14:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680643220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tfxpdbuFOonJn9jZwoNDRK7Oo7M2eMNyBRNxPTgb3pE=;
        b=nlZF5MckWdcsD3yTrtDoEG+amux9+C4Z40Fj6nowzZ4zknMCyIY0Xo/bmGo6m2A0cq
         LrJV7s6LuFw1Lopflme4JwaNjCNFa8Vf/mSDR4WU2J1BiOcoaq5/cq6sJVWgRRMk4Enw
         e241lrMINZA6loLBVFL98cqIkzYNMa0Bpxuf9MzVSJJ8LYmbDcFnE3PqHMoVEz1yNE3R
         qqtyuUEbvV62jdSdBQ/dwIBG4WgG/o3m8whi+O9iOXFjORd7e3kt8kMpgJHDGeZoIV7e
         un8MtxtrUjF8mPfbiIl6SvmQuv4iuXz9cqXn/U1ibtR5OI6XCxTHSx3oD1o8Xc810YJQ
         CcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tfxpdbuFOonJn9jZwoNDRK7Oo7M2eMNyBRNxPTgb3pE=;
        b=yxO4TrecKHmPXS8AfLYkconlmyihnelE8jRvF0GA+SWGKSx+0rfWyd6laT4Nymr5Uu
         3jd7eGYOT9V+nNiG9X5wvcnnPkzBv3UqjjjWX91E8v3RNohQ5hGfW0jFfybPhAtpE+m4
         1qSKVAtf4xSGimjqsgR4KpdEn6SnbqAyHnUtqJOrVSI6LzJs9dQeWGtcbf3q7hv8Be2I
         uctqhG+4M2/sHiJQqcnYuLpmkmAezyXAuZxwWh7JqbexY/SuEnTUo6vMXxpSjuTnLdQ4
         kIO8jV5uoFdAjPAMZ9MY1RH+mKXU6OyYECHDoknlBqQa/i5yh+ojXM7w1xhu5H3xAXoF
         xTGQ==
X-Gm-Message-State: AAQBX9c3sU2zdcE9rV5YXbkMRKrAHosG4XXBM1A9QdhJuMtvLD18OjtJ
	Oxoa50vQU4CdOFU9iazdCc0=
X-Google-Smtp-Source: AKy350aJI/6dxLYLWAoc9XvDP+IWUBXAqrb+bB5yni1lUMeuQglziJ8ffRrIZuoR4ZTcFi+pjIfVXA==
X-Received: by 2002:a05:6830:a:b0:69c:6b3:c7af with SMTP id c10-20020a056830000a00b0069c06b3c7afmr1822503otp.16.1680643220179;
        Tue, 04 Apr 2023 14:20:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m15-20020a9d6acf000000b0069f0794861asm5923942otq.63.2023.04.04.14.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:20:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 4 Apr 2023 14:20:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/66] 4.14.312-rc1 review
Message-ID: <d2c1d38a-03b1-47ca-8b25-6a808d0f2e55@roeck-us.net>
References: <20230403140351.636471867@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>

On Mon, Apr 03, 2023 at 04:08:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.312 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
