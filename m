Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F9C41C307;
	Tue, 10 Mar 2026 11:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142224; cv=none; b=JPlzF+Dx9X88Fi8qmNd6cH+VAVVouhZ9RUK/lYi0IodLVMop1huil8kK/QQPBQFCDDUKXv9q+j/rQ9PyTMcXhdfKv9Nlovm/xs2rv+MnFt7B4zfBgnJrFrRNecWtGXhiUHkx3jsVgJfezOas5nBd7dmUtYbYJ4ma9PKiHVT4hfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142224; c=relaxed/simple;
	bh=kznOSeB2M2LYqECj+f8jbs/4Y98WrvJVnIRq3fEwcFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChJvDjjxqZfMALH2KqDE+aiS7dXiZz15OFzbWLGaBdeCny+a3Ie7Xj/OtKWK/53RpSoyzTnjlNoVcNXmTOQqY9ecap3iwEfObPbzLlGOfUBFx3c4hplw3Y+TxQzUW1ZlCniWW6qcRNj4OUiB95P/qUH+0JmFfUZ8D/Qua02GFk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIPdWzXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIPdWzXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFBBC19423;
	Tue, 10 Mar 2026 11:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142224;
	bh=kznOSeB2M2LYqECj+f8jbs/4Y98WrvJVnIRq3fEwcFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIPdWzXgENTI+dY4WNTOlBXwuTh1ULp7dJkoSZIAbjjcMh6MJRC8pVvFQ4IoFLHAg
	 BzIFRwSF7XNUW1n8NTQcsTniyyhuHOgXtLtoDCV1G8QWGI/+4xAt5+cZxCVfGJRsc2
	 A/D4mdtBfRdFNc1G3TXZC0e4VQhynGPVm+Tpgn2CMBPkN/Xv0q9dSrg8OkCZp5m1hR
	 jHSplVBb+uHihafJyI2BqEmf5zLjVzDIsLbrQdjvs5zly599Vbf3bsBBJid/yFfTa7
	 mle3PiaXIGrol6MYfVQCm3Oe6rhofywLuhmzEpO+PIYHgLfkZT+gTbQ4fo4MFEEFpe
	 Ygj3H8lGSxdPA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/314] Linux 6.18.17-rc1
Date: Tue, 10 Mar 2026 07:19:33 -0400
Message-ID: <c86e53b5f7797099e5c89a0c3f43de859d8ec1ec.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 35c1fcb095717..45fde0552cd9d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 18
-SUBLEVEL = 16
-EXTRAVERSION =
+SUBLEVEL = 17
+EXTRAVERSION = -rc1
 NAME = Baby Opossum Posse
 
 # *DOCUMENTATION*
-- 
2.51.0

