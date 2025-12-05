Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB523101B8;
	Fri,  5 Dec 2025 11:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764933301; cv=none; b=fTJNMAoscbRyLDT2k132tWvXVg8v8RSqKYv0V/VSrpLVmNDl+7iZM4+ROb5h6WmjNsbPz0rihmEXSdcMRtKTYprG74QS706iqRXUE+hJnPWIh46rfNlTtwaF8v4J00cNGo95vAiuvcUxGy1qziBnfVUzDTxRGonqp4v90X89J4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764933301; c=relaxed/simple;
	bh=czEIgWWSBH8i1QHr5F8EQdhpEdwoozHhS9P/C3O/QXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LerXhUCLAFLXci4/CJyVffzoWoYbK85Co745ORkyynMdjmUR9Tz7Ny1qcYDFRI80hgBvAjyXrzC69luitOB/h6AF9UCQGB9HdZo/SAHArm7CwN7mOcG5jjDQO8nvFPifSld6XLqBF/k0+su2JoGUQH8Sxaj5BzibreLnp9DPAbE=
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
	sr@sladewatkins.com,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
Date: Fri,  5 Dec 2025 11:14:43 +0000
Message-ID: <20251205111446.11705-1-bacs@librecast.net>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251204163821.402208337@linuxfoundation.org>
References: <20251204163821.402208337@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.15.197-rc2-00388-g19afef1f91d7 #1 SMP Fri Dec 5 11:11:42 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
