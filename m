Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0089E28EB
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SKVv82cTTzVlZf;
	Tue, 31 Oct 2023 21:13:24 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 31 Oct 2023 21:17:24 +0800
Message-ID: <e8b4cdee-55ad-647f-e209-db0c8ed07c3f@huawei.com>
Date: Tue, 31 Oct 2023 21:17:23 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 5.15 1/3] ext4: add two helper functions
 extent_logical_end() and pa_logical_end()
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <sashal@kernel.org>, <tytso@mit.edu>,
	<jack@suse.cz>, <ritesh.list@gmail.com>, <patches@lists.linux.dev>,
	<yangerkun@huawei.com>, Baokun Li <libaokun1@huawei.com>
References: <20231028064749.833278-1-libaokun1@huawei.com>
 <2023103126-careless-frequency-07c1@gregkh>
Content-Language: en-US
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <2023103126-careless-frequency-07c1@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected

On 2023/10/31 20:51, Greg KH wrote:
> On Sat, Oct 28, 2023 at 02:47:47PM +0800, Baokun Li wrote:
>> commit 43bbddc067883d94de7a43d5756a295439fbe37d upstream.
> Why just 5.15 and older?  What about 6.1.y?  We can't take patches only
> for older stable kernels, otherwise you will have a regression when you
> upgrade.  Please send a series for 6.1.y if you wish to have us apply
> these for older kernels.
Since this series of patches for 5.15 also applies to 6.1.y, sorry for 
not clarifying this.
>> When we use lstart + len to calculate the end of free extent or prealloc
>> space, it may exceed the maximum value of 4294967295(0xffffffff) supported
>> by ext4_lblk_t and cause overflow, which may lead to various problems.
>>
>> Therefore, we add two helper functions, extent_logical_end() and
>> pa_logical_end(), to limit the type of end to loff_t, and also convert
>> lstart to loff_t for calculation to avoid overflow.
>>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> Link: https://lore.kernel.org/r/20230724121059.11834-2-libaokun1@huawei.com
>> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>>
>> Conflicts:
>> 	fs/ext4/mballoc.c
>>
> Note, the "Conflicts:" stuff isn't needed.
>
> thanks,
>
> greg k-h

OK!


-- 
With Best Regards,
Baokun Li
.
