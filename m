Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D53D1107
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 01:30:09 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id q6so410678iot.2
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 17:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677807008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=owjpyZ4YssNHMo11kjTh9xv1lU6Ssd531IleRLffemk=;
        b=XRR92sY5TwiA1oLizZDrUoFTbDEQLns0/+8JIpPqjy3R0W5mswrcTsVDCkx0/I3jIq
         mhDmpcxq8d8BL+nYCmWf492f1z0QXU5asYiIJvx2ZQoAtoVVifVSCAEyZ1nbXdnd7HdX
         NjYwrzsoxCA2GVhMpmyNFA3QIo/aWmE5jmzoVdA/gEz2y7DSSWiWtDTd8dWhQXGMLzwF
         nNtENT8ycvUdrwyRgHBVt05E5tyGz82ZNTX5Yn1G5KP0eTl8VuAwLv2Vby164wxK5WOl
         +FqHkKDJvl8ffV/1y2/VvavYqXps8dU0p6FnX0xp0Pj9dSyhTJSeUsnudIirZ6jPC05o
         KjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677807008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=owjpyZ4YssNHMo11kjTh9xv1lU6Ssd531IleRLffemk=;
        b=k0tIAe+eGvo08biaG4bobGzxPGPYctpg2o+ilYjpJQed0JtIHMGiHHKPyqhTal9sVM
         uMrNXE4SBhrWorTKiIwY6et32W4VZ/mpnNDTAr1fMQ5nCh3dhLnsJVCuHhyf9ycnP5Nj
         V1v+tntBe6v4HZgDYoy1tvIVgWcce5KiiT5mpVC831SIj9XQX1A08WzQww88fkL9+WYG
         vJK3XbqHRsOeU2gYz0TtgcCW3zMgQZEPF4AxnCGPUDfOOPmOim1Sw8S+sW++OXbWAgcK
         uBo/9GPvXy+yfbOaDSt6EFmZdVIKuLcTdVkxWeeEB5do2nKJpGKkn8UiX/wXxrYWd/mQ
         1DHQ==
X-Gm-Message-State: AO0yUKWqzELoU9Soflbrll/n1NY3bLKKcX58hiZWS1PdAEExmXk0UVFT
	Uly2D9/+bizbwbb7FO+suVM=
X-Google-Smtp-Source: AK7set9fhR4TYUFVbkZkVFd6kHFFDTpiCE6Gi4zYoAjq+2ZGZxe4Ux2rCq5WQdGqOWS+jEK/6k2GpA==
X-Received: by 2002:a05:6602:20c2:b0:74c:b069:f38c with SMTP id 2-20020a05660220c200b0074cb069f38cmr9502ioz.1.1677807008627;
        Thu, 02 Mar 2023 17:30:08 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w25-20020a6b4a19000000b00719987fc43fsm294662iob.24.2023.03.02.17.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:30:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 2 Mar 2023 17:30:07 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Message-ID: <c85f14a1-c73d-44f7-808d-d72484ae680c@roeck-us.net>
References: <20230301180652.316428563@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:08:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
