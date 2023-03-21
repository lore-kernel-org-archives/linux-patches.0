Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281C41078E
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 23:15:01 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id bl9so1253791iob.8
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 16:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KUohlEdy7/4ZYtxVhTsecipCyP9fVzhQ1K4SYmUTUGI=;
        b=KQ2BSDcxxAz4bTSPz9F0nUlTXdflKOgugaCfNNP9RhwGDUYn/q6dmS5DA3cdGKIcBB
         OdnOUgBWmbMugaR/aIOMMkTI7Xosax/DFzvwQ7pIU6E2m/ZsoxdlwhVCCpBbbnp/bEXA
         SstTq7ZL1Ou019liaHx9R3lhBt4INv/S0algm2/CiCGdZFcBOx4w/2rTgCKFpp1DFTwE
         MLc9zeLlSBWy/L1qg52W3N2+BWtxHrPP22XDWRRubppWwgdi4CNQaamKOWQLWOJr6BQ1
         ukf21nS1hkeZ6tCGkd5vfMw22szxBWKv6wVxUB64SDiwXCDPZ/cD16SoPFRPt4tOr+Pc
         BO6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUohlEdy7/4ZYtxVhTsecipCyP9fVzhQ1K4SYmUTUGI=;
        b=uLzcI3jm3yq8vMjYrFIVLb1BtgDaHYqVr3kXJBq/sxEP2k2gt5gyQXiHQgYkAb0QDe
         tfhAlelLLZi6k7P/+0rW3J3tgWNXXY0ZTUYfiDJbiV8ApfZnJZZcXYkbx1SALFEkmg1X
         g8DjyU7kSkISRTNbnPwIIxFDgyLIb9aRkZRIDdnX9BRZrX8nQB4V0pqIhmrjJfY2RWSf
         RlL7+F0/syE7wyvlP9JOenbTZC8V7AqXtCsTBuO7moLbcvwRPiw8p2UTuiSza4WqvjYE
         7SeNAQNPJM+Zk7aG+9MZWidQpYsJqgE2ySlLCHN2E+GmNBRMI0msbrQr+hwXSBxsDauK
         KYHQ==
X-Gm-Message-State: AO0yUKXlT4yHCkBDul1YhhTasYmRlSU7pEYc64ST1KMpOr9o99whfDhk
	/mAvXjT0wB52qYj5veRclnM=
X-Google-Smtp-Source: AK7set/acvO1NK8C51l/vLQVh58CKec92FoYICHGOu4gQqGJ4NvnJb/OEnmSI1rFCpwh2ggG5l6vHA==
X-Received: by 2002:a6b:fc19:0:b0:74c:8c3c:b71 with SMTP id r25-20020a6bfc19000000b0074c8c3c0b71mr3052736ioh.12.1679440501055;
        Tue, 21 Mar 2023 16:15:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f102-20020a0284ef000000b0040631e8bf89sm4505352jai.38.2023.03.21.16.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:15:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Mar 2023 16:14:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
Message-ID: <c6162d13-68a1-492c-89b9-a12fd34b81d6@roeck-us.net>
References: <20230320145449.336983711@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>

On Mon, Mar 20, 2023 at 03:53:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
total: 160 pass: 160 fail: 0
Qemu test results:
total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
