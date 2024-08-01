Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3BB189531
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 06:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722492718; cv=none; b=eHDWN3VVOkqltZVqW7gdSZ8wB973T67M4Juv837fndXUVkAeTRNpbQ/ARKlZBT16xRGmEkqvMFh6lygk2ACneZKlmU9GqJhGTi5YeMOt1quX/UpaYF3j95RoZgQK1dh2BKHEYgUklfqvCwpmnhGpy9eAp1L3yYxwQh1x7YBifqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722492718; c=relaxed/simple;
	bh=xpJ4z5TWcyrJT+BgcyJUrNahwDnMDSXzwV2nw3E1qvM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mrzMsohYFU/s5hSi7C4kAJ+xNq/SBYUXlauAT7lTCZy/DEZR7IhPt9A+kVZ+2tWQsfkji3Z9hpLYxmdjUDi+1jFMVUml1QxcCXgXANesHdFPAqIjHEMGIcXUZRl6cVSI9sUWfd8S9ZHmlqrXEEeLT336K71TiCro+6d/g+jyXZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WZJWT4h1Qz4f3jHw
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 14:11:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A2CE71A0359
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 14:11:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXzIIgJ6tmFQHHAQ--.55783S3;
	Thu, 01 Aug 2024 14:11:46 +0800 (CST)
Subject: Re: [PATCH 6.10 678/809] md/raid1: set max_sectors during early
 return from choose_slow_rdev()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Song Liu <song@kernel.org>, Paul Luse <paul.e.luse@linux.intel.com>,
 Xiao Ni <xni@redhat.com>, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151751.683503374@linuxfoundation.org>
 <974b072b-9696-42c9-8cec-f68454eedc33@o2.pl>
 <2024080111-poet-bok-e8d4@gregkh>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f23851f1-6902-d65a-f180-14ab95f13e9c@huaweicloud.com>
Date: Thu, 1 Aug 2024 14:11:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2024080111-poet-bok-e8d4@gregkh>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXzIIgJ6tmFQHHAQ--.55783S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCrW5uryrCr13WFyUAFyxKrg_yoWrGF4kpF
	W3KF4akrs5XrWUCanFv3WFqFy8tw4DAr43Xr1rJw18u3Z0vrZ7KF4fWr1F9a4DCry3W348
	Wa4qgasFga4vva7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwI
	DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/01 13:01, Greg Kroah-Hartman 写道:
> On Wed, Jul 31, 2024 at 09:43:58PM +0200, Mateusz Jończyk wrote:
>> W dniu 30.07.2024 o 17:49, Greg Kroah-Hartman pisze:
>>> 6.10-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Mateusz Jończyk <mat.jonczyk@o2.pl>
>>>
>>> commit 36a5c03f232719eb4e2d925f4d584e09cfaf372c upstream.
>>>
>>> Linux 6.9+ is unable to start a degraded RAID1 array with one drive,
>>> when that drive has a write-mostly flag set. During such an attempt,
>>> the following assertion in bio_split() is hit:
>>>
>>> 	BUG_ON(sectors <= 0);
>>>
>>> Call Trace:
>>> 	? bio_split+0x96/0xb0
>>> 	? exc_invalid_op+0x53/0x70
>>> 	? bio_split+0x96/0xb0
>>> 	? asm_exc_invalid_op+0x1b/0x20
>>> 	? bio_split+0x96/0xb0
>>> 	? raid1_read_request+0x890/0xd20
>>> 	? __call_rcu_common.constprop.0+0x97/0x260
>>> 	raid1_make_request+0x81/0xce0
>>> 	? __get_random_u32_below+0x17/0x70
>>> 	? new_slab+0x2b3/0x580
>>> 	md_handle_request+0x77/0x210
>>> 	md_submit_bio+0x62/0xa0
>>> 	__submit_bio+0x17b/0x230
>>> 	submit_bio_noacct_nocheck+0x18e/0x3c0
>>> 	submit_bio_noacct+0x244/0x670
>>>
>>> After investigation, it turned out that choose_slow_rdev() does not set
>>> the value of max_sectors in some cases and because of it,
>>> raid1_read_request calls bio_split with sectors == 0.
>>>
>>> Fix it by filling in this variable.
>>>
>>> This bug was introduced in
>>> commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
>>> but apparently hidden until
>>> commit 0091c5a269ec ("md/raid1: factor out helpers to choose the best rdev from read_balance()")
>>> shortly thereafter.
>>>
>>> Cc: stable@vger.kernel.org # 6.9.x+
>>> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
>>> Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
>>> Cc: Song Liu <song@kernel.org>
>>> Cc: Yu Kuai <yukuai3@huawei.com>
>>> Cc: Paul Luse <paul.e.luse@linux.intel.com>
>>> Cc: Xiao Ni <xni@redhat.com>
>>> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
>>> Link: https://lore.kernel.org/linux-raid/20240706143038.7253-1-mat.jonczyk@o2.pl/
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> Hello,
>>
>> FYI there is a second regression in Linux 6.9 - 6.11, which occurs with RAID
>> component devices with a write-mostly flag when a new device is added
>> to the array. (A write-mostly flag on a device specifies that the kernel is to
>> avoid reading from such a device, if possible. It is enabled only manually with
>> a mdadm command line switch and can be beneficial when devices are of
>> different speed). The kernel than reads from the wrong component device
>> before it is synced, which may result in data corruption.
>>
>> Link: https://lore.kernel.org/lkml/9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl/T/
>>
>> This is not caused by this patch, but only linked by similar functions and the
>> write-mostly flag being involved in both cases. The issue is that without this
>> patch, the kernel will fail to start or keep running a RAID array with a single
>> write-mostly device and the user will not be able to add another device to it,
>> which triggered the second regression.
>>
>> Paul was of the opinion that this first patch should land nonetheless.
>> I would like you to decide whether to ship it now or defer it.
> 
> Is there a fix for this anywhere?  If not, being in sync with Linus's
> tree is probably the best solution for now.

The second regression is not related to this patch, and another fix
should be applied to mainline and then backport to stable, hence this
lts patch should be merged.

Thanks,
Kuai

> 
> thanks,
> 
> greg k-h
> .
> 

