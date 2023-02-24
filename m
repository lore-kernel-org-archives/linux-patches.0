Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD2417C7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 04:29:18 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id l2so1709115ilg.7
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 20:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PQGPN7x6E89EY3z9VBVW5bdYElF7KZEnIddS4aSr7hI=;
        b=nBANjiYn5LxM71zouVdQwM7aYo4icl11doGqNfmorux5H1dwvOc1oCDUZCfkCfJBXT
         nRNLY0XHwvGhPkDuRpYjzFO8xZ8OF1mWeh2cQIiV+b18EuTxHi0pH3Stg8WREzm2y7af
         sgS19adRoCMQYjkvwYGKvIjSCvswoBx5fztFC2sROQlVQXRvTL/Kg009eWZdMe2FIaVu
         C6AolBSaSO9hvfJHmSDz8jiV/IXzYrZOGoinwFc36PNsOrgyt+4J1+e7XsgagnX0bsAG
         DneU/TsOt7odFveO8KAvaAGgShXatmNc+jMbsoSBshq/61SENDNS6rW97WYbpf6B10Wn
         ZKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQGPN7x6E89EY3z9VBVW5bdYElF7KZEnIddS4aSr7hI=;
        b=7/x74gbPJ1kcdQ3s7r9yNSpyhb1U0cKaaYSyqLxLlQcn0c/SVp3ByaIvTTHPPSojv1
         eVveKFNusPeMxPAcvQoqo38tuWX8lPhq5stcv8GYev9/CUIoDlnUEQbi3GhPCARKtZ05
         Dn4CDAD4/4UKwTrl3xv6Yke44QWSVrh/MNdX+nS6cXot1johl9NieHsphRHh+k/zwlGi
         Fo0odPCeQswU0i2lT4KapfXM9E0OqYK94Aeu0jMPxapg0JKsQbqjvKvAApbEWsUYoIth
         QnfdqUWRFBQnu/SjHbnF6hQOfZHk7ZbK4Ix8OJmRGTRYPPowbIbJLNWayeRf7G99T6hZ
         65qg==
X-Gm-Message-State: AO0yUKUIflX5QXihbUw3WIuNVLgg3VKkzRaePa2tfL0ksbhfbaN9EVUX
	/ZLsuQ8WmoRUB2vLC6MpFDF3if9G1io=
X-Google-Smtp-Source: AK7set9TscD0WuCDfVVPMIhvNppUgxA3OsL2+JBwaKwGV73U5SF/bKM1k9RnhIKrRQbcNmpCLa8Xfg==
X-Received: by 2002:a92:7602:0:b0:315:3d99:bbd3 with SMTP id r2-20020a927602000000b003153d99bbd3mr10775120ilc.8.1677212958092;
        Thu, 23 Feb 2023 20:29:18 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g14-20020a92520e000000b0030314a7f039sm3592367ilb.10.2023.02.23.20.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:29:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 23 Feb 2023 20:29:16 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <20230224042916.GD1354431@roeck-us.net>
References: <20230223141545.280864003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
