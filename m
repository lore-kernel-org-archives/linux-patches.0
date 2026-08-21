Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49B6478851
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 12:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787314454; cv=none; b=egyq6fLAbDHZYf8nE3QA6r2KjNTHovA7cfnA/iDphDU1zI1ZOFITfRLZeapfiXg5QPle0a/JjkBSFtpRavnYuIOsWYhUOt4aQf4INbyLqQg2oztwcp3QL/KLCIJjVUqNsV2/1tcQati6J84J1MmyE7nih16i9BMC7r+96vuPUOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787314454; c=relaxed/simple;
	bh=ksWXAQBH5+Pnp2Q4/hFAzeKMDuhHEYQG6YQkWed3gd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B5CYDRcnSfU+kXSmgoruuRhiGr3LiGLpZFsptPC7jrSo6XbR7QCyaAXPVo+q9tRVxuE/Ub2V3TRBBkzJ853MsAB5iMVJgtBtaSqj//vInCMlZ3cH8qawFVQSWFQQXDwpS8ZZgtxJT7oezxdxRTVzXYBt56FfwhM1TBn8mRglKdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=hOfED2NE; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="hOfED2NE"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 2F7031F920;
	Fri, 21 Aug 2026 14:14:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1787314448;
	bh=27LBdK7UJUe/B1vuAWYM2iItxhMwrJLsPR7U/deDshc=; h=From:To:Subject;
	b=hOfED2NEEDK3jpx0moign/r7mwfHP/VJYCj4Xvvz5L7oy734tw6c41To2LWMJn7Zu
	 aHeSAC3dLIR4YF4loQVHvaaVkPtG642lCVds5BLGKGkTn6DF3QzGg/RmglZbw8Kf4p
	 kseuDoKFpPlTa7ndeTLndQs+w7t8GVYkuOxq7jJJ6IXCd85DyF+mP1ujmVOuGPvzqY
	 uMP8KwBlHQRjEeMC9c/p+PqY0WM14oPd3NC9TUpTdbG6DRQiD0imCHeeqfAjfaBxpN
	 XfybVxGJq7e4JmGH0TnHQQEgHbLGxyi08nOj2/vofsg1UkI0sbuCWpo7HjUBjtHT1p
	 SHfA20LK28AXw==
Date: Fri, 21 Aug 2026 14:14:06 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
Message-ID: <20260821121406.GC69762@francesco-nb>
References: <20260820145223.480031205@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>

On Thu, Aug 20, 2026 at 04:53:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

