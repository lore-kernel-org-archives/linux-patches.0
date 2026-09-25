Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0E72D47FF
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 04:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790310227; cv=none; b=CmBhUtRJ4iDhIeOSXHDG/l03xTrdBx7BHYRPsiVYc/zsGUQv5o5mAYtYCTBpeWNErkdV3R9LZb0J/4WLp81zCckP16lAeG+a01kdR1QYDLrXRYqeXsz1hIPUpmEAEVBOSMMxVLqNodt1TO7KYEt2teY6Svm9D5qmp+bkI0vUfQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790310227; c=relaxed/simple;
	bh=HtRyOc2GBalbvAbi+TOSi3VpG+yiZxePG9PVaII6ZNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D9cTp4SYi1iA5O8/CnPuoQ2sTj0XCC1pmHRuHoDLokw3B8udeTQDDsOTwggJVLTiCt3MdosqUdW7ypSVrUU4oYMisknxiviDoxpeyBg9q784R74Jqwa/3lBDLmNfCrtc2wMzZAnNC6NskGzSWJkZWB/fN8XbRuyCRYGA93qIgn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=HJ+uCA1l; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=ESY6Mfy+; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="HJ+uCA1l";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="ESY6Mfy+"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 1C3D5EC0227;
	Fri, 25 Sep 2026 00:23:45 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-05.internal (MEProxy); Fri, 25 Sep 2026 00:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1790310225;
	 x=1790396625; bh=9O4l752m2avZiUeNfxEd+COoYSLhzCRbs4uuuwUXsJA=; b=
	HJ+uCA1l9zKO9nf9qJ1pesOt/s4EPYphZq665vfTymcif1+gawGY5+Uul6mQJbqa
	7ygQuSg4xtYA5o8e1yydNgmhNL+KRc9WAeuU1vnGi6V1yHtmcnh85bGRAayAzCdu
	/uyzU4n2h6xzW8LI7FfzgByQWi2jC+/gZ9hN+/ePGG4Fmpal0XGEulqOAnfpmKB5
	bLUya4x4/NOzy48oZKa5y1K8dwyUtcNhY4kzg+y4c5vCAdcvxCKraICPTqV1L9h9
	/PCcygn2Enrls2sjdN/iSaddNORzpWl1W4NDPrQE5Ycwmv1171skgE0xpN5ylTyE
	dMYnJz56OxkM02tkkBtmLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790310225; x=
	1790396625; bh=9O4l752m2avZiUeNfxEd+COoYSLhzCRbs4uuuwUXsJA=; b=E
	SY6Mfy++bpQnOsYBFWSZVSbR/e0KqiFO4DCo7ljf24rbJh764daacR/5rC7NiA2l
	FPuDRvYmq0+dZlhw5Q+FFp84CAOqumtxwntsK3wf22hjCmBg0hc6cozFdlf5u7Ye
	RRFsyNfV0NHL1wo4Vv6mG8ZP9ky/CXQEucjH27C+aBnoJ23VlaC6f2AAeVArkFN4
	Rq788BG+JaU5mZ9xskhLvYFJEIV97SfeoaiZYtBMP9iink4v0JIvp/SUD/tu7uqt
	XEA+WVhHape6ZnRU+r3J659h5EPN+OaEeP2ALcBCdLRsf7NPIcOKzEAy+D270UH0
	6fI+FlDWydvkkwBBtatMQ==
X-ME-Sender: <xms:UPe1ahKbkscYkVCbGIOO23UJIG7ra8Z3a8l2J6SMbSJhYDXyF_MDJg>
    <xme:UPe1apCBWR3SbVGO6nUuB01V4JYdCGJ_vAkCk2PJshHi_aXwtL1Lz9wYLXCSTt1kU
    Tk__P53BhUFfCw4EFL8d9BHwrGlOUcyhf9tf2gRN0Iss8RmsXG0XHGD>
X-ME-Received: <xmr:UPe1alNxV0PvvO4jXUo4_CE1dVTstAHEzdwRlLFWLmeoNxXg9v57WaUtGckPFX-pKvxR39tr5f1CDj96xOJoCY5v1jbKM6EP>
X-ME-Proxy-Cause: dmFkZTF2PRITwLn3mE5o1/Duw1QkPZC2jsLU/pfKJ63Kr0MOa586KQPs+cn3s49RyyHZqG
    e7iVvBh46D0UPZ/ItvlEZOkuFpT2FeAZmyyAwXjEN0HydKnGt06QAnZvKu89cMCrH85991
    w637pIvBzyEpfWckRb8dokT7s7u88mnwDyEk4khHqItkDKpfXPf+b1I9zjIw9Ntx0fM8XJ
    JI6Jgm6rbUmTSiXhhi/XFI8Ic26rBO5Au5dh4JGfGIjTjtwTOvxue7vyGqcAjfLjcUUOad
    4fBuqGil/VXvhjQ+ugZ6IACK5/dEFuo0wQ83lvbc6Txswq4/F7z+cMvBNKPl40/EFNwGcb
    NtpulbUwRmEWb9uvazYHIYQAMCD8AOZr5nF7TzxV0pVGusFH2U43iJluvzaDpqIjFqr4kw
    D/ooXtt3q8j+kwG92uxCW7zh1pjXy2WKNUgN8ImPeIDKuzB/zGxWq8L9OY0/cm/MRxs6dS
    +O490X0qxLR2O6M4HdZkHb88mjiajKb2VlSunUacKpcapxbRnVWKrQKWUuQYm1gf9VAW2n
    fhMAZvVhWI8CINtYYYHVR7W8vqW2fqItEfJLzjhf3Jr9sJelneQI/zvaEKe0OY9PvADZKb
    DxthUo3BcqfOuN33WuOTtOrcGS+9EQIWElPCvBDOTq6c/bV5F/lNbpqhdy6w
X-ME-Proxy: <xmx:UPe1amW8AgKRBPnEb8sPvdyzIckLkNgnMK5P0jF3N5tJTYYHcFD6GQ>
    <xmx:UPe1agSu9A4p2wTCdjjgE8Jxhmmqqv4fQeC8dfh1YSLA2cXF5nYR5Q>
    <xmx:UPe1ak1Gkdb3_zEGpCuRIvPNnmWzfQuU4lmM9tVNY7FcZqLyt85WCQ>
    <xmx:UPe1alg-yn8HagnmXs-4bkuoEf5E3Wj3WlFTUKbfU9XxpZyQSNWr3w>
    <xmx:Ufe1aqfNcYulSsN7EccSyh4f5k6ilicaLwaECTTQaGqocGX7y6xFS6E_>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Sep 2026 00:23:42 -0400 (EDT)
Message-ID: <dae37b3f-f29d-4a3a-8e8a-df1159f75d13@pobox.com>
Date: Thu, 24 Sep 2026 21:23:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/398] 6.18.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260923140643.441954610@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/26 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.54 release.
> There are 398 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Sep 2026 14:05:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On an amd64 laptop (Lenovo ThinkPad T14 Gen 1) and an arm64
virtual machine, I tested 6.18.53 + stable-queue as of commit
b1b54c5d771a22b69e435ef44b5fe9ac1e714703
("drop 3 patches and reorder one 6.18 patch based on RC review feedback").

Working well, no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
