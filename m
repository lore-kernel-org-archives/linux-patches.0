Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E7C7F0
	for <patches@lists.linux.dev>; Wed, 21 Jun 2023 00:37:23 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-260a60b4421so1471110a91.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687307842; x=1689899842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+CmmRrQCnGR13BTKNM1nX2I1ICaZM3+kWbJi3ubrV2E=;
        b=fq1Lo8s/yjPfpxS6WCgo7KmzI5TTNPtZC+t6vv/iXuM1AVPLCxCPXDxfCNNIFbHyAC
         FW2T4M7op68MNYWWMt85KZD0yhoifaHP2P/zBo0OXcePz0d4Iygjx7L2I25IGO2lR13C
         tFTfEgg0YLwUrEC2tMpvOdqnS8GB3yvj5Fd1jWxZ5onPlhLfAWO0gpRrrUxSW1CX9VxS
         PuN6yKSxHRxFvHsyNqjWneB7Bu4Oj6uVQ36XhzTFqxoJO3SaosBOsCvs5uIHqZOiXver
         XgVAaumCNqwxVdG7RGIVkmu4ja3TTp38KEqOs4NoQz0qmaVjK7Qf9oL4VkCFQUmg0KhZ
         nCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687307842; x=1689899842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+CmmRrQCnGR13BTKNM1nX2I1ICaZM3+kWbJi3ubrV2E=;
        b=YdCBvchktdXrIczR8OEnpPSJRzVQhhu9+TSCeH434Rl/q3xydNc9lovOwIbQOvZkjL
         FvuOToS6Rx+YZucDHyN9rCQTvqX669v3E+lCMlAXbpFpfOGWTq7jddSG08vCKBaszQks
         xbu/PFjsMn2jHoC7D8eUIDnLYeUXss5xL5N6yn6rRgCLrC+sdK/dk7OGuZqWOX1RpjFD
         e86EL3hDmeGQPY1grgP5/+CW3z2KRGm7fxaIGDRNPid9Za+FFxA++QIX7NrKZM3OG/0t
         bzyJQWbwTbYKN/NHncky0XBaQAi2/BxMfrwf9avruWltF9T4i5IE/JrCAhXble1Gumqz
         6axA==
X-Gm-Message-State: AC+VfDz+6M/Cl3WeqEmMpj3gLTa41sVxUXGdANq0aaQcnQ9QAnuQYGmM
	w5iwHHr766IBCCmZ0LbzrAo=
X-Google-Smtp-Source: ACHHUZ7XaFY65pBshpId6vsjCS3eiohcyTgZdIMOMDLtOJbm8gcWv2CZtbNhLJ83ncBTqXzLebmtgA==
X-Received: by 2002:a17:90b:918:b0:260:d06e:38b7 with SMTP id bo24-20020a17090b091800b00260d06e38b7mr2232428pjb.33.1687307842370;
        Tue, 20 Jun 2023 17:37:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a031a00b002502161b063sm8311379pje.54.2023.06.20.17.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 17:37:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 20 Jun 2023 17:37:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 00/32] 4.14.319-rc1 review
Message-ID: <80273ace-d87e-400c-a926-c7b9bf2c030c@roeck-us.net>
References: <20230619102127.461443957@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>

On Mon, Jun 19, 2023 at 12:28:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.319 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 166 pass: 166 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
