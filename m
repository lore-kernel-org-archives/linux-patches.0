Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB6720E7
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 15:59:29 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-79f8b2bfb2cso22239439f.1
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 08:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695311969; x=1695916769; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dSYSW2qFhPqn5+qIPFrNbOjRh2C16Pv4b0nfPD6viEE=;
        b=UXXWNqL75JX2aQp7XnvHLTakDgE1PSwk4xEvomiCSz4EI/EgUG6mqWClRt1zlNJ0C+
         DjxspC7/KIPgpr9u0HzKCpbgJ9P/enacfdBqDHdaprhprPYNjMagDwx9oVQGXmKkmnup
         wuSiwN8XQgG1MVpwIOUwHh4jkHrhoskyRitTKK+ecY1air/W6NCIHby1zQi7EjAnpom7
         X7zI2hgYLy5kuGgDryKe/3EKWXp7j7I7JnwfKmKbq4U2zc8jm84+ZSPhq3KQO6/RIhC7
         qp/awQN+S9NPMu/tQ+22BVqNYVUg37Bt+OP1B4BsvAIvBBySiavGwqMc9G9KkufXeT8I
         AmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695311969; x=1695916769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dSYSW2qFhPqn5+qIPFrNbOjRh2C16Pv4b0nfPD6viEE=;
        b=KOv6+FwUOaV3PaHklviB7TfAAgK+LGbRPfgy9izLwbtLcxC0c5t3+kFwVzU/1yLbhW
         0GFQx8jA+4ljVSxLGZtL9PRqyYen/K1FCOb1ztzjeHBiA4pYPHoliQMJxUNpfG2OekH3
         PfKd2NHaTaN2ySyBW6KWDJMl+Tj5czznuDW5tMn1u3aIteog6CUcpvtspMD1D0xPgagj
         Lpam53nFoblFC3AFznumJs8i78WxqDsu9iT5titMgt+CbEXWmkgWI09MKzdGIDVyFK8y
         ogBSvWam320hsqTC8PZiIkuumTKy/u+5r62j4RhcBSmCVKNUiow72hnDObYlMk56kQi/
         eAqw==
X-Gm-Message-State: AOJu0YxDBzSrf+bLsdbh3AXmKRvr6veQqm5FHyNrRTq4UA1ms9Y8zt2R
	owQF59wNILPvAaefxOd8x0I=
X-Google-Smtp-Source: AGHT+IGUC/NwymIeM7tgGfAVay0XJcI/uXhc6rnS05JwOhzLY7q8Ynum+iAmHSi90rAnZspB8ioraw==
X-Received: by 2002:a6b:ec0b:0:b0:792:9333:2cbf with SMTP id c11-20020a6bec0b000000b0079293332cbfmr6309253ioh.6.1695311968868;
        Thu, 21 Sep 2023 08:59:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l17-20020a02cd91000000b0042b2f0b77aasm440766jap.95.2023.09.21.08.59.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 08:59:28 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Sep 2023 08:59:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/83] 5.10.196-rc1 review
Message-ID: <2ab51081-698f-4556-b673-cc0b62b0ace5@roeck-us.net>
References: <20230920112826.634178162@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920112826.634178162@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:30:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.196 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 157 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 495 pass: 495 fail: 0

gcc-10: fatal error: no input files
compilation terminated.

The error is due to commit 653fc524e350 ("perf build: Update build rule
for generated files") which uses PMU_EVENTS_C without introducing it.

Guenter
