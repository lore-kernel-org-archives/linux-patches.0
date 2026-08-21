Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84C240682C
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 05:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787291559; cv=none; b=MARVZ+/ZqwHr+Xh745tNiCQEH8rCzfPpZlRexDW534o6e94jJY9a59Sq/JDqWAB+QhfdKtBz/AVxi888Q9CS2WIWG6E+vSzNUVHJRnPwBCNTDqSF+uFQ+agOzCRdoVqlY7oaeboJzz5nk3XxnMPgS5zwyJ4rvszTr77wP8EgacA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787291559; c=relaxed/simple;
	bh=p03pntsf5Yn3vU34Sxg2xig9+dnR4rWUWpM3lUj908E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=chZAK1VHhihvHFd2UxJr6Fra6Ru+7QhxeuiKyDH7GRF+shU19sj5uAixxpIEiT0l+R+ouW3aChct1HqkqTgGf6akXRNOLlZe5eXioU9pDyPhAqxin7MD9/kPytVKcx6SFAQpOjJbMgg1U96M6qxLdq4FDvcxDUE+7p5xOVxmt7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=Ar0km3C7; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RaNknMNh; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="Ar0km3C7";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RaNknMNh"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 25E8D140014F;
	Fri, 21 Aug 2026 01:52:37 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-01.internal (MEProxy); Fri, 21 Aug 2026 01:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787291557;
	 x=1787377957; bh=WJApWt+xdmeag3C1GGyyGw8pjeIetWGoIwzVgJ8twls=; b=
	Ar0km3C7K3o2qqdKM2Qbi++jM2EAbzoPWlEc3BrArEEA48ARUq894ug+kiAcbj8V
	7PH9pF9hJ7J6eUwKRC1W63lSqEGDe3U2+H29zthekrQxlLBYgrJaBA8/OidULW4U
	nIZ8o3XszkueVWRpNun/eSPfnJ+QQvEYM3/R+Arav3H+PKa9QJ1r7SelJpM6I3fu
	ji0oaROFigwQqtz1VFE0LcFAfOaXDCguabOExuzWrjupJJOcUwg8MPVdyRt8H0lB
	tgfJxa/Mfc3oe7XbeGtL7oKxnGCgtvOnvH1R49eOZlddR9YgoOugyyt5FnNXdRI0
	h/z0bQvXiRwQRaXsoS3Uog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787291557; x=
	1787377957; bh=WJApWt+xdmeag3C1GGyyGw8pjeIetWGoIwzVgJ8twls=; b=R
	aNknMNhljsHc1rmsphk+XfhURNtiQOK0gyF/N9llVqLrttGkQoRRVroPwYt/lxFH
	Hg74N/1RYXik9ZLJySxoTjGNdPR96gZCHT/jKFEerpC5jEsrkSw4vymBeAJVAEL4
	dI4zwdWUUZ0pKbyyTsr6LxPQ2zwxCTsJQd0yRjOkxrFMmAMJg1N00nE6IUpnpPhW
	OmTTq6b5OKX69tfRngyneXE/EkVZtT5Zr8UNrWPeScBBxalYNcRjT9I8KswTWzmb
	ZcMiKsSDZqoY0VCc1Penjech/jAMadNxtRhaEMfIg36M4t3asAC7QkcsjHasfYjq
	VB86mxo//jd8vHmnxnVPw==
X-ME-Sender: <xms:pOeHarx_RKFImdJFwPr5iF5L8L87PhBo_vkj8z1ovZcai_8mP1OEdw>
    <xme:pOeHavKZQNogG5YKtkJ2_0ZhKtNrZwyQZGdn42b9LTgeFzyKUiwtJcsjNFWSvSswy
    rlfr3M-5cnhEiN0wqa-_-h0tGRjTR_rZtKW0whQYdfHRGdFcQBOXu8_>
X-ME-Received: <xmr:pOeHag3f_Mdzet3G8oDNwrNRjQA7iXYji8eDo2UKyzZB8LSLTnPX0yIZYSY0qUIKKAkxp1z0RSlD3AT0n4kbtSEF90X3W2XQ>
X-ME-Proxy-Cause: dmFkZTEJwTl2HlaHnC+RGiWcL2fTf2rWHYvLYe05An4X0j0CsWVX9Hq3OEensIKbPoEh5A
    GlFugIF7pe+B07O5o76qBQFIUKsWoDdDYZsGeOjata3/vY3nkNhDGEW57mhTzF7he8Ptd8
    xmgkRdJbGuLdAHMWczvl3HpHI8Z5IrzaHGiCom9OSMrb9iyC393ohk1PNumu6OWtLXdUlo
    iuIIgeiUTzj+/iZ6W8AWXUh1oghhx81fqtPFH+QnTjChRsH1H67HnHluNVMgYAmfaYgmau
    nq3cfMyZd3TegTUGWrNY32IRUkgEVH09j7MUHNaFQ+hv7YrjrwUtYJ/7/Jq3pbtSUMvbNx
    YZKqYx7+5g1siq/389xe6KaPAIqGNLY025RIFVBIESqGgSbdBSNVdKj6rNfDMjZqSfCX7J
    zXUbNK267a2bTVNP6HuDrhDxSI6jasKuOqTgknlrunZaK8fcaDElF+pobbLIc14JrP+/AY
    waF2C5Mnp8pk5Bl+vG8NmNxmUdjoKzS5zSHUEavKlaswty6iu2j5aLoXz3zjZwoIfjPybm
    b6g/fCI01nV/wUvf4bCFCpxVzX9MWAGFCSDH2Qbsnb/cLeprnwJ/cMKSnO6CDtQ+slqOsP
    2CvkqQlpHWfWoxmgjsIrDbMAWDt/0uaRvN4d/a9WwmGHkVrzHreZAaoSuWnA
X-ME-Proxy: <xmx:pOeHapeQf5B1DNXeTmQhC7fIaEPIWfT2uv2hdNLAx9STTvvkc3cWGQ>
    <xmx:pOeHak7z19rxndQl46IXZk6qS-MFbguitSqCkl9pVOkdjIF3RZPM0Q>
    <xmx:pOeHas9CzuILWxzqnb5L05VHMm0_-Zka2U5S2rwKwCfR4U7g2zXmNQ>
    <xmx:pOeHarKNdgTbDY-mPtAyjHhcH0z6_5kxDM71h4ntSEngtyT2tNRfZw>
    <xmx:peeHamlkJR7GkxM0zn_8uqcxNwXjVsbJyltMJiIaW-Qfe28fIs85lQAI>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 01:52:34 -0400 (EDT)
Message-ID: <6654ab34-2a60-458c-8a4d-b19ee751f60e@pobox.com>
Date: Thu, 20 Aug 2026 22:52:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/235] 5.10.266-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145216.426568665@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 7:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.266 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.266-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
