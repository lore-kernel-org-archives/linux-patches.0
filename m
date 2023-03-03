Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D6D1107
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 01:31:34 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id s8so817633ilv.10
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 17:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677807093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AFSBhx6GM80UDw/tpb9yhUm/OU5MNnvb0GkktU0dK9I=;
        b=LWY5+gSE7JWgbXI69OECoBJIxPWbMXvqy6a7bT6BqqoHn0HZcY5SqJr1JJkhm7xE56
         UDkCghmFIiHT9VMTTxCEaw846icy47h8O2oL7B17YWLo637OaziuPypCTqO0UXJPTh9e
         Ova9mpI6YLZJxZcJaWiGYm9BE2MAIuIgwVrj1YkuBH3cmr8d19W2pIe7GDSTnQFxWvYc
         JOXT034/Nq+BFEySikY7rhAwDTk3sQ8Qc4oByGB+xzp0zHPjPtz9bsiceDpav0pi4Wz/
         uD2jJ/m+6KKTTRuQ1dvPbmDnz5yB1RW/g6Ss1uZq345UlRwCy7ngCt+mgm4cKoy8pH+U
         HcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677807093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFSBhx6GM80UDw/tpb9yhUm/OU5MNnvb0GkktU0dK9I=;
        b=6H1X7O1Y3/AxFodGCYIWJdCsAUpnvx4yBo3/o7AlKW9pS1XcoNW/vLOo1UghGBCI0M
         s4zVxWUBUJqcBLqT+qsre/V+ywaWMSkOAJwXutoiZvRptolIEcdBUU3vP9tPgEUcmhrH
         xGcMnIXPe5GOnFsTsyrNiz981+rFgNarRkgMR7YDAoC0FsvllYAqgAep+NxKSefR8njK
         5Z6GIKyEeZaJPlNGv7jryeum9pEzSzjeQnXqYbCNfBploA54lFofVIANz6CD5pQ1WZYd
         IAQ5Ftsa9a/KX63vLb/j+iGqn7hEu6kgikWetbzHZGbECm/btmJ1SJUl/wS2WKhW59rQ
         TA0Q==
X-Gm-Message-State: AO0yUKW5kU/vLWRPT5HIHjCo+5zszBJvJd1oEReP8XTPkdRBPLR307k6
	RC2oXFfnl7CzSgv2GNq1xgY=
X-Google-Smtp-Source: AK7set8RDSLapjeowHOH9LTpfI9hNnnOJtvH8Q5QN6BGrrDsTa6NwRpp2OIwHoHxPczJxkz1V+salA==
X-Received: by 2002:a05:6e02:1b0b:b0:314:e56:54fc with SMTP id i11-20020a056e021b0b00b003140e5654fcmr465893ilv.1.1677807093412;
        Thu, 02 Mar 2023 17:31:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u10-20020a02cb8a000000b003ea1dbd00d6sm320431jap.70.2023.03.02.17.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:31:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 2 Mar 2023 17:31:31 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Message-ID: <1c58ad1e-0b12-47f7-80c8-c0fbba941f0a@roeck-us.net>
References: <20230301180653.263532453@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:07:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 504 pass: 504 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
