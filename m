Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.245.111.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792786558;
	b=n3IQCI5fSpnghY1O4GFe+0qrwAlVzc7AOjTWjoOIIl+3w7A/CgFd1XlEAM+a1Vn1K44V
	 RccKUn7m3nyna48NxIeCKRtyWvd62816QkrM9rpeNraQ/Kk+GSTco4cSFxNWjo88HINS4
	 tCliq4wP8Gh5k1ND41FfJLm5Mcae3KiyXppqzmRey6d3+j1k10wqReQiEQkWqLi/L2v1X
	 4SYJi1aBa3hAXvaL/iiIThG2LlVcBoLoVh/JjPS90hZFJmvDtGrPbPU9SAteYYUCNEc/u
	 hiFosKBakG6YAKeAUM9BSD/FU8LMQGpn9WkhoRTIgzCn3TstsGHEJ4fPyZGGL0fx4Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792786558;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:X-Scanned-By:
	 X-Scanned-By:X-Scanned-By:X-Antivirus:X-Spam-Score:
	 X-Milter-Copy-Status;
	bh=uwC5ILlYQ2A20iGAvOVLq3SHPtalALFaviYePb1v+Jo=;
	b=a2mJcuHTYo3GOs8ZbRKQPHBRFPIleuh42ZHXjDJ1xIqu74lxydNJ6P5+M8qSdJCs3wP0
	 yGsSWZPAwoGyngLFH4NPnksEJ4EPqoJM3yYiSQ2POKGkiRXKYfQbYPBKPP1SyV5gI/zZr
	 K5RTyzhV+lED6adbDDUaxqeHBXR41edZti4w/ITtqIzaMM2YVceS9gjSvqVXpYHsgyBKO
	 HikKu9tI3sUSWOgazJVFzhGXL0VvWtZlfG672t8kf26kLQsEL8NpSHzAjs+tlMDMqfQ7k
	 tQ91/f41SvptgWh35f1T5Z90e+bq59D7zgX3XEAW4vwhAQo9UvRbL84QZyLyndE6hgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxbox.cz;
	spf=pass smtp.mailfrom=linuxbox.cz;
	dkim=pass header.d=linuxbox.cz header.i=@linuxbox.cz header.a=rsa-sha256 header.s=default header.b="GqxfIHI/";
	arc=none smtp.remote-ip=62.245.111.132
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BAE606A31B
	for <patches@lists.linux.dev>; Fri, 23 Oct 2026 20:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5BAE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxbox.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxbox.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxbox.cz header.i=@linuxbox.cz header.a=rsa-sha256 header.s=default header.b=GqxfIHI/
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69NKFchq114283
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 23 Oct 2026 22:15:39 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69NKFchq114283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1792786541;
	bh=uwC5ILlYQ2A20iGAvOVLq3SHPtalALFaviYePb1v+Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GqxfIHI/ZNK47zxCF4ufsQmSoTE5hYnhT/zZFMxRm6llN8YKQZGZ7pVj3Dz3rCq5D
	 Wmdn4t09L6ZkZqxQo+ikWiGav9Pw2ZUF2+aSLuay1IjLAy2l30GQu17Ny76X7loNQ7
	 0WbyYgl1dPVt9RX/hCyiM0+Ps7bKKZiizu0X2MJM=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69NKFbS3027201
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 23 Oct 2026 22:15:37 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69NKFZqJ3372149
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 22:15:36 +0200
Date: Fri, 23 Oct 2026 22:15:35 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org, sr@sladewatkins.com,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
Message-ID: <atvAZ/bgkZl2tezN@pcnci.linuxbox.cz>
References: <20261023163714.201276352@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Spam-Score: N/A (trusted relay)
X-Milter-Copy-Status: O

retested intel ice and also KVM migration of Windows guests with VBS enabled
(ie nested virtualization), both seem to work correctly now.

thanks,

BR

nik
