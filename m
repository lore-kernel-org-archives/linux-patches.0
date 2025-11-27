Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B78033468C
	for <patches@lists.linux.dev>; Thu, 27 Nov 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764257568; cv=none; b=K+L6Sclqhu6jt/F5aQufCsir8zoPJs5vVAG+Go+6qG5zllxL8CHqKIZsuM7OxUfkHaInd1M1kozIXs7p2v9ZrwnITsBph11sOGsetkqb1W8q6Mmyy/uRYd4+c/KDojIkgm0dT75U2PTrkbOz/WVcAVFN8+mF4pLdtdQRzTRaaDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764257568; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4M8el5Z5aYLf9tiCFtZeX3L9jmfLIBswUL2d95EhHknwhKeaXe8pGG/brfCE4tLSAGs/nEZQzsxshzbE1x+mCgh8fbK1QOS+7GmQOLQqOhlt7O/Suezm3e4H7CAYkDo1QDMVJC7Z5zzf7KcruoG7jebTa/J9PNBId1XJY0D8uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=J+hG2QMW; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="J+hG2QMW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1764257527; x=1764862327; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=J+hG2QMW9dvufikGnktNDp2eHR5Ity55i/73g/dSRLN1zpW525qZfGnbWZ9ixL93
	 Lj2i+oyg8WUhZhN1kIZkGxvCQsvafYhqZbKU46TcWyTzXcIqdaw46y+glj/3Q7r39
	 iDaK73ijuZyzkfAmcDYaV7uSAgkbNneJbFORYNHtim6IudsNiPjjP4Z2z7z5jo7tY
	 KEC0gDy+84FTVWTztO1Ru9iaQZFpnYPF2wSleTKxTim6DLIzSDNQNiPiHQg4Y/Kku
	 ciRhczz9QAm3hi6hL+V4v8FCh8g5c/pr+00gRHHwsJpi0isNmkJHJHlxjrknJwgQ9
	 uNrQpCRXymW2NiDwFg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.252]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mj8qd-1w3lcA2N1B-00hnj8; Thu, 27
 Nov 2025 16:32:07 +0100
Message-ID: <f1c70622-5aab-413b-8e98-ad527d62aad7@gmx.de>
Date: Thu, 27 Nov 2025 16:32:03 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251127150348.216197881@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:sUT9lJb8rfgjxdmcXzQqtcF+436AIWc8+x64BFuUsDM5ohLeal5
 /igAFQgYzdOFbrfpkqU8Jwh7CZWvQpad9Q+At9ZAcPG4TpioR7iuXTAp7p8CAu+HHd6T7GD
 Wp8loeEre2mwPUjir2EI2NdJGKwIQ5cPcwM8zP1+cNjlE99VzidYJwg/0aTp0ivDMBBlzRD
 vKTPyWUAFODSjXakp2fKg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KaGADOwD7fk=;02FW2eEt9yc13B+4L0NjKikoETM
 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
 mn3BUDvwYxT89GU6JQea5Z7SBA=

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

