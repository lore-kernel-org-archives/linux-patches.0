Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECDB28F93B
	for <patches@lists.linux.dev>; Wed,  7 May 2025 20:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746651530; cv=none; b=nqP1blUF5mEDvRZNPw35lntL8+q6g8J4MH0aKJV6Gs/grV/R7oPOns8Csx9V2Gbulf7LxiexJBxY++srYoLLMoSA3dvgXq3HBbb4lc4ZmcJYv1pX8P/iBvPSPAlG5Nh+9nZqO1Gzgx8/3MCFtRSUCYIuGnYSLE2fIMxLwrEvSuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746651530; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=caOQZgrDpCXV140lx54E68lt9ikJNzJVOKIVt6Ipbe4sq35FUmvpWEcftruz7B/4OyUXpmkXFfNFgsJ7L+tpnjGDAuGuP0nq5hI6kotx1vPZpr+YBEic01g4URz1wZM0s0nE0Et9VDdOQMWE4tPUNzgeVcBY9M1X7CHdMxqjyNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=WuuGgEbx; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="WuuGgEbx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1746651496; x=1747256296; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=WuuGgEbxK6eW47+i4u9bdSVdWyPdfMmMgY900vSNdsu/LeG/qJH2/85qP/MiC2v2
	 KlE6EaxjYMF0huVxFgieAjk7mdgSlR5Uvh9YuIdbs893FjCi+W5ZcmdRUYQr9M8T3
	 OseLgonYwEdwTIZZAtFT7x/byrzCJGuPYzswXXhXrDtcqfxLaD+1ar4cUeLVnvkwy
	 vFq04TPxfhOOSWboYtsujX+bMweooZcZ7Dl7DHyButCKwJVhoGlSnSSCK7LV+8keT
	 SFnNzRg1U2UV77LRgnzEppTRheBjNV/+FgpTHBkDkwlDzMTTcOOrcQj9J07ty2C+Y
	 Tzmm8dSJQNDG5jb0OQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.53]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MYvY2-1uYkfY0bWS-00VQGH; Wed, 07
 May 2025 22:58:16 +0200
Message-ID: <b1f3a530-e409-44a6-afcd-94810bffc347@gmx.de>
Date: Wed, 7 May 2025 22:58:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250507183824.682671926@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:1C2B/l1POeCqXlGcOcZ6PspWZE1x5i37JhwY4B6QEOMA0Msd1ru
 seVOLvWt/dZA3rYPcc56MAVhQ+9R/epVwwMua8gRDvodSzt815QUS60cJ/A7XiXxIPR5vJ7
 2zvOnOYsXTuqHagyp1YI5ZQU66LQeEm2JU89/snhieEbu9b/Oka0OhXg82DldxbcCk/G8kK
 6Qt1bc5QBo0CQSQkIWb7w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cBXX96OWt3I=;WIbHqEggykxn1cSdRIPHCVv6k7c
 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

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
