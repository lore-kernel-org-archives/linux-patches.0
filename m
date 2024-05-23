Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1941D545;
	Thu, 23 May 2024 13:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470628; cv=none; b=g9RoBNvQV2FSFgIJfhz/JlTVQbRppNAo6pWZLrj94opQTAJ5twO/rAeYxk74IRbcU1qPZFeMByAggGy9p7moa4otX929cBVwkJMbgEB43a2v6za8ufk5Y98ckvCPzDLxSLyBda4oNwyiCjsdptTHfinH47qsLuUP7kRyKkg4/nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470628; c=relaxed/simple;
	bh=G/4CFnU4oKnu4him1nE1CHQwar0YqmzaoFZ1r8NMmlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcsIzXBg+RIz0xvbpvD2rmJmBZ1+srDfEUq/QFdnmt/UOhgO6CjoZ0P1EA48Xo/IxxO9DYN5UD65kugqP298rV4oT0PW85oLwQOKM5xKfIrd3rF2h4v2o39M/jJARAI8YxS2dPwJxOakw4kjVgpHo4nDPpyxO9FcT/GQEvCZOL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfRsb9yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfRsb9yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755C4C2BD10;
	Thu, 23 May 2024 13:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470627;
	bh=G/4CFnU4oKnu4him1nE1CHQwar0YqmzaoFZ1r8NMmlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfRsb9yg/jSfMOayO3VSKDvf649RKww4WJ7wM4g9fGz2/QuvbVGUsT15jeOX7zjiW
	 9/NkjJ6Of8bjLV7R/vnlSTJZ8IqE9oVePhToNcj7/pZ2Zkz9FhRyYelTbF/3OuoiM6
	 nDHbhi0jOxY96pULYNNkHktpoRs0GfDbOX2qls+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/102] smb: client: delete "true", "false" defines
Date: Thu, 23 May 2024 15:12:58 +0200
Message-ID: <20240523130343.712882109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
References: <20240523130342.462912131@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexey Dobriyan <adobriyan@gmail.com>

[ Upstream commit 5d390df3bdd13d178eb2e02e60e9a480f7103f7b ]

Kernel has its own official true/false definitions.

The defines aren't even used in this file.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbencrypt.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/smb/client/smbencrypt.c b/fs/smb/client/smbencrypt.c
index f0ce26414f173..1d1ee9f18f373 100644
--- a/fs/smb/client/smbencrypt.c
+++ b/fs/smb/client/smbencrypt.c
@@ -26,13 +26,6 @@
 #include "cifsproto.h"
 #include "../common/md4.h"
 
-#ifndef false
-#define false 0
-#endif
-#ifndef true
-#define true 1
-#endif
-
 /* following came from the other byteorder.h to avoid include conflicts */
 #define CVAL(buf,pos) (((unsigned char *)(buf))[pos])
 #define SSVALX(buf,pos,val) (CVAL(buf,pos)=(val)&0xFF,CVAL(buf,pos+1)=(val)>>8)
-- 
2.43.0



