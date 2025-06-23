Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DE928DB78
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 15:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750691898; cv=none; b=ugKFZLJOagO/uVIEB/yn049pueys7iy5A5DKgpCzXcdN7j0KcEFRQ7cbs4SWGHO6RI+NhDOUIm2EjFFLo+A+QdE5D42PZbd0rERE8vzBopWw1ciW+/opYqnXPck74p2MHD8iWIctRpAA20nAGd51Sjpc3ScaDS2gvCt2X+rNpoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750691898; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EjDfDWwabJgrJ7++t5/JNIC2ErAvp6eu6ehHDnWlOr6fLhDD8uSa101RRRnS4f0BDfcg7eL5fhdMCrwGIjJBFqvW+5Rt8vQXFR0AO22Ej/guS3bqZMPZn1ciMZlEQzZiEQo6rILqahJX/k3SqgZdtOxo3JTuLpCgtPIbfbjsTJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=kPHXiPq0; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="kPHXiPq0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1750691873; x=1751296673; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kPHXiPq0Aw8Ub2+ryb0uEqSS/cFgn4zLAShBaDtMAavdAJBwvyxL7aPjEKIj3bQy
	 XX8l4dKvnMNXWZeC7n6OUupgyYlrREIHhhNFMwL53sheLT9znn8hYAGwhhbAnqvh/
	 wua3SYpvpCvSRFsX0ruUA35Jsl2uWy0nWFy/uaKOT5UH4/NTS7RhRNw36KRWgE9la
	 MdouayfmrixcwNfkVw5/KrOQJEkrHDFt/KFlXtx2q/TTG1IwSPYkAwcWhC+zofrUh
	 uBZ67WVQPn5uAHuQWw4uC4eymPobY/qAaZhnHUTdVKUBucHJY16+d4S0AA6zcfxWw
	 LfTyI00YTF62TaWOmg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.69]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M72oB-1uOUwQ1Cvf-00EgyD; Mon, 23
 Jun 2025 17:17:53 +0200
Message-ID: <619c6c76-3e0b-4a7b-b13a-04b197533ab5@gmx.de>
Date: Mon, 23 Jun 2025 17:17:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130700.210182694@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:OceQxfyLikXVmhr8n3WTThXll0dnKAketK4BUIygzNM0uNZta03
 G5QaUra037uksVwe+mVk5ZxHVyAr7KGd7HrHw2jS3td7DoMhbLXGlMjzvBwxx4zbaqWgt6V
 j+th0kI1gn4e8kdeRQ0snpJ4lTVNXmnA/HSwmtZnUMD4JhKo0R0UR+pqh0VdQxmqFD9VzLg
 1UA5H7G7kaehv2R+r/1kw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:h8vPtYSV6UE=;XcB6KgcEZfbU33+3XKe7+a3FeDB
 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

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

