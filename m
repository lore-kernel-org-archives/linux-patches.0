Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8C9D518
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 15:29:03 +0000 (UTC)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-57a6df91b1eso62964877b3.1
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 08:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689694142; x=1692286142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KyE0/fDKwt8r/GBJ63+HlewaRDyQRINPAaWQSmZkqf4=;
        b=VgyYyQPCaB/LoR/abJvGjHy3yDhmSQAO/vfOSiIEVQYd99sfkUY107eN3492Qosld5
         ev6jaZAbBA9TE1L+p1k2DRhkvvZ2lCQwshoR8sb+r0IiOHlN+GX8MRM/p4TJT97lbGf3
         ulxM1KGiX+tNk7y5A3KEkltuQs6n/jLyeRVRnWwtGZtZmw0G2qvYOTPOJygdsV8zfM6Z
         2bj0OQeHsCi+7h5muOs9ffUwf3X+LlTgcd8Q/d5T+CRl3zLFTtbkjwKdVVZKYvzSB/nS
         EEwww57F+DuMZZTzQSjktJlbg2kh2FSsWyDt+MC1/jHX+9AEZBO1uttdfbX/uqlK7b1w
         uFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689694142; x=1692286142;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KyE0/fDKwt8r/GBJ63+HlewaRDyQRINPAaWQSmZkqf4=;
        b=CjPlZedEdc+1EdesHZQ2vt4sOamlUuuE3s3XapRkfbPyU1zPcQQTznojFeOB5jvyaZ
         9nVUW8MruwFzUz7dh8uzp50nm33AvnetqCDfC00SaED0p+4Y/nwMK10Tuv2NRHjsZYoZ
         HjvfPkq8xrgB5WWEybcd1+xC40W23oZWZchrnmYnyCHqIGKDpSIC0mftXWG2+VjhTIY/
         2wLz4Gz3f1wZ6oTcsbcjv0dbPEVaM0JWD4LxaBMz2vNMTgrvgClFPM4zYE6xz7hFYiqh
         OVCfgszLPlZ+OXBTVo+tkSTl5FbvLh+3vNGfMpQ4dKOzSXfX70GjgW3qFctNpW4Q6Ze5
         rKng==
X-Gm-Message-State: ABy/qLaD6to+95vTNECpyoRLbf0GPoXYs0DMAb/0+eO970dppo9GDBWg
	URYTFXkdX8NhnCNN/UgwBt4=
X-Google-Smtp-Source: APBJJlEhiEn8AIISGAC2VhfGSVlNDoIeULmev8wfh7LlZmym8UELY9e1bBIEHgz1Y1zlVNY92IuaOQ==
X-Received: by 2002:a81:91c5:0:b0:579:e318:4c01 with SMTP id i188-20020a8191c5000000b00579e3184c01mr3107023ywg.19.1689694142299;
        Tue, 18 Jul 2023 08:29:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u84-20020a816057000000b0057a9a46e2b7sm507979ywb.80.2023.07.18.08.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 08:29:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Jul 2023 08:29:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
Message-ID: <83d8c38b-0b27-4489-9c72-318775739aac@roeck-us.net>
References: <20230717201547.359923764@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230717201547.359923764@linuxfoundation.org>

On Mon, Jul 17, 2023 at 10:34:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 521 pass: 521 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
