Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 096301CF7B1
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731049592; cv=none; b=ZYsOpgzNPdmw3iq+sZgIO86a2BNG9fbDemp8FDN4FJPagaamDdqNYsbN3dHz0wInGqqBeUgofJpTFwi33RvJNgRz77arKR+7L9DrLtpN1kDtGj0xCQaFFh4Dyu0PhIRXZPlp3wdRjUUqEpcOQpcckseRZLT/q+VHOgBs5Oig2Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731049592; c=relaxed/simple;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=cUo7c1YuZEEc08LrqqLp4bDzcjZBD6XMaLcdeoKu7jNRgedYqTdfNgb4Wa40dGvye9o9h9ddge2EzeqVsLNCFnrZF3AKPv4EG/1ToiDi6ZQwAc1qnp2hl2jNpiC2iXFx9Gz4iKWWvqFasaDhLOdVblrryCcnD2ogZQT2mlJGVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Ve2i9wQw; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Ve2i9wQw"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 6E5D9212D51F; Thu,  7 Nov 2024 23:06:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6E5D9212D51F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1731049590;
	bh=H5yKHa85K/kN38MCbIEu0HaXLqb/id9+omWJt6O4sx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ve2i9wQwhVOHPx9O3GvWd4NZb55wkZw3Piuv4JAOrEI4lGj+lm3dCW1c/xTCdt4TY
	 MNGRd7EUaMLY2qITntNNa4SUfpZgCbQ+JKrOVDJb1jdQ+9/UOVN+dJd5Or2lvcneuE
	 yTdMWb6CQl7LdRNYzENiT4o90e9osJjY5pIyAYIE=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hagar@microsoft.com,
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
Subject: Re: [PATCH 5.15] 5.15.171-rc1 review
Date: Thu,  7 Nov 2024 23:06:30 -0800
Message-Id: <1731049590-18706-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
