Received: from relmlie6.idc.renesas.com (relmlor2.renesas.com [210.160.252.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EB9110955
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 22:45:00 +0000 (UTC)
X-IronPort-AV: E=Sophos;i="6.01,211,1684767600"; 
   d="scan'208";a="173217089"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 18 Jul 2023 07:39:51 +0900
Received: from [10.226.92.22] (unknown [10.226.92.22])
	by relmlir5.idc.renesas.com (Postfix) with ESMTP id 212B9400D4D3;
	Tue, 18 Jul 2023 07:39:45 +0900 (JST)
Message-ID: <9da5f8cb-5ed0-1854-0a0a-252794e01ce3@bp.renesas.com>
Date: Mon, 17 Jul 2023 23:39:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230717201547.359923764@linuxfoundation.org>
From: Paul Barker <paul.barker.ct@bp.renesas.com>
In-Reply-To: <20230717201547.359923764@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Greg,

On 17/07/2023 21:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Building i386_defconfig in my Yocto Project environment (with gcc 13) fails:

| /.../kernel/workqueue.c: In function 'get_work_pwq':
| /.../kernel/workqueue.c:706:24: error: cast to pointer from integer of 
different size [-Werror=int-to-pointer-cast]
|   706 |                 return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
|       |                        ^
| /.../kernel/workqueue.c: In function 'get_work_pool':
| /.../kernel/workqueue.c:734:25: error: cast to pointer from integer of 
different size [-Werror=int-to-pointer-cast]
|   734 |                 return ((struct pool_workqueue *)
|       |                         ^
| /.../kernel/workqueue.c: In function 'get_work_pool_id':
| /.../kernel/workqueue.c:756:25: error: cast to pointer from integer of 
different size [-Werror=int-to-pointer-cast]
|   756 |                 return ((struct pool_workqueue *)
|       |                         ^

Cherry-picking afa4bb778e48d79e4a642ed41e3b4e0de7489a6c from mainline 
fixes the build for me.

Thanks,
Paul
