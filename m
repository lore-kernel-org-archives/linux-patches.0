Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5FDA92E
	for <patches@lists.linux.dev>; Thu, 26 Mar 2026 03:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774494120; cv=none; b=JV4GSbiu6PI1I52ofhJ4o2+WzQcC+wmuNWpGKvKISQIjAid9GuNla+C3fog7qMOlB2xfAVJSCkzvpeWHaY1ffCCrvcOlayg+qg54g71HsBK+9y8zyCKBtG3yuRjxbRRkcmOW0Er4By2sY27862vfCURSjEuKb+K1PEV4cpEM2xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774494120; c=relaxed/simple;
	bh=thbOWSOqrhQKqwfKETz+0O3aR0qSREUl5isN3IimXjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=C82hcGYKnVy5GAUN3Gj0TKV0GtzPhrQxqCC7DGRu3s77lMWvPXnwYAMq43KlbLMZkSeG5ApDN8VEYASvxORhbEOjxbcXAI2zTrc3GpwJAVFGc5R1+lKFX4AgrtJthlsrMHWcCLWuvBj4F4K8V62DJ8OK9ulywtNMatmCam054uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1KaPn96K; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1KaPn96K"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kcy1jzR3GKVXHVdCc1RqC8re+/bIxuG8qN8lVpGjxF4=;
	b=1KaPn96KrUqf35EsISAzK+OVzIECrhD4QkFREp414aEQXGf9+ngXpENw1IJ3dy/XSuz1i5Vmp
	7Kkwt8vVxk1eMZUAJDXhIlj1ir16j270aEA6oIbA8ltJiKGirNklCN7N5vAMZKN0vUh/UJkNRTi
	AzF35Glo6nzcrphDYde8GjA=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fh7hQ3n1YznTwR;
	Thu, 26 Mar 2026 10:56:22 +0800 (CST)
Received: from kwepemr100006.china.huawei.com (unknown [7.202.194.218])
	by mail.maildlp.com (Postfix) with ESMTPS id B8654402AB;
	Thu, 26 Mar 2026 11:01:49 +0800 (CST)
Received: from [10.174.179.92] (10.174.179.92) by
 kwepemr100006.china.huawei.com (7.202.194.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 26 Mar 2026 11:01:48 +0800
Message-ID: <c2fe8cab-2f92-4c82-9743-04ed35003105@huawei.com>
Date: Thu, 26 Mar 2026 11:01:47 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Theodore Tso <tytso@mit.edu>
CC: Francesco Dolcini <francesco@dolcini.it>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, Jan Kara <jack@suse.cz>, Brian
 Foster <bfoster@redhat.com>, Matthew Wilcox <willy@infradead.org>, Gou Hao
	<gouhao@uniontech.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Zhang Yi
	<yi.zhang@huawei.com>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
 <d22ffe9f-8cd5-41ee-9da1-d0d2800a5f16@huawei.com>
 <20260325133456.GD2107@macsyma.local>
From: Sun Yongjian <sunyongjian1@huawei.com>
In-Reply-To: <20260325133456.GD2107@macsyma.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr100006.china.huawei.com (7.202.194.218)



在 2026/3/25 21:34, Theodore Tso 写道:
> I'm confused.  That commit 060913999d7a should be backported to
> 6.1.yy?  Since 6.1 lacks this patch, I dont understand your statement
> "the race condition doesn't exist there".  Or were you trying to say
> that the_fix_ for race condition is missing in 6.1?
> 
> Or is there some other commit which fixes 060913999d7a that needs to
> be backported to 6.1?
Hi Ted,

Sorry for the confusion. To clarify: commit 060913999d7a is actually the 
regressing commit that introduced the race condition by reordering the 
migrate mapping and folio copy operations.

Because 6.1.y does not include this specific commit, the concurrency 
window it created does not exist in the 6.1 kernel. Therefore, 6.1.y is 
not affected by this particular issue and does not require this backport 
(ext4: fix e4b bitmap inconsistency reports).

      	       	   		     	     - Yongjian
