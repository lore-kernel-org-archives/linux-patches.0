Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AD137EFFF;
	Mon, 31 Aug 2026 19:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788203555; cv=none; b=UZxYD8BpLnnXARTC5uCu1mbXA+fmyT2MCPv6/aRqMtKM5jNMFnBtXlpppF/cys4A/1IEzo9AlOZsnYmIluKLdrXr4ZIqzXzup070TgV7FmwF2sQDIhmqV9wSn7/zpVISIo0YRr490Tpx9EHHpyxaEjeQ4VneIliIJk6c66qh3Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788203555; c=relaxed/simple;
	bh=kv7c7/bPThzXHS1WBXBOpLc2IKsbiAbTMee6NBhQJ0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD1RD6YASXYHRHGR1ihPSEXUEHQPTFNFfn8Pp5loCIyn25YOSk1eOI3M+tgt+B2944gti5q/q4pCmUr0bx3o7wfF6qsmnwV0QzkW/zYpohCFbjKkKmlFTba4JLid7y9HKFIIZFUl009l0uxZ/oz5PqUml12Pv7yk4Z16fr41vJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
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
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
Date: Mon, 31 Aug 2026 19:12:12 +0000
Message-ID: <20260831191216.28045-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

020/020 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.1.187-rc1-02128-geba5b1b4f9a8 #1 SMP PREEMPT_DYNAMIC Mon Aug 31 19:03:28 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
