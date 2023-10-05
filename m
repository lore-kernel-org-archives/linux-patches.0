Received: from out198-154.us.a.mail.aliyun.com (out198-154.us.a.mail.aliyun.com [47.90.198.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17D215B8
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 02:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1323387|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0365959-0.000864689-0.962539;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.UtlC8rI_1696465066;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.UtlC8rI_1696465066)
          by smtp.aliyun-inc.com;
          Thu, 05 Oct 2023 08:17:47 +0800
Date: Thu, 05 Oct 2023 08:17:48 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
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
 conor@kernel.org
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
Message-Id: <20231005081746.D7B7.409509F4@e16-tech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]

Hi,

> This is the start of the stable review cycle for the 6.1.56 release.
> There are 259 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.56-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

This 6.1.56-rc1 failed to build on rhel7 with dev-tool-set 8, but 6.1.55 works.

Build error message:
gcc: fatal error: no input files
make[3]: *** [pmu-events/Build:33: pmu-events/pmu-events.o] Error 1

After the revert of 'perf-build-update-build-rule-for-generated-files.patch'
the build works again.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/10/05


