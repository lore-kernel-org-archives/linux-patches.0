Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72E7B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 03:40:14 +0000 (UTC)
Received: by mail-oo1-f53.google.com with SMTP id b10-20020a4aba0a000000b005200c0d4a2aso1084187oop.11
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 19:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678506014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kgezN8INYSZHjuwQgUy5QlYxATMrFNIactDDwCM7oOk=;
        b=LvSXTIxAI3mq/JnRMLX7y3WgV4r9oY5xGDoqbTNJ9PHl0OsBnrIpdd7SqSPwkKfLze
         3YXHTfdEz3RmQv2zyZpRnntQ9dG0WBmnEiLM3IofEAnLIJo8zvCfGZYE676uUru5+rXL
         ONyQ8LTpAgBIsgTPA67BWBgXKE7QkOpCPkQH/1AUM2VfTJvPacoelJXGcopI7+t1hlor
         xMoeRZQQVP/tizaN1YGdPTsauYEYbf5ch+R2YX1LFqbuVrIVS+/Tuo9UrI35Ypse1jGx
         UUxtfKC91TmBJiLzZU/3LsFZyHUR3YI1D+9/RIXYlXdlaZDk8O0WhlF2RGJ7oHy+wzBU
         OR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678506014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kgezN8INYSZHjuwQgUy5QlYxATMrFNIactDDwCM7oOk=;
        b=oIUfUi1wQfTkuK9S4okrhXhWEwemzeFqWl4hoPi2u+sK80/7CPt/Blcm0ogfSjBumJ
         S27GQUsjkj7Ohf3orYea7MdmvnZagKSX0N4+58IqHTq7O/4fo64U8pfgW2uIHHMdGEXV
         DWHREJ2HfG0tbeo2pXmONuc60hO0npLzvpmYb5//fgQ3zj5r2vbSfN6jkoUb0X6rVuFL
         mInncfu8PH3Z6D7afvaZ7J+dgL8wrUdnnu/ile+TNO4GmDnJ7SG6RTkreOaGz8C/84/o
         iPMw3zEFdjBMfNIUdZqjAGn1v5GJg0BG5S4NOsdh9u5rXeR2RAIuWPWSM9Ewxd+1leWU
         VXJA==
X-Gm-Message-State: AO0yUKWeh6H5ZaF73VB+KUYY5xzZy2UmOXW4qu+YSI4bU3PJ+vvlKLn0
	AjxTpwpCUJxoYhjtTu62UNVZFGj5r30=
X-Google-Smtp-Source: AK7set+2kwEJsAEwkwZazC0fhwfp8PYcF1Uph/l5f+zjmp51oFzGh1I+f/zaqGlPcevTX2OxkiIkVQ==
X-Received: by 2002:a05:6820:104a:b0:517:67ba:586 with SMTP id x10-20020a056820104a00b0051767ba0586mr3225912oot.3.1678506014064;
        Fri, 10 Mar 2023 19:40:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x5-20020a4a9b85000000b0049fd5c02d25sm669748ooj.12.2023.03.10.19.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:40:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 10 Mar 2023 19:40:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Message-ID: <68bd3efc-1a5c-4636-bcd7-bf7defc073b0@roeck-us.net>
References: <20230310133718.689332661@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>

On Fri, Mar 10, 2023 at 02:36:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 517 pass: 517 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
