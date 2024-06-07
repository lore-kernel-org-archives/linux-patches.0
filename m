Received: from out28-85.mail.aliyun.com (out28-85.mail.aliyun.com [115.124.28.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F43619D89B
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 07:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.85
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717746047; cv=none; b=Kcgk7D3NNsoSjW01FzA3tZbQ6fr1lpnOmQ51csNYKKZ6iEotmbgOeGUed/rnt07J+Ufl2X8MS+iBkBfM9LfQggCzUAeqarr9UJ38HDnLpXJ+S9K3G2rhPOgLGx7M5RR0S+Nl+Tv+SmNy+eYAAsETcc39JX/UhimjAuoXkdMgqq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717746047; c=relaxed/simple;
	bh=fAMmynAkLq/9T5oJhSQBjzCJzuuPwGsraB8+4SjvDiw=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:Message-Id:
	 MIME-Version:Content-Type; b=aBVQjHxXSkPkzc48dvO69dJSbDQFqE2jyXm10x8XOtKkQTiA09JKH9ZM6Zp5hu1xu8t255UDf+R+tbACHptjy8DERfq4p57rzoBeqW911GJ+S7hrnAhKkOzFBuNPTOMY4GIPebidk03Nb09Ogo/JxPlJr185g5osC2zMp/45WVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com; spf=pass smtp.mailfrom=e16-tech.com; arc=none smtp.client-ip=115.124.28.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1183273|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0120478-0.000116442-0.987836;FP=0|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033070021176;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=19;RT=19;SR=0;TI=SMTPD_---.XyXjO6-_1717745104;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.XyXjO6-_1717745104)
          by smtp.aliyun-inc.com;
          Fri, 07 Jun 2024 15:25:06 +0800
Date: Fri, 07 Jun 2024 15:25:06 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
Cc: stable@vger.kernel.org,
 patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org,
 akpm@linux-foundation.org,
 linux@roeck-us.net,
 shuah@kernel.org,
 patches@kernelci.org,
 lkft-triage@lists.linaro.org,
 pavel@denx.de,
 jonathanh@nvidia.com,
 f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net,
 rwarsow@gmx.de,
 conor@kernel.org,
 allen.lkml@gmail.com,
 broonie@kernel.org
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
Message-Id: <20240607152504.4D97.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.06 [en]

Hi,

> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.

To build the 6.6.33-rc1 successfully on x86_64, we need the following 2 patches.

8a55c1e2c9e1 perf util: Add a function for replacing characters in a string
f6ff1c760431 perf evlist: Add perf_evlist__go_system_wide() helper

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2024/06/07


