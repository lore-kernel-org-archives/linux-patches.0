Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B953AE70B
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 16:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772037203; cv=none; b=SsVY7o6lchYRG7P+jzPE/kfp8ytC+dNDpuGslH2gBUiyat1IRfXZaLDqDamU9uoFcMvKuRsXX2HxTapGfUREl7v33ZYIG/21bfYYA3kDHKLSfLKhg8tRXfzRbDbgv8F1AxNTvgwYZyiAhTxUPU40n1HXA0SRA0N1VEKw9xuv1uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772037203; c=relaxed/simple;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWpvz6QR8PmWn9OHYmu7RCVFzd882sDwjRC/nzaGNEZGC41WTV4xETTC7BXcPo9z3lGGSNLJ3/qHjt/5ONgClacrkrDpLNGkQhhVGd5AxgQe1NoSZmXTghGU5WBdYSoFdSdQ/p/7uYLFn7774WHETYvGrdbmSBg6rBkUkW3I3zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=rHR8wNDt; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="rHR8wNDt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1772037182; x=1772641982; i=rwarsow@gmx.de;
	bh=1R+q0brxT5FCSRMOO/LqKS2K1GLvRDjYnI692aiflvw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=rHR8wNDtYSHmrC6KB4A70ng6H+aL686j8TKWQvdQTpSNbmTOUoCtbYGMMsxonPDC
	 3RZk41fSKE6SNLuZ2+56kL9SYy0TOdOeuxAaNQNH8gBnW1cppWwpdMAbkdOWWtY18
	 DHTOquKlthPw7TgvYCviT7+tKzeKn9en/IgXKoVOFmWMRS+z2tgi59savdX7+rqL5
	 Dwkr96y0Ef/oAwXnmP6bqjyN14YjCIDjmOtJODdHAlu/UL5lV4m/L6pIatTE9gv1w
	 EDUcN/g+G4QoCl+0ymHhxD/1XXqjjvQ2JE1Ca4yPo/9tG0EeuIhu3QNsPUrgxfnQC
	 rxsJ9HTTLva7l1E8mQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MwfWa-1vWlym0rfO-015w3E; Wed, 25
 Feb 2026 17:33:02 +0100
Message-ID: <35369c82-facc-46d4-86c2-a71fc03e299e@gmx.de>
Date: Wed, 25 Feb 2026 17:33:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260225155341.094945851@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:sViRT5XhavO1EfAgJeR8a3SoouCtlir+7u+xsFU+6ElqieEF/7N
 iE991HaL1ev5a66lcIIFFyi3D9XMOnmxKS8/oooA8jedoBF5BUWCn/hfiCUjBit58Y99gCa
 Gn9xYnY7KeIVR2+aW1XcNGufJ6lDF6oBpltbbs1AjbfjPHmAQJGWqeodLv4Wp2GydGNTKsq
 T9tqW8Y6cYsRtnAuoZgDA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JND51rqVtqU=;D+oCAbiBM4hBSR2Hl2B9DEGOiMq
 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

Hi

no regressions here on x86_64 (Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
