Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D852C3253
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 20:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748895155; cv=none; b=dP+T00/jQGkoDYi3LlupdTpnDa8Sf8KYgObtY9LnEdW2Mgtr9xf48uBfQE/NIre0f6yxWYUSxt24a05XXLtgE7LzVtLMh/LHDxZdpem6P2QGoE1IL6MXAZTv/mkAmD2F/w/mj6i+kCGGXthRw490YZ6MgJEsbRafJh8gqYMJwRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748895155; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZptThajDmITJdYBTfKcjHj6hB0rFkBIxUlUoW/oYoZB966FIi2thHxeXSmvd7/ry+XLbVPtzWVYj3CtBGCj/Q4R/F4CYlBPIrZi9npklaxdGBwqRCjxSTxmVWTRmblhc02NsuxzcNXhpPZkxn+Kvs6jRfXNDDz/BtiTBrSXIOTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=stw53U7U; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="stw53U7U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1748895115; x=1749499915; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=stw53U7UBqvelok6+Isl36ol2zbKoUx0KptTDMXG0+KNFqFal0CJt5Jj+MqeYL8S
	 cwqLhjnmz0didsOm7rG+DkZi7nK8iyh8DD4tUWLOMlCXtuO0dOmi0znMcXdARXUA/
	 Do2bcJb3RA2f2gRII3h3DzFb2fFG0x0d4/ByGVXaPMjsYF98tDatdeAFEJm/aRLaj
	 cUJ//rH1nXFhi3/BpU6/j8cHuDDL4iZwInEiv6y5ZlVUQRDvpsBiIonwHvBqgII+3
	 J6qTjIrKXEDEi2WIm+pyFwl98vyej3qmrr098G8wrnJ16OTjX8HFTMiiYeGQHGZYw
	 6XShUpNovHCxg1yQIQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.40]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N5mGB-1uxZgm2j5X-00w2Ky; Mon, 02
 Jun 2025 22:11:55 +0200
Message-ID: <782c7507-a51c-4006-b515-999853825bce@gmx.de>
Date: Mon, 2 Jun 2025 22:11:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 00/73] 6.14.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134241.673490006@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:TlMlSjH7v7OPrTNn/9/tHaCk7ExhPHsaRi/K9ZAMsQiGuxQxgXL
 M+uUu9AldIu6t20FMtHZkLWvL+LnM0o1Tx06/qxOU5Mk8hCP5j9/xoakYkzsrqcKKZdq0D3
 2QZiOJ8OByHwabkxfpFn0umg9RIM5adbQI5yDEJ59NqXZJLdRpStVRdDPcNyHdQ9zHB1J7L
 mrJmhNUCRMpYIXDo47JmQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6ZXY2SQlzzI=;ZoDNlrbepOB9xznBNYJTduRgjQh
 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

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

