Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFF51FA6
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 17:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB01C433D2;
	Wed, 28 Dec 2022 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1672249135;
	bh=TIOkX6Fl7QU257FKnfyNVkA3crmw2BZs5EqZXWs6sP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OA2ixycvEkuFpFNZ1whzdRvYcTuPF81g9zeJ/UCq1HR7Zrf7ePE+z2BVFIVmDPoht
	 gcM3ePVWaWv+8j6N77kbUA/00PHc0bVajntqLDYXIVD+/szRwMIfHUUniIxlILTrGR
	 xC84hQHVbmnoY42jVt1HJYN7/sq8c6MqN2tKzFIhB9//XcSg95aumBtUvfGAWvV2Hz
	 GaSR5GrI0GUiqOGzg8KEYcsbJAUUnkVkTTaPV7abB9LuVc14X+WU6sMEzWgAEJIPYn
	 Og/5VmIeHqp7baWZ1H+quvdGhBKO1ZUv7owL8v77zboJLH0OeFWixiu+UeszFPbaMh
	 TRfAEBZ7LK9Dw==
Date: Wed, 28 Dec 2022 12:38:54 -0500
From: Sasha Levin <sashal@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Message-ID: <Y6x/LkDEzeP3m4x4@sashalap>
References: <20221228144330.180012208@linuxfoundation.org>
 <20221228151059.GA2565317@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221228151059.GA2565317@roeck-us.net>

On Wed, Dec 28, 2022 at 07:10:59AM -0800, Guenter Roeck wrote:
>On Wed, Dec 28, 2022 at 03:25:39PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.2 release.
>> There are 1146 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
>> Anything received after that time might be too late.
>>
>
>Building arm:allmodconfig ... failed
>Building arm64:allmodconfig ... failed
>--------------
>Error log:
>drivers/mfd/qcom_rpm.c: In function 'qcom_rpm_remove':
>drivers/mfd/qcom_rpm.c:680:26: error: unused variable 'rpm' [-Werror=unused-variable]
>  680 |         struct qcom_rpm *rpm = dev_get_drvdata(&pdev->dev);
>
>36579aca877a ("mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()")
>was applied without e48dee960462 ("mfd: qcom_rpm: Use
>devm_of_platform_populate() to simplify code") which fixes the problem
>without saying that it does.
>
>The problem affects v5.15.y and v6.0.y as well.

I've queued up 36579aca877a, thanks for looking into it!

-- 
Thanks,
Sasha
