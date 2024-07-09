Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E833212DDAE
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 12:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720526738; cv=none; b=jBJpZEIB1An3g1E3hhU+QJBGVidfG9DWmIR1XQEGewEKXr8c3QNwTqvm++hmJh25+iyunw0hSIpyzIMSsovTPZzVSAHRIvWF7/EajKA+kMXAjaTpSl8WHo3+MF4Qsc2fJAr8OPY0kBIopIPoi4kufo7Y1F+3D6dZSX+BJ5phD5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720526738; c=relaxed/simple;
	bh=Gol8w1yhV97XRP+PaKdDO83SzQwcySabOgp273aJOMQ=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=f9S7dLLmSCN/oa3SNAzoEBzquKIVW2HzBgfaMJIYYS0ZjUoEdC/VP3tLjWISEkBkatHR1/dQ5S0LwJH3/wsNGv1vOlws+ameqtwu/pDXVvNRV8Fx2fVMiJ7fYDLVoQIrF9u4w3lMerAlMR32UBVvOEx+fIhaN92PKlLvbtiJDA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4WJKMj6Xk3zQl5D;
	Tue,  9 Jul 2024 20:01:21 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id AA959140258;
	Tue,  9 Jul 2024 20:05:16 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 20:05:15 +0800
Subject: Re: [PATCH 6.1 009/102] irqchip/gic-v3-its: Remove BUG_ON in
 its_vpe_irq_domain_alloc
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Guanrui Huang
	<guanrui.huang@linux.alibaba.com>, Thomas Gleixner <tglx@linutronix.de>, Marc
 Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20240709110651.353707001@linuxfoundation.org>
 <20240709110651.723892970@linuxfoundation.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <be1737a6-66e4-e009-9225-a5a0cfe87b24@huawei.com>
Date: Tue, 9 Jul 2024 20:05:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709110651.723892970@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/7/9 19:09, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Guanrui Huang <guanrui.huang@linux.alibaba.com>
> 
> [ Upstream commit 382d2ffe86efb1e2fa803d2cf17e5bfc34e574f3 ]
> 
> This BUG_ON() is useless, because the same effect will be obtained
> by letting the code run its course and vm being dereferenced,
> triggering an exception.
> 
> So just remove this check.
> 
> Signed-off-by: Guanrui Huang <guanrui.huang@linux.alibaba.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> Acked-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20240418061053.96803-3-guanrui.huang@linux.alibaba.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I don't think this should be backported to stable. It doesn't fix
anything but only remove a useless BUG_ON().

Thanks,
Zenghui
