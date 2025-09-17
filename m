Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 924482882B2
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758131809; cv=none; b=YuB08woQilXNmYWbP/1MQcPVyA0dgSw9cSBxchbHUdjAbpF7zlRWFmSAqIX05gxIKhzI6mqshN4wUTaq/sGrwl0jTHRavnvGdsoXDmOo5p/hYFnHhlp8ii7hb4SZfeknRI1Wt9omAYNxWTiJ6MEf+E4H+h1alxn1nzhPaPMvfow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758131809; c=relaxed/simple;
	bh=2I3ucNbptVz/o/0a2THX5Y1zOx41TXHI/Cl5kt+Qk9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=JbJa/R7nP/Ik9yXQUko/RdOrvCi9GBNgstHejw+ZzqglgCidgI3lbjKs47W1//0plL885CtnzkOy0aqLSMEevrgabMv0F+7TgEALx4y3hf+BC3EJVudSdC0MaMuW7BSJDMfyA+5R+nCwr10IE9T3VCf8qOUV2CKqloEmyxGMFpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iGHnYFvw; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iGHnYFvw"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 2E51020154EE; Wed, 17 Sep 2025 10:56:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2E51020154EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1758131808;
	bh=2I3ucNbptVz/o/0a2THX5Y1zOx41TXHI/Cl5kt+Qk9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGHnYFvw1H6ZX4rS1Op11gnHhfqPivq5gNy1jBhKux3pelv0EltNUsM/SwLVBDv0a
	 grjH0x+p6vew3YTbLBrgMcTprS52LJb42m8cR1ztnTvU8bZsUe3TdJHUk058/hsWdX
	 ITWVJmfVIpL85KG0Dt5hk5Wwm33VQUFJk2ffgQbw=
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
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
Date: Wed, 17 Sep 2025 10:56:48 -0700
Message-Id: <1758131808-15548-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, perf tool, and kselftest builds fine for v6.1.153-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
