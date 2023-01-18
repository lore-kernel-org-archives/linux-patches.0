Received: from out198-157.us.a.mail.aliyun.com (out198-157.us.a.mail.aliyun.com [47.90.198.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25215A9
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 02:45:47 +0000 (UTC)
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1684025|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0108859-0.000814038-0.9883;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047201;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.Qvn4t1z_1674008073;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Qvn4t1z_1674008073)
          by smtp.aliyun-inc.com;
          Wed, 18 Jan 2023 10:14:34 +0800
Date: Wed, 18 Jan 2023 10:14:35 +0800
From: Wang Yugui <wangyugui@e16-tech.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 hch@lst.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
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
 rwarsow@gmx.de
In-Reply-To: <Y8Znr6CAFi8ikhdH@kroah.com>
References: <20230117151136.CB79.409509F4@e16-tech.com> <Y8Znr6CAFi8ikhdH@kroah.com>
Message-Id: <20230118101433.734D.409509F4@e16-tech.com>
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

> On Tue, Jan 17, 2023 at 03:11:37PM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > fstests(generic/034, xfs) panic when 6.1.7-rc1, but not panic when 6.1.6.
> > 
> > It seems patch *1 related.
> > *1 Subject: blk-mq: move the srcu_struct used for quiescing to the tagset
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > This patch has been drop from 6.1.2-rc1. and it now added in 6.1.7-rc1 again.
> > 
> > the panic in 6.1.7-rc1 is almost same as that in 6.1.2-rc1.
> 
> Argh, yes, let me go drop these again.
> 
> Sasha, can you blacklist these from your tools so they don't get picked
> up again?

this panic does not happen on  upstream 6.2.0-rc4.
or maybe we need a bigger patch set?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/01/18

