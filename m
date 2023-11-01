Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EBEA35
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 01:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SKqYY4s9bz1P7m5;
	Wed,  1 Nov 2023 09:44:17 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 1 Nov 2023 09:47:17 +0800
Message-ID: <bc45bd9a-0ca6-536d-8eea-751befda32a3@huawei.com>
Date: Wed, 1 Nov 2023 09:47:17 +0800
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
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <sashal@kernel.org>, <tytso@mit.edu>,
	<jack@suse.cz>, <ritesh.list@gmail.com>, <patches@lists.linux.dev>,
	<yangerkun@huawei.com>, Baokun Li <libaokun1@huawei.com>
References: <20231028064749.833278-1-libaokun1@huawei.com>
 <2023103126-careless-frequency-07c1@gregkh>
 <e8b4cdee-55ad-647f-e209-db0c8ed07c3f@huawei.com>
 <2023103129-variably-surfboard-d608@gregkh>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <2023103129-variably-surfboard-d608@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected

On 2023/10/31 22:11, Greg KH wrote:
> On Tue, Oct 31, 2023 at 09:17:23PM +0800, Baokun Li wrote:
>> On 2023/10/31 20:51, Greg KH wrote:
>>> On Sat, Oct 28, 2023 at 02:47:47PM +0800, Baokun Li wrote:
>>>> commit 43bbddc067883d94de7a43d5756a295439fbe37d upstream.
>>> Why just 5.15 and older?  What about 6.1.y?  We can't take patches only
>>> for older stable kernels, otherwise you will have a regression when you
>>> upgrade.  Please send a series for 6.1.y if you wish to have us apply
>>> these for older kernels.
>> Since this series of patches for 5.15 also applies to 6.1.y, sorry for not
>> clarifying this.
> Ok, thanks, now queued up.
>
> greg k-h
Thank you very much for your work！

-- 
With Best Regards,
Baokun Li
.
