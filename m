Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C7D2581
	for <patches@lists.linux.dev>; Wed, 25 Dec 2024 01:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735091416; cv=none; b=UXQ7jOykLzrW6C2i4TX6Z8I28JL4MaEZ8zWjw58iIgo/5vADDZjpRCteZ+zc66BX7rKRi3CXCDJyBkpH7TsVPoRzx9r5h0YnDg1NwJFs6Qa30XcumKpegAIoLHl0MocltUhwN0O2drDzvYZFLsPomgwg09594uzKqV+P1mb44iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735091416; c=relaxed/simple;
	bh=EdaUEwtMp14tYaHw5JolGOjmyDZbWdJgQVblhV5qGvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VPpHCAVChIclg/XI/XLussRKh6+fMd8nql8UuaISel6/KHUNSYjXcL+9f39i8ZnelXGOHaLjmKUUkPpoPOdj0MYHUby2FAAGuX753YuW2AeeuNSK1arp+NnxjoNUVJPKYAtgfZjh8/1CHBgg+hRZZ/b/O7DSdlgingwtwBdpuno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 92922892c26211efa216b1d71e6e1362-20241225
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:3ea3fa0b-20a0-401c-9156-22e5864dba5a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-9
X-CID-INFO: VERSION:1.1.41,REQID:3ea3fa0b-20a0-401c-9156-22e5864dba5a,IP:0,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-9,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:-9
X-CID-META: VersionHash:6dc6a47,CLOUDID:86630b22780dc18832a319ea0a9c4226,BulkI
	D:2412250950104SCDE6W8,BulkQuantity:0,Recheck:0,SF:17|19|24|38|45|64|66|78
	|80|81|82|83|102|841,TC:nil,Content:0,EDM:-3,IP:1,URL:1,File:nil,RT:nil,Bu
	lk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:
	0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_IBB,TF_CID_SPAM_ULS,
	TF_CID_SPAM_SNR,TF_CID_SPAM_FAS
X-UUID: 92922892c26211efa216b1d71e6e1362-20241225
X-User: zhaomengmeng@kylinos.cn
Received: from [192.168.109.86] [(123.150.8.42)] by mailgw.kylinos.cn
	(envelope-from <zhaomengmeng@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 403518014; Wed, 25 Dec 2024 09:50:09 +0800
Message-ID: <4b9e8925-4851-4b6f-94ad-ab3f238f7252@kylinos.cn>
Date: Wed, 25 Dec 2024 09:50:04 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Daniel Reichelt <debian@nachtgeist.net>, Zhao Mengmeng <zhaomzhao@126.com>
References: <20241223155353.641267612@linuxfoundation.org>
From: Zhao Mengmeng <zhaomengmeng@kylinos.cn>
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/12/23 23:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.122-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

I have tested this rc kernel in my qemu environment, it fixes the issue of loop-mount Windows
Setup ISOs can't be readed by executing `ls $mntpt/sources`. Daniel also confirmed that
udf patch has solved his problem.

Tested-by: Zhao Mengmeng <zhaomengmeng@kylinos.cn>

Links: https://lore.kernel.org/regressions/Z2XKY0f6on1UbwWb@eldamar.lan/

Thanks,
-- zmm
