Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA00624E4A8;
	Thu, 27 Nov 2025 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255957; cv=none; b=A0PRaYh5/j4CuyxCI/db1EMs+Dk0VvVr6I5MpcmicJJYu6OObM5ex2VzNpg6SMuUd3I+7NFRq+QUgcvJ4JtWYndD1atIX5OuZ8Y1tA1FKY0aQp6dqng7SCsfK9gMptCdIcn4krD/GeXf70gMbRLhEgcna2/KhaEzwLnhA8Iw8gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255957; c=relaxed/simple;
	bh=48sIomVFUQPPuXBQuXp6DAtX2H3jyqpqJR6USRouRoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai9/a9UNvvdhMLSSeuuoje8Oy9JLpkyO1ma/2FxMb307crtJKRx3/eWxE8JPLyWti1Mk/IvecCpAD+39ucFV1DvthioMbLfgCLb+wkBgf586IdwcToHI6pd49TJRRVRH+u263OmOUcGFk4LzViSd9ELBacSfL1mje/qRXEJCLz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXcrtgOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXcrtgOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32236C4CEF8;
	Thu, 27 Nov 2025 15:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255957;
	bh=48sIomVFUQPPuXBQuXp6DAtX2H3jyqpqJR6USRouRoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXcrtgOEpwSSnNyE2JTfI5u6/ziN3gfs21fpn/0lLjNr/Gl9+R5R4xKXzf96lxTqp
	 LDPfYo0XZp+d3m5w+53+q0f8aNZxpIYPlaY5E4Jwsg7pNgUtPd4e0SnSERgE018BzH
	 Ti+6iaBV+yXaByYx7kzBFSgdDqw3RDP/4qk/fGwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Spear <speeddymon@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 140/175] cifs: fix typo in enable_gcm_256 module parameter
Date: Thu, 27 Nov 2025 15:46:33 +0100
Message-ID: <20251127144048.071359400@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

[ Upstream commit f765fdfcd8b5bce92c6aa1a517ff549529ddf590 ]

Fix typo in description of enable_gcm_256 module parameter

Suggested-by: Thomas Spear <speeddymon@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index e1848276bab41..984545cfe30b7 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -133,7 +133,7 @@ module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/1");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");
-- 
2.51.0



