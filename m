Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4701107
	for <patches@lists.linux.dev>; Fri,  3 Mar 2023 01:30:31 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id f14so405050iow.5
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 17:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677807031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XlGgobBosr4aLTqWYDgJgB9Kw3mIrz4zp2pRXMgYa9s=;
        b=RBdfXRCpwEQJHNG5UbkFvEE/B38F2OqP6WtzGfctEeb9dmnVdLYytcncweeP+AWDWY
         dQETkD8JiX7fHVW5iFFacWbWQ42MmpDgqqRnOUfv/ZT5pBCJOSOWh1dikegN0CtBkhCg
         eg71MN81Qq7KffVgCygD9G9v8BrhKKWGXffipDAiOWVEpM8wjEEDXGIdGcW+RfiQqQoK
         ginWcdT7n/UPOS72cufWclqYPPUWA5Jixc5PNPz8fk6ySBLKkOyXd+nS4dtU/aG79Yom
         0LjHACjm5Q0oyMlXGA7XYaYxynG+t6fanhU0dLCHD4xkJg4eSxQV98qUGPlde4YUHqlJ
         RVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677807031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XlGgobBosr4aLTqWYDgJgB9Kw3mIrz4zp2pRXMgYa9s=;
        b=w8Mxeejsna/IVSA0uqhRdRBYEbRBFpYeZzR/V4hUZATfZHjsJa/QfFLlVgTln60edt
         6PhqZ1KpU4VEk8qsLYI6TNQpfJ9FNb8yXH25ENDRrQIsayzSi3/dBDW84YhEkFnmlbFO
         45dyvnCwY93l9YZS9YK+MQLLEuILGWjuzDC+dr+KfnhtqBCZ7PSMtLnx7C0AAs+oAY3Z
         Ahjy8VbWwghHHSkM4BzqQBw0IGgaJ1EsVfgRoVxx6+RYyX6Up0n1n00XzxFx4RHE9QHY
         EH5zcKc2cVlsUUwfI7RdqvyrPdw0L7jiyi7TnNsS9MRDMkdpyK7XQnC/9HTEjV3KLj6Q
         hjTA==
X-Gm-Message-State: AO0yUKXKt+LquZ6H8R09JDkf8JAxQypNlBWY+avQRKPUTgn8YE3IC9Sv
	KJgYlYcFVm1daFn0QhVR7q0=
X-Google-Smtp-Source: AK7set/eXBvlGlBYJfZPV306b20XP5u5rJAyiTezRWvpnOvnYZA144L4ZBc48sm5eezIermQxyJp2w==
X-Received: by 2002:a5d:8795:0:b0:74c:e1a4:a285 with SMTP id f21-20020a5d8795000000b0074ce1a4a285mr16270ion.2.1677807031044;
        Thu, 02 Mar 2023 17:30:31 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9-20020a6bfd09000000b007407e365832sm303927ioi.23.2023.03.02.17.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 17:30:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 2 Mar 2023 17:30:29 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
Message-ID: <29c4a6d6-b073-4b09-93d7-a5602ea1c0dc@roeck-us.net>
References: <20230301180652.658125575@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:08:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
