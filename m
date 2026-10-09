Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817764E5350
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791558903; cv=none; b=HoQOJ3ecPSq6g+srSAsWwXcOv4DGrZ4nRqYOGniYP4viaKCvZDcBQLowklqybGG5ga3ENgHPMm2nvY4OtlDLjnLLXjrzE6RdLA7SMle7dbzr06QBkqmtZBtW6is4Rq7FjFYB39YpH87+wP2FZsgvBWoWfAj2tcPBzXn/5PElrsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791558903; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q3Fk7qZEWe7UlN1sbee+xju04PHXbSFbMKTPhWhWPwUeteBvtM6kPNVqlxVB+7nYgAJ5aNVlt8QW4c5hAlUHjQ8XNBcnYi9mPMZeZGJcccaBdAh3z5UMP3ZAZJDzsb0i5rXMHxzbORtHLLLmRCY8vvOXCoUChKfg+8PA8xH2ZDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=Q3/PXgJP; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="Q3/PXgJP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1791558886; x=1792163686; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Q3/PXgJP0MB+QhTYERkVndaAltaau9aKw10vlsMNMngqusy2cGVDDPiWlNNFyIMC
	 tkqFOR4Uw+CAT0g25o/99N8kBLUCtV5gPgVZw+0uRrPrJcC5VOQ1P2oyO+qpBEnZ6
	 +uoHXuU10yEaGY4Oj+hpE73YA37X4tmxxBbdK2wCjZ0gxuOkWrnakPoD6gXC2LsGz
	 FT1tDFrqB51pZs2oeXjAbCAgXbsyiWQ2KqpV2YDDshlj2hMCcuZ1kcO/LukHwjBmt
	 z1lAVaCLFMfcohLh2rZmTXL6SjeTHxUfWAJbVB1AQFeG6xgS43C7lYVe1Y3vxtBud
	 Id9Xd8GVtpqLeww+OA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M5QFB-1xG1Fj2qY9-006GUu; Fri, 09
 Oct 2026 17:14:46 +0200
Message-ID: <cff5bf67-7204-4e1f-a5ef-947e86710ca7@gmx.de>
Date: Fri, 9 Oct 2026 17:14:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261009140946.008206689@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:WQ2JIcfzDXhLVLoSZ67uSsFrATvwJEbpkpdzzXzse3GVh+QdXor
 lJLfcSeBh7zw6rxpVzF902ZpF64HDzduRlXOBJWZOSQJjuNqxr7UxrdYkmyrx9ASB6Hqgp7
 fvzC7NOopT2BwjPmXxB3vKJKJnyoxsUVwX/DGJvL43NIRK10b51j/2AG1FVMObS02GNMYkH
 IRsqvu3cKbcUtML3iUhjw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:BCyATDKrJGM=;Aig//7OvIAQ1eSfsYgGMdhGdItX
 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
 uUp0GFqXAFZ2dFXfTxoO/ON7wKc4fHyPe1A==

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
