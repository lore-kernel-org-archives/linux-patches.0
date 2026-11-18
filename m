Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020817;
	b=cD8C+PBwPW7ZWO+sUe8sTPzQyCWPvhk8Qy/WFL3iEs/uk9vSXaDa4sqFKh4iMMY9KeZ7
	 ffAsxZE099Cfu5nMK4H8DeXzS/u5oIZ4T8gp/30ewjBToafXB3hyZRCZ0bF/wneRXZoyW
	 8JzI58GPVVXREgE4mQlvxvZtezVtL8VemyY/t+VUoWS7CtlsJO1YAwQNrEQ35a6pBUYtq
	 Zd/c/GbCUwjCDGWfRBoGOpTYKW8PIeJ0T8C9udH0RLGUmRtDtzu3jYZ1Y0bO8OnG7xAXe
	 kpHlACV2aUPlZrocLBKBTMJXp7tQ6HK0UOP81CqCqLkwI+sgHKjFNckbR2fnuVeuOEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020817;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=trsZ+1RZme3i6jPw3o065+OWOfJHPXUoMlTsFMytG/E=;
	b=tbVCpDS4foGEnaqvvyiIVoBjf/Esd8hhMI/CFPAijf+gFqqTjDcnZmgYQYM8s7bNMRXe
	 rZBF2FJi874YAeYz08aXHnvpnNzaNK1tDxD4cQ5af+8R+oWQBPF9/IWFKxSqYhCW930I7
	 43NauE64xcrVkbACQ+oi+VxEu3YiapurtxHqMvRsedeI/wOjMBMmP1r+FU091bA2LNfGJ
	 GXyWJ2ZbNfRvCjRKD1jB+kdCY+7m3ge9Aw4ZLz7YbNmM38hNogLq/zPsGbXwuNwdFgaCS
	 P09wQN++GD47j+uAf//7WgQvKHvH94trUV8PXb0B3aRzEVcikg8ohV+ZTuaT0Q6xw1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=ZQ31Zats;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF993606A337;
	Wed, 18 Nov 2026 16:53:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF993606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=ZQ31Zats
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=trsZ+1RZme3i6jPw3o065+OWOfJHPXUoMlTsFMytG/E=; t=1795020816; x=1795884816; 
	b=ZQ31ZatsKWh653EzUQcHnOn7X1PKDnsnVLmY6mKiZ4MX2WkmA0gON1RoObE+DpAkji9RBNeGFQ3
	NKaTAujKP+QdNR+kKzWOpwlYyCU4kV1y4nMH8p6RzGXcTh62sadTyCW4wsd88SY6GOZWy5z9+jKFt
	zG/Eh3er5FMlsQ+eiq21RoSx5Ngn9U8DJNPfOT7XSl9X1+CBjJrIJ9HgOGU1CBGjateWmRntawrhV
	kCCv05yrkNATMVkl6ig+m2tkcUZKDXsGuD392eAPR3BF538kWrgixJXZ2hkKiTHarMWUpD3bN/U8X
	d87cVNbz04osBCXwIXTj1gKcA5ZaiBSdbNSQ==;
Date: Wed, 18 Nov 2026 17:44:43 +0100
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
Message-ID: <av3V--DT8f8qsT_9@karahi.librecast.net>
References: <20261118150009.797899913@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>

On 2026-11-18 15:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

Same build failure as reported against 5.10.y

-- 
Brett Sheffield (he/him)
