Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59132154BE0;
	Mon, 10 Mar 2025 17:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628720; cv=none; b=BOermZNinnSpFdUgT8suHjQoXrqLGbd3ebXvkdlBvf3hs8K/jgHXGkd0pmJLzkpwz4JbPHpo10nKr1LsXGDCFExue9slW7MxWWXri+t6giHRgOzmNwvKtKRKkvg4uSxnRTgGPxZGSaLxASOUnaChz1dHu0TZXE/QoqJvmlmArTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628720; c=relaxed/simple;
	bh=eHF1PGkn2I+cPfYz+Nkcvhu9S4yPQsF2nD/52JSrk/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gw9NXPJL+yD7vx4jRvbiqhgGMsKk9r0JbUCVnSk/N1EDiM80xl3TtwISYzDAkcIeH2gOeroZr5JDIpU/arL7mi8M7lD3LK12X/fIUNqZ9t5BKxEJYlRl9tBnqzFAaALo7EbLFqd2ouOqzkGIAFJIdu8i9g/Utw5AWFZpdKuPXfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C++jbXtf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C++jbXtf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33CFC4CEE5;
	Mon, 10 Mar 2025 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628720;
	bh=eHF1PGkn2I+cPfYz+Nkcvhu9S4yPQsF2nD/52JSrk/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C++jbXtfhj0051yaZ9OKwotPTFOhvu1b4/mJV4xDeh0Tan84JUY2sHMwaMdCE6Sfy
	 MhoW4gHSpLWfEF27IOkvdsARuk0+iSiGAu46xGiGQL9twuxlE5aI/hrW2ePT+1D62A
	 cjyTwm0PDWkMXyWcfhP2kXxmjg0OtDnlK/l43RyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 014/620] partitions: ldm: remove the initial kernel-doc notation
Date: Mon, 10 Mar 2025 17:57:40 +0100
Message-ID: <20250310170546.140440057@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8693704dcf5e9..84a66b51cd2ab 100644
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



