Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC805C2FC
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:27:28 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-56dd69cbb18so3198350eaf.2
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 11:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692037648; x=1692642448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eAhMGvofRWfSgtz5u4k2nIYitbgyVcQrqD+LU5q4Ia0=;
        b=Ws546J6GtLIWv08o2rhn9cjjrVaCn6kpHmZqn+BvFYFqKUGJxBnosqnlNdyQxwt9xH
         nZFT3zozeJVWDDeMtZ7k+lrNnq8jtqIZfL5zrIVIKCUw/LOMpyc7N2Hwgsnf2NTBniGx
         MCX4zvH9CtlDTLt4rc/i8+GW95LhOSvoAe0QEDJcgkf1Aw8nDy/QxuBW+5aJzupw72cy
         nrfbs/N84aaaPHT5HTUPleyVpzEbzb2Hg+AeVUJnwGFSnBKhL2tJbMKRHAIutoPzI2By
         RR/LjlkG5CrWR+cGbNj51zyb7VXD9+eFqfF3qG694yaJI6JOwunl4lKVKT5ApVocVtq4
         N5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692037648; x=1692642448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAhMGvofRWfSgtz5u4k2nIYitbgyVcQrqD+LU5q4Ia0=;
        b=Na/XYpm9scpoESETAhCVydXHtldeibw4STVhogs1sF2GOeUxsqfUEl83RP7/hOYBMj
         Zk4lfS0AFlXgb11jED3ALiG+7uQnpolimDfGXS/Om+6ByP1ahmZMQh5yQf4o3SueyQqL
         u545oMuha58o2nq4YylgsS55NzSIDZNq+hBp+jG1s9ZZ/Ys58nrFy/pQjxkJzJZ2CgN/
         9voskvv5YcZ4niLJvV5U6+5rlMeZu01Q+drrPlZUaA31EUkxRqrf8QF0d3xsTEkuille
         DWmyy05GOpG4bpbjAXOu9qktN6X0B2C62bNkIdsCj4ZAjjvzpf7HU0an+gV5R0a5+v+4
         dMyA==
X-Gm-Message-State: AOJu0YxXhLhKdUapfXOm3j2jXfUOyxLm3hwe8zsi6PBIEg2d8oRjw8TR
	eJFCG6KOfBsm9UxB83De2pU=
X-Google-Smtp-Source: AGHT+IHY2MBDjJscwi+JytvRjdu3eZXlT95uCAtcbonJrBznwoHoRu7QVwAp/m4acx9nPzxqVnw9yQ==
X-Received: by 2002:a05:6870:6013:b0:1be:ccce:7991 with SMTP id t19-20020a056870601300b001beccce7991mr10048539oaa.13.1692037647724;
        Mon, 14 Aug 2023 11:27:27 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i6-20020a02b686000000b0041627abe120sm3173833jam.160.2023.08.14.11.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:27:27 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 11:27:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/89] 5.15.127-rc1 review
Message-ID: <bdc5a048-6707-4fc9-876b-6ae2b3befbcf@roeck-us.net>
References: <20230813211710.787645394@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:18:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.127 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 501 pass: 501 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
