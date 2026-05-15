Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510A13DA7C5
	for <patches@lists.linux.dev>; Fri, 15 May 2026 17:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778865979; cv=none; b=Jv8cW5fdMPrO62kdbChP0TTOAzklsSynz3QL1mBFrVypIZ2w07S6rUQEbnfCE381j18MKrXjOnhIA1uJx3VGE1Zqr2pLCq/lXQMNXPV0dM23Qc4MkLMm7DMoTNIHCQMMAMhNuKZWhSynYGt0DxHommRptGDJKNr3Fqkse+DnDSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778865979; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpaB+PNzKNvIrnFSc9vdy+sJZ7E5FNvIsSeELHkzqWHAaGp0VzlvGSIDeNdFloBwRqcGlM00CeOu/FX515oOmRLkWuctT6xdua+IHcMgHEk6+JwjAedsGr86UgGks6I81vqXHyCWCF3VrpYW1rLtU5XeZESDHTDBREO/jV+SSss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=KfEFM//2; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="KfEFM//2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1778865975; x=1779470775; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KfEFM//2iMm2jFi5/oxyReBdmPXdl1MSkE8mi8UF0V8z1gFg/s5EA12zF5vmYDof
	 meRcisgZXrAr6TGBDasGXHsoA02Rqo2HPaRPL/tG4I1QuuBhtRrsYOBfkOrSktSAO
	 +1SDi7WthWosLX9nRwDNBJhoW9fxiNzgU3IEItBfhcdEEBSWnoCubIsbcqATwOxQ8
	 obuopxWhY+44V0z7WLDb+NWUfdpjb8tlWuEqH+SUFRg6gFwrz3W4SZpwuCsYD+TH0
	 FbBt8/RwMyC0NzeQwJbkPfQ+M2kBlWL9lz147zrSyNbYFpVdk+F/CdnoIDpCh5LI1
	 K2u+Go2xZqNFUaqlGg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MxDp4-1xLOdr2Jq4-017erD; Fri, 15
 May 2026 19:26:15 +0200
Message-ID: <bd7d7066-d913-40c9-b4f5-baa7972932fe@gmx.de>
Date: Fri, 15 May 2026 19:26:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/201] 7.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260515154658.538039039@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:SaoI99PPJbtV+tiXwsvk67Ya6awe8kde0xJFurCgG5HwYGF2m+B
 Vjt4BVpC6bGlBszY/P9IjQkvRPZhs83lAY5Q3tyE6/0APwAx1AVCuFsjtqOlQBIxRXs0BFu
 Bj4muLQ1s3+zp8XOqqp0FzZ/oqQc+ufp9cqN5WTjx6abzTqz+wMrh3sv/uzWCHFMTkqDHql
 J3Mm1GCQI6l80RXFMDXGQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8XczuTdnbXM=;/JdrpFrGzJgD3xUkmPxZt1+qJWG
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
