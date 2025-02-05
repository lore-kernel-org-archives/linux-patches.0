Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA3126C18;
	Wed,  5 Feb 2025 13:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763289; cv=none; b=SeMjaRcK0YIqTsqgObG1f18PsQKyuopQB9YcjdoqLoW+DC2ABVuOOy8jXRhd6oV5R3qehsVWRaAkcLNP0F6nIP7o6vnr4ljrbyo6BYOZJ40VlkAUOOdknABpmgnTex5htnikKZz7aJIdkFbLrTY8mXzgZRGZGO0NtbaSCMN4rPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763289; c=relaxed/simple;
	bh=dANetWE4vxK7TbQZkq/E6iIOA3/0ksjPLj5aNY28tTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbYHB1oo+jF+MtoRdg1YzB58ztp0GmDpIZDTE/E//MZwZ8Zo+YSVCc83JlnRIRYglidTH8QUiN/9EjQGXlJu08gkCbnkqBybU4BS+fJQOwiZMY0GixQH9wnKoT++KojiRvMgiewoH+6lR4oXxFf43jYE/EXO801YAf68wjA9pxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnOMHpO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnOMHpO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56614C4CED1;
	Wed,  5 Feb 2025 13:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763288;
	bh=dANetWE4vxK7TbQZkq/E6iIOA3/0ksjPLj5aNY28tTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnOMHpO/v7YAfa6xGCrvA5QwiUGdvoMXnQrkhxxT+ZJJldjURyaVWyKaW4KkUvZwJ
	 CoaDb0pm2brabHAucxNeXwpbbfqu2NVODsiFveNt5XLTV9tAPOdtKcctH5M4zskOQD
	 /hZ2JY4UN5darp8z3Ae2ZYfMmbveHqTH1alwPRHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Richard Russon (FlatCap)" <ldm@flatcap.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/393] partitions: ldm: remove the initial kernel-doc notation
Date: Wed,  5 Feb 2025 14:38:52 +0100
Message-ID: <20250205134420.803684419@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



