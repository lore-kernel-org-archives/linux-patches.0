Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A05B4F7975;
	Wed, 14 Oct 2026 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791978180; cv=none; b=aHLPW1xHSGsCCX1FqbYpm2YLWlbFoXBXQz0q28akcnQaQA2C92X0RuzKrJQmK7PZ5FAYRJO0OjUe4fvcMCWw32DfMlmWpUiQebIxlyLNagUvnFRoPB5payKfMLVyJMODHXZr3YhkatcpqL3/xI9eMx0Qp5g/qGGvK5Lr2oaIXVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791978180; c=relaxed/simple;
	bh=NKXpdDD/X2cTy8xSIrjJPxDhoWoiZrVPaJwvUXjVzYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDyMXmPWbq8jxJQvFZC2GQ5qx9LUwUfMosKvZrR/xuT96l+iC0TlkcvVx6cKJPQBvitS+fhExSzm9Vom9T4BJNwwCrsFZkw5KVYx22bzwkXK9V10iXqJNoa2Dl3jv0nDctEltIwUgFgj75lXlXfPTi0RBEtRy3mbZqN4hTB1AyI=
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
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
Date: Wed, 14 Oct 2026 11:42:36 +0000
Message-ID: <20261014114239.63516-1-bacs@librecast.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

044/044 [ OK ] liblcrq
010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.12.113-rc1-g03c552c46ef0 #1 SMP PREEMPT_DYNAMIC Wed Oct 14 11:37:02 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
