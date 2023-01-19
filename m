Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DA02905
	for <patches@lists.linux.dev>; Thu, 19 Jan 2023 07:42:06 +0000 (UTC)
Received: from kwepemm600020.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NyDwg147xzqVCR;
	Thu, 19 Jan 2023 15:37:07 +0800 (CST)
Received: from [127.0.0.1] (10.174.178.94) by kwepemm600020.china.huawei.com
 (7.193.23.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 19 Jan
 2023 15:42:01 +0800
Message-ID: <3f4f9d10-215f-d90c-cbef-4da388b5ce41@huawei.com>
Date: Thu, 19 Jan 2023 15:41:59 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 4.19 000/477] 4.19.270-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>
References: <20230117124624.496082438@linuxfoundation.org>
Content-Language: en-US
From: zhouzhixiu <zhouzhixiu@huawei.com>
In-Reply-To: <20230117124624.496082438@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.94]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600020.china.huawei.com (7.193.23.147)
X-CFilter-Loop: Reflected


On 2023/1/17 20:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.270-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Tested on arm64 and x86 for 4.19.270-rc2,

Kernel 
repo:https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
Branch: linux-4.19.y
Version: 4.19.270-rc2
Commit: 2738270a87607b0fe9d198d07d8866c75892149a
Compiler: gcc version 7.3.0 (GCC)

arm64:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8947
passed: 8947
failed: 0
timeout: 0
--------------------------------------------------------------------

x86:
--------------------------------------------------------------------
Testcase Result Summary:
total: 8947
passed: 8947
failed: 0
timeout: 0
--------------------------------------------------------------------
Tested-by: Hulk Robot <hulkrobot@huawei.com>

