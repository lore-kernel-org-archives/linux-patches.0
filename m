Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F8726A0F5;
	Tue,  8 Apr 2025 12:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116761; cv=none; b=PSVs4Tdc9eMsavN4G3AmImilWP9Gy5FTypgLXJ+wQK0cnWszx13KDk2uQ03Av5dLWWjzXicQM8vYpjADXeCppMX8nK4FQFqrpDpVIBd5AJlqEZhg6Yz/zwhLjcNXwm4P+lif2Ro2CVqXb79WC5Ljm02+diBZsjOGiy/DVdy6QEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116761; c=relaxed/simple;
	bh=H3IFkeNqPXc50utagbb2Ki4gnk9PfS6lIikjZkejrGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GooGqThZL75cJPxJV73m6Ef3Ukcie8xvOaRJq2eSnCgAiZ+Ml2GiNORCSPriLVr1jc67v7oHEMsVl6wxuBIZ2brCWQilfnEm/78M7WNbFms6kpzaIxg8LIy1daTXPyRrqTBFgSeIUXLbOPIQRqoELW+mg0ey5VsFzRHDZA3Pr+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RArOJegB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RArOJegB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B81C4CEE5;
	Tue,  8 Apr 2025 12:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116760;
	bh=H3IFkeNqPXc50utagbb2Ki4gnk9PfS6lIikjZkejrGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RArOJegBlLDUY3QuDr77h/kLxLyjaG6FvogkjgqJlHYxP2dhd1MJf74U6zEH8ovdq
	 u5wLg1QgdO5rrs257yqzencBf8uUTfDYMxzWjiQqrHdRf1Ii+G4eF5XewzpOBcr2ck
	 IqHSh2IcBFamvrd1sclQwQGEfxjkNpit4HuHoHk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Lothian <mike@fireburn.co.uk>,
	Elizabeth Figura <zfigura@codeweavers.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/423] ntsync: Set the permissions to be 0666
Date: Tue,  8 Apr 2025 12:49:43 +0200
Message-ID: <20250408104851.729914678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Lothian <mike@fireburn.co.uk>

[ Upstream commit fa2e55811ae25020a5e9b23a8932e67e6d6261a4 ]

This allows ntsync to be usuable by non-root processes out of the box

Signed-off-by: Mike Lothian <mike@fireburn.co.uk>
Reviewed-by: Elizabeth Figura <zfigura@codeweavers.com>
Link: https://lore.kernel.org/r/20250214122759.2629-2-mike@fireburn.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ntsync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/ntsync.c b/drivers/misc/ntsync.c
index 4954553b7baa6..c3ba3f0ebf300 100644
--- a/drivers/misc/ntsync.c
+++ b/drivers/misc/ntsync.c
@@ -238,6 +238,7 @@ static struct miscdevice ntsync_misc = {
 	.minor		= MISC_DYNAMIC_MINOR,
 	.name		= NTSYNC_NAME,
 	.fops		= &ntsync_fops,
+	.mode		= 0666,
 };
 
 module_misc_device(ntsync_misc);
-- 
2.39.5



