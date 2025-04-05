Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84BA1392
	for <patches@lists.linux.dev>; Sat,  5 Apr 2025 01:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.184.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743815439; cv=none; b=OUzBqeYlH/FTFbEw4MxjvRNMRYxxuQmy1NAuNUlLBXE1nBNo7vwmlnydjUFUOnxeB3NEE5+kdF3mK3cjS4GEADl6ELvYLcohFcDg9t6ciTYyrJ2bU2KUJSFUJi0xMdEqWC20ykLzj51l98XH6GZWYpJKK3IdsG2+5e35IZlu1qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743815439; c=relaxed/simple;
	bh=NC72eaCdOLdDuSwJryEhke3uZ3sxPzT3dX1I4p297tM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cnBilL4VaBpEIwpDEnQlkna9gTdzf3cWVZfsayZZQQfs1c5aaHePWtVuNBPlUV0GkDH04VHAS3B8v1YMjBE1tw0r0juAuN4KeZCQEJT61TfFIyMTw5MF8g6Hefog91oz7OXU9hoMzJ7DDAIsGX06gsqNht8l2L1qc9niwdpElA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=PGOu53z2; arc=none smtp.client-ip=207.171.184.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="PGOu53z2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1743815438; x=1775351438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=imok/5WHu6GaAJEgOqF6aevm3ZMFvooZNy7JHaSLlAg=;
  b=PGOu53z2OsQ2c3rRYabhQcqapurZPmosiIXzqPvBR+j1W+dR2Vzbgn7e
   iPDzFXtQgXskExtS9+eIz61dNFym4Ase3yLER+Ud2A71lDnMhDpvCfYf7
   I+fQvRS4WHlswE6Pbq78Ert2KM2DMW5W1qGcWJzWoVPUgX8iO/mEmLnN2
   A=;
X-IronPort-AV: E=Sophos;i="6.15,189,1739836800"; 
   d="scan'208";a="509006952"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2025 01:10:37 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:55389]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.51.140:2525] with esmtp (Farcaster)
 id c3bcf88c-1ec6-4e1f-b907-2ca1eac46478; Sat, 5 Apr 2025 01:10:36 +0000 (UTC)
X-Farcaster-Flow-ID: c3bcf88c-1ec6-4e1f-b907-2ca1eac46478
Received: from EX19D010UWA004.ant.amazon.com (10.13.138.204) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 5 Apr 2025 01:10:36 +0000
Received: from u14c311f44f1758.ant.amazon.com.com (10.187.170.18) by
 EX19D010UWA004.ant.amazon.com (10.13.138.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Sat, 5 Apr 2025 01:10:35 +0000
From: Munehisa Kamata <kamatam@amazon.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <akpm@linux-foundation.org>, <broonie@kernel.org>, <conor@kernel.org>,
	<f.fainelli@gmail.com>, <hargar@microsoft.com>, <jonathanh@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux@roeck-us.net>,
	<lkft-triage@lists.linaro.org>, <patches@kernelci.org>,
	<patches@lists.linux.dev>, <pavel@denx.de>, <rwarsow@gmx.de>,
	<shuah@kernel.org>, <srw@sladewatkins.net>, <sudipm.mukherjee@gmail.com>,
	<torvalds@linux-foundation.org>, Munehisa Kamata <kamatam@amazon.com>
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
Date: Fri, 4 Apr 2025 18:10:00 -0700
Message-ID: <20250405011000.460488-1-kamatam@amazon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWA003.ant.amazon.com (10.13.139.46) To
 EX19D010UWA004.ant.amazon.com (10.13.138.204)

On Thu, 2025-04-03 15:19:55 +0000, Greg Kroah-Hartman wrote:
>
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.133-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Complied with Clang 19.1.7 and booted on qemu-{arm,aarch64,x86_64}-system
and also our hetero-core aarch64 system. Found no regressions.

Tested-by: Munehisa Kamata <kamatam@amazon.com>
 

Thanks,
Munehisa
