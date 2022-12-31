Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C197215A4
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 00:18:22 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id i26-20020a9d68da000000b00672301a1664so13959905oto.6
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 16:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=gsBeA9puLHv312HXGRargKviqboQP8bDFbKQVh7oLP8HSMGIbMFKW2jkFJluyDd+Ut
         2J82O/Wxazbb4Hhi6kG9AOLCcCF/AEro9GHDhJL6c4+vqhIwO7qiYKscjlmU0m58WeRS
         45gWL+LVa4hvrId0hJR3CtqRGGJHMg1ZLHoRGuym4+6zHHjB4FwF5p3FWMgysRo9ugID
         A7BQcwLyYQ1jaWPqfDoQuPCmTlPrPOXIAid32yMnQuR/0+cCwAsDH6eUfA7JmFHfPWZh
         l1hEFZrJUODk1lHeonJtfxWwNNpGFcNdgecScij3+wGCAwnqlkNVZcQAyCutCdvy5eZ1
         jDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aD2pyMO7OOE2EFdyuJsS7VOYOnoYMeTk7hsW83uEvV8=;
        b=yIzvcZCRq6r9bHkS1rpirXJIIlYy6agTY5o3JkkbMNMpsT10BN+zSgR6sBZd8lct75
         joQZlj/mKMydkvh57wUlVLMFtzamNWW4295FtieKg3jRlr46JgqfYfWYvxb26qnz8c4g
         35DB3GmJl9j5eL8SFoCQQKY01CXx+akXTXAZb3eSxfOAyAQcQq78BQMPp+E7uta6UZ8h
         ahL8jpDiR0tyoN6vE//4SvdVn5e3VInfVLrVKEFDFv0GZrNxf3abmTx+EzE3iu00sstW
         9tdF2bsZOzhWWQ2Jl86YJldFFTwWzA61HI6OuTHQ5ncjA7HAT6xMZ+IL0ggmFHCDLcVq
         XOwg==
X-Gm-Message-State: AFqh2kqptURLrQI4UVWCO+ojcihmszCV54xWzou2wI83g9EhHM4Gv8UJ
	a0FWd5/NCR/Tc2e56uAgQSU=
X-Google-Smtp-Source: AMrXdXvdz+SsbecyfkE7gIv/54GF5vG6lc9xlPFy7e3LWgWslg7ajzCmV8QAsZb0wnBmQUnbsypmOg==
X-Received: by 2002:a9d:7f12:0:b0:670:9cff:64bf with SMTP id j18-20020a9d7f12000000b006709cff64bfmr16529193otq.21.1672445901893;
        Fri, 30 Dec 2022 16:18:21 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c1-20020a9d6c81000000b0066c15490a55sm10767405otr.19.2022.12.30.16.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 16:18:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 30 Dec 2022 16:18:20 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 0000/1066] 6.0.16-rc2 review
Message-ID: <20221231001820.GB2916712@roeck-us.net>
References: <20221230094059.698032393@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221230094059.698032393@linuxfoundation.org>

On Fri, Dec 30, 2022 at 10:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1066 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
