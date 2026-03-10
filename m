Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8918B38758D;
	Tue, 10 Mar 2026 11:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141306; cv=none; b=nsgOOpes5U7UUWx/SlUcLORRsGkxatJfed2FYw8YWiyEmP3z1DFqHDgqha6hksOUiVrUEj2zq1Foz2uJ0gClip4EAwYjUIJxvVPV2aZddfmAox9XWUe3O7vCQn65mnaUTd+GyULykFEmbjOcljOry6EQwDua4hmEl4JGxznRf2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141306; c=relaxed/simple;
	bh=aHdPSN20W67Q+3u478jZGIKVX9CZJfZX+cE1kVXfDvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqJKT/0u701OfElRBzVHaNrerFsm0blCGnSe6LB13UIKmKp4KZBS2O/EDWVkx/z8ZhW04JD1/Wjo9+E30r01tJCZu2x7fIY0rHRQ+syFVyEdvv5cn5NQ21xpwZtQZFeiYCZljx1Ask+J6K5/E95wc/C6l3mX+hDBCk5wmIJYC/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGclSuCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGclSuCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BB0C2BC9E;
	Tue, 10 Mar 2026 11:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141306;
	bh=aHdPSN20W67Q+3u478jZGIKVX9CZJfZX+cE1kVXfDvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGclSuCBuPvp1lUX3c4NJm6FXM4SLZfFDrC24oHLy8XuU+5DOw2CewubRqmx7daYI
	 MhL5/1h+51ctL8v9u9+1ervkiQIOiyky0f4Mtph8LGmeKMIaKq5VguUZs3+ece3bIf
	 3WfeUhKL+WuJWSdQZghRdPJfJrmfPkNatxGuOhi6n0djzIMM3BazYXIz/P8CDUdARX
	 0MOVXSplCiI6hR1weFXaI6RNLcf4Ia0oqym71iowzprNrBhBz1uB3PB+mGiB0jdOD1
	 WICj+ZPdZV2EMknWwNyF1TvEHkXpebo1vWaENw5eIIpM+jZGjX3zwygv+LQLgFtlK/
	 wDn4I9yBIIAqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 311/311] Linux 6.19.7-rc1
Date: Tue, 10 Mar 2026 07:05:58 -0400
Message-ID: <2867504d9c53260444ef95c17adeebb724395237.1773140656.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index faab511ef38c0..10167f6e68a0f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 19
-SUBLEVEL = 6
-EXTRAVERSION =
+SUBLEVEL = 7
+EXTRAVERSION = -rc1
 NAME = Baby Opossum Posse
 
 # *DOCUMENTATION*
-- 
2.51.0

