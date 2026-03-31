Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B6036897F
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977805; cv=none; b=LWGjPPQl4LWI0MNbycRlFeYxr9zV5YjSpse7ker/kf+ISx5xnigwIVRt5yZ38UhDWYfqYAO5SsLMgApB9IquUfzhtYTYxJiC1w8NzZYDJtu+pZakHTaJCMVZBKuXgJg/spj54kLh8hlRnjXht+Umqz9pcyUIlJmO9hTuRgoChkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977805; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DXBM6nN+nVZVzb/wECWl7MpnqiugRz0oeh+ixksLFKaPcpRr9Bv5o64BIhbLik4FEMj1JQTGYW6TWI73hcSAgo7cdkWTTtuz/ziNnZoANyAJec0aiemb9uVSqwCLHYv9fboJ4/976Hbiy+MvocmfucwrqImhoHWVwbx8A+rToGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=IJk5PdDu; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="IJk5PdDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1774977782; x=1775582582; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=IJk5PdDukhiM8ugTD2Kqt/CVeHVLIMt2bGOdURt5Sb7IlYBmkYQ96T6ofPtm6G/m
	 mGR3h176TxQJTZS7NQJiLKpZ5i/xDx0tBsAANJKzLDWh7SgsM77nkJN2TX7G2EkGn
	 oq7Dh3+TT8kKl4A/PpxO64vc93//EcmuSgHwu4GxScEvG8tn/XIs5Rt7M9apsaEaP
	 SY5tkGMHMci2Nk4Sb8rXQZgsHedsb+T38ncaANsi+J3v/ruuyq362k9nH8x5EWizX
	 1VsRzfsX7xS3A5cjZIHzPemHUBu4ucw0lSkd7tvHNosAfEBd2wTz3n1RoBoSLmy+q
	 960SfZbq/ZqeqstwiQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mr9Bu-1vlGbI02Vi-00iXgj; Tue, 31
 Mar 2026 19:23:02 +0200
Message-ID: <a111bf2e-7c4c-4047-86a0-34590fc571ed@gmx.de>
Date: Tue, 31 Mar 2026 19:23:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260331161758.909578033@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:XtmfCsky1woUr/rpelTerwoVMpBQamPQeAL9rXjdEkdMP0KM6O3
 z9A8wC4QElL6On05eBOEa3sE/Nn4mjV5XgAUSMkUeikqDeDF3r/fU4Oyexkc5hrwl+EEi5y
 5JT335LPAdscUNKoCCo5JdAHbpVQC79QWHvELmBhg99pofe034gUhwXPQgRr7ZvmEMaLzSj
 ystMQkdPSzHgUTUVH0W9Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yYZ3xq9H2lo=;WReig8UXA5LDWqMp4LUDW6yanJY
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
