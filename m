Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2831E3C81A9
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212659; cv=none; b=JJtD/KzWvfe1dY6kOoaJCLUOABLEe8UMjGqDpNlxu+IDGcW7K0ADyiviPI6uIqItxrTHsz+lxhG25Z/iiNMENyZI9zIm9MbY1qvNFk9hFtu2cqrwUYTxb3dYJVGOAjhUsl655pAnuLlkRrPzo6imL4SeSAO9dFS4+1/+SWMGdmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212659; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epK90UHDvc+bzdA2lrCd7hBEKROlIUOX3lQKg7dqGI7vRaaaFfzWn1kTiVHeVUmBixLoCptOA9MLJUvBa9reQLnSGDpO6RR/ocM/0c75hQpq5GGrnrOtIaRknbnmhR9xLXAfHcc+a/6yEUwTgbR9k7C2bUWRfhdui7G+a1BrNsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=hG/WTO41; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="hG/WTO41"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1784212647; x=1784817447; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hG/WTO41OhYoD2cYcwMOvqqm+r3TiujZ9hYWnH/J5HIEP4kaKDmrtygN1INHh7Xx
	 Qj2LZZCPRttUuHdMETGdK0x1KMzdiYO07BmlNUmxz+8RS21ajff/8dXi1qt7uF1ny
	 bOtwH9hH66EJunZiCsArUGgPeLFTmDtv1a2UfR+MmlEEa5eBqYjzn/pPWiGMNBhw4
	 oSQAD6fLZjxWwKkCj68gGOe4mMiOMKdumjLweCplfhujvH1fBa2DhYHxTA92zfroS
	 CxGgX5wBWuuU+EV1tSMsv4WO/k1Umv2iYF3fWlt8PTcfHIJPVaOeJLCLAz6B4NIfs
	 CvI/92/PrlTyMOoNwA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MowGa-1xNFrl1P9q-00cPch; Thu, 16
 Jul 2026 16:37:27 +0200
Message-ID: <01447a28-78a7-410c-b46c-ef7de6266f29@gmx.de>
Date: Thu, 16 Jul 2026 16:37:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260716133047.772246337@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:OvQlS2D0hQCNrs7pj6SaW+ULEoB7+fQe0KI/QxKKpI2grimP7n/
 SZcfzPR7svwS58iKJIf39aB4PyNsbOR5vC+VuoRDCIYjgI8COV2K/T+J+qWlLsR9w8ZFlgJ
 eZvyN6u1yIvDMnq0MyGhs2Oj+RiyvIWfpPlaM/iyInIWAc2MpaJxIVUgG/Ts503n4M0KWw9
 o+lw+ZdRnvLRWSyiIKA7w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:kcBhRKukgw8=;2c3xGxxJKyBu9+5VnpShvVXz8zb
 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
 208Wa7RHl3fK0fvhj8=

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
