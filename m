Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C70E369D7B
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791990421; cv=none; b=AMBxAq2p6V/aod03xkhLG94PMLdJU4zdjdNlNGwsbTxMfBWRExuXgGIeiupgAm/fNqsafGi/NpGHNVwGAzeen/ErK19Aj9ebUjUmyVmdRp3goeC1GQFTA5z4azRjJFSPpmWWH9CuG+TG7+I8TNMZEzZBwF4Y/g8FnQgaWXXEJPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791990421; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gyo1u814/2tWDhNCbp0ZIphbFEPQbvKvp2kayRlgdt7U6d3ikLr86uYHiROh1GKlv74Lnt0ozrORmc2QYyLAMI+XTjDeCjjFHS2SVNjPieW9FTbgi/ObbVYZvyYaxdMpr0sSQfb1fURE2Z+2kjbI2/gGcPyGTTUsKsbfSnAzs/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=HpxTxCR5; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="HpxTxCR5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1791990415; x=1792595215; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=HpxTxCR5iUs0/mZLdS7sfio/2/iBAr10CcvsyM8Oq+8wQl478oZrbBRj5FwYC/Vt
	 Q+4BoolI4ntvC4q5RDVFYTiAgsDvej/wWFt4q/KwTbDVKoHPYKgCAIP6FgvuVY8Or
	 HBmt2nLOgg4gHii8PitI1fMNwBOwmDraXGM0XXo1tiDFJOww17TEWFPRGG/DTl8iX
	 VYgc6lnLY20i7ZIssO9Qo5hL7uWgPgXtxT4SVW40iEhucjB2dp1ye0TV4OhBj66z1
	 y1JaJz8i86zKQIfaIeu+WZei/EE6Tf3uWVSISk9bELEVyE15j3L/bt1e1WmmRN0Kj
	 XqfdF6B+VhefmJP6qg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MPGW7-1x0Hb93LLB-00YcoA; Wed, 14
 Oct 2026 17:06:54 +0200
Message-ID: <5357fbc0-5452-4561-9169-d0d67b034113@gmx.de>
Date: Wed, 14 Oct 2026 17:06:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261014123758.782265692@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lMEzoQ+XrTgoT2QRSEYrc15g1wSmBsyPWlzLJ17zuKSkAfbW7Yx
 nsIA0ufT+snrP0n9puyjRrQVer8u3LYXywgkl8BrotCFkWOF2OHDghgnpjV3wvYJfzJzX4h
 +DvlN9rjCin0kbzTrqW03KFRzKEyC8Ut8dAk93yZx2VWLjtn8+vu0unyQYoz6VLQYbjwepR
 yeQGRB//crRCG5N8aTh1A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:NGw7yHzcltg=;+zx26ycoHh5di+tqveTXdhsaC7e
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
