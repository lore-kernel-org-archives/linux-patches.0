Received: from out28-85.mail.aliyun.com (out28-85.mail.aliyun.com [115.124.28.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2E9D515
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 11:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e16-tech.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1214311|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0259023-0.00112094-0.972977;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=18;RT=18;SR=0;TI=SMTPD_---.UxYfX54_1696938141;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.UxYfX54_1696938141)
          by smtp.aliyun-inc.com;
          Tue, 10 Oct 2023 19:42:22 +0800
Date: Tue, 10 Oct 2023 19:42:22 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
Cc: wqu@suse.com,
 stable@vger.kernel.org,
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
In-Reply-To: <2023101008-argue-impart-a6ad@gregkh>
References: <20231010161046.7861.409509F4@e16-tech.com> <2023101008-argue-impart-a6ad@gregkh>
Message-Id: <20231010194221.C1C3.409509F4@e16-tech.com>
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

> On Tue, Oct 10, 2023 at 04:10:48PM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > > This is the start of the stable review cycle for the 6.1.57 release.
> > > There are 162 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> > > Anything received after that time might be too late.
> > 
> > 
> > drop this patch from 6.5/6.1/5.15/... please, 
> >   Qu Wenruo <wqu@suse.com>
> >      btrfs: reject unknown mount options early
> > 
> > becuase of this report.
> > https://lore.kernel.org/linux-btrfs/f3ac7b74-c011-4d1f-a510-677679fc9743@gmx.com/T/#t
> 
> Is there a revert somewhere for this already?

Yet not.

but we can suspend to apply this patch(drop this patch) for stable.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/10/10

