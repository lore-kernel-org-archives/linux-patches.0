Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABFC39B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302642; cv=none; b=QPXvCotsjPtUb/t12kHHA784Jt7IVf8gW2bmpB0mV86LfaxmF9B0kZNw/qk6Uc4lpUL69rTUgSs/0B8GGMa0WDVw8TBkYXRl4b17Xyf5YPpATMztljsjJDtylRoYOCn7O1NwzXcSTOkI0tiAHgwOHlTdPZ0UEGIX0uU5TYfUtiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302642; c=relaxed/simple;
	bh=/FPONFhLd7z3m+xOjTv6LYn0iqbiD5PZlWojWOkzjb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdLOD7gbwb+TfPOxHoZxmKi5VSVpmAcTO9//qX7RjlBgBpglCpBwtuEfwNbduvPz1QHwXiXr0BfmLvOpPJZgT8ixhu5qN2GRmUrXjRC6NaECxus74fTqZpcrRjZOIxa7DTteSDGFttoAtx3xqCtYex0kmEwwn4sLr7PYVOtgFbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jj3ZGMjQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jj3ZGMjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C671DC116D0;
	Sat, 28 Feb 2026 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302642;
	bh=/FPONFhLd7z3m+xOjTv6LYn0iqbiD5PZlWojWOkzjb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jj3ZGMjQA3t0HfN9vqwYpT6VGxGyfZWj24XcSFMLiRsWyMDBQnRESRVgoyxtOPFQD
	 sGq2WxNz4xyBegmnIUYXcUWvN/Wm4B1QTjeLdJBlvQzhgWSjp6qtuWPBW50kfi43cG
	 +85ZYlSzaO7I5JJi+oDdXUZrFGRdKQrWLErYHI60H70hCiH7WacuS+Z+VGr5VHoG7Z
	 657ZeWMpkk8dg5dLewYoQ9SjlhYVrnC2n8FF9zGf6UV0Aof2zHd6qQ0Hp1USBnjaQy
	 pQ9bkcK74bUGuE6x5cvocsCAmIpuaR3XODXebKQhKYeJAMAeVE58OIYwvegJbX2UQa
	 Flzj0Kjl9ZsHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/164] Linux 5.15.202-rc1
Date: Sat, 28 Feb 2026 13:15:03 -0500
Message-ID: <20260228181505.1600663-164-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 5e3d4c453ed7e..f796f9a5ccaab 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 201
-EXTRAVERSION =
+SUBLEVEL = 202
+EXTRAVERSION = -rc1
 NAME = Trick or Treat
 
 # *DOCUMENTATION*
-- 
2.51.0

