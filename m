Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC79C346766
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 17:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099759; cv=none; b=uCamod9MFN6tSh7lnxCKKhqYznD7YNwT0SVX4z1wxlChy1ECOqLco1oEPQbGojyg7MBgKs7IodH2Ld4QrRySYylBoOEKHEeV0fbV7fIOUgeQMFmIEFHRbD5jxOTnIS1qQML+Q8w6iAM35Fd2pZoGOMlJgR5MfGzZXcIl59ZOkAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099759; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NaUnFqXqpr2esfBjJcKs/Z7oS4TmRxODN6jnG4n92kM09yMmj9yW4llDLARIt7fCPvN7V8P1FCnjciPD/3Zgr2I3c0vdbMtmb6CU2wY0Op9XgAqUegjVx33BdTZ0QM9B7ZSlOVQPa6ZHybcqHHSAPh6sHncdVhEadrlCXMtsaJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=nCIv8n2+; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="nCIv8n2+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1776099713; x=1776704513; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=nCIv8n2+pJnNZpUBRKRidj2cMqXBo69UkTy5qsu3Nji2zJQv9NAISxnh0LJsOY7Y
	 5mz+1ovauozF06IY0c29KTftz2Eid3RGL8B5uD56qkaYdL4V24ffTUZTLd6T+76CB
	 hAk0MvY7MK1Kp1WOrEOt6yiZVfLmsnDzSH7V0dJQjCw3UGFGGBESxGrne13JEgDRa
	 ZL3NZbp6ylsUvdJ40BdIn3RnJmbV+oE/nH/t3jowAatuoBbDG68CZWc4aZWCvq6pY
	 iH4KjG/haickgPIpAGpWzbtcZFodpLOiGuVwZKJ/nVYiAwJGvmik1aC6NTqeoKD14
	 j4gwJFj8ggBB8ANjxQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N9MpY-1vP1qn1WZ2-010bz3; Mon, 13
 Apr 2026 19:01:53 +0200
Message-ID: <613e0190-553d-48f9-9b65-c07c2de8e158@gmx.de>
Date: Mon, 13 Apr 2026 19:01:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260413155731.568515178@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:jXoxNgslWe82j+k5mcePflOwbW2Etd0DfiitXLiB3V7ly8nSiqo
 u+/RRY03ib9iKcgF5dnwsR3TYKhRVHaRzA5rL5zBXIU5aKVaCjnQqWHBf/NV2oNhIxe4ayq
 cboxrCpAcjunJCUJ2uv22jhdOzwgkGHuuuKnOtk8JaAtBgIFqPbXlYXe075E2mS7aGFoZW0
 rytvIINGvzQszKyHcrj1Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xqUphWNNOA4=;KXXWz5Fas7FbAaMjBx/UJc9CZh9
 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
 cb8SB/tVcVO

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
