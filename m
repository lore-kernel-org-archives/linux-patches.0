Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0C518DB17
	for <patches@lists.linux.dev>; Mon, 12 May 2025 01:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747013704; cv=none; b=C7YfRRFdS0JmNSO/oByS/sIvzkCBJGz/q5/+SJ8TtZ9lQN73caXB+p291PTIMvr57GaVUI8mDzpgRO3y71HGxLTDh/vBpxuRTwXI8SU853L+OAMaGiRKsLHrJnGcQRrYCAdnq+/3nSyhIFs1Hw0CIefY2L0BOnFlquGqNb3HN14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747013704; c=relaxed/simple;
	bh=Yk2IvjIJtieJzU6pTb7ZmV0Mi88We7U4fVXXQfsUxpQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Mjuay3sujm28Mgnzj1efq1fg6fMFixXniLVJp51nME/9EidHIZLimqnVhn0zOA8JG8NccEoSRvjtypfacLlVHM0xAEluQDmOW/qEfAlqUlPRR4xLYtlj5fZdGWXVMJGbQ/nvgPjbXa75V4zR8VZmLJu81hizEO1byPKenqhjpAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZwhxK3nKXzKHMnZ
	for <patches@lists.linux.dev>; Mon, 12 May 2025 09:35:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 38B7F1A0A20
	for <patches@lists.linux.dev>; Mon, 12 May 2025 09:35:00 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHq19BUCFoQM6WMA--.51533S3;
	Mon, 12 May 2025 09:34:59 +0800 (CST)
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc2 review
To: Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 tglx@linutronix.de, suzuki.poulose@arm.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250508112609.711621924@linuxfoundation.org>
 <aCBZ9Ie7/QLNWivS@duo.ucw.cz>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <77dd550a-496b-e431-87e9-407788608750@huaweicloud.com>
Date: Mon, 12 May 2025 09:34:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <aCBZ9Ie7/QLNWivS@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHq19BUCFoQM6WMA--.51533S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Wr43Jr4fZF4UuF4kXF1fWFg_yoWfuFgE9F
	Wq9F9Fgr18Zrn7Gw4jg3909rsF9rWkJFy7Xr4UJ3W2q348ZF93AFsxKr13Za4ru39ayF9x
	t3WkXr45Gr129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb-8YFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JV
	W7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr
	1UYxBIdaVFxhVjvjDU0xZFpf9x07jIksgUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/05/11 16:04, Pavel Machek 写道:
> Hi!
> 
>> This is the start of the stable review cycle for the 6.1.138 release.
>> There are 97 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
>> Thomas Gleixner <tglx@linutronix.de>
>>      irqchip/gic-v2m: Mark a few functions __init
> 
> This is not a bugfix, and is itself buggy, needing the next
> patch. Just drop both.
> 
>> Suzuki K Poulose <suzuki.poulose@arm.com>
>>      irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()
> 
>> Yu Kuai <yukuai3@huawei.com>
>>      md: move initialization and destruction of 'io_acct_set' to md.c
> 
> This seems to be preparation, not a bugfix.

This must be applied ASAP, there are regression that following patch is
merged without this one:

https://lore.kernel.org/all/aBJH6Nsh-7Zj55nN@eldamar.lan/

Thanks,
Kuai

> 
> Best regards,
> 								Pavel
> 

