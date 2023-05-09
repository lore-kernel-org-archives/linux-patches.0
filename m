Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C03E18C01
	for <patches@lists.linux.dev>; Tue,  9 May 2023 20:00:18 +0000 (UTC)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-643b7b8f8ceso2800996b3a.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 13:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683662418; x=1686254418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKKLAFyTiJU1GoBQgK70evF0DF5IZgIk1ne0+KMszP4=;
        b=NGRA+5knmlP+GE4YkAOjgBOfSo3q+WTkUeDaOzjGZEkGESrM1cZppswykv1VK/TSkC
         wGpDhAwZzLAIamlZyoaL82gojJQubWXhjmi93UpjYVFScF1M6hZyWig3Vm0Cl1dNrFdU
         iONuzABrWOoOa0Gs1JsLXtY1dsjFoBKtVPx7wErZr3B9nepKJ6/A0gcUMA38Vd63Vd8M
         D0cG3CO1NuS114dMsxsuEeALkQqSMP3INv0KBAyT4Xo6NBpjyGqFqqG34g2PA6z6iYi5
         Dg851LL26Ku9fFI4Qhp2bKfO6eLodWR2BRgJSu3g5W9SbvCDWU++J9gkUaOqO8aNlmcd
         yM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683662418; x=1686254418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OKKLAFyTiJU1GoBQgK70evF0DF5IZgIk1ne0+KMszP4=;
        b=WAaRxj9tGG6TfXu5NdbRjdXqd7ZdclJRm8cXt2EQVOs7ETs7oDi+8X2WBFpgfJHuKe
         yL8tPI2Jbm+zcyu/6r5U98QCvGWdMYEmUvdhJlMFgUP0Z53uKJPvjnHCHJ714rfAtGLw
         dyXIfXciFOFl8qMcFdoKxarzp0gVBXKfMMHjBzyfv7ad8ArVor+yTFivY8cS75pkpGn/
         uBuRDjQRxCdd0bZTypc0hXTDJa9clP0dx8ca1YTklufMQxjpQMqioadPDvrJUmPGBFaG
         YWnh4Exn5L2MuoW+8F1Gnl2urYP/zc+WAdQZ/QpCAZ4UzkNtBsoPcQNL/czo13+7XsK5
         zoMQ==
X-Gm-Message-State: AC+VfDyLrUAJ2er7FDwUoz4fbk71r6iKfDx9gwrj1BkttsNCprTZ0nfM
	7qHb/br3qAl4ZuzagEQN7k4=
X-Google-Smtp-Source: ACHHUZ78WwXLcgQG9GilCWGtRMvh3SkxYYobB2xWTmaO/k8z3A50U90Dx+SiHD/iaqexy0v/EJvm1Q==
X-Received: by 2002:a05:6a00:2344:b0:643:b68b:dd08 with SMTP id j4-20020a056a00234400b00643b68bdd08mr17639679pfj.30.1683662417927;
        Tue, 09 May 2023 13:00:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c21-20020aa78c15000000b0063b8a30b571sm2155625pfd.9.2023.05.09.13.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 13:00:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 9 May 2023 13:00:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/694] 6.3.2-rc2 review
Message-ID: <73d76fe5-81c6-464c-8926-e10a1b9ddffb@roeck-us.net>
References: <20230509030705.399628514@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030705.399628514@linuxfoundation.org>

On Tue, May 09, 2023 at 05:26:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.2 release.
> There are 694 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
