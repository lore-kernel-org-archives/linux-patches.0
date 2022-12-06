Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE3F27738
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 19:05:29 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id fz10so14513597qtb.3
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 11:05:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/TaSyIQyIVk1tPPl8SpOfU95ahTR/5mZip85LMpUqE0=;
        b=aP4vpnBPWS5WVPgzBPPC+E/8DBpGiIxOr0kvPB20hzlFZ49MWOFQLgdRZoJCvVEz6F
         WtbIsK6v2u0JAOZgRdq4hlGoX9kw0DNWP7EzB00bY8178oKP6i4bm/pTsuTaXTkNsGcT
         36NFt5dVvUIeEpM73AEIQKGxYqqitAv3ShJD7nsxLxISl9a3nQN9JbIR1vaGRcjL/V5l
         M+q+9UyGHo6fU/nvyHGfsgJHgCJ3tG+QcM9U/MohfK+7C/MtcQw3Y/If4nFyzCeit/Js
         xJP9j2xwp5C8LK01tfEScKTz0wyRrotYTdsdUnJ2Htez0ieA5nCppSyMMosg4NW7gRKJ
         ljIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/TaSyIQyIVk1tPPl8SpOfU95ahTR/5mZip85LMpUqE0=;
        b=78KpXc6sVNJ/issImoag1aHZ165nWTBdKdlVUMSJ14tnk1KXXGZQ/8W9kVQJGbGLjY
         y7ZY1f94BbELiwZ671wUPy+efZb1Wp5jJk6OgOGZsd1xLvMJD+Yn8w2EylYTD1MLIXY3
         Wx0AleuzE9sdtLxtAU+TSPLvJNKRax1l031x5hdB74WjUXf5R/iyfgBmNBKHqL62lte0
         4aM76lDxPTyj5BADU0fU8vdaI3Rm0/U2fvsETThyv4ldFj0R/JhGuplhAtUhZfm3c9M1
         C0EbzEsVGTVNr/ed5I8cxE3Zl0mVW0HBJNOWUfPA2tEkWfFfvlYDtsdf+9iVLyukf3GY
         6QCw==
X-Gm-Message-State: ANoB5pnHglfkqIBXL8FulSHanM2y3R1gnTsIDD45htv3JVw5fyWNH9Tj
	8+GlCVD4y6mcza5Ea2+s1z8=
X-Google-Smtp-Source: AA0mqf6rJ021beKfANsDw1zAUU/n6XEvZd1HJ0S7TwgV3vdiH6r4GFMLDMurjIO9Jh+7EIYvZNjG5A==
X-Received: by 2002:ac8:4541:0:b0:3a6:9904:d3ea with SMTP id z1-20020ac84541000000b003a69904d3eamr17886721qtn.597.1670353528117;
        Tue, 06 Dec 2022 11:05:28 -0800 (PST)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id s11-20020a05620a0bcb00b006fcab4da037sm12513107qki.39.2022.12.06.11.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 11:05:27 -0800 (PST)
Message-ID: <6cc9c6e0-1107-e743-de98-6ea6b04bb131@gmail.com>
Date: Tue, 6 Dec 2022 11:05:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206124054.310184563@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/6/2022 4:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

