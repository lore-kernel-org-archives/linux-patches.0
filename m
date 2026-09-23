Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D073AAF62
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790180154; cv=none; b=appGAOq1ib4DSlWvQREbc9s5Upobyo5NIMSMaOsoVskmAoSoE1Ma8OwJi0ufLmQXAn8TNuYpLJc5W6M5poBt/xR4dapMem74jpvcI//x9/aS1t7rj9CXoAz15CoNsSwhG1HqKBsbzREzY804wJXOL2M+Tnsvo8nQtPs/bqbzioQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790180154; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hx+ltP3w5AfwXxOMT7CkF8jJpoVURx4Ud5xNRC0+SC2En1833/zlHt/BfgYFZZRmVmPh0ppIruPZO1F1iA0zUrE8ONERCbVA/jH1hEVusZorzF0McmhO5lgM9QU7d9ZLtF1bzYRZ1DYhKVC5DFgoKatxWe+98ovaZh4il8E1OY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=LY0XQQfm; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="LY0XQQfm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1790180146; x=1790784946; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=LY0XQQfmkwaOyeS74s0KIF3+MVa4blDD+LBD++xxUkuS/drKX5qdMH9/pnK1P985
	 59TLTPb2F9VFdImrFiEDNZJA0QkwGHMRTxkcSODrf2LxQAtWSd+AnPDJNTBE6T4hj
	 yJMo83/qbvkPmVrNX/YKo9o0usJ9TO/Z5Djuw69UqJBYe/gJW/rKiuum8JX8a+Uzj
	 z2on4KZiTcsYFRv44XMDTOhYKmdGhk/vX46yWl4JqIFTLaC5LB4F521OsYbUFWleQ
	 XFsLnhcHdvPx7Qcb3t9mACQqR0325+oafwdYisBFBYSGZwQo5cEoSEeqnORZFkHWq
	 nQTKJRd9X/axBm2Cdg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M59GA-1xAW621Nye-003Oq4; Wed, 23
 Sep 2026 18:15:46 +0200
Message-ID: <0e6bb59e-9c4d-4bdb-af7a-5af627e82220@gmx.de>
Date: Wed, 23 Sep 2026 18:15:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260923140644.756254324@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:m1OQPgehz+9AFHT2XE9OtCBY+ClKoJYyXbRtOdTg0ZPpyjfwiTa
 KEVKTkv2KyuyKKhtGJRjFCOWqYcpd4MespgNHeO9XfSezDERKCTQ0YzPvOQV8Cq0rzuQ/6H
 DKOwECiIt7TljKj33vUUuGEnUUsZXXcuZS3xz4K7OfdQHV1ur3cVNSS6zabnCHcOd5UHE3K
 fO53MPgV9zPhbk6p3spKw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:jbPlqXlw/PM=;1Hf1At+G1rJhfGnaT9oqp6Yp/Yu
 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

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
