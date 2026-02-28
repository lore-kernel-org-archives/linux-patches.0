Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BD633AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302774; cv=none; b=sHaMHPSMqgSP8BV4nQul1kZC1zUucssGWAxMm3iquNQ5yzGVOtV2u4Pt9wZz5d6pkIhmqjWy228/7GX1P05VlWTCzlU39z87BjqWiUcEaHkr6EDhCD7AuXYlrFYH9G0cwN9EV7HLi1b6TlNm7B8fMRgGyU5JenJ5A0pDIWoadBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302774; c=relaxed/simple;
	bh=cpIyRYFubB1PfcDU3SDE/6REKdfXFpu0WJcEjLE0AG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVdOZvaPF76bh9cAD80V/ZZHj0K1zxQ7RovbevJlXUrWe2gnQbvy46wGyvaxbVASJLr2jnG81qbnIlG2A/Kg6Z2WrQz4VNQSRWlvIiodIzSR9TmFdZ+Mj2StbvYFAzrShZGYLpMJtZSw3lcLhmRRuIIsT6iiUkQEnGuwlJ55cLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA1sPZER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA1sPZER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB41C116D0;
	Sat, 28 Feb 2026 18:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302774;
	bh=cpIyRYFubB1PfcDU3SDE/6REKdfXFpu0WJcEjLE0AG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NA1sPZERn6KCXlPp5/kxTxaCAltsgU2sgDA7QrawXhdiDyQfrGaRXNBzDtGjjN9xb
	 Ufcyoo4PtymkCQarqMqqh7715Y24WV8S1qH/sa6G0TWMwZ5MyUw9u/qW14Dt9YauWe
	 6HmKW9sTjiTEFDElBH752S7t/daHv/9l4qsa7M4ZTynGGXBD0b6eGQxqmm50lmkbbQ
	 VxFjFuKEzYLhgV1mwoAKypPiappAglQJJNsTywCbevx/JLbVwqa+nfPNZOZqPrkuvJ
	 KtGLWHnSlob6zY2xul2gzfXZE7/rKe3bibaGhyeioismpoZmqvqhqqcWc9c5mv6hk+
	 4LJz1dKRsxbJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/147] Linux 5.10.252-rc1
Date: Sat, 28 Feb 2026 13:17:35 -0500
Message-ID: <20260228181736.1605592-147-sashal@kernel.org>
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

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 03bae5ace9e77..ebe7308e3b80b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 251
-EXTRAVERSION =
+SUBLEVEL = 252
+EXTRAVERSION = -rc1
 NAME = Dare mighty things
 
 # *DOCUMENTATION*
-- 
2.51.0

