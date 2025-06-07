Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EEC221554
	for <patches@lists.linux.dev>; Sat,  7 Jun 2025 11:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749297050; cv=none; b=aTv6JSD4I+AMqhBRJAtQkn7GlwBq7Nu+7e821PNFmM1xj+rG5vFFLaM4KpNr+4CezjfEEm25FOLVqbE20D6uxgVMwTs08zaA/7cHvokRLkc7p0PN7ys9X606vP19L+C5k9qLMZbiF9wrYGZzGJIcEGd78dKch2jywsSTMgqaMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749297050; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NfoqLLqtZ0vcKtXzEqRijlxNjce3Kc1GenexkExDQctoWeV4AFmiK65f99gQuWU9sSUycOU787XGumS4lTcTjhbeP4cVH2jxFALeloBIXqZg2livqV7+o/ZsoVWgnGRJXHugrVGUm769/3tP9ttnHGVaJ7RWpVRSoQzmC33JVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=ZfBdfdmJ; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="ZfBdfdmJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1749297012; x=1749901812; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=ZfBdfdmJiaaSkvldJcyify+LUjRoKkZ7SLsy4nriapQ4osiyfSlnBsPZM/BJTHQ+
	 VevNz2uFcTlTqa+gfTMY6lmK/CSTYSlxs6WE37VP53rdqnLomH3gCxvkbTPGtKbgz
	 Dj0NqgdwEP6/chqR1NIQUVLvWJEcqPTmDTyo64Ju2Hk8SEBOim5WTeTxHAByouWjP
	 AzF6QIfSx2A1hv2oO93oYH8n35ck0s2OlCnv00vhvQ6IMWDJ9lMIjfH0hQj4d45pv
	 XdWMOz71Pj3xPPzTVvHEBNjfJNRSoL54FfcufTJSAwWMClg8ij+T5gHXyg42obxKQ
	 K69QBXhAL7HWFDFFHw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.40]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N6KUT-1uvLAr0DW5-00vTlc; Sat, 07
 Jun 2025 13:50:12 +0200
Message-ID: <7fb63be6-8c3c-4f8a-8a34-9a6772c7ede5@gmx.de>
Date: Sat, 7 Jun 2025 13:50:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250607100719.711372213@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:J773HgHQekuxhQxkPhTl0XHY3CbtlyMysiOHuVuGA1yqkk+yGkT
 BzD+WZ/m44LXXFyEEI4brXDBTNjav1hDCNri8yGMoPtQSm1hff+hDGe2p9L78FO1oq2fonZ
 ZCWxpmsxGfMyjl31xUAfjL8zCT4niZQvl2bakKLzUGfJryT7f1uTCuqS5Ks1i+R5ZVQoOgT
 MxcgM4mmu/BZDktA5BSBg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:yI0Wr2w2SXI=;humUEjXPbniw2DeaO59veWhA/ag
 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
 UD1VLXOw/+7ys=

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

