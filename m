Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B4315667B;
	Wed,  5 Feb 2025 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763878; cv=none; b=o/n+3esz8OPUeblJxqkF72NZdBzBtnfk62+fNZ5tEdVByslUjfPr+WMBQ0h3eqHVAWCNxQA9mWWCn8VTp9Z3m0eHCzwGRPAOPXt1M/aElg3Ce7uDi2hZg8zI0DVlPf2ULej4hh493oVnNSYW/EYOKFVK6qcd4XoM864jQGY7SnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763878; c=relaxed/simple;
	bh=1A3HuEyzr0aAa3F1pTOH/LTUvo4IE5LhpcbfwYHxiTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6AxcKF8qY3kn9uTzt709gK0eaFvb7EOQEt3QkOFhczFTNWfen17wTGd9ovmCzzMNNJJvmvCgXWvFSe0PaqTDYKRGzp5oqBY2ydi2iukYpWl0J3SsYxZgMN7oyOMni0fwGFE5jtgR5KP5nFGFcD3TAAXtmAS49wXi4Ix9ZMoFuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gySmfcdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gySmfcdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B44FC4CED1;
	Wed,  5 Feb 2025 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763877;
	bh=1A3HuEyzr0aAa3F1pTOH/LTUvo4IE5LhpcbfwYHxiTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gySmfcdGQ146meH9tP9bPMheDt4zx9eeKkPF+AumsVrLBhXYFsOgVVWrlLhAemSLS
	 itQMtqpZ7DR+9GcXiKPc+HBzO1ncYeFsNEmMR9kgkYc1SU757vZ5HhGJba9QnJK9l9
	 aTr1NE8SovjqhDBfX2iHNe4EbwgCGG/X7ox3VLO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 026/623] partitions: ldm: remove the initial kernel-doc notation
Date: Wed,  5 Feb 2025 14:36:08 +0100
Message-ID: <20250205134457.228835790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index e259180c89148..aa3bd050d8cdd 100644
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



