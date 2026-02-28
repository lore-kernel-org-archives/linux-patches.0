Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58322375241
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301568; cv=none; b=khQSzRD7Z6lOIPvre0HWUYfqyOJ/NP1ha8vZUPeWAwrySLv/Nm6Z1ruiQ3nHjTpdRyyZZxT+hYWa9W2VLsAcr4n2IsImx1XdDpj500ER7zxasHnnhf8Gfj5MX4KYz8w6zO9rzlwUqMZAHTT/9nHZkXduMNQVk+uvutsWtFaMeiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301568; c=relaxed/simple;
	bh=bUDJ3fUVjV/+U9YUBERTHWb4f10F+gfLUFkZ8eYFfRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQkn5XMZb5hLtMbK4b9B2fyj7esWTTnimQVfrNAva1a4kfakEyNlRMMwUBxhb4mXyeBHz0MFP3qBaHuwmad0n/BEG9ak5zqpe39m1BLu+8matnIugKd9mp8IdyvIHG1XgQGOp50cTpz8xU6YP2hzCSqB9CmOE8n/65e5ILLSqWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ben4HJG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ben4HJG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A0FC19423;
	Sat, 28 Feb 2026 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301568;
	bh=bUDJ3fUVjV/+U9YUBERTHWb4f10F+gfLUFkZ8eYFfRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ben4HJG/XmAZSeH5/+TR1N3p9KMPb/TSB+pitZwuRKCRPM+Ux8MCR0GDQIrfA0RCH
	 cEU0s2OkUnTn+K4/vDzqhsKKhZBloRlFJKg/pnqquOPsQwosr8K6c7YJPBgqBbTlAk
	 xAPjrvafWFMIOIGdrf4p9n4I6A7owS/62LTuCbNbwmPELlKzckzci4y8Z4DKAEbGHm
	 FkQpN9rqTTSkvZ3pG6fG+u3NajHCliwL9m883TJt5k8ieOruy2dffOJRI8WWYMDGt3
	 mFWb+AijRtOqUtfetlqXTvZtVUOGvSQorGcxQoiK1Aa0VE03hi4XsXxL6MZw2sfdjH
	 WLLg91aBGHw0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 752/752] Linux 6.18.16-rc1
Date: Sat, 28 Feb 2026 12:47:43 -0500
Message-ID: <20260228174750.1542406-752-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
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
index e4aa2e76ea563..255bb58078bb4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 18
-SUBLEVEL = 15
-EXTRAVERSION =
+SUBLEVEL = 16
+EXTRAVERSION = -rc1
 NAME = Baby Opossum Posse
 
 # *DOCUMENTATION*
-- 
2.51.0

