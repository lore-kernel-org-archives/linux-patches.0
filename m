Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A1827C869;
	Tue, 22 Jul 2025 16:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201800; cv=none; b=ghmgosOPJ/Z9wtfeHTBXMmvEcPFENVs6IqYCs007VECbQq3ezZePsp6G6cCXK3Olk/DixzzoHOBQaVH5yPWZlBtsIkacfU/VgmNWiJL4xXg5vvLEUy3/dRC9C+ZLwQLb9svrCsAfS4fdZH5fgXJab7LLWrncc53QwJkBp/uxnFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201800; c=relaxed/simple;
	bh=hadC/eIhRQESTGdQVFVYhBYs7qkz8mtLFLSq4THhPQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8XLhyhH50fUfspwvYci3A+nEpZD0M3L6cbjpEtWqSV6YErT19rH3tj0Qeq1y/0HqAyERjQlAyVBwtjE0wUVBQDakCrZEfqKMyKdZHYg3stiCZF/YnjaymdbAvfUvfXWnOgpNfA2zHSVzqX443v+mqwKp/4r8BwJNf7ok2ojEyM=
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
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
Date: Tue, 22 Jul 2025 16:29:40 +0000
Message-ID: <20250722162939.25223-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250722134337.561185968@linuxfoundation.org>
References: <20250722134337.561185968@linuxfoundation.org>
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

CPU/kernel: Linux auntie 6.6.100-rc1-gb00c1c600f8c #28 SMP PREEMPT_DYNAMIC Tue Jul 22 15:32:08 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Additionally, I confirm the 6.6.y IPv6 send timing is fixed:

  https://lore.kernel.org/stable/20250718101603.5404-2-bacs@librecast.net/T/#u

2025-07-22 15:40:44-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00002s)
2025-07-22 15:40:46-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00004s)
2025-07-22 15:40:47-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00003s)
2025-07-22 15:40:48-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00003s)
2025-07-22 15:40:50-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00004s)
2025-07-22 15:40:51-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00003s)
2025-07-22 15:40:53-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00003s)
2025-07-22 15:40:54-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00003s)
2025-07-22 15:40:55-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00004s)
2025-07-22 15:40:57-00:00 6.6.100-rc1-gb00c1c600f8c 8 bytes sent after 1 tries (0.00003s)

Tested-by: Brett A C Sheffield <bacs@librecast.net>
