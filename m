Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E62224AEB
	for <patches@lists.linux.dev>; Thu, 29 May 2025 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748535981; cv=none; b=SqfuVgDfopj+vI5pvb82zQDGcCxKc7fxX++qQxyPNIpZVIlZ98oBT2WceqkWqT2BnIIzX2TXroFU7QWtNJGlInpVnrIasRvMP81bV5xNNbwJtVADbVUwv0ilVTL8Jy9EmQDrH3YmnlZuUstBVd4kkpVj+SL2Xd5s3x22HTu4bhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748535981; c=relaxed/simple;
	bh=9F308+Own42jkc5c7LMrCUDVYibPKtxgEIIStS5iUPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=s9KaxUijoeG9m1HPD4gqJ1y55wHqi2TJrYPZIQnVEO+KPs8TpG/GPZliDIRuTrcRbG8AZeLQ5YHVq68g9z+n74r6ET7ZgxXi7FJi3xE0W6UwDNq2u8V9+sSzcCi8jt4yXBXV9fZF6owvuGsSSKYQ74TFwPFpXOrAQiz099M0C78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eYSz3B3p; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eYSz3B3p"
Received: by linux.microsoft.com (Postfix, from userid 1158)
	id D7AFA203EE17; Thu, 29 May 2025 09:26:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D7AFA203EE17
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1748535979;
	bh=9F308+Own42jkc5c7LMrCUDVYibPKtxgEIIStS5iUPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYSz3B3pQFEiXz3jtjWRXXjkol8f0djeVoBuj2reQsAW4SuWkXqK7ieik6FYAKSef
	 pIxRWCFYBg/amXuG7blg8sqsaprVvB30gT7Saooz5QYB6rovtgpR+CbRDQH9YQFt0X
	 0Yaup5Q8pj6Z9byaio8XV1/wlw0r09k70vbsjNNI=
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
Subject: [PATCH 6.14 000/783] 6.14.9-rc1 review
Date: Thu, 29 May 2025 09:26:19 -0700
Message-Id: <1748535979-4921-1-git-send-email-hargar@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

The kernel, bpf tool, and perf tool builds fine for v6.14.9-rc1 on x86 and arm64 Azure VM.



Tested-by: Hardik Garg <hargar@linux.microsoft.com>




Thanks,
Hardik
