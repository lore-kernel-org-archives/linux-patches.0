Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B19F4E3251;
	Thu, 17 Sep 2026 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659200; cv=none; b=UeADpHhXtOClJMdiPcBdqPvZuH6B3QYjLxOhrytWhn0x2JKzYoS+iyazQQLEzlbB/iI0S/hxV6EdHwJdggKxVcU+9iR1AE6fslnvvflY9TrvS2SBBRLvDttne7JwAozDwSdpy2oRt63kkKUxTEQnArXPd3tQGwZo+bAK4mV4zR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659200; c=relaxed/simple;
	bh=BzizlHacUDjxpQqgPDLZuluLHWZbRz5V5Z9zCgJll9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOGZV3nzmCyYZlYJiUY+GATrcLpeQcaCSyQDSmpKl3VtRjDlj27RoZKHoj56pyRsGpPWuizIVUwG+7DCVPXmnrgLC11r5zFAXYram5wTG1oLJ0G6WCsTJfG+23jojfaw5eR7W7gqwVKLkGXfzK1x0Q4y4Sf5Zp9JeCi4mUqS/PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zvx7Pfuf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zvx7Pfuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44ED1F00898;
	Thu, 17 Sep 2026 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659191;
	bh=zeY8+qLiyJVDGq3itclYuaWuCqFf/BeAnKpxzpN7iMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zvx7PfufORotyxS0gyt/TFl9qFUnYidesgH1/FMwiXCj1xGkoX+kcd6+Yl5axgNBi
	 ZW7wL0pepc25BABGoppbIX8y0dAoeadubLOvaH7LoBABNc7t/OXujObAI0qwSkCMkc
	 Uxk0yUzTBLBkEwGVxBdgL2kQXkM/35u72HEfFe1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 175/733] ksmbd: fix sparc build with atomic work state
Date: Thu, 17 Sep 2026 16:08:03 +0100
Message-ID: <20260917151355.469109046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 636abbe7a66d80e179011a31754d55001cd44f63 ]

Use an unsigned int for the work state so xchg() uses a supported
4-byte operation on sparc.

Fixes: d12168084c8c ("ksmbd: safely drain sessions during logoff")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609021157.8f7Wx34I-lkp@intel.com/
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/ksmbd_work.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 5f1d3ebab4fb5..0844aa929f55d 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -82,7 +82,7 @@ struct ksmbd_work {
 	/* Contiguous SMB2 compression transform owned by this work item. */
 	void				*compress_buf;
 
-	unsigned char			state;
+	unsigned int			state;
 	/* No response for cancelled request */
 	bool                            send_no_response:1;
 	/* Request is encrypted */
-- 
2.53.0



