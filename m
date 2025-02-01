Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [149.56.97.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B928D1EB2E
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 13:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=149.56.97.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738415968; cv=none; b=OivblI49ZRi+OajZsF7twlJQv6s1hYd9AD7wm76kOY5mITu2LBey8Lnf8KUt/0ESA9QBSR1T+Hhx39bEIriwbuq8vt9jgGY9jd+gvSNDbKFrVMM/KT4nsAOjulQjQrljtY70FHAKi7Ws9mizEYfQv2PrW0ZajJ3E1MGAw6SfHMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738415968; c=relaxed/simple;
	bh=zS/5Ci1eFBdrFOgAjh5ugHowWx8ek2XDTISF9JHtRDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D/lKDhqvrQe5Ioss86K4CdagJhq/BLH3YBSxdw2EsO8fT6cEtaUKfA/OyckpxtqjkHyT658yR/8Mbyx/Bh7KizKQYmahkdr7IDl6u25bLpTGrpl91A4itVJTIAcajzlFYvzAekTCSVB1KIZuatV7vIVEWsaq8B4tx9F1MItW4aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io; spf=pass smtp.mailfrom=aosc.io; dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b=mxUbyPNU; arc=none smtp.client-ip=149.56.97.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aosc.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aosc.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aosc.io header.i=@aosc.io header.b="mxUbyPNU"
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay1.mymailcheap.com (Postfix) with ESMTPS id C00063E92F;
	Sat,  1 Feb 2025 13:19:24 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 7334940099;
	Sat,  1 Feb 2025 13:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1738415963; bh=zS/5Ci1eFBdrFOgAjh5ugHowWx8ek2XDTISF9JHtRDs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mxUbyPNUuqqHJ/NyrU81sXDeBqad27xu/XwQg1fLhCfjhpzFmkWU6WKomUO5G8quY
	 2clEqiae4nJMFAk/7DL8q4ay3BY3DYE/kNrrRVu7infryoPv91RDXkUlDXjDR78X0i
	 sYvmKggUqJSto11Dx9VjCCJcidQcEL+j8fdb3gVA=
Received: from [198.18.0.1] (unknown [58.32.25.108])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id A4D3B4016D;
	Sat,  1 Feb 2025 13:19:08 +0000 (UTC)
Message-ID: <4df8733f-b124-44d2-b6be-9a9afbcff063@aosc.io>
Date: Sat, 1 Feb 2025 21:19:02 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Thunderbird Daily
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130144136.126780286@linuxfoundation.org>
Content-Language: en-US
From: Kexy Biscuit <kexybiscuit@aosc.io>
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7334940099
X-Rspamd-Server: nf2.mymailcheap.com
X-Spamd-Result: default: False [1.41 / 10.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_ONE(0.00)[1];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	SPFBL_URIBL_EMAIL_FAIL(0.00)[kexybiscuit.aosc.io:server fail];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,linux-foundation.org,roeck-us.net,kernel.org,kernelci.org,lists.linaro.org,denx.de,nvidia.com,gmail.com,sladewatkins.net,gmx.de,microsoft.com];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com,gmx.de];
	TO_DN_SOME(0.00)[]
X-Rspamd-Action: no action

On 1/30/2025 10:41 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:41:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.12-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Building passed on amd64, arm64, loongarch64, mips64el, ppc64el, and 
riscv64. Smoke testing passed on 3 amd64, 2 arm64, and 2 loongarch64 
test systems.

Tested-by: Kexy Biscuit <kexybiscuit@aosc.io>

https://github.com/AOSC-Dev/aosc-os-abbs/pull/9524
-- 
Best Regards,
Kexy Biscuit
