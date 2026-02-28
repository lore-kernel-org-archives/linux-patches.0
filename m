Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DB233A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301946; cv=none; b=nCezMwYF+XYqloplx3Gqgtti6k4sVtc69KfPKPedAeJRTUfW9EBQ3M3wxqnExSDaynkLSA7nNNQaLsgXC+YM/z8/8Z/jTpXpJ0/4tsYNRwsjh+wYn6w3jrn2sg3rRkL+gk2KVS1oEdlHUX4OAMGIBMYnkBDwozQhO+hODOwudJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301946; c=relaxed/simple;
	bh=3k8mCkf0qZaS5n7KqrSw2SJrSZZ6xaew0iedJRJ16Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQCID+NctpcvZbC2WHuB17GbK+53ObOPMjkNIGfx+/wuiD8/5X4TTJtcp+YmEFVjdwPfI6W73hN3BWml9Obiuth+pH3cIE5WgLMx142J0dCXjbrvrbGVSAML7862GmU2BheRul/n9XnR9Z6dUuA0/zrRjyym+0UM6Dw15w3TBjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giDEApqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giDEApqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4644DC19423;
	Sat, 28 Feb 2026 18:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301946;
	bh=3k8mCkf0qZaS5n7KqrSw2SJrSZZ6xaew0iedJRJ16Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giDEApqpiYaVPGQeJNH/WgQ3sM+MYFU8iUHWynrbgmNwFtSap7nXWHEQPX6521wjD
	 FXMR9E9Y7Z7f8eqB6/5c9/lBQGk1AWmMEJJBmMz1SrMMzHR/l6XnTKVLQvP8yAA5Sw
	 0gyGDCIoRP09+zUweA49qroGoba4AaRkZIjiJcoPQDe8R4TMwMsMmHmPaInyCdEyta
	 vMJGZfUgkERnm+ta5o1kcjpmPwtPy/Dd4LLFPkoZ7DM5iyHBaSGcLX9qhYaQqG9ZmM
	 DIP5apqXVgahoKXz1R07St7YD5Pl5k3mmpDzl3qxZmtNDimM0GEwsk8/5xjxQowjR9
	 2IYLKe7OHQBpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 385/385] Linux 6.12.75-rc1
Date: Sat, 28 Feb 2026 13:00:07 -0500
Message-ID: <20260228180011.1568201-385-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 4193928df50c8..698e6ae8200d9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,8 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 12
-SUBLEVEL = 74
-EXTRAVERSION =
+SUBLEVEL = 75
+EXTRAVERSION = -rc1
 NAME = Baby Opossum Posse
 
 # *DOCUMENTATION*
-- 
2.51.0

