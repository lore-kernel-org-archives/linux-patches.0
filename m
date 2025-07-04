Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6774C29B8D0
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 15:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751643488; cv=none; b=eNeyc+EDtEUd9c6EFAfwTlrydANxwVf0VskX+MCvYWepd8ToNhTO9plQb2ucTepDO6PF4Z2SGfuYs0PzVS2Rx/oo7/G4Hwvvx9McfyZOCTM+fXJs/s9ReIWa2H2D6NuCBN6fxaMCBOUF1qAwIqhx1HS0yM2PJcjvr/mVSYgC+sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751643488; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AeQEBnk0M1pmLDmvrWNjXoHwgS0XWXO8uu43BodvjzSxSFj4Yc3yKfbJjwqOihKbakw6frVizL9q+svX5bdk+w03kHHfpAwpybsNEcSrzOeQNFKKfwM0banSdLJUkJu7RYUrZdYkyAilzIEFD/V5hAubCOasY3XlOdpoBevbF5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=OX/WZ6nB; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="OX/WZ6nB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1751643461; x=1752248261; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=OX/WZ6nB+ODVApO9YyTaMZwGboGEf6UjWXHXqungujfwvye6yEtNfnwU1sAJQE4Z
	 WFr3/g1v2bxFIGV4VNkwgj3u/2e90/Hr/4YPwFb4CJaQyoVFGq4te27eht3H+Qmji
	 l5Uv06/ePZqxklYGYsj1vXEliu0Gx99e7HgDs4u2qZ3Y4M/KidM4VX6fj46rMGpYJ
	 GTVG8sboxydl72c9mBVsGw/1pzYCIx466NV189oINrRac2qMytiU5Myx7MNy/fs2X
	 7ZS+/gV2olameEvOjMXh1GcQoavT4eodZTaOXXOZV2BpW9laDmYWJb5p+I+rw0YMn
	 oRVYbVBPY92bsLAXvA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.128]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M5fIW-1udlAE3Pic-004mST; Fri, 04
 Jul 2025 17:37:40 +0200
Message-ID: <678fe368-326a-4d0d-860e-95e2f44a61c5@gmx.de>
Date: Fri, 4 Jul 2025 17:37:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250704125604.759558342@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:Q4ueOPUJpt/njJqrbcBzvUGStjncSVN4382XVhGCRZ6DNOTAHV0
 JgDTpN/dSOW/XrOban2gMu6MJ3y+LZEy1f4vCn/DK2SMJpPsy7ou09niZMppyqwOWOYE1Na
 TcZuNvynKWdmS6yY/i8k2GHInGRTyGyUtk2NntcJT++mYA7MB7wvcLKFAGIgAw/az1ZsAEz
 NEFUPR6i8blO6FdPAtPHg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hcqnhP9wrnk=;k2GRxpn1vx5Tn3LzOd2AQAFbcHP
 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
 t9wKFjD

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

