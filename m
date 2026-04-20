Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8823A6B85
	for <patches@lists.linux.dev>; Mon, 20 Apr 2026 17:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776706388; cv=none; b=SGUX68ZvW01ecApTM1MhjGKVah2U522ZSZyxyZC3v4fUD/C1oQ7H5XhnsWuyqW9N04PQ/mGgMfHZQNL29mFk1OacjfxfeRduqL42m8CfBOJAutogvPAi1GlspXnHuH+RlSwACCVHGTRI+yrPGJR8Gx7NMUt+TUxwG3o9EoLCksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776706388; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KeHPmSncaXl17FXC2MRhplrQb7D+rkJdWXp2ATNwST3m+HPD1GH8qzU2CXgg9XPt0nCog7oxwN3ld50GLoIeRer5gXqh6jGvtgJJMP0Fs2TjNTkx5J8LXt4yfrSg3FQP9zBdezhrvcuREpB9UR4NHXsWP1wn9TpiPWFn2YnlFHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=MxtJEFu+; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="MxtJEFu+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1776706357; x=1777311157; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=MxtJEFu+hbeIWOb9ioSV30r/uNpy+w2eSy3gyCOQFvgyzr4Q0cAVJH7O24VvjJBW
	 erRyxojZ1THXA+ra7DG9DqGl1PoEw6ik2JhNi/9KypV6g0dfqkLXRnYFYIyF9aI76
	 AVSiTWUAL5ljXH68D0wNh60ValdujQH1iSOeZNOsDVmo1QdQatrddhrMWGGEZNNvo
	 5for8uI6QruAqFZouWGrxVsQxxSKw2MmCOrPf9uRiNxVyoUcYc0F9/Cf5nXxSaGoe
	 QA8VOZMkVF3Yq/0zWiDT+YldukpvvsD7P8EkwG80V2kKszfl3H7wMq5Yh7ljzm15/
	 GHhE7x9IGquRHvQlJA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MysVs-1vS11L2ggE-015Hyi; Mon, 20
 Apr 2026 19:32:37 +0200
Message-ID: <dc055f46-d1fd-4a9a-b0f7-ee995fa8085c@gmx.de>
Date: Mon, 20 Apr 2026 19:32:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260420153910.810034134@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:+kh/FHzK7aZUcOC5OR5CtaJTnJBTUKwykgLyhvY4naRerj8DZAp
 ChSDTzL6cTMFr9eWaUcpAK9U2uOLNrIRg5y8BIxU5g0/b9WwN1pNrhgt5X/GU2+D283r7dp
 H+DwUnyfURaNDOE8137dey9AY3uzS4eZWj1AW1S//8g62FjpJBZ14FvAjz174GIFJFgONTT
 3eRHLv7MqPE7//0xfKMWQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ueX0Kmull/I=;kChrGnISRXguW7AHW3Q1OUusxSP
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
