Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2FC2E540C
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 19:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752002689; cv=none; b=sK7V10uWLF+CaFQ9FlRH1CFmY7VC4/Tzu/2Zjb3uA5j1w4UiC/SRve10Klm4jv9YWRPR4VQV+yWpMghqbG7ZysZ8y5bZmhZrNeXMozAeQjQyUkXPuQN5w/Sq99+pndlyIe1/+up/1lleOsvA1i/U4u2uf5RSGqhoSaExJ5uD+GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752002689; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PpLrnb0JSIqJTbBvZnv+XUivX5Ji0g99CdbcvqS5mG0zy8HqDUPox87zICPbfLJJ1M/owMytAs9bY02DS60f9GNn2co5HpLrtC6hPPfXMTHy8B5FHxxHDLCC3LHlgHhyqNZiPKYLRr49wxZE1uoDpUMgp+O8Xb7g09c2rv/EYZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=khLEBTgg; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="khLEBTgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1752002659; x=1752607459; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=khLEBTggsh4Lj9c0a9l7stPVVB7JyPJP6NwUe+tfgaE3urJI+LpFdBQZDBrRahLY
	 bXzGADQdWM1tAwULzIRWzkTIxzf7NunyxTGZRP5c7yAXFW1r6nsnRRAxZ8vKhY4Qo
	 tQqO4AIMKFa7d5nWx5rC8YAgJ714qv7WdH191Jxg6eOUnXynphR1zP9G5uocakMZ/
	 M1VY5R8HuWk9h6aEETebh6io2B5ebKur4ffyl/mV4RwXltYryjKxkJqfhRsjASok2
	 bz0FS6TYeh+kxbqfjqRenLlYjhZVmyRMJsscXOTwwmPf9apMAKJkdEY81W0P23fR3
	 BgpVgCYw3zODrNJf5A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.35.211]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M1Ycl-1uXJJg0m5L-009CwX; Tue, 08
 Jul 2025 21:24:19 +0200
Message-ID: <f2a6c833-497f-4408-973c-bb594a287431@gmx.de>
Date: Tue, 8 Jul 2025 21:24:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708162236.549307806@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:K4xqnrx6dM8Kt9EMU/hQphjvPSZYFrEF39GIRQeLVvs5Yx9y+kc
 mlwb4UpQdAeV9uWwP7pR0f+U9XbXAYGln5K3zdWqh01pYPYnvYiOq8+PYfYJ1OpUtrCzduZ
 DGnkH/qB1MEf7IPUZmQazocH9jJUqfFlku05gYiUpNrL3iB6CA+ems/pC//jL8ozIudMVtM
 7SdzCIuI1kkQikzrcpq0A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gkedTHXxU5w=;xLUzJ3UkKvgsJTKEgzmCdJBU5rv
 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

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

