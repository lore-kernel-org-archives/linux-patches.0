Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF7444CAE6
	for <patches@lists.linux.dev>; Tue, 16 Jun 2026 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624273; cv=none; b=ZYHMHuS+WLwPoGJ9f5B4gH/6B6quLA4ps4+E4KB4wo97MAACSP8mYZy0aMGScFiWAjA0pezib6pDj+EdQBUKif3zPK+Rj2EvYDdKEjE6lIYqFoyrLS3ybjPSD9C3N+E9jtid9BQ73rhucn+9xFUR45/KbJEfEcBqzSDOMMJBaWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624273; c=relaxed/simple;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dST7osoxgQD+k8//PVN47md9HEErO6MZnnWI4uaXf1+Y2VouS8Y6X8IGvWCc1UXx2jSF+TAejQDV7z7/B2KoseZc17ZGR7aVLavK/okpH5zncMwSMYgV4e6EhTYWfcccBLFEcW+nInMgr/11ZtOqTpkmdywHJ8juSBQUQT0ExmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=qRXudxOw; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="qRXudxOw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1781624257; x=1782229057; i=rwarsow@gmx.de;
	bh=1PO3YHl+btPykbwTM16jfcwADiOLFguz3RVcskKvjrA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qRXudxOwgLbn/RaEyoNriTupwQKH5sqKJfUX8wn1bed3jOywFfIPisbDATevhkaN
	 +9HJrewig+N2s1cgDnggz9TLbtSiCNW7iPKYBHav3/wgsaayrgWYIcFaIzzoITeTb
	 kows4jkh8IvkbBlghIOYoIRNiC6wKYRz9nkYUqia3SQiZouCOqB0FNbPed0NknqKh
	 8CtJLAt8AKHFhNPqfOIH0RhDNtfRNd4+vhzIl6MKVdgDBLRIibz32QoaFPWLSaEJB
	 5M5JaLfcdDKV7nVD/b5ao6ElaEHuqIIahnTcQA/WuUp+yycr5u0EtWcfllJ1lRh5O
	 J3UO8qnwctWazBpaAw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N33Ib-1xKYRg1Ji1-00uwFv; Tue, 16
 Jun 2026 17:37:37 +0200
Message-ID: <0ecdda63-7ebc-4018-954a-a163ed6a177a@gmx.de>
Date: Tue, 16 Jun 2026 17:37:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145109.744539446@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:f+Q8W4YrKdd5BZFbk09ZtPvwZ+CxmmFuWuFgT1lFB1uGbdRkiMF
 bb2Nz1f871dqtSnd1uxyi6KhofxCyEJrFh0BJlhRO1TLS/21PiwBJ2CQS9ZBQwfyJd9HG5m
 HDAKvf0bSJxXrrRJ7/fM7zrJIUUaNM9Y0IUDwL4AzXYY8rQQ2DCtNE277CoshRyxWddBPNp
 aPWy06vyJOPMXMr5TMwjA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:YAmcvobl+LI=;H4OwzhY4cJuldTIejZzyAvDLClG
 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
 FT

Hi

kernel build / boot test on x86_64.

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
