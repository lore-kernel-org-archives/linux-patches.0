Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF92E1A315E;
	Wed, 19 Feb 2025 09:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956029; cv=none; b=MQrzxfoWFhG6imcbZgnMm/wme+fuCQCRAp2UxUCFUWBBC/QmQTTOJ5mmdlhYiribBYb2ltkl7Jb7riTkc27vbDAh42f34brsPFlBQackY8NdUYzS2yya8itWo6TmzSAcahUMUSZ87suAWBg8ofvoAq805lr4i26ywG8yP9PAFKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956029; c=relaxed/simple;
	bh=alKQu8aUTswDDHY9XuOpsjXbqwBj2L/YC+lwURUYX9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogkidMhoF9tTCaCrzjNvyTNzGVZ17KrB3DPZIgF6SMl8kwdoeOk10kTO+UmKmWxFjZCbQDq1Nx+Tz5q2XALIPATTqs432iUeJ/roXO/IW2zqe2nIIYWfc8QWwQOiPJciy5H7LDM+Sn29UTMsf8TQp/Yt4LlhheU/29CN6Mf9lEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jiSCSrnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jiSCSrnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B29C4CED1;
	Wed, 19 Feb 2025 09:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956029;
	bh=alKQu8aUTswDDHY9XuOpsjXbqwBj2L/YC+lwURUYX9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jiSCSrnwVTh36dHeYTIFidXoM9NaiGwh3Y8DKdGxVaE0fKWUA2BPXa//QK80zXpTm
	 DWvhEd3DmuVIVSoesrMnHZ+kWTArIm6kRuP+BB7qQVcA290GsUYlTra1q+dXRkm+d5
	 stRxqoWjTWJIf2Ns/5jP8WkSJymyRYidwgz/bOfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/578] partitions: ldm: remove the initial kernel-doc notation
Date: Wed, 19 Feb 2025 09:20:14 +0100
Message-ID: <20250219082653.301541884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0a747a0c782d5..f98dbee941497 100644
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



