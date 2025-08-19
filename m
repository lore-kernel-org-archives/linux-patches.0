Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613CC326D66
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 11:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755602494; cv=none; b=AIgffVsV4+B0OZpNWZAqto3c078WpkTcHf9wa0qno93cDe4U2shzJUzifDHPpl9ioxYcMR/+kbSY/VP+N34wn4JymHMx0M/sSLU16+dbZwlwE7ML8FCyObXLMhYD/zNCk3y+VzvlErlZSJyiQhq4I5aby6jYZ54XVPZaIAHItnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755602494; c=relaxed/simple;
	bh=f5QW2bzIdPyk4dqGBhuwk5Tg7mvinjzods+Lj1uhn6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FllsnsyrbVwPAxXjEojdafpPDB4HQ4PJSIlvvA0teSzI2onvRSkZEDVI5IdulQ9O1U/rIm+ghpozDvJXTWmWcLgDOH/zXsF64FxB8MFIJMJFQuhJhnTdk2c6RQLFaLvr+2DfH6nE8wfnVgMWsd/XYkV5/FYcP0/WoUi5FB+kMEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c5nGL3J8PzKHMhD
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 19:21:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D9D971A0CE4
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 19:21:29 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP4 (Coremail) with SMTP id gCh0CgA3sxM4XqRo5FXVEA--.30606S3;
	Tue, 19 Aug 2025 19:21:29 +0800 (CST)
Message-ID: <df2f04b0-2caf-48a0-9817-a3cd07ae1bda@huaweicloud.com>
Date: Tue, 19 Aug 2025 19:21:28 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 429/444] smb: client: fix netns refcount leak after
 net_passive changes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Kuniyuki Iwashima <kuniyu@google.com>,
 Enzo Matsumiya <ematsumiya@suse.de>, Steve French <stfrench@microsoft.com>,
 Sasha Levin <sashal@kernel.org>
References: <20250818124448.879659024@linuxfoundation.org>
 <20250818124505.034228404@linuxfoundation.org>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <20250818124505.034228404@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA3sxM4XqRo5FXVEA--.30606S3
X-Coremail-Antispam: 1UD129KBjvdXoWrur1kKFWkKFWDGr4fZr1DKFg_yoWDXFcEgr
	Wvva1fWr4DXwsa9a17A343Zr47KFW0vasYvr1kGrWfKa4DZr4Yv3ZIgryYk3sxGFWSka47
	Crnayr1vkrnxZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbwkYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHDUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/


> 
> Timeline of patches leading to this issue:
> - commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
>    namespace.") in v6.12 fixed the original netns UAF by manually
>    managing socket refcounts
> - commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
>    rmmod") in v6.13 attempted to use kernel sockets but introduced
>    TCP timer issues
> - commit 5c70eb5c593d ("net: better track kernel sockets lifetime")
>    in v6.14-rc5 introduced the net_passive mechanism with
>    sk_net_refcnt_upgrade() for proper socket conversion
> - commit 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock
>    after rmmod"") in v6.15-rc3 reverted to manual refcount management
>    without adapting to the new net_passive changes
> 


Hi Greg,

This patch depends on the preceding patch 5c70eb5c593d ("net: better
track kernel sockets lifetime").

I have noticed that version 6.12.y has not imported this patch,
so I believe it should not be merged.

Best regards,
Wang Zhaolong

