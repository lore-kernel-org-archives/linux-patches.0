Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4463A25C6ED;
	Tue, 11 Mar 2025 15:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706333; cv=none; b=qdt4eA69UReZfHKM4k/1KvXXoxMf53pnyMAfLsKDWS+Lk3tEbWsWXGgR6i0N71T/dRmV4T6ffAzIcUrKuVKAWm3bT93c7TOI15oE6j6GRDBAosBFGZcpeoVMxtu4UmfBDGSCKO473Hr+gQB7LuMsQC60wEHDI7+VzhYDgs0gBx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706333; c=relaxed/simple;
	bh=3TmBcZWRER99nuczwGNegVQY50T8/D6HZBw/hyIBMpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJePBIahh2ICPGBHs4o883KZcB+yuhE6qPvaISjVa1ORtivghWxwLzmw2IWM+qqd8YgIO+1SEyRrElkZeGPzEksyld+qisTVsI6Gvqa5q5oxsTZRfpYApbatiZLUs8Mb8BCE3vOeZDYCr/bU9Gu4gcYxZr8OPfeRiJugkfE1Sg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RASKpL2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RASKpL2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA3FC4CEE9;
	Tue, 11 Mar 2025 15:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706333;
	bh=3TmBcZWRER99nuczwGNegVQY50T8/D6HZBw/hyIBMpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RASKpL2SwBJlaoTC0hiZPZ3r/sVX0qYgvKGrTHs0A/7aoupTqi7tuA9YpHoJHw8ku
	 gwW1ZeN7hwUpEs3tC+8kGfDXUMqxyE7TlyukjmaY8HD9jIt6sQfa3J8+mc+9lKhWoS
	 ZiA9t/DoSMiqGnlHd9duU2yl5OEtZy+dc8KsyVUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/462] partitions: ldm: remove the initial kernel-doc notation
Date: Tue, 11 Mar 2025 15:54:31 +0100
Message-ID: <20250311145758.563836381@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



