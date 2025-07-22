Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A023A27BF89;
	Tue, 22 Jul 2025 16:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201673; cv=none; b=GJW4VofQLsyPT4R7swctLHvq67wGUEH9Ro4hjePPsz7xL69BLc8EZO+JfLfHguRyUawW0c1J+2npGma7AFWU92UOVuhUbC+VP4z9vaAl5UtdYGVIceV1DLoY/gUlt3TXb7hHJZjJAXzt986DxI6gMgkH/bbaIQla4rK7oV6zSSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201673; c=relaxed/simple;
	bh=FVq7DAULYYmLKBQj4nN3POQ4/HuRWXuOsyR3rRzp/OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upH9I9RsqxfG3cBeX7dtugOW51ffo9lk7FohJ1RHywWVslNnQTqBCmdnboaHyh2mqIzETFO+p9wcMUtyVx6i2rsl7Jajly4fxQjCdiekc40LXOP3WA15NSEs1d3vEbx3Zyuwi8HXwyKwVL7rjrF6m1AzkwMwrH389AOWHCg8p/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
From: Brett A C Sheffield <bacs@librecast.net>
To: namjain@linux.microsoft.com
Cc: gregkh@linuxfoundation.org,
	longli@microsoft.com,
	patches@lists.linux.dev,
	ssengar@linux.microsoft.com,
	stable@vger.kernel.org,
	wei.liu@kernel.org,
	Brett A C Sheffield <bacs@librecast.net>
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
Date: Tue, 22 Jul 2025 16:27:29 +0000
Message-ID: <20250722162728.25168-2-bacs@librecast.net>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>
References: <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>
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

CPU/kernel: Linux auntie 6.12.40-rc1-g596aae841edf #31 SMP PREEMPT_DYNAMIC Tue Jul 22 16:04:12 -00 2025 x86_64 AMD Ryzen 9 9950X 16-Core Processor AuthenticAMD GNU/Linux

Tested-by: Brett A C Sheffield <bacs@librecast.net>
