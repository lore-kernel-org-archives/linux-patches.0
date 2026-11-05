Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793848124;
	b=AmHAp8UBgdpgxQSxtRo4lRBuRmIg5Tjl6BnX2y/u+25oH8fNWhAxUsGpquB4UWL8m1ov
	 5HqnMOIVVc30lBEta1Dvqva5aQZh2rVV2qyjhojmK3EEoiTkfmnMCPZoLaH8onNcDPW/Q
	 3VBsNy7n6GPVgbr/0+gwbxbpc27RM3Dsw229EiBb+rt2kqF5U9ZKMq80Vf1wegQR4/MHq
	 S7gX9bodYH3WcvIrGK4ie16AiLIs3qX/3yTkHieFR3NLmm/6CZlFwcDavZZ8ka9FQKRay
	 8Y79y6eEixWtsYGBtxbnZW0C7weiqGOOclKbh1aA4bi0A8pvuO9lzWtQeEUmO/RiouA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793848124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=O4hDMZyahdHdegz9dJ6txQLowUvWcjILhCbebbhV65U=;
	b=pnuOYe1x6fITVpgGFAz4FObc3NeItqJKSYvh0FqnXR3P8EKZFJ15Qe2lG8ywMq6+MNHo
	 uaAcuVI/iUjvQvs/lzg3H6qn/ChTu5sH7PZuyyV302t3OF/enO35kci97N87qd5jzMyQY
	 SNscrtvRZ7bzKod7CizOhDSlVw57xGmIXq0+PIkRG3P6YP27hXJP//mzDIfl6h08IUw/7
	 KJKOsUXkd3zOOtrOSV2FJQnAwkuduk9OmpTGnNFv/KPFVd3MP97KFD6WAixJ10AHce5Wq
	 Q/zUXnsQ4aR0FCAJsOUk91xuM/DilDFeQ3fpQnDdg+3dKtJSFUHAKC+aspgUI3AiP5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMLexRDH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE64606A328;
	Thu,  5 Nov 2026 03:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LMLexRDH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB421F00A17;
	Thu,  5 Nov 2026 03:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793848124;
	bh=O4hDMZyahdHdegz9dJ6txQLowUvWcjILhCbebbhV65U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMLexRDHJs09ubq1cI7EzX1rCJn+bsp7C6uAMbrfts6jbE+TqUChZsvuO22U48gFI
	 msrOtJN7ZTYG2jhjF0hTMaJ+de1by5SSelPfRyU2vEj5nPSTakIm3ntD4/InRQD2Ni
	 0LTN0Fd0BhBjg2Tyt36Uh7Uo3TYLw9NBeMiLNpEdvAZ31R5clw8OzUFSghkhLwR64c
	 x1WuxMdqUGzQUqwKIPC+4dPVlv3adRZ/OIHaL6cwe3CRZ6OJH0yCnw7oORDGuDJax6
	 qxI6CISU/Fh8TSpEaxvctrBgD4ijOm8WERTSuYlUfayZNZQ0qlmwLds3/I/FwXGp2p
	 OlHih/LOtsDCg==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Date: Wed,  4 Nov 2026 19:08:36 -0800
Message-ID: <20261105030836.89040-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed,  4 Nov 2026 16:03:04 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Nov 2026 21:07:23 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
