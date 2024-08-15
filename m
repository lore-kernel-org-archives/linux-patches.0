Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8D31A00EC
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732917; cv=none; b=c1nK/FGoHb+Dg3FjOEDUaseVqtvws0/ZkAVV3SPFnqNKpnTFygL8SC2EFR/exE2zZfy5nSN2to/n9L5QPwRomWbdZWKmKrKnNy/B3m8F733UouO7gC09dNn/gBaAPyMjSkq0g//41Uq5cn5nOVMp6N8w8Ri8031Mfaj33QVOiac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732917; c=relaxed/simple;
	bh=V1Tmi90Vp6+xVthfYBvn9AgjYVq/QodifRtN0GFYLAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CFkGgUkrMWAbFBIpujW4RtMlDZg89c8FyBakvRimyF4d4yw4jfGLZ33rJxoMBzVar4elkGU+sY8OEgZeHuLQBgjIwhlQOCc6xWL6Xt86T7nnhXPXvWnqb+PXPasWSQhQgIS4cyUQqBv7+DbLpd0GWPFb0SxW8hImoqUEwK92Rxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev; spf=pass smtp.mailfrom=holm.dev; dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b=qOSMXXyI; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=holm.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=holm.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=holm.dev header.i=@holm.dev header.b="qOSMXXyI"
Message-ID: <886dd1f9-82f0-48f3-90bb-684a2e193ed4@holm.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=holm.dev; s=key1;
	t=1723732912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V1Tmi90Vp6+xVthfYBvn9AgjYVq/QodifRtN0GFYLAw=;
	b=qOSMXXyIaKlk62rmLQ7dh/+QRGQyCSs26sQ6hgLNqjYgZ/MYHFTA6j9B+dGjay6c2VciwG
	HxPdbGdATS5qLQcQOX4Z3DzSzBX66iifKRF1XhPIvK0hu7tlerBHIvBkEV5pztHL5OV116
	hmnwTplW3HMcIcocOJ9RLkS+Z1hXm3Vc5mxeo1R6MbdJ72igApAqCPriKk4uytHynfpA2K
	rXnX1HNB47Ie9BJinyiDKhqV+lI/w/BcmDhLu69KLRfyxlMEEjApQf02Becbd6mgKNXHu6
	J6ffIYn2wx1cmkA5jyWtPdjJcP3znEwxuTCO1dtDYKbA8MbZo1sKO7qlQeaQoQ==
Date: Thu, 15 Aug 2024 16:41:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.10 00/22] 6.10.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131831.265729493@linuxfoundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kevin Holm <kevin@holm.dev>
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Works without any new errors or problems on my Setup.

Tested-By: Kevin Holm <kevin@holm.dev>
