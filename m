Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A45A284677
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421228; cv=none; b=XrFK8SeVsV1DSsvbFSeh8wi96thyXZNPUtA0Mdhi1+oGZJocHPbmxQHoCztTmIoUXBKPfdk61Nz8FcNzJUj3SOi5fLz86Ybrt2e2PddYW6sAxGEe3OFpgsEze3WIi42eB/mQgwRyJanhdn7IJpsSYWKIxhEBYe6mMcOitafOt8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421228; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ldAbkTLOVP9ZVIjYh/+bdHxf1XF/ZpaI3iuGC+pvC4JNCYdp5IHrxiYX4Up0yqpvmUd/uy4IkfrYcYnQK7EPviKfxW0/a9Yw26SKne2XllgLCC+34bfXbiPM+k54GlGTqJ/o9QGcBg+jnRN/F2UngW4ikGjEgmUvQmcAp0lKCcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=lbDO9Ppy; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="lbDO9Ppy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1745421198; x=1746025998; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=lbDO9PpyCw6/XeT9fWfYSItoms/7171/GwSyf+9r9JTpdLcL835dIdo11X1AaWZk
	 g2qFKsqiVXB1JU2v7foI7CHNXeZ1qp3h8Z7DPU1wozbfu8s8Rc8FAJ1vFOrE0HPhx
	 u4pOp+QuQTUKsQpmeABXbjF8VJCO++5nB59Yi/0DQv9sUONmjBwydJGsBOP7H/2st
	 TM4FZDuxO8v30/s75Tx5Nmw4Ino5bBdv+QTPXtOa/LKvSP2S72+XdiWxpdiiOd2JZ
	 o78tuNiDx7RbRCGiL0VXp5IL4j4zMqtgcxBQe75Cc4pKU3TJw8+7bASs/7A7UCgYD
	 hst4Tdjl1o/ySdGtSQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.99]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MbRfv-1ueTYt12hV-00mmrz; Wed, 23
 Apr 2025 17:13:18 +0200
Message-ID: <f5ee9a3f-8534-46df-873c-073f61a68fed@gmx.de>
Date: Wed, 23 Apr 2025 17:13:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250423142620.525425242@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:aqrLckR4uCwlgh6/JEaYQP0FOJLWHt9SZpk3kTxgPRM8y2T0w2r
 lXA+NkLgiXy4ilB7vHJiDnef6cDXvCkC4Jl+dgG/rLrUgk/IyE3z1YNog5KmLOBVvyJdakn
 To13MbRmgSXgVg0TU2dK0jWmMWxAhtX+mEA9KUUNytPEgXXGFHzM9Yqq+qGZ8afPgHhxhh6
 KwTMV1jD1IbsYuxGJqJsw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ImHXXAdgq8g=;t1oBT8mUFMrEy2aeGi+oO3fQRWJ
 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
 50KdhfiJXQ==

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

