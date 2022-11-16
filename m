Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC88F7C
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 10:53:17 +0000 (UTC)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NC0Hv4N72zRpCx;
	Wed, 16 Nov 2022 18:52:43 +0800 (CST)
Received: from [10.174.176.230] (10.174.176.230) by
 kwepemi500016.china.huawei.com (7.221.188.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 18:53:02 +0800
Message-ID: <1e6a3d14-90c0-9555-ad89-3ea24217f9fb@huawei.com>
Date: Wed, 16 Nov 2022 18:53:01 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 5.10 027/118] nfc: nfcmrvl: Fix potential memory leak in
 nfcmrvl_i2c_nci_send()
To: Pavel Machek <pavel@denx.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, "David S. Miller"
	<davem@davemloft.net>, Sasha Levin <sashal@kernel.org>
References: <20221108133340.718216105@linuxfoundation.org>
 <20221108133341.836879145@linuxfoundation.org> <Y3S8K6Bzs62UkKXg@duo.ucw.cz>
From: shangxiaojing <shangxiaojing@huawei.com>
In-Reply-To: <Y3S8K6Bzs62UkKXg@duo.ucw.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.230]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected



On 2022/11/16 18:32, Pavel Machek wrote:
> Hi!
> 
>> From: Shang XiaoJing <shangxiaojing@huawei.com>
>>
>> [ Upstream commit 93d904a734a74c54d945a9884b4962977f1176cd ]
>>
>> nfcmrvl_i2c_nci_send() will be called by nfcmrvl_nci_send(), and skb
>> should be freed in nfcmrvl_i2c_nci_send(). However, nfcmrvl_nci_send()
>> will only free skb when i2c_master_send() return >=0, which means skb
>> will memleak when i2c_master_send() failed. Free skb no matter whether
>> i2c_master_send() succeeds.
> 
> We still need to free the skb in the other error exits, right?
> 

Hi,

I'll check and try to fix.

Thanks,
-- 
Shang XiaoJing
