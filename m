Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04312AD3D
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 14:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777039830; cv=none; b=ncjM7u5YyPp1cwJLcL2jf3+ewGh0lMlddC466FuIwUGuYEdc6gKSNFSwayAdc4hiCqwMPOg6lEjth0Jdn/P47T8RWxK3rjuw9Ipjx8cnkGItilMyOfDxHBKG/ZIFIkGHiYs5Ebd+VKm2Up0SzDYjcxhBIyD46a2iGNExnuszN6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777039830; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ho4g27ujpe+0Rbo4eJZoOYaINd/NCikpItUa8Y+LcLfKjGWTPHvIusRpBKD/a05dOpJh0qlPQUiekO6Z2pzGza7dZsP2hPq611TAgGjNpXdo3EQUGOqI+pSkbiAvuvCaQMf8qscd5yAGj1pjrLMZ6rLslqwtjBwEWOxqhziUva0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=L/k49k0x; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="L/k49k0x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1777039792; x=1777644592; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=L/k49k0xGIc7SwIz4OD9ITjWqHXrVrcyQ3kbFXE4ZrrZqpx9Z8gBhcBsVtC+vTO+
	 H96A5ZQz057sMAnuuM9yq8YHK1fCgaNfB8QKgsE5buNAClnFEcVULq7farxXGX6nN
	 7i1sLYUzv0pmLRmqHDT4uoQn5Npz2adMzn9HFfI31940yNFoT61atKkgnv2Jm7e0Y
	 ga2Y9nJHSJYwWvLiRMDehTnVNUt00Sz5j3YZSUNnza7mqCuQUsgOrqnYqiVOSk8nj
	 zrzKGcDL0eszWlv0vlypP9kNuZmf1vwQYNz4kHMoKM2DDhSxnoOWguIhucgovJR9E
	 4nNCxnYPSKlgTbBvQg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MF3DM-1w9cJj3Gno-0032i9; Fri, 24
 Apr 2026 16:09:51 +0200
Message-ID: <8c7f046e-26a9-4967-ae28-59ed07b443cf@gmx.de>
Date: Fri, 24 Apr 2026 16:09:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260424132420.410310336@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:TPf89lKvszaHHWwDjbnic8dRDUJRmj9yUXPKo2F6u9zC4UGRdLX
 l1xdU/jiUt2wQ0PsNYXv098UXma1mjhC4IwmzO+1zNouPREB+wx8/c4hNqpPBW05ujSpQeW
 2GlD7KB/Grltq+/F4GUpOG5FLnUgMO1ku3fzY11GKMbreLBqxwG2CdxEo2S/wneuyHAx9VL
 YqwR2HpKNsPibs1bxdFSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wLBxwWHHwCE=;W5ry1anvnNkn2RkbVHFmTZGqQEc
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
