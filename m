Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E268317EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:20:59 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-794d98181f0so98662139f.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628459; x=1694233259; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7hEjY9vj5E7uMkH5SH9VhgI6wy3KF5lzRxFg6Q1w1GA=;
        b=TuHJdIm9ZUBtW5aShCDCdedS4/67EsxQKQByTJoRGYi56il2YsP4V9r9qIsM6WEJtz
         pPmsevW2bdvlGYbU4ic+J8f4/wQZOynk7GJuOl1Urd8ZH63+SJZBgv4+nKowKQsySJbx
         HV5fGlUvFD9+26E7lCjSdmuR3mwK9ennOEr8HySLSwyymVMQzz2bfdLe0H9zvziDvCd+
         Y5HfXixnmUodjvrMsbhRQ48YDHT8a/3jlaKWjRV4M+LHtFQagycmPDcM9hemeMZq8K+P
         qih/fIr1OB8v6j6Nm+y3HVIGUWvL8szrpqAEZFLvw0HiJsnVXf4Id4t1+NJRfqQaBDPx
         N1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628459; x=1694233259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7hEjY9vj5E7uMkH5SH9VhgI6wy3KF5lzRxFg6Q1w1GA=;
        b=iBUEHjw6yW2vbEzIrDE0UuxRVhmvnr/WM9ViROKUBTXwbtFNVihF9xUWmMuAowx+gZ
         thJo9XrhgBwMYgh3jCueYDsiRRqPFPsuaQgf9umyVGLLI4BgoEpj1QsUpJldKVpo1CFS
         SFvAOKti9rI+EV8q2q9yBxRfT9tC/5inBo85CzHcBA3KDIeBwFJUcqmH0bJzi1Bkwmk5
         aK/5ygWaGbpjbPoVl8XouT2Nb7QjuKlvVNYv+sF5Dxq/gEmDGrYEj5JIo1/52WqGbES8
         cPWiBuyoQG83J/gTjvJvuxQB0FO+Pv/uLrWFMParMEm+wRrItcZu/g0HmAvMtRENdIG2
         UBJw==
X-Gm-Message-State: AOJu0Yzf+Y+YQhmjvUZuOG9xdt/itlQAEAFc9zhZaZ8zDBPXwvkaL0Za
	HCzfRVXWBGgA2ijgqGihRnc=
X-Google-Smtp-Source: AGHT+IH74zWwDIm0Q2OgSJlKWeZM4fba5zvlPeF5Ox1th7OCd0uzHDYgWyALsE45xB3K4A58kKybjg==
X-Received: by 2002:a6b:7b09:0:b0:795:1c0b:d31c with SMTP id l9-20020a6b7b09000000b007951c0bd31cmr4657585iop.21.1693628458873;
        Fri, 01 Sep 2023 21:20:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y8-20020a5d9b08000000b00786fe5039b8sm1556644ion.46.2023.09.01.21.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:20:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:20:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 0/9] 5.15.130-rc1 review
Message-ID: <1fefc96c-08b0-4ccd-9167-d5d7d4b77f9f@roeck-us.net>
References: <20230831110830.039135096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:10:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.130 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 501 pass: 501 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
