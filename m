Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0BA27A10A
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 07:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751614820; cv=none; b=b3zMvLVvvFjysFJBiU/UlkesXSVAtmuIf7v8oWgj7hTKYu7w0fKTMXJ6LlPU0EfPUtN5XzfjTnJXrTfrqfbaN7pAGBP4emfhWZWKcu6Qr0IH3wM0MGu9lOkAomjohr9GlK3n81OhVUkrex5SHAe8pIkYlsppHqDD9CR1/HuNNS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751614820; c=relaxed/simple;
	bh=CGs0Fff65AzXGYRyDTJF/eX27m/8Ywa1tS1bgNimHW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sCNQ0jfa2bknPxZKD+v1y5nwpuZgpwKKsBPY2STMPlkeqCxWpKuzGtIuMqftlScXgAcBXZlNYAaUu/Mr3dFHXIhyAR1J92n2KZQBkC0LTjJAT2QYO9DOld0jsNROtsp+jRgErPiquKmPt0cGFakk/pKrU1fJ9NdZB+NIyUqsQFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net; spf=pass smtp.mailfrom=hardfalcon.net; dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b=T04H9V2t; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hardfalcon.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=hardfalcon.net header.i=@hardfalcon.net header.b="T04H9V2t"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=hardfalcon.net;
	s=dkim_2024-02-03; t=1751614419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xasny3TaXLihi3Vs7IGinmOfqgdTVwfxsXvQElSYYDk=;
	b=T04H9V2tqxMIYJpDOmqbaDVGdOfruXd5Hg70WPlGnCm09HyK2cduZcsgIVK4QpqwtsR7t4
	r4yfoieN4XVFBTCA==
Message-ID: <fe4e0930-210a-4dcd-a215-9dd8b2613ff3@hardfalcon.net>
Date: Fri, 4 Jul 2025 09:33:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703144004.276210867@linuxfoundation.org>
Content-Language: en-US, de-DE, en-US-large
From: Pascal Ernster <git@hardfalcon.net>
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[2025-07-03 16:38] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiles fine for x86_64 with GCC 15.1.1, and runs fine on various physical Intel machines (Ivy Bridge, Haswell, Kaby Lake, Coffee Lake) and in a Skylake VM.

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
