Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B94328271
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764782623; cv=none; b=SKGSp+1izkYlXu+WwqKGqPkg7TW2EZiT+Ig2vgvxc1hRnNFx15EmXtEpcgJp3kjY/qUNxATi77RTVV0soI4LRCJnIUS7oCCmBaLEDKivHb+oY0nKDW7DsWEeHLgwnMM2cdAthg2fn/xiw++3t6Ufd53B9s7m63FJtRfpCw6u2IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764782623; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k/VV06mj+mmUXUpBybsSDmE2gwPSV2qNBx5Mi1yuSTbD4l4bKQzuYgYDXeVU5FsqGMWwAVkjapPMAyDlWOY47jDdLyvgVeGXmnF0Cws3I9/M1e4ofeBgi9BN0Eh72DoUTMgrVA61DujKs3Xt7BhkyqwbSd1tK6wziDCxFGSU2pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=BbttHD+S; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="BbttHD+S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1764782595; x=1765387395; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=BbttHD+SzTUlCQvijr8l5OA43kIMtX4kBpiCJ9AZDcfGjp+86fhlqXfFurCOrNIT
	 A/uyX1DMDobhxw695rqFFAN3hjopVlLdh5RzlrXOyBVV9u/wbyBE8PgVmifOTQLQO
	 ODQqR0v1DDXEZ2RJ7abo1vCN5epmnUHomryYMFp2qH1D8tdyMTt3GZA7RQNxXVEkh
	 o9+jKaYSMQsTQjcdfxcsI5WSXkNQWV4kxz78/8+G/GYfJ2AfIRQe93EFnqbUrDInz
	 fR4AisAaoy7N3URUupNi2t42gKvej1E0wP79G0a/B3RTi7L4AtAj4GCcOnglNYK3w
	 aJ/ualqKRQIVnGA6/A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.102]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MVvL5-1vavLT3iBZ-00K80J; Wed, 03
 Dec 2025 18:23:14 +0100
Message-ID: <f967a21a-51c7-4323-b756-74cfe17f2e5b@gmx.de>
Date: Wed, 3 Dec 2025 18:23:13 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251203152346.456176474@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:5gFntKjCAm5AFjzvQZqAKROKHmpdL4v5ZX5GCN4WwXLUO/Q8PYJ
 5rxUdSVHlxvG181GWt7C/XVrtUR5RYWi7Yuzf3JLhmhsLOlWznrSQq9pnY0lFN8pGI6Sf+S
 4OT0E0+2rYYHN2uuw16e2jIegb2P6rGH3/GuKXmg2p4b9W27to3LrJwC3DCDPXczlXc3yp7
 bo7BHNvbseCHRUMrxqq0w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:OXcFGMC2VoU=;rTX9KBWXO5zw7vP56nowS8dAVKD
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
