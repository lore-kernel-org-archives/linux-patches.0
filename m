Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0850C36C9E2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302360; cv=none; b=HSJfRjSvUCfCtdpkjRvr28/GKhQ6XilCU6AQJlG/t3Su5z5AsovERadhlBCx5zcpamLBCclEtg2aIEQfE6vheDKpALS57QbwMY0Thn0gH9p6R+eJAWwjyPopsev5RyagItJUP+PwmL0tN4ete7hs4TLv15dk9mNkTJMe4ieaZZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302360; c=relaxed/simple;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlQvxxs+r0aMEFpiMnCm2gQgSgF1WpBVTvFGjL6pzqIUaJ1AyVyRBcZq3Rl/2d6y5Osr2o/7sCjomIqqqHWz1emxgPkFKcW2Y/P/XHX7SFSBjwTpZhqgiYp3VZWDWdT1TMdaaEEFOr0o9m8TzH5IrGvyDFAAKVz40NHPhXmlphI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zuz2EDr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zuz2EDr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E350C19423;
	Sat, 28 Feb 2026 18:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302359;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zuz2EDr1iudKU9gZeeCC7SQgAp8HCQjR0bYGJ7oEXRmveZpZgfRVLSFs+Q8xUDsTy
	 NZ8hXNmLfnybcJJkOVBh6Isc5GobzVFIYm77N2kyPnuG5fa0jI8YgoaNI01VY8BqrG
	 HPHKJjq9Fl8qM6HFQoEaDkRApFUlW7avrMIIaJNytGWorGdne6mnZS4ACEd1D3zrHr
	 s3NNk5olMBA+n4cYZlDgkXP6Kpkzsy1euplgmiwq8MBBJt6sAoyJcSfX3KZppJcgrp
	 ZEHFr7ei870lPPn7kOPfwbHeFlyH9xai6ySlNDbDue8U3NCQP7fyV4Z0nRhuA5WeGw
	 okNd0hhGXJgcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/232] spi: tools: Add include folder to .gitignore
Date: Sat, 28 Feb 2026 13:08:59 -0500
Message-ID: <20260228181127.1592657-86-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

