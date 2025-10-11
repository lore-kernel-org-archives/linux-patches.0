Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B29327FB37;
	Sat, 11 Oct 2025 17:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760202227; cv=none; b=LtlRNnyR1ND+gUoFnPOe6Ltj7b3IvByMMdUcOrYpMxyOQYEedW1VZBMceo3AcfI8R9tKAnLytNkAc6joRODVkXuNaE9Yqn2wuoYVvE6ITbWD7zw3Dluuu8wJgt++gqhV8oFgCSe0N1K8QldFVMf4oia9lr4mECXIyjjMpVQsgOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760202227; c=relaxed/simple;
	bh=89Ue2LApDv/iI9obxwTtbER3n/HvvxJZqVCxmQjbR64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOmampkp0B6BxmR1sH410jZKbNjlqekoeyEFsquDpY4EDYCIG22uEY/f4ml87Fw+sua6XTEqWa5qbaMxDY5kAeEgt7CGVZfefzsQ6tz54q1+PuZjU5IUCD41I0liPkB41lVfkmxagrU/9WZVSozDcFO4riEgOrrQREbUr7GQsZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.6 00/28] 6.6.111-rc1 review
Date: Sat, 11 Oct 2025 17:03:29 +0000
Message-ID: <20251011170333.25539-1-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

# Librecast Test Results

010/010 [ OK ] libmld
120/120 [ OK ] liblibrecast

CPU/kernel: Linux auntie 6.6.111-rc1-g65af00078567 #105 SMP PREEMPT_DYNAMIC Sat Oct 11 17:01:57 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
