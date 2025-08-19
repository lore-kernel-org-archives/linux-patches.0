Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F522FDEC
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 16:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755620644; cv=none; b=JdkeZlqrRsXNVlG3YfCjGueX4lxA4H1b02+HfDW4gSbTg60AXNhicmAw4DjgMEcOg9C4RA/DWXauvztViztI1feXfYdInrUlW+IHyxcZKbL0qE+thLWmNOKBrvBaeE5kpG8jIe/i05LKFJhzLY7igqpD+t36ldGCMwjIWJ9TUSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755620644; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X02f4Uu40Mc9quOxC0d/siT1Im9p6LbLTA9gnb3p9zhDHSZq6LTUCLunLd3loquKZmKRWo4AxugU1DUOeMtOuq2QC7WqVElIIbfZ9anq3d6v4WaKrnsMjX06vlF00fBZlcWrcXEz6NMECrlV6XccL9mm4v1mlh3JcrfgJH9zbJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=GnVunnZQ; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="GnVunnZQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1755620612; x=1756225412; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=GnVunnZQxIbRrJueCETZJLizp5Bvh9bfsS6H6+QPJwPPDuPcnX/C4SXGUiNF+0bM
	 ewc2A7KA0LCFXfVtd2TFReMG0b76bNOR0rO4csjy0TIAVauZ6Oo3nkiCyK/pQ8KeV
	 ioV0uZ8hc/Nhdw+EzwjxUHFfIZynfS9T2pzVwtQjgKcaTpcMx2YK1kgzqADS52eok
	 E+sBzYDUvIaoMCbDt9i7PJaJgtPHrFYmz1yJlaItHV+17H7WuJNUjfuKom0qoetFR
	 B6YHeq3ahlGrC1gJHisjZg0hF8zcU4LiKSkVP7eW+nhzWMyYrrslYXe7O2E2o+ge+
	 faQQW3f+ca/7ZZUYiQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.212]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MWRRT-1v4gpj33lb-00LF7b; Tue, 19
 Aug 2025 18:23:32 +0200
Message-ID: <a5e5d321-cad6-4c6a-b15f-9dad9d25d7b5@gmx.de>
Date: Tue, 19 Aug 2025 18:23:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/564] 6.16.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250819122844.483737955@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250819122844.483737955@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:2E/ySvqgtFn6USIQ/w0Yvwoju0rFo0qOm2KBO7aMmMs8YoB1+iq
 Z+OpTNa8zD395nNaKpQpeDtzjHQS3qhUx7FUHXB2aDEwLraAgTOEH9ff4B0g9X21zjnzSns
 ZfouXYHYWt2yeSJx8bM7skDra8h8wF/ubTsEzihH24T1rRRlxpaBHQmxZMPl1JdLY/d57jn
 6sjFs1stWD9Q79EwJuIPw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:R7rSkzBfnZ8=;PhjUugIoawV3M3lrHtQ13CMraOC
 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
 ZOvLbY5edK73sNO1xjyc60tiQ55yz/rHK/5Zo

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

