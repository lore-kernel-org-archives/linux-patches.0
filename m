Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B897470
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 18:24:20 +0000 (UTC)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-17ac5ee3f9cso39493983fac.12
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 11:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680719059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ONtXHsFdkNYgP1HOTNA0FlfkBGs3b4xV19x0hQRzSms=;
        b=YpYX0GN+Nh/RoB4ClA83wZO9sfkDDFUDB8RQcRJh1glosn/bCLWQAcVwr6TBF56CWg
         1gMrOHy/J+eTvX2+IoXBRsWADsXrHrPrU2jsNETWnrY+r59FFY8wyPas/SGegRvZjN0s
         56x+ZNkGRMJz+jDbANPbKi54y7tryHoZ8xYDVlU2jyjSSrpSf6bU4Vp9ujUOrkXc/Njx
         +nlVwTFRxOvR3Ww+CMkYOwZAmZrD4Q8790oXKn90GpNsWLcOoRLUVznuKg7eJTeJeL8M
         u21kIWubNqGi+epoWyxyURJ6LtJvM7Q/UbSmRFLnOqs7X6czOwdFHFxlWczw0Y3Jhno+
         Y2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680719059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONtXHsFdkNYgP1HOTNA0FlfkBGs3b4xV19x0hQRzSms=;
        b=kH847cnIE0j5CLuEbL63ENPW0U0koZuiNVqATpqPj5Oor4Xa2RRGn8SkN9SWfya48M
         vXBGLZ78RTJS9asgxQcZrWx/GjXx8vo4Y0oHUHp7q3dWWgqm61vO2Frt8bQBv4+9Ua7A
         U/e5hroMcdh9OZ79nVnh0oseAfOYvO8ariC0sIX/wXOOEZwguxf1KP998EfgN7DvVQu6
         HEygsuV48SOgh85/MVqN8tTXCza1q8aOG7FGmI/e7WgWr1TGl3FB0Qffc0hz1InyPtQk
         2zY0/qnKS3azp+WIzVaJwqT9XyoEdliD/2Kr4I1/oAs3SJR+6NuOYM0FJhGDl0AHodzI
         XRqQ==
X-Gm-Message-State: AAQBX9cNS0Z0FN8ncc/3qMwhQTbTn9QG74e8+n0pLvYW6fGsIhXgNXVt
	wnU21MRtrwtX8/Fng8W90dg=
X-Google-Smtp-Source: AKy350bDmas/yzxcH3Kf/5PqXkUJUvVJpjI1WNx8Mz5HkO6lYyL07ItMMKVTA08EYa7t1nW8ThCyag==
X-Received: by 2002:a05:6870:2181:b0:177:a15a:4d5e with SMTP id l1-20020a056870218100b00177a15a4d5emr4487368oae.37.1680719059618;
        Wed, 05 Apr 2023 11:24:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id vi17-20020a0568710d9100b001803597b4cesm6075364oab.55.2023.04.05.11.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:24:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 5 Apr 2023 11:24:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Message-ID: <b1ee46c3-7a3a-492b-8547-3d608082d78c@roeck-us.net>
References: <20230405100309.298748790@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>

On Wed, Apr 05, 2023 at 12:03:46PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
