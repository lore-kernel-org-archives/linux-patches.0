Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED30425E817;
	Tue, 11 Mar 2025 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705391; cv=none; b=TkqsGb3VehfyAE9HUkFq9MEMAeB6kdMC2Y5FeSsHhHrUIeISe9QeBAJ8DRdY2YRf4MYVu87jgbec4dGzQAeCC8jB21H81bKwB4H1b1gmupFAxB69mGC8djoDm6LL9VXe+BVCGqnVhJfkDuuAC2Ww/+1pZcurWJyv4I25XOAmO30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705391; c=relaxed/simple;
	bh=0AsxiipOw3W0LsEjgyTrLZLlZpOcp4OdXqSDWh/K+Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS4DAHHpqSR5ch2QNCBMSJzCz7/U67QDvK1rtIOxxt4LRyh87nI8e0XAnzVl6CRN9wTjCCM92ZsOEfAjn7k/0lFaSoWnX44QzzbMQt+OONFG3zLUKyqvy/EvG5auEI6Z5mom3b2D9OK9zaqZL8rNMJwEshBAupPum/+Oeg1qWFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVMZ32tj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVMZ32tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FCDC4CEEA;
	Tue, 11 Mar 2025 15:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705390;
	bh=0AsxiipOw3W0LsEjgyTrLZLlZpOcp4OdXqSDWh/K+Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVMZ32tj/jMfXjpu1Fj2ip/oBxKFVzqLBrWgzeexygsqqsdOCgJan4lJnDK4H08Z8
	 MOh4BAmkkgcaqBQ2JEf8F5h72vBJ3A4iLiZmq0VIYczaMnRAjGPyoZCqmx1xWP6nqw
	 XcV5Kfy5GbODl1IUyUn+kZtUV1mFrIX3Q8FnfFIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/328] partitions: ldm: remove the initial kernel-doc notation
Date: Tue, 11 Mar 2025 15:56:18 +0100
Message-ID: <20250311145715.207499442@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit e494e451611a3de6ae95f99e8339210c157d70fb ]

Remove the file's first comment describing what the file is.
This comment is not in kernel-doc format so it causes a kernel-doc
warning.

ldm.h:13: warning: expecting prototype for ldm(). Prototype was for _FS_PT_LDM_H_() instead

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Russon (FlatCap) <ldm@flatcap.org>
Cc: linux-ntfs-dev@lists.sourceforge.net
Cc: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20250111062758.910458-1-rdunlap@infradead.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/partitions/ldm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/partitions/ldm.h b/block/partitions/ldm.h
index 1ca63e97bcccf..05705ead955ec 100644
--- a/block/partitions/ldm.h
+++ b/block/partitions/ldm.h
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * ldm - Part of the Linux-NTFS project.
  *
  * Copyright (C) 2001,2002 Richard Russon <ldm@flatcap.org>
-- 
2.39.5



