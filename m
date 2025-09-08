Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44BC2264A3;
	Mon,  8 Sep 2025 18:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757357435; cv=none; b=UrJSfDqLKfCk8wiOJci+Pt02+x9Ji4tY6blwwBK0EYHV2vBlLzPUoiU30g95AT2jMkwxK5Ad8OUbiBZ2KTGJzeBhkEl8n9tPrc2tUSgJUMxKU5+jwSS+5sGlyU1j9s1RVZ2Ouex7WPkXttLbfhtgFbg9aLyEO4UO2+GhOZCdPOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757357435; c=relaxed/simple;
	bh=g1yXA7g+/H8zKwTXjkgRnfZN31Et1h9PUnKfpVutGRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbZVgIbL/p6pZdyE5ccqkOWX/GlNrc7rW92bIB77vESpAZ4NxnXUMzpAaM37sSSiFXHHyx0OwpN3fFKBZ0QEri1zG2Z0tngaMd8bI24YMZlq95oTfjewYry3xZ8ilQSO1uFJ/YnzazvHf73PUUMPQX6CKCpLvugByFw8dy25QNA=
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
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.6 000/118] 6.6.105-rc2 review
Date: Mon,  8 Sep 2025 18:50:12 +0000
Message-ID: <20250908185011.1136-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250908151836.822240062@linuxfoundation.org>
References: <20250908151836.822240062@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.105-rc2-ga13907443c81 #78 SMP PREEMPT_DYNAMIC Mon Sep  8 18:11:34 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
