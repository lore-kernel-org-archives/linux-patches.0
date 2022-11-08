Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B4F33E2
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 19:27:50 +0000 (UTC)
Received: by mail-qv1-f53.google.com with SMTP id j6so10883443qvn.12
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 11:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EF69t9SF3x61lH/czl++mmCOkbNRPl0mdOxYpEl0ZJY=;
        b=i/R/UyK00fjhw0Gd1bgCB8+Wxb7ibJvCxm18utgoIFJt6d6GVhSv68rLdnzfFEHSnE
         Nb7AHIHbmmlfl4WZr5eBaERoXudsUFgt+qOnT3k53Lr4F2gijlVOQmxNskxw9NBLiafX
         DBajWxgwsPFzHwZlKOQUaHgcM2RO/J2RP/qFu5I0Y5yF6NDrlyeAwfid7Ft8Nup2Ca3d
         YTa2fsoNFbbLhvlzNaWJX+EFUBsD/GuDXGF+ZU1U+C0Wp5GQJF7xySKPCHj/LFbs4JiW
         6CrH4XhjdcxzDgnYhMKJo1v2o4dI7YpjeuLnoZHohABlyTa5wkmlWyo6qWetoGycZM4a
         xptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EF69t9SF3x61lH/czl++mmCOkbNRPl0mdOxYpEl0ZJY=;
        b=mX4KQ/cQQmodl7mPyZoAeiuGxDLTiAGBELDl+hMEe7edOYdM5U2t6pu2hi77tHI4/l
         mPtTbxZI1msMWUvXMLHcJNO8DMNuBSFTG/iNGe69xytcsZ3PR1yt6sAZFVt7OHxoIETX
         61GrDNlma42YV/NBm3vQWkP12DRw/HucWCLz8vKbPhO0Vu8vqdGqgNuenRyTIi9nWNMS
         fIEJYhs1mFQB02qX+gcC46LIcUSg1d7qQUanyCOY4HpQYqskO0I3FNjr2K19tejFf/D3
         0Mg7TA03koy91t11QgETNTce6kNjqBoQpfSDpOeLdGWCNcWNVd2h2fzGofriwz769EHd
         v3PA==
X-Gm-Message-State: ACrzQf3jQF51H0E7e+w9KAbVVRIoe/SMCA0T90em+6h0bImzadpmjjrC
	jU4Q8hTI5z50gNLUKJbWyTs=
X-Google-Smtp-Source: AMsMyM6BBm6ib7X3NTmbMzqQ4gCyTQwLwGpv9L8fijeutqCGsSZZ6bF7OzYf7J1Ecm+IRsyH/fafZw==
X-Received: by 2002:a05:6214:76d:b0:4bb:e59a:17dc with SMTP id f13-20020a056214076d00b004bbe59a17dcmr47088968qvz.125.1667935669746;
        Tue, 08 Nov 2022 11:27:49 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u22-20020a05620a431600b006cfc01b4461sm9647505qko.118.2022.11.08.11.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 11:27:49 -0800 (PST)
Message-ID: <682a9f6a-d8d0-8f73-b262-2d38c55bc4be@gmail.com>
Date: Tue, 8 Nov 2022 11:27:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133340.718216105@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/8/2022 5:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

