Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C73B0AE9
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236463; cv=none; b=fllSMV5AKA9LLbhh7sG+Pvd2XWD9Kj+xs3o58EE/bSP/iDJ9GKYoQ4wIQHRz8ALwsv209eHGjiK9sdrlAW9q5ytgDuPDZ7DJoSzWRKOYfeAdBI/sfggMmenszDOI6NRd7A9kyHoLMYoMUPVjCBUqpxd4RfcCerKR537jzqSW/hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236463; c=relaxed/simple;
	bh=zA711oX0ET3D0sK9sLm0XigEYQE1bQOhStZUxrik4Dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VsKIc3MNd1xu3ert8MAhMrPYXbAFf/+pzu6R6N6bKRL8H3u+C7y0Lr+uWoWA+gKWta/EOqOncHIPJs3OErEQU6g9QC3ey9qjeIiJD7qCdtjUsWc66Xgnhs9ns4GdrnkNOPHYzNDmvTvvhOaRd7ausENWkrLDufhhcxU00UKa+xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=ZTACFnct; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tE1iDEQa; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="ZTACFnct";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tE1iDEQa"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id 6F31A1D00060;
	Sat, 12 Sep 2026 14:07:39 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Sat, 12 Sep 2026 14:07:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789236459;
	 x=1789322859; bh=7gIQihy6tyE+Q+xCQxRWgrIZXoNFX+R2j3iieKJ0g8c=; b=
	ZTACFnctjLSK4l3PszRsEoCtFQ08q9TjyvL3177Hny5Sttu6fvHMpBbHk01wPlzH
	BptFiYv+o4OFykJKXCntz7L18mplNzcT6usokcBv2EgZezVPofGgzpArRVcNSB3F
	8QQQoXTmOehCuiSzsTS7/Do9r793YHGlHiNiOH8RBo1sO1QDyQbOM0D79byFUP4k
	pMJhH+GF4BLz7uQrxiDiJfEMo6ZzS0/alOKbwhF7Sj/Zl9ud1rqqHHZv82eMaAEY
	+csQu7v9WWoF9Vdj8Akv1oYbeaigyJNciU3oRMu45Es7CyaIP8IzaCzSu2KKkYgO
	PUojxDW1A/Wt0/GadY8D/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789236459; x=
	1789322859; bh=7gIQihy6tyE+Q+xCQxRWgrIZXoNFX+R2j3iieKJ0g8c=; b=t
	E1iDEQaSILlld2eMjUDMaob1NS7qQaHr9byrnDb9ju5lPfAoqbdXI2ZDFIpBb30h
	KiiqkXOXSV3EWhIXzhZrmOybYvcqp+64Di5M5EN5EaQR3ShKgF/Sw5aRHYv5NQuZ
	p98tX2YbJKbazBqFkycY5jm8UdMfUSq2PytUo9SS1fsRseyHJRsDWvb7IR8CQv6w
	vRpsafX7A2CDyZjLXXoa+6XXqNyOYPrwr3apOlup9E9F6H/nyOcbnD6zbyOaTPIL
	IcVcjIKl+vQ6Trhqn8tKJChkhNWt2ncAwUHiZWiiiShNcVwnUqfKGlP1dM1qPNgF
	mYfuUtCPqZ5iziThz3SoA==
X-ME-Sender: <xms:6pSlarR43I_4z4bD_kVTTC39pM39mLoYY8jbeAsBAS0euLwzemYKkQ>
    <xme:6pSlaoprRI_As9ZEJIke7f_6tUwsbzUaFB3UehQXM_T_WcolnlSdwxjnEAKwoQboI
    O-dbI-_UJzzIdsFJUX5yDvwOb_bg4_3QxNKjCd7Fw1Sz1GpvfuYPg>
X-ME-Received: <xmr:6pSlasWsC1Hlp2s3yLStBnRHRmrRsM0Oxc_qbLOzoYKI-TsS-XwdSBGcJ3PMzSr1mnoSWNYIsr8XvifX1f6x_wZ_E3QvQTuj>
X-ME-Proxy-Cause: dmFkZTEfZw3tp7pu28EdwD/ARQ1pPl7y9MJlS0o/SlSVRbBdiMwpuY069Fd9ErgcgNHBYt
    6vqoSl5CuFA6UFL0Wt8GYnJ1XNE22wAMP24P1PkVjMsvVeIjcVhTCaSlWey50j+fdCNhJ1
    LToD5plm2vg2gEiwDbbWMu+f8asbkQfOx08CCHCvtS8xpS8PlrpuSgDPAZHpQZVch7e84K
    DVlnG7rHP/rdIc15sQLybBxnD4zV65mUz3xPjLbgSivyLYEl/yKHAhwM51HwBvKqUjswXK
    0LMRhH4RCWwFfKFaHf9D+gMLNhfXULUeqUFQ1o0CcJ/uQtSedboNeobqqqg/KvAqQ+Ugak
    8qEA9A8tYQYRJZrksCaI24FGdvo0QYsZ5L3x/aJ2Gx5oFPsyvoRr6LeHz9sTBsVjeWRxqP
    YiXp44oOj5TlSVRepCDdY5j9alYKC299iC/0H6qXD++biovFnP0UQxUMSsjoUHgaeefwsn
    IBF214wJeXcdqZIY8/dgg0q/J4iSX5nKgw5TIuzggK3z7WjKll2KczYKquIhE+a02oQTZa
    cAq3an2jZX0Fg7Gg5wSp2xI8WMkVA9+STpvY9iD+qxOJs4iJGJm6e41am8+lMeq/aSxqzk
    ueQhgfSlI/gK/BG/fZf7FU93lmZpWI/xmr+avZWb7REgTo0kbSMQut5CmixA
X-ME-Proxy: <xmx:6pSlau93QG5lt8v9PdlR9BjSUyADhq2uVTBgBxqU2p0EQsPZGsaC-Q>
    <xmx:6pSlasaD8yqZpO6pwqR8idYy87RfuSSjil5BzAyNeB51Aex_kb5p-w>
    <xmx:6pSlaueV9gCREZztRXSAXUws-ZZ3PJdkuev6Orqzc9crfJdJ685xzg>
    <xmx:6pSlaup-aYBvyagatdQMUptptDeLacx_0ujwObhL7oRy7og4fuHlWg>
    <xmx:65Slaq75Lgr1sRPCydUckoxuNJKZy1k6VzuwuI5QX3er8bz_-9AUmLqG>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 12 Sep 2026 14:07:35 -0400 (EDT)
Message-ID: <78328020-83f9-4a4b-b7db-892ed028b7ba@pobox.com>
Date: Sat, 12 Sep 2026 11:07:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/935] 5.15.221-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065526.833703348@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 11:50 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.221 release.
> There are 935 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.221-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
