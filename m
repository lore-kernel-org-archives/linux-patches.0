Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677C1D501
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 18:10:23 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-12c8312131fso3219730fac.4
        for <patches@lists.linux.dev>; Thu, 27 Oct 2022 11:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=IeM5KWfu9W2RTeZSkXYtdOOQaeG8hqvQE+0X5a+j+Og=;
        b=NWtLf0K2TIx8Rqbwq/414h5zlREzRm3zr+HVqfm6VWX1ryjgEZdU+ZDL4y9K/db95V
         FcZD+TmmwPp0fYeO0H8vbvlKDClB1+J7pcjzCX+nFoiF7lB0N3DZD3LwMJ746O8f58Cf
         9Mn0PyQRSnI+2lzt1V8Q5rCNEoonksLYk0vvVAEgpOriDJ06d3DcaECBW2XWqpGd35+u
         ViFXNrdtuJv+/L9+Fg1cuaqyrVE087I8LVgt01wPsJm5hY6vlgVweJriiZMXOfaW79gS
         VxSSX9aDMsIsquh5zAIpXcTB1Pn03x05rlf5Y1WPFTJCTyOAEtbAuhOyIyqrx5wIqt3e
         QXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IeM5KWfu9W2RTeZSkXYtdOOQaeG8hqvQE+0X5a+j+Og=;
        b=Z26RTGh2iK8Oeyt6aj6pLjAOFLA9p+ez5ASnVjdJEVmk8/jWyyYuNeJkXlEKExQZWD
         lgJc1mu04hSTYmks7Tffj/KZEIVssQe8EJBTuspTTWKnIWacGOjCrpqdnI7tGFnqC/pD
         NbBPWI9n0OtkOqoJ8GJjMOzp8Jrk+Pi67WNLVr6mrusagFw84kp+pbFVOkJWYQ93L5wW
         8gV63V+yBvLodra6meyGZDIqGJ8Oj0HVAS3LNgIBf0m/qxe+jTMziAjqn+iAEM8thu9R
         +1SNxmvGvpJ7Yndj2n+Jy7rphUUTAEJZr63cuw6Xy//EiRdPYwy9xLlkGNUS/oscVujh
         WlPg==
X-Gm-Message-State: ACrzQf195LUBhwQM30ITX8Rw8p796yQwh8fNyMQUnPUCZ3QnQdGbEjr+
	yWGi7f6PbH9KdTMUl1DRWiw=
X-Google-Smtp-Source: AMsMyM7ypmwA0ZnHsmxh0CYkiVp+Oufv7JoqHGP6VeVxBTfHFfapMhzkB34PiC8er6dIK69ZZEfJiw==
X-Received: by 2002:a05:6870:14cd:b0:13b:bc46:287f with SMTP id l13-20020a05687014cd00b0013bbc46287fmr6286934oab.118.1666894222352;
        Thu, 27 Oct 2022 11:10:22 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o19-20020a056870525300b0012752d3212fsm871116oai.53.2022.10.27.11.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 11:10:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
Date: Thu, 27 Oct 2022 11:10:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net
References: <20221027165054.270676357@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/22 09:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.151 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.
> 

Building arm64:allmodconfig ... failed
--------------
Error log:
/bin/sh: scripts/pahole-flags.sh: Permission denied

Indeed:

$ ls -l scripts/pahole-flags.sh
-rw-rw-r-- 1 groeck groeck 530 Oct 27 11:08 scripts/pahole-flags.sh

Compared to upstream:

-rwxrwxr-x 1 groeck groeck 585 Oct 20 11:31 scripts/pahole-flags.sh

Guenter

