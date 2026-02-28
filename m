Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64CE359A95
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302484; cv=none; b=Z6O18WtuEswQqRzUJRxA1yKxKbfGrsFXhqg7+eEOBZ/sl3UWiU3d4Vgrp4EnQZlv5OT0ZBL+VYjYUaR6LSWwJKNColmrOUeUsUyOqOe0P7wCsUDGq5FRN++I+n4bj6Uf0zlOB1Huusi6oSv4C7qRvl2jXazl3SL/5jckKnFU6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302484; c=relaxed/simple;
	bh=WvMfurgEoCej7spxf2lFsR6qb6NyfAqucJYornctUCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wqylz1TzplE6MyjQ6wAVxkgZWZlp95cZkxIF/cUpsAuZ0wei9YmlwCQG1BOgFPcf4zRKY87w6crtSu3ENcOBhBwfbrzcwtnjngPp5tTUNRbtkt6V/EMHKCwGD+DGxq5XGFXTebKGMaPHfXDt8Ns5tgMG0dJGvIrFjB/nplYET0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DggE4RyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DggE4RyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C97DC19424;
	Sat, 28 Feb 2026 18:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302484;
	bh=WvMfurgEoCej7spxf2lFsR6qb6NyfAqucJYornctUCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DggE4RyQ27WZE7pFySBowLwovGIu9THoIROxtYuO/dEgdzwSpfEIkElyv033RYcUK
	 PU+sacrhlZt34+auaHIb+afpl1StZ5bgeYdPyb5TzLn51IO/rXSZldjfdjYavuE4u6
	 hiOo43uVqAESwCRs3jklIQr8Vgr6idDrDc3ZHx5G0C0C7Jk1gFmQXHG0eZe9k2xY4W
	 1tmt7Nh12LWGLYjbUi9NkNMWfuhfjvDaDW86+jATqxr+AjfqwT6e45XbVHGUgTvJur
	 TRNMkEP5/2u820hUTMM9N5DFpSJ30mCo51zBtlpaXwOLIOVGvDGKvpUkWsuKkMmnV6
	 QarZrD52kXAsw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 232/232] Linux 6.1.165-rc1
Date: Sat, 28 Feb 2026 13:11:25 -0500
Message-ID: <20260228181127.1592657-232-sashal@kernel.org>
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

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index eca6fda434773..6335b71eb7155 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 164
-EXTRAVERSION =
+SUBLEVEL = 165
+EXTRAVERSION = -rc1
 NAME = Curry Ramen
 
 # *DOCUMENTATION*
-- 
2.51.0

