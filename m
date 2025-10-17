Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA24533291C;
	Fri, 17 Oct 2025 15:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715078; cv=none; b=nS50jAf+KqkFIEfz6EQPxOWy0TtsUO69SC8NQDHHH7Ku9EbtSmmM1vYdsENcxNwZ8op/x3SThqxnaIZy/tnkMEnh9q37Ve/oKQeUdpuH0IeceYFxSeD8DIR6KkXQoILGE65aUkUF6yOptLZrpzT417qW8P70kV6t1zIdqFKcaFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715078; c=relaxed/simple;
	bh=Xmz8CAKjnqrgMpLfWTPb9To6bjhr6uiTAmEkjZ6mj38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZbdia9foNukHp2F7c0LgpR6PjQASwD2Z7L6Kosg0GBMIW2RkJb5HuKT0lR/BhBNhWuSzrHWrZLIFEW/TAK3CnEHbG2CmH4+p5NtqH5UPtj36E3xm5trv2jBOqY7RRi55/gYSAA0ns8U+LgqPrLHi7bZ6dWPrH5kcW27pLBQqUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J9Efp/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J9Efp/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542BEC4CEFE;
	Fri, 17 Oct 2025 15:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715078;
	bh=Xmz8CAKjnqrgMpLfWTPb9To6bjhr6uiTAmEkjZ6mj38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J9Efp/ioHUcblhbU0WPZBjr7VtGPBB/VnvMxQDRi3BLXvDcXbbN7TC40An77j+cd
	 9ASALmDRkeTPGMLLGwB96wWIAJZcfjgWSrAZY+S0BV64wXJR7eRH7hddYEEoeNdhHZ
	 luPezuBePlNmbCD7fxYBgXMf6VPfgXtygOAaGpfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 057/371] nfsd: ignore ATTR_DELEG when checking ia_valid before notify_change()
Date: Fri, 17 Oct 2025 16:50:32 +0200
Message-ID: <20251017145203.862034497@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 5affb498e70bba3053b835c478a199bf92c99c4d ]

If the only flag left is ATTR_DELEG, then there are no changes to be
made.

Fixes: 7e13f4f8d27d ("nfsd: handle delegated timestamps in SETATTR")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index edf050766e570..3cd3b9e069f4a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -467,7 +467,7 @@ static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
 			return 0;
 	}
 
-	if (!iap->ia_valid)
+	if ((iap->ia_valid & ~ATTR_DELEG) == 0)
 		return 0;
 
 	/*
-- 
2.51.0



