Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28AC21D52B
	for <patches@lists.linux.dev>; Fri,  1 Aug 2025 01:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754011894; cv=none; b=hA9s1cQp/BAfBr3U45jJmhVJZsKycyv39wPuP+s5a/ZLwuZvtqUpON2wKKsrsGXaZUq64yKULpOyeB5KMQ3P0jY+ie7bIp7HKAjlZQK2rrQ2nUNu3qbB8Kcru96XbW6maUuwQw8NuwJHmk7b4DAksCdEJzXotZMAwqtDfnj2lWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754011894; c=relaxed/simple;
	bh=gmDxmGr10ha0SVthIS5G5pwuQ+FfYR2x/0H9aKwNkQo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=pN7hvDQ6u6bGSm8VbbQ8v5yKsntSkXA21rr2/DjNg+YTLQiNGhjwIPbMM4Ul8l13DwyJ8JWwiK2ElJzL1+BqKVoQz8Mt/pVyHjjwWyIHFcfa/iYStfEEhr6NYvuYrNAQZJk1WRfwNWkhLr3YF2hq1/vW+srotLVVzyvazKshE9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=biw9pb6g; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="biw9pb6g"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id 8737621176F5; Thu, 31 Jul 2025 18:31:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8737621176F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1754011892;
	bh=gmDxmGr10ha0SVthIS5G5pwuQ+FfYR2x/0H9aKwNkQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biw9pb6gbvBaCHeJ5x9yLE2OSG/x2+ASu8EDT8ZOkxEa3y32X/yLSa3Kz7az20PbU
	 DHqmpYTNvyykRtg7Cwfrhgyk0SeI4N72v21gXj1CjOdfBdnLf1x3RdojqcTxDaS9FC
	 shpnBdFvO3X3ffkRC0m9xLVTDPKQiX79ADXZyXvQ=
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
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
Date: Thu, 31 Jul 2025 18:31:32 -0700
Message-Id: <1754011892-27600-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.15.9-rc1 on x86 and arm64 Azure VM.


Tested-by: Hardik Garg <hargar@linux.microsoft.com>


Thanks,
Hardik
