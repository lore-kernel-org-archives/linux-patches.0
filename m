Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CC617F8
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 16:41:53 +0000 (UTC)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-163ba2b7c38so3895136fac.4
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 08:41:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=lQykz+ho0dzn//pid42h0j3Zw5664RNaB/N6NIgAdVA=;
        b=bzWlcPkEN7DoXeuoghAZy74wsaFYn7VDW7/q7bKZWkq+zGnrn2Nc+/esC+BZmoiS/Y
         h+4s2I8+v4tMJqebI5+Dt4MO/YfJAQMm/zaTl03ZOyBBeDchbL9ABiPfJ4KFQOQoTlR3
         IRPDzgIGjYNtQFRSxx60YYHJR7sW1mUewibsyHoxU2P4/SBNFfR3zTSEyYyuyE0YgJYa
         6eLhjR7Rb5Q08jSom9cCRobFRYrp55bHfePJTWkU2A/WK1TY95vugAAHCmbO36nalY7W
         nJIwtpfOfznzwgDbN61OnKzT/5sJR+ozx0wbTzI1zfrJMJWa+ZZb2X0IaIRGhz9fZS39
         tttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQykz+ho0dzn//pid42h0j3Zw5664RNaB/N6NIgAdVA=;
        b=chzLvvkXBYz2HbFqPLbu+WyuOlFGFO4dbCp7qgFUQ3tq8JKGQP8cunAjQ5R7dGEpUl
         Jc1DREKBgprEjjDGFPpEgZSLFehbQsXD94EqexnrNZep5mQrjqWg396KwfBaTqo+gfti
         CkJZ1cLtkvyBt/H2QwoDU50nNtuG1AgooysKu6BVgEjjWNoxnR8ezK+md3f6qxSsCFM/
         0cfB00jMG7V/uAKgPllpi/+FrlAHf36G2h5jJ5ZZJKVtTdWeXZx87yuyFKys5DbEm0ZV
         W9JKdqR9fnx0SddzxRFeeSp7t+y39z9JoHMNgpOlyfUk3afMbIsA17GpguZMxY0ILEJj
         FDdg==
X-Gm-Message-State: AFqh2kqhXAlA9Y290VVTIHYYL+GDBaLTWCN3sHdJ1sUr6Zhcr5hWRUA3
	WL4UwWsaNyPAhmUkZRFzCreEHo3kqUs=
X-Google-Smtp-Source: AMrXdXsHgi6SKqNcCm2Dwbkqgbbdu22MQPHCna+uJLvYJPCswiqpDAky5tWakbPzK4li+s81xKv+4A==
X-Received: by 2002:a05:6870:b30f:b0:160:3545:d167 with SMTP id a15-20020a056870b30f00b001603545d167mr15539104oao.36.1675096912582;
        Mon, 30 Jan 2023 08:41:52 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n19-20020a9d64d3000000b006884924ca4bsm5551478otl.5.2023.01.30.08.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:41:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <01cb274a-1adb-1a46-0260-fbaee94feb8a@roeck-us.net>
Date: Mon, 30 Jan 2023 08:41:48 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230130134336.532886729@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 05:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 

Building csky:allmodconfig ... failed
--------------
Error log:
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: In function 'amdgpu_dm_atomic_check':
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9397:43: error: unused variable 'mst_state' [-Werror=unused-variable]
  9397 |         struct drm_dp_mst_topology_state *mst_state;
       |                                           ^~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9396:41: error: unused variable 'mgr' [-Werror=unused-variable]
  9396 |         struct drm_dp_mst_topology_mgr *mgr;
       |                                         ^~~

and other similar errors.

AFAICS it is missing upstream commit f439a959dcfb ("amdgpu: fix build on
non-DCN platforms.").

Guenter

