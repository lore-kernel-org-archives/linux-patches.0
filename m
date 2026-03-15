Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5704418DB26;
	Sun, 15 Mar 2026 07:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773558729; cv=none; b=jY8CKZ2AfL1Bx82brGFrh6ho4vy4TXTx1jKCK6bLPTajHZytptSp+1yadrLHZY0nfCod2gaENl7bPH2Qgzb5P33iPcAFBHZxMkjsvrMqU8mgq1Xvy7IXgS3wBt6/xqaiuBucMrBFOi1Bpa/vSRDHsN5dwpUzA8KTndoatkzK1WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773558729; c=relaxed/simple;
	bh=GY0u/0y3A0/CpFA31WvFHoDmDexyHnDMsKmxW1rS1Qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qagDPeAgSC7Zow2CXiA/rekEytAZqeA/1kHJrlR1YVF6aYb9kqIMM1vRiYh/oOCUneuyl74/F9RRCOoNFIZLNNp42cpvV+lj9eaCq8k+qvYdq0MlClXLZp//XDPrbivMNQ7Xh3Yyf4KgNjujmPnB+AzSiswanlJxr56E2TjIlVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+ih2s83; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+ih2s83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ED3C4CEF7;
	Sun, 15 Mar 2026 07:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773558729;
	bh=GY0u/0y3A0/CpFA31WvFHoDmDexyHnDMsKmxW1rS1Qk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b+ih2s83vNbn1bNcXcFbPXGw7uXGmWeocItBOTNm5m7/5cT9uamOOKsm61xAGC+MB
	 LGAF+H4dpcOZxKGkcqwqrlUkpWKgjxbO4gWzj9s2f8nZ68hEkq2ab6ZQaVEcufYmEV
	 zq4lKz1u/tBUYyBAkm/5v94QV60DLEFVgHqJp37lz22CkqaU6BtDxeOe1yDpI+1OK1
	 FjHpVSUe5tW3g2kxAMxNz/GEf7hhbaOaW93uQruXcPVEEU86UDjJ+DJgtEPlHmXvqO
	 xLhHX8ZcJ6ZI/3V8B1qLyjTlOa9vfHMVUvvaU1BM5jsBNUQn5FjLHRyK3PfaC1fE18
	 ubhM1fLIisgRg==
Date: Sun, 15 Mar 2026 03:12:07 -0400
From: Sasha Levin <sashal@kernel.org>
To: Marco Mattiolo <marco.mattiolo@hotmail.it>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
Message-ID: <abZbx38s46vBQSJT@laps>
References: <20260302160918.2520730-1-sashal@kernel.org>
 <DB8P189MB0854A0B206B632B12F15441FE642A@DB8P189MB0854.EURP189.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <DB8P189MB0854A0B206B632B12F15441FE642A@DB8P189MB0854.EURP189.PROD.OUTLOOK.COM>

On Sat, Mar 14, 2026 at 07:56:41AM +0100, Marco Mattiolo wrote:
>Hi,
>could you please double-check commit a7037c3eb013 in the 6.12 branch?
>
>AFAICT it is different from the mainline commit ad33ee060be4 it
>should be backporting and it doesn't match its own commit's message.
>I mean, it modifies stanza "vreg_l12a_1p8" rather than the intended
>"vreg_l14a_1p88".
>
>Issue was recognized while investigating another issue in 6.12.75 [1].
>
>[1] [1]https://salsa.debian.org/Mobian-team/devices/kernels/qcom-linux/-/issues/
>43

I see what you mean. Looks like the wrong place in the code was patched on
backport.

I'll queue up reverts for <=6.12 trees.

-- 
Thanks,
Sasha
