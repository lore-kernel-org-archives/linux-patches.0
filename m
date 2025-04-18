Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FC71D6AA
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744985822; cv=none; b=fzQl1biKfaVz7BdoDdGc1QKXBMQvth44zwI8HktsR2FDYzq56tnSetqVPB7DrX4pCJeedxi6fMnIH1l5+KssvTD9QKdv3nlsZ0X/RHrGS7gt4NdxvTLJ5/TfMlWVSXDQhkCN+02dXYq//MEK1j04uc+IPXjcKfFoKnhJQ+eBLS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744985822; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUZB777CLI8SFymjuHOq2lEuMIEzThmMxqXLboabDzHlBn8qOqbmPf9N+vnW/43zmgFZ7Leu35/Y5lZFZJFwFiOvTgEjRsG14IfToTTkXMxoL72I1tWzfukreP8U5cJ3z0dcHb3LqPme3ih8NBw9zGI2rCPQaWjTdwAOOqd59Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=oiT4VktU; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="oiT4VktU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1744985804; x=1745590604; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=oiT4VktUKC7oWyadd4ac/FNF+7MAuJWP4NNqmJUnbTz2kOvPE8k7tynNEL0qXwOT
	 CgEznyp7bjVYYamz5h6FkKhwGV3+TTWErX4uxAGF59elPdksUSlcyZtRlEQNX0gHw
	 9hcxrSj+4QoliFdP+ouM177mERJvBBExLenvB2NYoPySrP0GYBw+YPH23IULCBU1E
	 tD9xVEdiSVWKCKfXZs4iA7Z1w+6PGAxP1EO8POQ/lGyj1Jvvri5LriXMuU7TMtNb+
	 W03Ytmy9w7cRxeYOu5yNL1JxNKsm7He3RbNP+Mzy+9c5KxTBQ/9+ZyK3so+fOuToq
	 ME0L63a0wXAjEV3FSA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.195]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MzyuS-1v1ZXe143K-013Xbt; Fri, 18
 Apr 2025 16:16:44 +0200
Message-ID: <a8cd4c41-806f-4fff-ab7e-7a2c85c0c869@gmx.de>
Date: Fri, 18 Apr 2025 16:16:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/447] 6.14.3-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250418110423.925580973@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250418110423.925580973@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lRHOK4iF1zcl57vCz3gBhjRXD159mwQJ8f5PMqsuRhFsmA8mu5e
 eLLz4WNCBOXIbb4pAGI2pFr2xB5stL0yQaoFk2J0AgmjH/JZx7ROTr2ks7cumRPOgmyWoX1
 lGMib0KqVvzO9yZsLZ/cT9APa4AlsWZdRAVxNtry9EeCvlMV08LXYMAoF8fryqiGeUBVKBl
 nugYVG0jJk7Wowu41q8cg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KZ9Xx9UhwTE=;bx5Hy7GXgzzIQig/aUvmZoxMfJ+
 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
 +4+wTb2PEA==

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

