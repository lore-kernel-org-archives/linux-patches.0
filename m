Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B362E2DD4
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757439517; cv=none; b=TrvUJzeSclZjrIM1eu8IFmn4jIm1yJ0besDz7XEw2BHnPvk6tKWDgTykg01aNDbtyIA6QCe4V/ocNkUjp8Ltt/qQLS3lnFn55KjZRC3vKsuEy1Ig2ojY7Pu3wj2df9AuJ5cb/mRhbsFZ2PsgYOGZD4VfqNcQMxZdkKENzox49KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757439517; c=relaxed/simple;
	bh=CueeUK+sDRs8Z/D5w3hV0rIFES6mlQhADuIbe/Sj9oE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=LAMRS+C94PetGgkTc0yKPZeIsISpzQG32m7P20abKx2CsecwkyPZCC9toBTjIrw3GYPOLPG6sWdMohDhnWsP6Hdn256NKp6rx8rqc/YcG1vz1PlAX4NcTci/sjQg8RLCbzi8P5ZVY4jq8ehoCNTapz+DSKj2hxMym9eEgvbhOHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=CmU2CdUA; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CmU2CdUA"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id D595A211AA11; Tue,  9 Sep 2025 10:38:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D595A211AA11
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1757439515;
	bh=CueeUK+sDRs8Z/D5w3hV0rIFES6mlQhADuIbe/Sj9oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmU2CdUA5WMATM0PYbOapOKjaTA3lTvFzvLHhUp73edbMAHPRgMY/TSY1/FMEbJQ3
	 3ATEXPl6paDruKVz+1b2DvnpTXws22gZkm7BdPtF9DMRz8tTF/d1AfaiBOQnCrLm2W
	 O+b1F9NvclpeDcBPMUeffpDXlG87Lj5MFICE9p5k=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.1 000/101] 6.1.151-rc2 review
Date: Tue,  9 Sep 2025 10:38:35 -0700
Message-Id: <1757439515-15566-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250908151840.509077218@linuxfoundation.org>
References: <20250908151840.509077218@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.151-rc2 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
