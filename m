Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC6D199B8
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 15:55:39 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-792717ef3c9so43966139f.3
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 08:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695311738; x=1695916538; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9CKMGYQM2xSphxnd7h9aDjiueXWWZ1DAS0m32zMMcFc=;
        b=B/52KC+NDP4X51pnQc6pM/R4s5P+R2HScqFSgWOjNzmZXSQSPb+BCqjhBA8f+aL0SK
         OnQJoqW/v1Hn15oMBUShZSgmgF49kkqtpbcrTnxXfCTrJKaeVRPqx/Vt8rrbKMKyDuvO
         xOTmOPTJFt8i+YMD9tqxZjcnj2gpfhBOzdgrSSGMfaQxQ+C15TCagwEMAqhwzBQxIQ3T
         vcSocL+mARAPHJ+k1JYWeKy/hTopq9phV7mlTXtdNGCcYezK9lS82CqrS1UAKt5nnT9T
         pF8K4pc2DhM8WcW6Ch+Zfz0xtlPDLq9rN/qM79rdTGuc1LlEnl8cH6/yvRy3QYcCdZ81
         qiHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695311738; x=1695916538;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9CKMGYQM2xSphxnd7h9aDjiueXWWZ1DAS0m32zMMcFc=;
        b=eaeTNY3uFEbw25VQLjzCX6MhhCvBPpdyoy9OLL8zuJtg8LjqMQt99EJLR/ZjgRZE7/
         xkXPQlLlUIA7d4CcAnKSxQxTuIa0CLCTlsVvlvlUxDCqjVvQ+qibK4eB1k0RyM0Twvb/
         ckQKV/JcO1rcqFVeyfxlysvhEkWTgwmKMVnBlb6fonkn1BFQKYxEUgSDddshWrznQL21
         aZa02p0dLJEH0EWqv5GsbnF9CzJIVfezHhxE7YEb/HMsTYhiWmZkigSViEWym+spoJUk
         fdRDkJPgO/GCcdGHu/ztC5h82pU6TKMGCqHHPAKTZiQHGSyQvOX1tCnz6+qPTVdeBr7G
         ul9g==
X-Gm-Message-State: AOJu0YwZhEo+CU5b4nGVqr5edEe9VZDXiZuFti9w7RyB2sgefKeKcety
	FlY/EPpNz+SHAUi/HW7ZgQ0=
X-Google-Smtp-Source: AGHT+IEmzTMKRhsDTL1/zowyo19aKrYc25ObOXG2WI+wl+UKZIdrPvY/3Opqv8v4tLPBXfzLLH8Tbg==
X-Received: by 2002:a5d:8b0b:0:b0:780:bf50:32ce with SMTP id k11-20020a5d8b0b000000b00780bf5032cemr6171170ion.19.1695311738591;
        Thu, 21 Sep 2023 08:55:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id eh24-20020a056638299800b0041d73d0a412sm436805jab.19.2023.09.21.08.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 08:55:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Sep 2023 08:55:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/367] 5.4.257-rc1 review
Message-ID: <8c686e7b-a770-4336-a047-4f2e2739405f@roeck-us.net>
References: <20230920112858.471730572@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:26:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.257 release.
> There are 367 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 464 pass: 464 fail: 0

libbpf.c: In function ‘bpf_object__close’:
libbpf.c:4205:15: error: ‘struct bpf_object’ has no member named ‘btf_vmlinux’

Old question: Should we stop build testing perf on older kernels ?
If so, why are perf patches backported ?

Guenter
