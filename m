Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF0138885B
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 17:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770657930; cv=none; b=BUzq12nfz9BddOzg7Umv912djiWl08mfIryE5m/SXwq7SlU2h+Fj+MaI0dDe1RYydx0NioLT2CCk4OZvpm3hbjnLfUStadRlv4v7rKomDf1exmfgjN4BsAY0l3ZCZv4wseVRi9CXxsTwIO5EqP0fVaRztioBvv0vam5cSHg6A1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770657930; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NFhnlVWgKqpIhEBjL+rE76i6EMt+49E9+Ho0nok8BjEfLzuZR4uwA6t7r2ZUio1hkjmVnNhStcFqNaSlNGrYTrrpXbkMq9M9PORXLIEwzFjvUiuA4vEyItPeiidEz9pS9yrY6Bc/eJaDcpvD3te41ehhxxeqAbLL3GzlercmEjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=EnpHolIA; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="EnpHolIA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1770657901; x=1771262701; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=EnpHolIAn4jsld+9RDonEFD/zNAAH5I/M6ecbom24iXgCk3CGDO/fs5OX0cGCcC1
	 wPN6BSu8yAgk+w8k5jPxLfTnqQ+4qlMLQE4VhkmxgEioslh+KrMIgm88aTiGMVjZX
	 n1NQxcHEbpXIv01Ko6sB3hZPwKQTXZLB7UFco2yfD8a/6x0NXRiclz+Rml1MEqrW6
	 2bIUdIOQbuO5u41yAR8IkhKoc61kIRONMEBu2t1PnqrZ8lahwS1BsQG3U+bg0Hidu
	 2S/xb9VUYbropyZpTGWZaiUezk/cs8lc3l4iTW7Oi86ZMJBYm8v1hnOffsgLbvLMM
	 aI2Z6YNZ/mjA2SyLpw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.28]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M2f5T-1vo7gw1H7X-00Glz0; Mon, 09
 Feb 2026 18:25:01 +0100
Message-ID: <0c7d0dcb-fb37-420e-bf42-7929f7bdf781@gmx.de>
Date: Mon, 9 Feb 2026 18:24:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/175] 6.18.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260209142320.474120190@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:acti/QEWtF2XLaIiKiWGP0M07tqtW7Od5bLFN944KQsKQ9gNJSt
 fywogJ4FquJew+5Vhl3W9C97zxb9cEjJ8lRHZo9hhZ6FbBs0r9Y+uHXUaIs1zskfNaVrIUK
 2RngniYfflpDmwwxIZjZbixccCAyIiGqTBFDSvBVn0K3m1YdosMX/xe0c670rwkbRGQjqEk
 /DkYB8rZhl5+JYIIm/hKw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2uKMZdTAZK8=;fWzkoifvUD7FU8dl8bWYay4+VmR
 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
 ikpwlmlFL6TPBRnJ8=

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
