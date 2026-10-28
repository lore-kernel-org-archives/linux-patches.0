Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.210.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216408;
	b=kDJmvXorX611b8Xw4MBdlM2nMT5nFjNPBTATf4Dh/d1IBspLnQeocoScUi2m2Zqy9XPZ
	 V6v1/CdqRQk2vvn06a9iQ4iz6EzRutqc7ylRwEIaGYpFRboNlIe9ERk+xbOM3Vfy980MW
	 4sHbE8OLop//LSeCeiQttLt/j0raVOEnivw6DGaEj8XAwpOL170N0dDeseo5Rv4bHih6/
	 nzl+JzOhPBMrFVcKW9CrEF/RwtGbMNnjgSeOfwXUb2B5AK+yrdssv7vMa9/rMAcfaetXi
	 xGU/DfMT3dZvbS8SXaz/BHg5E08JBnBb4AuhZbA6t887KLUO2oPA11WFxyJO3ftLpZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216408;
	h=DMARC-Filter:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=kxTdXS2a2oUsmZwpe/L6fIZmRh7RKOkRqyLuNDjKAxU=;
	b=xjDCiRftM97ST1hqEah1aipVn9n/U3UftdHj8jCniBxL7hHNOGFR9c8JB3OEgUciG2Bv
	 vXLLaJ635fUQI9aKf5tkM7PLaaJd2fS60CpARWwTkWleVQljQZwNIgF5Z1++T+11p0bYP
	 f4UXy3ZO+pvIcni6+VvRYzYg8mUgzyxHv+JALMlEaGhhLryCltbBp2yPoKQftBRkm/dw7
	 mwWEZUcMObgMh+E1LY+ASSFoz9ZvODczESYXqzUzdSvqrZ3hJPJjQkz/i0U39Tn2BwnqS
	 ahzgSnD88BdOKcrSjRdb9UQsNsvj2Qjw7JdwYsVTrVBowvHqVMJAvbdiE0XTpvUznAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	arc=none smtp.remote-ip=185.128.210.58
Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5122660A2616;
	Wed, 28 Oct 2026 19:40:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5122660A2616
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: stable@vger.kernel.org,
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
Date: Wed, 28 Oct 2026 19:40:01 +0000
Message-ID: <20261028194003.86077-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
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

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 7.3.1-rc1-g57ad63e19488 #2 SMP PREEMPT_DYNAMIC Wed Oct 28 17:59:37 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
