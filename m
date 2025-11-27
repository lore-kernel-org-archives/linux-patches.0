Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A5C27F18B;
	Thu, 27 Nov 2025 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255049; cv=none; b=kQEOHet6dg9MxIBaIsMuxZbFWlHfxBvhx8eiSFHBi8Z9G8D4d1+YZ8q4O3y2Mg/vKp+VWPAbb4SJLmV5jsTJouCF8H+JuKO03NPqoUGylfwX6E+WJwGVh7rgXOy/uk4+QqgGNqos2jITenMtwsjk+T/5k8TYasrIl0Ok51Y2WIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255049; c=relaxed/simple;
	bh=f7Pr1ve7g+zUXB4B8Zoc0l3y/nXwIWiKrdAQJ5nZBBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yv5hUv1BR9VUtAUOlXsgh9O68F0WtRvHPljPyPlyAcXS+S+Cj8MxYLiEwnTaztE6IAIndM0jfBLVDfTZ5dd0sJbMETZwxWrgyRiWboTSqb22YrZWShL8zQfkejlh4VnyzVOVytbqL/GYXJ9QOLGqQsToPVx0EEHChVB1PL5SBHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w087hoZt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w087hoZt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACE6C4CEF8;
	Thu, 27 Nov 2025 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255049;
	bh=f7Pr1ve7g+zUXB4B8Zoc0l3y/nXwIWiKrdAQJ5nZBBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w087hoZtadj5Owu4ju4zNMSs3uMfiuGT768NnpgudkQQU9knMAjV3ZAz6fUkXTw/C
	 ORbxQRZlNH0x/LlhFYm5Z2788+L4doSP8CILO9+F9H9zBrjD++OQhWp5AmxmObFSJ9
	 7I7/O/Kx8eYdmeXEwCjIaz7Lyi6oAleaBTBmKUJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Spear <speeddymon@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 59/86] cifs: fix typo in enable_gcm_256 module parameter
Date: Thu, 27 Nov 2025 15:46:15 +0100
Message-ID: <20251127144029.987526607@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2744d5580d195..0461f89c4852e 100644
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



