Received: from mx0b-001ae601.pphosted.com (mx0a-001ae601.pphosted.com [67.231.149.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66BA179AD
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 10:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensource.cirrus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cirrus.com header.i=@cirrus.com header.b="Z5pwpL0S"
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
	by mx0a-001ae601.pphosted.com (8.17.1.22/8.17.1.22) with ESMTP id 3AS90TAg029233;
	Tue, 28 Nov 2023 04:42:55 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=
	message-id:date:mime-version:subject:to:cc:references:from
	:in-reply-to:content-type:content-transfer-encoding; s=
	PODMain02222019; bh=v7qe42i6c1o9SGtFr6SNq37Ysuvk+0p1YKpHB5TLlxY=; b=
	Z5pwpL0SJ/cTBLRWTWWl2HxDhmsimao0yyYGe4N84WHmlG6wfUFFTu2eo2xx/F/8
	uGKei2XySWOQXqdEYI9gOAEbW6mOcNqfXnNMDsVEWCgFycjjnscjrolUDdtFqu46
	t0F7DTT6z8M7tKVzYx8AK4oR02o1r0vqi6ZEEyeabqTgwuG/CEX1ff10Vg6jl6/V
	mEtqFfgiycI1+T8qoAm3r/i7W0xrPv5dNUEHePyP9qrZpxXkQxcO79V9ibXDnyhp
	36PKpKGaA8l2JLVy1T/pWjoOaFYVsWWG/GtRHgsxdo4O1htYj+RL4MR1R6CpdzGb
	hLnQeHPmv/t/SdM7m5Dn0Q==
Received: from ediex02.ad.cirrus.com ([84.19.233.68])
	by mx0a-001ae601.pphosted.com (PPS) with ESMTPS id 3ukf73b352-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Nov 2023 04:42:55 -0600 (CST)
Received: from ediex02.ad.cirrus.com (198.61.84.81) by ediex02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Tue, 28 Nov
 2023 10:42:52 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by
 anon-ediex02.ad.cirrus.com (198.61.84.81) with Microsoft SMTP Server id
 15.2.1118.39 via Frontend Transport; Tue, 28 Nov 2023 10:42:52 +0000
Received: from [198.90.251.82] (edi-sw-dsktp-006.ad.cirrus.com [198.90.251.82])
	by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 0C6EE11D2;
	Tue, 28 Nov 2023 10:42:52 +0000 (UTC)
Message-ID: <eb4fb7bc-93db-4868-8807-f97f5da59b23@opensource.cirrus.com>
Date: Tue, 28 Nov 2023 10:42:51 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/187] 5.10.202-rc3 review
Content-Language: en-US
To: Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
        <patches@kernelci.org>, <lkft-triage@lists.linaro.org>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>, <rwarsow@gmx.de>,
        <conor@kernel.org>, <allen.lkml@gmail.com>, <maz@kernel.org>,
        <andy.shevchenko@gmail.com>, <brgl@bgdev.pl>, <wangyouwan@126.com>,
        <jani.nikula@intel.com>, <ilpo.jarvinen@linux.intel.com>,
        <dan.carpenter@linaro.org>
References: <20231126154335.643804657@linuxfoundation.org>
 <ZWUJWhOkbHlwC2YB@duo.ucw.cz>
From: Richard Fitzgerald <rf@opensource.cirrus.com>
In-Reply-To: <ZWUJWhOkbHlwC2YB@duo.ucw.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: FsPjS-HeCQyM5Dl1BIPNPnaDZ47pmB0m
X-Proofpoint-ORIG-GUID: FsPjS-HeCQyM5Dl1BIPNPnaDZ47pmB0m
X-Proofpoint-Spam-Reason: safe

On 27/11/2023 21:25, Pavel Machek wrote:
> 
>> Richard Fitzgerald <rf@opensource.cirrus.com>
>>      ASoC: soc-card: Add storage for PCI SSID
> 

The driver that depends on this only went into the kernel at v6.4.
