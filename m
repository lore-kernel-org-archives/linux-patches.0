Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159A85C613
	for <patches@lists.linux.dev>; Thu, 14 May 2026 02:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778725768; cv=none; b=X8hWg/e15jQKun5Epo2lUntpCprEviQS5CoL1axLaB7QavCKFHVfRZrzkXzlgWdfWzWCciqVZu+u7mEHvsInGP2MF4uWGvqAsKBcwn0L/8NudxXkerwL1xyL7jP8hGuJz5zBK8QsctX3ZrO59vcrljjDunwqliPyhcT+ibngp14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778725768; c=relaxed/simple;
	bh=5PzRp/5jyDYi4WOlrdLJ/nomKRvpGGgLL2zfcjBNl6M=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gPxIChvdFsdrGzW1r0eI1gy/oFD6t2LAyusbBEKgS/mJLzsHB0Jf18gpZanDg2cQX0ZWJyKxhtJh6DyMroTqTR+1PyYJKpQwuziNs49Owq15wPJEewvECmERaWHWKLDgsLVgcGY4Uk6zHz1ygZtnGyixGSwRdM+KWiIgKPSv/wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cetola.net; spf=pass smtp.mailfrom=cetola.net; dkim=fail (0-bit key) header.d=cetola.net header.i=@cetola.net header.b=M2VTX80n reason="key not found in DNS"; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cetola.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cetola.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=cetola.net header.i=@cetola.net header.b="M2VTX80n"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id NJUhw2H4Bjw8YNLpAwIlkh; Thu, 14 May 2026 02:29:20 +0000
Received: from box2192.bluehost.com ([50.87.253.143])
	by cmsmtp with ESMTPS
	id NLp9w0icIwILMNLp9w9nrW; Thu, 14 May 2026 02:29:19 +0000
X-Authority-Analysis: v=2.4 cv=F+RXdrhN c=1 sm=1 tr=0 ts=6a05337f
 a=j14/dPpTP3/5aO8YB4ELDw==:117 a=j14/dPpTP3/5aO8YB4ELDw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=jNmq5YGq058A:10 a=wTo936TsAAAA:8
 a=-1dujidA0GkW3srLwSoA:9 a=QEXdDO2ut3YA:10 a=J3I8QpufI4RFOXkfet32:22
 a=dWMlSAZEh1Dptg_Be0X5:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cetola.net;
	s=default; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5PzRp/5jyDYi4WOlrdLJ/nomKRvpGGgLL2zfcjBNl6M=; b=M2VTX80nEb8nRWtXR2BkIZELhj
	Xkq/TLt5nydK+NuBMoPm8ybe65HbxptD2AcnEZjVzCDJVgGxRp/S20U5SDzmhEbYsXQqjRy4NEgh7
	8a/Xbjqan7iQkomZllJzTamY4tV+3eSQkJ0elAdZDSmJNkpuEXi+eoXHW7mo7S9hT8dk=;
Received: from [71.238.14.13] (port=37696 helo=[192.168.1.51])
	by box2192.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.99.2)
	(envelope-from <stephano@cetola.net>)
	id 1wNLp6-00000003Ruu-2ciT;
	Wed, 13 May 2026 20:29:16 -0600
Message-ID: <8acb6b5839d8373eaaf84c218d1e946a4c2400ff.camel@cetola.net>
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
From: Stephano Cetola <stephano@cetola.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, 	shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, 	pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, 	sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, 	broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
Date: Wed, 13 May 2026 19:29:06 -0700
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
References: <20260513153754.934923793@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box2192.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - cetola.net
X-BWhitelist: no
X-Source-IP: 71.238.14.13
X-Source-L: No
X-Exim-ID: 1wNLp6-00000003Ruu-2ciT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.51]) [71.238.14.13]:37696
X-Source-Auth: stephano@cetola.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: Y2V0b2xhbmU7Y2V0b2xhbmU7Ym94MjE5Mi5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGlWg74ZApP2vFEj3FVRiNdDJAgw2TyFnuT5zMH1Y7jdzwD0xW1VJsWaToWl4jmegwbjoBeDPKSENN3bb3NWNUYVVLHfGnViKJjfwYg4CgSCEnAWIpdM
 2zy7bNNub3Z4a8CjYeCdxrDlguUvtDbcwUHsnFCklKI4WJiW8SrUKEfk6TcKtbH19b5DSe52KGkG6m03pjHFB3vl8epzx2komn8=

On Wed, 2026-05-13 at 18:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a
> response
> to this one.=C2=A0 If anyone has any issues with these being applied,
> please
> let me know.
Tested 7.0.7-rc2 on an AMD Ryzen 7 8745HS, including with:
CONFIG_SCHED_CLASS_EXT=3Dy

Builds and runs with no regressions found.

Tested-by: Stephano Cetola <stephano@cetola.net>
