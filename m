Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527FF273D6C;
	Tue, 22 Jul 2025 16:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201883; cv=none; b=OyCjYTD+RKveTLmxXPZ81PYXsh3mKiEGBjjKgC0QOb7efCdwhmrOCjoT5g1BjDDjTi197lM6kzknA2hDYYBKo5GFfWUTAgR97rOGO1Ds+DZItjyMNjIdorqCsme/jh3vDpdZZj4DwH5WgngdnsWyfvJ0QJdikkWmIQb8Y0tzx3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201883; c=relaxed/simple;
	bh=hKu0DavR14LGZIJAfj4j8Z/wGRb0H/m/C+HcNl2G7sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GS3QQ8XbAHHcfQD1Yv5R6KQV8Wb26Q5xGi8dtHpcVBZo+iC8I2PQXjgg7IaIFVcYvmp8B4wjc41jESsWbotaeIifqcFXYtft1eZwfxMHgMijCzty0gJAWLXCeF7F8h0EfGUN6hE/5OyLXa6UK/zvuBEX5tEI+uDWaoqNuwRSLKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: gregkh@linuxfoundation.org
Cc: mcpratt@pm.me,
	musashino.open@gmail.com,
	patches@lists.linux.dev,
	sashal@kernel.org,
	srini@kernel.org,
	stable@vger.kernel.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.1 00/79] 6.1.147-rc1 review
Date: Tue, 22 Jul 2025 16:31:04 +0000
Message-ID: <20250722163103.25239-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250722134331.302130274@linuxfoundation.org>
References: <20250722134331.302130274@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.1.147-rc1-00080-g3a0519451f2b #29 SMP PREEMPT_DYNAMIC Tue Jul 22 15:49:38 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
