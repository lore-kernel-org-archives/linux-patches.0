Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 824CC1BD9CB
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 20:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737577116; cv=none; b=XmgRFF5M8/sbsYJs1hAnVwTpbsiK9bWdM1yXF+60FgAvwolGIdnxobu2ue/sxEmiVkESep1ICjTjQCOTtUd8Xm2RR9yr2ndIRHwMF2K0Z64PxoxZkFjfpxkfRMQyoTo2VmiC/zeXosMb0CCueW5J0VpU9tqLBDzxe9EkZhI1wBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737577116; c=relaxed/simple;
	bh=RbF+NUu5/7bAxq8Ryn7pdyvMV/Ae+Qe+ZiXBywiphos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=eEVz+jYjnU/WRSta2EZCVLM3Bip0xSvTLinA+trs1z1nPBEpgh17ecftK9BiwXvgrnWG205Pqb11u8Fam1cZzebOlDMl/WROp9AKFKvCOrpvbf7GuunmhZ1DJZNUAN4yEVR+U0T7RGtSbp/EOU4E79nNU3p5ugumWsikhpStkIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=aaFkTtKE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="aaFkTtKE"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 16F7220460B2; Wed, 22 Jan 2025 12:18:35 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 16F7220460B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1737577115;
	bh=RbF+NUu5/7bAxq8Ryn7pdyvMV/Ae+Qe+ZiXBywiphos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aaFkTtKEPGns4qO4Fse1MU0zFEDiymMw5+rkFPz+siG5+RZIKM5V8aoz+kGUBg+c0
	 4V7S27n+Tt6bvud7Z5+kAK5h/Wv64eLIkcPQSXW5Kr4qHtvg6oVv0IYLGH20hDnMZc
	 8TASSWmyC8rdhSJW9W4LqRlJDLDugDZ0U5XJZ27s=
From: Hardik Garg <hargar@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
Subject: Re: [PATCH 6.6] 6.6.74-rc1 review
Date: Wed, 22 Jan 2025 12:18:35 -0800
Message-Id: <1737577115-18241-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, amd kselftest tool builds fine for v6.6.74-rc1 on x86 and arm64 Azure VM.

Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
