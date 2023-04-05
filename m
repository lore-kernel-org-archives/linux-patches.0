Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845C17470
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 18:24:00 +0000 (UTC)
Received: by mail-oo1-f49.google.com with SMTP id bp9-20020a056820198900b005414beaa075so1335333oob.8
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680719039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MJJt5ZmLdmo6nA2ruRkOyJYK88J9AtGXuib+DBnV/oA=;
        b=P7Bb+8RT7KU4UzfZkFET2IFOp9hBT+o3Uk2zFF+uRu76XQbRQ/Sm1ndijsR3VJuE0g
         8iEL8wM6cgIEM71gfylJaujZfQKAVkVNe+dIQvaaPtsVGBx2ruhgIiSDnXzDaKvQILcI
         8W8nQXbXiEhXJxzqHa9OQ63tdPRiOEubb7w14hViW5p4T11/WW3nnQ7nsCYa8SLidHMj
         BI28zm5MwhvzPr4XjGQLeHi7VDSTNHBSFjLmXtSlrDtJL6I4Z/nOctJ0Rv0Ee8GnXPap
         atm0HkUa14BVWDEN9JDUBeeJixynE3LQzbk4mITdkY9BnIE4+5vULdYP8xMxQbxPOmf+
         9tCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680719039;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJJt5ZmLdmo6nA2ruRkOyJYK88J9AtGXuib+DBnV/oA=;
        b=R/Fib/nCdL9nMcWmYci4YVyi16itCUo63etmXxPcJQ9Q8p/l2xWdSPkkPNsfXGWfeV
         lYWFSkugxjtNNGguzL7hh7Gc9dYg1U6Yzy4DypIKb75gNHEL0F5bskcoAT9/VpYKCX9J
         LKrZ4h8p6g3KMVEJ0ZiIas/AVK9j5j9ADXCXTWm/xwwRXlt0IUF1oX9Pt+ZIj7mH5uwS
         7V5wTEVrOdk4C5JyCfoeD9j7H2AB4hxBtL3Gsom9T6x154rsaAcUPSAYw0YcdB5JaChV
         5YLavnohd0SW5OJZFSXNYPwjs2rYMmQ+L7cJi9BRzrLktt6QZpXWSDh8cQ3dANi3WA1k
         8K9A==
X-Gm-Message-State: AAQBX9cIfjaDvuCU6thlpNLQYANG1oZxoNn1BYEVDPVhzp25nKuxS2p+
	7jXHGUZCq4e38f/+pClOSsg=
X-Google-Smtp-Source: AKy350aSmjHUdkgQEa8IbniOopA8vMgCr5Kz2tSuUlmEfeFvdo3tWWPv2KiEWTZHsbyGG0v8wKyuZQ==
X-Received: by 2002:a4a:4f03:0:b0:53b:51b6:3b43 with SMTP id c3-20020a4a4f03000000b0053b51b63b43mr3133411oob.9.1680719039577;
        Wed, 05 Apr 2023 11:23:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i185-20020aca3bc2000000b003848dbe505fsm6605353oia.57.2023.04.05.11.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:23:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 5 Apr 2023 11:23:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
Message-ID: <d5f456e9-bcfa-42bc-be3c-56ae454990f6@roeck-us.net>
References: <20230405100302.540890806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>

On Wed, Apr 05, 2023 at 12:03:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
