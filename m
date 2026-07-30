Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5CD3A641D
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423157; cv=none; b=Up4DHhD7GyRc01ygM623qWo3rDa95Bfvl7JdSkE//hrKuSAXqA8jsk18QGK53vLXH1bCmDvxbP6v4wxR0bSpWnLKGssCHEt+p84+KejVwwvt6k0QveuBPAfjssnMRqX21gipOF3LsY4s273jtnReTkNGsR5j7tLj1yQPNGkxWAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423157; c=relaxed/simple;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TyY/e6wURLJ306auHdAmmp9ywFuWGHFpLQ0IudVBXSohI3bFbffRb74YDH/dMCLautk68gMANEDCJpWFpkySwKS4OfEpMptSCzKjNqJ6sOQz6xUpFWWEvpEUE5sA6w4ODK80HWYkhu4ysYU9pj+DsfIMhcX3DHS3trqWhfTLPEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=kiIN8krR; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="kiIN8krR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1785423149; x=1786027949; i=rwarsow@gmx.de;
	bh=SSebE+ST6hsckt7BsoZWaCrfWED87E2Ve65oZGO3YSg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=kiIN8krR9TSivd8yOS/lzKdXz7f/r99KD9mhgmIkJcV8RhdrptW2qLToClbmWllR
	 4Xj7D4vt++BbXoW4pnr8pOFuLp1wBxp8WOC9Rngk53Xaeh+vsygw0W+YUFW+ympvt
	 53oAnE4XnkVimo9JZ9W38ILLZF7qhB3Hgs15JXY9G3eqfIiKSrO7RL93/5kADoexi
	 BjLV3d9kPtrI4WtQPKCXd9eNiGXftGDJS+GSEu5drA3rtTzJtf9DDZApccsLtUIsn
	 9nxP45IZ4B4i9P6D64BKEzGvGpsC6sI2EOMX6Qqy7iyr2VRnLysXW3/WsUHx15z16
	 AqWWTMlivZ5K9b7LBQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MQe5u-1wckYt2tAU-00TZvV; Thu, 30
 Jul 2026 16:52:29 +0200
Message-ID: <3066cac4-d8ae-451d-9469-a75838a50dbd@gmx.de>
Date: Thu, 30 Jul 2026 16:52:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260730141444.267951807@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:yQPkOwr2ZjE5fsobu6Y+lHkGbW+ALz2OKr/0KGTlPRo06EBBzJQ
 si8WuWV7ej8+vmU6/Rx5IB8ZvNkQxJNVYPDAfGi9S6FJElC4decIORU6ve1Fi7RlYsb7yui
 bSgrlQJGZluYO5YrhXegkijhiiQ07XoXe05HmTlpZMEE9vf6uq116R8nQj9swNDQog18jiN
 TkQKLkO/YHuLH9+TU555A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ejCKGcFerHk=;ZB6mVjNVhJtfJIkhVu8tqplyggT
 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
 cYH8B/HILFPsyi5vNHFRe

Hi

kernel build / boot test on x86_64 (Intel).

No regressions here.

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
