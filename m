Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1B6225C3
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iOg9LBqC"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-278eaffd81dso3585544a91.0
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696961899; x=1697566699; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bk77dOQP27PiG73gUxQsGyH2X+lxrMRV+EDRGaRWSjQ=;
        b=iOg9LBqCnKL7Rf0A/EYkLHjLoEOBIiPbZ5yulFMA1e56VPbO9TQcKZ06Kf8yx7Xne7
         fN16jPa3GWfQB6R82OoaIIZ+oZUNoMiKgK2077s8R+d6N9Z/iQYcUs7NYHq5cZYLLKNl
         vSNAEzUIOzZ7Cz53MtcESty+btg69ulMDuVytoTs1ywR8roDyKofLmzUaNjX4iYz55s+
         MDyVvJzj2DxH1VTWVFHMBoP1MrzGmziBsY+SWp5HIt5mpT6bRmurNC4Cev2uo4iQq/Ic
         gowOXG0GcblBRDgGnAEt0GXPXL86zeC4YqQE+yz4LRHbbKOXfiD2uI952HbHc+5bCK+M
         9f8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696961899; x=1697566699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bk77dOQP27PiG73gUxQsGyH2X+lxrMRV+EDRGaRWSjQ=;
        b=EOGE5uym4Qn2lZzp05S/W2D4xlmPclreUytT+EPo+2dzciGmcOFIyJY15s61cMGoA/
         /tM5i9MTxTOhTrapnZELRfvJkmBD1O+leHK1V8wZc/zQi73I2e2BkSRqBOF25uWlPO7r
         uKSJyGxbtWviTSVziHyd6Okae8SE3/YFjOUcBW5VGxbGqw8yHq7QMLU6qoQWtpcAcUFt
         prJ0O+Z8lCMh8/uWzB0dH6RbjzpQbElUqyjkfovb/cyeoKy5aoQpAvbnvzR/CetaJUS+
         Mz+yixKWNOyiNwZfHitBZ53nZKbP7V4fLVb+gLi2ha/bWwspSaJhMpDQNFBPvw28acKa
         r+7A==
X-Gm-Message-State: AOJu0Yx08xG7cKOek7lm9D3bO0lGfvIMdniCRMWIDmmVcOiMPlWCQ9KH
	//X5GkiUIVDB42kAU8aMV94=
X-Google-Smtp-Source: AGHT+IGsj6CyB+Bgk2IelMiKwZc0FpHtAzxeQwZP2EDKXbD7aNGJKEf63jyWOYHrvbLRwvUrEG99Gg==
X-Received: by 2002:a17:90b:3e88:b0:27c:ea7a:3e84 with SMTP id rj8-20020a17090b3e8800b0027cea7a3e84mr2390535pjb.7.1696961899414;
        Tue, 10 Oct 2023 11:18:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a19c800b00274c541ac9esm11329784pjj.48.2023.10.10.11.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 11:18:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 10 Oct 2023 11:18:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/131] 5.4.258-rc1 review
Message-ID: <1b3c65f3-9803-4904-959c-3df68a07b918@roeck-us.net>
References: <20231009130116.329529591@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>

On Mon, Oct 09, 2023 at 03:00:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.258 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
