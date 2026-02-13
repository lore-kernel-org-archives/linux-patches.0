Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03B23EAAD
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 18:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771007237; cv=none; b=W3JRzb8SVgx9+igaUdpg8S/NEmiWshtBWBOoqmW75QN+oGpwBIpa6EH1R+ikL3ZaV3+ReqYwOJZVIqW7i6HMNgxdf6QohEfH+CPc+HI685Pkh7G4ZrMX8LH8PwIECVP1VkVBsuptCwdXzYBzNuNtNc83srgWsH7YOuxnEiOcHM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771007237; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PNKn70veIfxHvo7TAU42zBayfa9GfmuQBVXz5rCXEqAOYyz8+bpcSiyDH5fH2HWDm2EJ4XHRxR9jeMZQxXOt34scjz54wlHQus33Sd+KNorADrk5zzpPfulc8cHJSd9ctysdpFsmO3dtZVTLnut6ASupH3jXGUfRv9RKFj/O14w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=iQjwiILc; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="iQjwiILc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1771007202; x=1771612002; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=iQjwiILcOJ/rJZxx1k+dfaO0fw70TqCSMgxYHNep8Rxq2jbQUFmvOU4AkqnGlJU0
	 7q04cpyBexXCIE70FMko0BDSmkVt0W6qsbRarhtb8FwzXW8Z5br85pfuAE2OlA6Bq
	 StvSeHk/6N9NE5LcGPj/Rvu02bFQX+5k9A9sOu0sySDCxYgziRREOtN1VsF2qDxTt
	 8ucOV8wxAF++WY1o1wAIDsnm3JuDgUsDWi89jeEDNXndjCUTXnWX4UDn05jWLPBpU
	 6U5hmHz7VkdmX6fP+4Cc1AokxDkdfIzN8UgL2pG0mIicgPsL5la1DtL0Nd26anddc
	 0xJPDxtVDasGZShWlw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.226]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MDysm-1vycq60ftk-00E28k; Fri, 13
 Feb 2026 19:26:42 +0100
Message-ID: <9f1f51d2-a880-4f34-83ee-dc48557d4778@gmx.de>
Date: Fri, 13 Feb 2026 19:26:40 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260213134708.885500854@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:i1wlTkCjn9HPfExDv0LqhCV+MdJ7/sjXI80rcztSYBND87VSeaC
 U3uj6Jyptz15K4iNdVUA1mGnIh7hDB/3CQPKZY6nZl9zA3uPSUn5RiQFXV/5IhhH9wP4n67
 sg4iEQSKGZMJT4Cf8mTk2FvAse3FqNgkXbuMSulASWqiHctddLgY+XENpWwBja49kKM/5e/
 9cWLlO1FHOoPMHqti+aaQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:e6FCX3+tdRw=;62OogSegWYggmOIcR5pQXT75c/G
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
