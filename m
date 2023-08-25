Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB299101F2
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 14:24:31 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68c3b9f83f4so43081b3a.2
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 07:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692973471; x=1693578271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vHyka2U6Y9QLR3iBbxMxEWSzu/iMnQI0MUngbRlsFAY=;
        b=BRzIOGxuRosXrZwg7/OsmumCL3DVKh3ipGfPDi7BQNgjqFv/K4e0DeFlCr6B9ScpJq
         tqhWrH3jBZ3JCUmy2nO/aJ99fqoda8abgk505EcnjRILOKbEQoUDhIdrY4s1YtUlSQmy
         TpRPjkHL6+i1lhltwha+HSuEM3tQ89i1GyhmGfaERgalGjlkhSm8rpPV0QOg3DyRnm5X
         ioNUCdsgXRo/Is7OidNH7wvAL1UDGdrF8S5GNRutFqo8OXIZWGJRHcb0eRNUUvP26L3j
         trdtwFz8rEt8HDzw18kjjJvsyjev6lD3yRtb55T+vQOsggThF56tEMhSwUhz2RCNODof
         eraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692973471; x=1693578271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vHyka2U6Y9QLR3iBbxMxEWSzu/iMnQI0MUngbRlsFAY=;
        b=Rv7Am5bcfOD8bSSwc24hwjvF+vqO5MFugFYCAIUqmP9VZX9Xs8J5zVKGENQ2RWIW94
         vWu29UekrBQFqvDLJkEkqeKr3NWLduTGaZgvDnz2J3epOx6BKogsrwDvbqc8E1KNYJTK
         6yZamBpPrk/jppH5kKdYK2oZ1FTHwBmsJGDbeQ+YzdsNMnqADSgeMsfbJ8Fwt/XIwEtI
         AC/eGIe1/r5p+Zj14n+XhcUmoGzN8PEoF7Hf6UMeJC65AiQtw0OW3KEK5Bf8IFia3F4r
         9Thq6h3fkeFehCMF815T33Ji1FGE8j+KxcMD4gPqE+LrvWBB98HHQvU9VB4PoWhN63ug
         on/Q==
X-Gm-Message-State: AOJu0YxbFw7DjL1jfA1pn1bYA8d6HbRu/Kypzd6B3lp5QKD9rWfLSGHA
	gtO1QZZDVxY9o0vU4eGTJOs=
X-Google-Smtp-Source: AGHT+IFVem110PP4tmF7Ev+4kTdchTFejqRzAwBbt3fP8YY3TzU76qliEjKgB2szc8YRyFlqWUssoQ==
X-Received: by 2002:a05:6a00:1581:b0:68b:4e07:133f with SMTP id u1-20020a056a00158100b0068b4e07133fmr11558479pfk.7.1692973470973;
        Fri, 25 Aug 2023 07:24:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y1-20020aa78541000000b006879493aca0sm1623555pfn.26.2023.08.25.07.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 07:24:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 25 Aug 2023 07:24:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
Message-ID: <fb1c3952-1d72-4f9d-bc93-2988bcde462e@roeck-us.net>
References: <20230824170617.074557800@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>

On Thu, Aug 24, 2023 at 07:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.192 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> Anything received after that time might be too late.
> 

Testing is not complete, but early feedback: All riscv32 boot tests
crash badly with errors such as

Starting syslogd: OK
Starting klogd: OK
/etc/init.d/S02sysctl: line 68: syntax error: EOF in backquote substitution
/etc/init.d/S20seedrng: line 33: syntax error: unexpected end of file (expecting ";;")
Starting network: /bin/sh: syntax error: unterminated quoted string
sed: unmatched '/'
/bin/sh: syntax error: unterminated quoted string
FAIL
/etc/init.d/S55runtest: line 48: syntax error: EOF in backquote substitution

This is no longer seen after reverting the following patches.

92609bb3a1f8 riscv: uaccess: Return the number of bytes effectively not copied
e06648704417 riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit
20704d763646 riscv: lib: uaccess: fold fixups into body
4f503bad920e riscv: __asm_copy_to-from_user: Optimize unaligned memory access and pipeline stall

Guenter
