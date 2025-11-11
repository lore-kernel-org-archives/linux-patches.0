Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DD1277CA4
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 05:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762839557; cv=none; b=S/rmdIDBeWOcYLzuR2gYAyIcV57Yi/nRZFx49CNkZKIgFe14XbU9hvLFMr8oJGOX4O150kRORaENQ64LfA5lyDe+7GQ6dJo6Anj+CtKzoRq3mDPt4nwPhzg2hqdRU3DrrmUyden87mITol4uTzuVhoE42QTt+3J5PiBARUmNMvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762839557; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IVUvi9obBG7iraW2ehIJgf1/0ECSSqsF9u+w5313QcpTPJTAAdGK/Tn0XZcGS4K6JT+sOGfjQXdiSqeSEAz8VpQbGUSI6xjH+DOu9Ib32jtISTFIQzEEabHsoll3mWLzewkkIFUXdtz+8R3LUy96zi+T3fRKXJdFBxwLUqyPfG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=hQhLsiQX; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="hQhLsiQX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1762839538; x=1763444338; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hQhLsiQX+x39tlsI0RjBLWrmAiX6LceWjGD94lGuuu2pr9wi36fnGyPUjZjIPdc3
	 RP0jlb5B80+Ms4r7ZofdPbTh2AaX8FIoncNZWttdyseZ9PKti3bYbPlu7N0P974tk
	 UEeQ1oPErCNmI4NwoV7jS7IOsXQ1Rar2YDQ54MngSrMZ/NNkEqdewkc3d42mb3OyJ
	 MgHpACxpvYLgEhrZUxnSjXdgiMQm0vw9umdm/HMrz3O2lrWvHp+Q85S22nNNAFNar
	 25l/1+BqMwSjZSEmRUvx1tWX31LUyG5hfFNxwhz0sz1D9iwRbASvmqUDtcn0Mw8Rp
	 J/VRHZGHnWL/sMsufg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.173]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MRmjw-1vkhGC2pB4-00MkUq; Tue, 11
 Nov 2025 06:38:58 +0100
Message-ID: <7233ee9a-9ba6-46a9-9baa-7aab6641d1fb@gmx.de>
Date: Tue, 11 Nov 2025 06:38:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251111004536.460310036@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:M0F5RI+/ksTEirpr+igM5D2b8jUxPdhAgqxbZdmAkjZ1nyLSBfv
 iX+SbOnircF4neBzSGDyqLsOUfU6TS2xi2qiB2ktJqLASLnEDlXJYTgLTkKm0Qiiqgd9qvX
 qaBQS90h0erul0MgDYRr141la/hda5BDVKgnxcP8IVfenYSmo9ACvseu7tzcf5qQEavGcRh
 UyxvsejALRqwkVUWayu/A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mnGsFjCWo8I=;5iHAVJ2HHM2AUeGOVKW3iDmDDno
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

