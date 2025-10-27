Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCF731B127;
	Mon, 27 Oct 2025 19:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591710; cv=none; b=l6QyxXx96mmF0U/nAJsXmTUEl6l0Qba4TEipgLPcG+Z8GL57VFAiMU/R4l8yasCQaayaFZfsQZvFA0fP856aDtAAkWovbEeWPKU5tpdQNX2P0evf4mXeTuqlz05kCTHmev196uS/5zOt/mo2xgFFJM0YpeQEwHihqKJ8RFXdBC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591710; c=relaxed/simple;
	bh=2p0OLRacqdB4Vz6Abt2wJyX/wpvX8eD3L2ikcbU1Kpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkH7ty+zXGk2er/kfPUAjpZQF0MWRaZzT1O3Q0wsR6+tBzbY4dAq+S26jMJsVpHPyNBIpMxATxVsmg77cogDFL8pIOAnrHmKjTYIoil33qzrEz/PAO4wryHag7tZxHdikcuF40dz1Ky1JaWvH0TB+yOIdr2qctxkCVAwtTiCOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9acUrUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9acUrUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD44C4CEF1;
	Mon, 27 Oct 2025 19:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591710;
	bh=2p0OLRacqdB4Vz6Abt2wJyX/wpvX8eD3L2ikcbU1Kpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9acUrUbuXNTAY3JEW7TZpBYhesln3pzZsI5ZghSJcX/xw+WthjZInO7KhcV1u/AK
	 jJpckJqLWTjo35YUYCU0yJ2GP+e3qtovoNOTRVTG8uRlLxS33206PC+lG/Mldoa+AZ
	 cXN3nrog3XKyaeV5Q0qRZhxnIp5/lflre2xAHNmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 264/332] dlm: check for defined force value in dlm_lockspace_release
Date: Mon, 27 Oct 2025 19:35:17 +0100
Message-ID: <20251027183531.823753839@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6af515c9f3ccec3eb8a262ca86bef2c499d07951 ]

Force values over 3 are undefined, so don't treat them as 3.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 624617c12250a..db33e521556e3 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -783,7 +783,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force != 3 && dlm_user_daemon_available())
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
-- 
2.51.0



