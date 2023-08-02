Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42D17FE8
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 23:20:49 +0000 (UTC)
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-63d09d886a3so2113436d6.2
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 16:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691018448; x=1691623248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W2vcx5gELJsgfbxT0pmjpLmAr1n1LycLpK/JQlvaDwo=;
        b=ReVvWhzUTjGE0LnMI1RoORPK1dKXSmPY9CTJqnjhthVVRQY9ZuN4wefnr6DHEqmTZJ
         CGMiSxDBYvCijQjuBgFreHwYQuaCJzKWNueh23VPb5jHwzWRv/cVRtxQtaqDofYtbFtj
         cEkfRzZAEhMO2Rvb4cveXeSxUnueTffbk+eXZqPPrivzNEzLNEYGdWIAnn2BWGR0fbDI
         zYfx1UJbx4uxZa4LUv6TcZ6W8RIhKc7dAhfj+m8w3iZVEabEXyNeOTqKWVLh0nh34Qd/
         F1pS/IMOdx98bJ9LjQ3V6OJOx4KB5cZMjSB+x01EfhvSox/Ta95jQm+NJ89EOxU8xMIW
         KUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691018448; x=1691623248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W2vcx5gELJsgfbxT0pmjpLmAr1n1LycLpK/JQlvaDwo=;
        b=UYIF26aJrjwu2ikLL3KKGFb5C7lFr8hNhuZ3CAOFkvfxBIBzkVWwY3dTKokGEdt3ov
         dCoK1Ug7wDSeh4LgBTToQ+AX8AgVuFWx5ZDqQfCpveLr5Nsei22wpEOEvmhuym6Lx0mN
         n2gYkYUm8p6M/JZJkji/im8TgVkgTBgxlM/PqhvVcoTDD5nhnmgnNNd4g+I3ofOQstro
         6GfQvVKC0U2ambKUVvOfljuZw4H5uNn+rYXHlR66MCAFA5pz9J2rFBMOZkAPfha2n8cT
         0EwG/o16pEhJhyxJRn1pO2jq0ddL6hQ1Ek9TpkRNCqSpyjfzbzZxQRcF1t6CfbWMeLeq
         nl2g==
X-Gm-Message-State: ABy/qLYaZ3cH+zH2d4pQdJHDSnz+yIlw0+UdEW4xzHBdabWbGZDgQ5xf
	ZaLgvsZKJUe982cLLYBZvHA=
X-Google-Smtp-Source: APBJJlG6tXUdAR4U5jf2BK3+UJZ8CVjryWPIZnH08iLpNkwDPXPHkd6Lx6MoZRMEXT6mp/C4o3N1uA==
X-Received: by 2002:a0c:e78b:0:b0:63c:fe76:c4ca with SMTP id x11-20020a0ce78b000000b0063cfe76c4camr18026614qvn.10.1691018448250;
        Wed, 02 Aug 2023 16:20:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c14-20020a0ca9ce000000b00632191a70aesm5898299qvb.88.2023.08.02.16.20.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Aug 2023 16:20:47 -0700 (PDT)
Message-ID: <8bef84f8-9971-95f1-c999-2695e3a742a1@gmail.com>
Date: Wed, 2 Aug 2023 16:20:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 000/235] 6.4.8-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230802065501.780725463@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230802065501.780725463@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/2/23 00:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.8 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Aug 2023 06:54:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

