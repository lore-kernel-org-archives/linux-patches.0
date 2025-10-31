Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8712238C0A
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761922725; cv=none; b=hrzkhfBCcgt07mWimtxSmU8+53fhiwpzx0mTF+uW403XRIizMmztYEyqro4CofuhxS1Yn+VzLtUn8YGH1IFZxjH5GFuEZbGoQaYDkF9CKdTt+GFaMd3PZQmSJFNs+B4FFzkgTpb102XbWs6PdkmzGehT/+CB9SXfQ+ir2S2760k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761922725; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffSt1bCFsCYaVBq3eIQXmWZq93X58IPMr/6lJXnFjJPYlg/N3+jozubT+Oi116u7UjL4uY9HMbj5ozo0CUyieDOK9pPRN6IfcBZBQdhkw2iyjh4t3XgeVf47qR56GgA4wEsj5rsfUQR78vS3cU+DS78uQP/36fJoVqxM9+ZQUsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=VQlh90m6; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="VQlh90m6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1761922687; x=1762527487; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=VQlh90m6uDSmQ2IUwt2EtuBC2XK3VRqwlgSxCX+aWEhswCnEcHZVMtV7wP0hGmrI
	 gdmoIk1QOHVuz/C2oKnvLHx4iAoq/5ZgIYR9g/XN2kQ2BjdygRf7gw2VAxZwzCK+d
	 ZFBNf4bc+bpNc1mLcS60LJNc+VJln1Pu9GzzNJORybrfPoKfEvXtjINpzWxJ5jPz3
	 +3Q+sRTdU5Avlp1fHEIyT8FLR2wccAfbmYBxRvZ2KuD73XvM0G2UZrRB5MJ2lEjb/
	 ix+M1oxeMfUYIFkUJJVaXAY4V1wZbD0W9GAD9gUL43wsooFokgpr0gsHKCv/1n+GK
	 2ohrOj4uU90RCqvJqQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.105]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N1Obb-1wHHoy393b-015Yfi; Fri, 31
 Oct 2025 15:58:07 +0100
Message-ID: <5d3b7831-7130-4424-85ed-387918bad0b1@gmx.de>
Date: Fri, 31 Oct 2025 15:58:06 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/35] 6.17.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251031140043.564670400@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:GX9ArV7aBQISlJkxtunYnMGlaEBLgcFLfjT1wnJ4baw6LtLBkkI
 UU5xxF7Te5OI7qR0lzBMI/vvtVm+Uygpm9C0ORoKiRiIJ4IFY3Rkq2rUuKmE7YrOb1mlBxA
 DiCF9XbARMfj3OFWQRr4PYNZukwCMANHRYq11sA/ENyotVvysiQX2dc1BWqIfx5MVQHCgL1
 CYdO6tUELHodVlf2Yr1ZQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8C4bP8/kBlw=;BR89zmsWBs4oUBOp1X6Y6uxePL3
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

