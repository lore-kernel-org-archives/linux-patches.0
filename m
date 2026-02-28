Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80693A2AEE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302702; cv=none; b=DDZfcW6MiIsXkWNNdTq7eDppXwr4JfGiag+WdJ1vRPw3UyjMaCs2pJXQOdUpQPZCKxpfWP/M9sIDF8hTWqHGKEvKOzuQQfkI7YiD6K+1IVl4mFHpkrGjIxjRJkzy2NocL9my4XwgCBk4hYWJeFGCnEM7oNM2vEqoy9bILbGVdk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302702; c=relaxed/simple;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9M9QeKOhCIaBTISyGVQw3AuO6j6oKPT2wT8x54Zx/USZgHRpf4Wfouo51CqhtjvkQNnpNgEdSTBzUW4Eiv6+XJasQMQRiCCj3Zga3TKnHd8ed4l76Mm+SEPbh4YEGnr7YECMV7JES/aJjjUDgUlhHzpnDt/M7SPnhtSnyGMsJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJn//Zu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJn//Zu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513DDC116D0;
	Sat, 28 Feb 2026 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302701;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJn//Zu+DzWlZDri88VA/NMsR3PYB1qQIp056Lm2WMXydOsnpq85UrXiM8FC7nPxy
	 hd5bBEBR8b0cQW9JvyWX9nu1f6xWsqBdTlFUHfPWVUWH5C7QUidIT3W/1K9aDoOeeF
	 W9VRtKKLYg3nxjTGXqzKc8fWCz4QdGbpxgKthj1Jp/0Ikm0vp5hUIpyKyxifoX8a2o
	 AtVsXDeFX8VhztVHBxusvwBiOdBqGUgqDhgdUnuwMC/uChdnKK2/EYqhpEXWu6XvBR
	 LqGiwzTCchLJ5QTa9183TJFNix+pDKI/ZnbL6dWib7IEKueWAwkjOTynOCfBMlHst0
	 okk16404Cg9rg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/147] spi: tools: Add include folder to .gitignore
Date: Sat, 28 Feb 2026 13:16:06 -0500
Message-ID: <20260228181736.1605592-58-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit 5af56f30c4fcbade4a92f94dadfea517d1db9703 ]

The Makefile for the SPI tools creates an include/linux/spi folder and some
symlinks inside it. After running `make -C spi/tools`, this folder shows up
as untracked in the git status.
Add the above folder to the .gitignore file.

Fixes: f325b73dc4db ("spi: tools: move to tools buildsystem")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Link: https://patch.msgid.link/20260209095001.556495-1-flavra@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/spi/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/spi/.gitignore b/tools/spi/.gitignore
index 14ddba3d21957..038261b34ed83 100644
--- a/tools/spi/.gitignore
+++ b/tools/spi/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 spidev_fdx
 spidev_test
+include/
-- 
2.51.0

