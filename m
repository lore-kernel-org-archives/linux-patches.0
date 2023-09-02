Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB0017EF
	for <patches@lists.linux.dev>; Sat,  2 Sep 2023 04:19:23 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-34ca1aadcccso8972785ab.3
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 21:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693628362; x=1694233162; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7QdftxmwE9S4q+Wm8VAAV5jDe5pULUFp51jEAHN/z6U=;
        b=I7glFXqwrlf7aYeDAz6qzrKVWRXDfKzSmfa3llscMGMLOvJV3ErooqcInOsS4dft2e
         F22CwTBOfFMYLYzNF82LFtiayR3zkUMb7W5iGHG+3bRnUN3byhUS9Ixj72rfkNWcQk8b
         dH7HGyvDisMEsgxQBB0xTqFLPx9uPyA2QJ/9ywpxMFr0nlW2uphfKErWFrOCZKrmfN6r
         KJPhbAstLsUP6egku1xA/a+yv1py+W7nHfnCJSAY0uCeCfNCK2dmTu+8l+NfuER5ivQZ
         pVOclfWaIU3t4bwhUSlUezFcF++LAyEGf0oOLKETg9q3cNU8+xsg/JDU6FN/nykOHIVz
         xUmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693628362; x=1694233162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7QdftxmwE9S4q+Wm8VAAV5jDe5pULUFp51jEAHN/z6U=;
        b=DF2ioRT334NDiPr7Cu33P7MivWYsPnARDjrjpaoUxxccPZMWscchGlcjVMBkItl6s7
         jfvQyhYT2pFzhRE6IziYl3LQYgnCwebXMN6yUXdz7orreQu1cQtEuAw4N1RLuXRzTmJp
         RnKVLR8JDI6jUS/ZODsDK9KtK5ot8E1XJzAAMGmA6a+UWdw7iFDT2rDgogxKK/Y3i1bH
         fl0mj5aBmxIW8dLrsGWCoZLu47t4NKeLtNxh3QlSH6b/7eqaOvXSjvNG9rMZvp4jDJFM
         Jg7YBUlIAJNFh+esxpdrmULdaJxDSa6vrDiccu9V+oWzbflITPWuziCn/a7lGsWt36wW
         KC/g==
X-Gm-Message-State: AOJu0YwpalhXPuJ9z3OYw7pahMKtbwcLE+yoZLIS7OGyDcJ8A89yLrmJ
	GaSMkRMsGXwF/fQWL9jcba8=
X-Google-Smtp-Source: AGHT+IERpXr+53LLKHCJ0ONZGVx8+rUUepKdylO8PBQm59sdQHCv/UZq4gc1yVK6qaJIVobhUcyWLw==
X-Received: by 2002:a05:6e02:d0c:b0:34b:ad7a:383f with SMTP id g12-20020a056e020d0c00b0034bad7a383fmr4796388ilj.0.1693628362441;
        Fri, 01 Sep 2023 21:19:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id gg18-20020a056638691200b0042b57bbbaf2sm1568330jab.26.2023.09.01.21.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 21:19:22 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 1 Sep 2023 21:19:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/10] 6.1.51-rc1 review
Message-ID: <970e0987-99ae-4194-a40c-6a5e18eb0899@roeck-us.net>
References: <20230831110831.079963475@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>

On Thu, Aug 31, 2023 at 01:10:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 521 pass: 521 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
