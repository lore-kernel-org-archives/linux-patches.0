Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8DB342C85
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526361; cv=none; b=kqOS4JAgYB3/swVPBy+IE6/QOQHpNWR4TXJVfUc72M+Z0ABe8Jek76PGdnxuzYrdkfZKDcJQ7pSM9Mxogu3pwvfrRUJudo78dXa8r6aNGJmoV55qXJruneoXH9uKkOcRKqqyx7gxjeqe00bzH7kSHgPVCVvIbvE1Xqg5INUuDV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526361; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n+g0VfmrHnVYcRsr5RPSYPD3L+8Bemlf+jdAfeoeClt+BHCVN9i1F5BdDeuENBFoSDRXb6To1ms6gYazk1m+EJxtp9Ux6kUjBq90FAlG9MxtaXAR8XZrUulh5O4tjj7NqsEeul5kqJboAel/ZeLRZbE7VBgUgTHdtkk/Q46/n3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=gcottf1M; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="gcottf1M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1755526340; x=1756131140; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=gcottf1Mtf8OiAmIesS4FkiTAmqMCDeOK3nLZvHK0K7nrvOvAaODXuZl0RO5/Cxp
	 NIsSH9Tzjqjv7rUBUrDpBKISR4JZn9m72tl/jFDqJic5sH5ZWUdko6XWSmv2xY0VE
	 57Nb1clYgj11Ye2BsbcywSI6GB/oXhMeyN9k9slrEyyqs99c1oLheQn5F70+uD7/+
	 7OX7npKFE4TbCVWKMQtrY+CxRfeT13xRmjj8trQaOMfjOuGvl/ep8WUsEG369Vdc0
	 t1Jgsnnz5hQHfXgA1WkssGWspWPZcv/jTWG03X9e3GeO7oKRlTu7TbeMSNlSV76aG
	 NNaElchv3NTy1N3MFw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.171]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MVvPJ-1uxfEH1c3R-00Lpvt; Mon, 18
 Aug 2025 16:12:20 +0200
Message-ID: <10cdadc2-6fea-498b-b07e-3a24021fe5b4@gmx.de>
Date: Mon, 18 Aug 2025 16:12:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/570] 6.16.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250818124505.781598737@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:RkjMpfHx145exU8PyU4+4hbze01n2EASQHligjBwhasmHdX+yCS
 PeNAgdLrtWSM7DJ6SReEbU1z16mW+1TM7GbNxmTCrqviqf9BXqomfaJDeMLpNZm2cGo0x5j
 hDtkU4bfwc64nnFqeUHfms/XMtMvwZQlwMMxgwbiB/5SvZvj84uZjVgptAcvvdw39WNC4mg
 PoVLYHUN3fNnT/rCsB39g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UD1IAoDxqwc=;HNGdNj0qafXAme1o+i22nS87AH8
 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
 P84w8hDHPzCyDjgXTblzYbNSY=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

