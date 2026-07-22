Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD6D3D47DA;
	Wed, 22 Jul 2026 16:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739289; cv=none; b=RePJ4yDPgRZ+QshVXdF0UeZHf2WNmgvqu5VvVyyTSUOAK3+FDHSm37WlpFmYOb5eaq2mDvupcnh4goJ0VX8+KxEPMi9drrGNH1jxBYbRds3mrdubj+8xqVirUzDKdWyEBNnkAqdCS04e2W6+FCue5sekM37IFnqIKflorvZK358=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739289; c=relaxed/simple;
	bh=zbX1n3PR+UrRmkSTg3W5V+GVTKQNSvpiYOzlq64jGOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAroJ4kd91wnDuUGhj2knOihhpdMT/APg9BLBX9DJAnTznUx+DrDebAzCj6aZ5js3qiXhrBUK5YUXYjQBa2w8HBcuHYTcYv+w4dC4p9kF3KQMhDpxzJNr1gQVwFlVVtD58gs7iUGenjQlp+SjKFAs7PGdsFBI4NHI+MvLWguGxY=
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
Subject: Re: [PATCH 5.10 000/674] 5.10.261-rc2 review
Date: Wed, 22 Jul 2026 16:54:31 +0000
Message-ID: <20260722165437.41889-1-bacs@librecast.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722142749.280611149@linuxfoundation.org>
References: <20260722142749.280611149@linuxfoundation.org>
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

CPU/kernel: Linux auntie 5.10.261-rc2-00675-gd0067f0d9e68 #1 SMP Wed Jul 22 15:03:16 -00 2026 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
