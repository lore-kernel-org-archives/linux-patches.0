Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D0F2A1BA;
	Mon, 13 Oct 2025 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368768; cv=none; b=Qt+uFPwZ2nCB42Fs7VE6WCw7a7seg2jfuSQowoSWu//gp83zHIwX2RopH7T5q78Dro+8+T27yhRAQVtZL7mIcb/guuiaOgVqthCgmDM8YFB58G3wiRcSYSAN3Y6muRBcoG1h1uGhhMlfiaphJj0kzG0aD8xV3pt79YVD646afXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368768; c=relaxed/simple;
	bh=GmaWP9eZHmsu1as+u2ulSIRMIQFEqWXfYqrDvvpMYR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awvMQWLrVWykCgDvGmMYTA+ExHy897FNi+OuF+Inc42ubA7UzULQ7MegPPdwUMSpcSXSbJ4x/V5PFKaT8bxKZPu73lUvsCpIHUltdq3a/e/Py3P/Crtv9GdGgF5URN4Azi94X7D+TI6EtHUKJAoep9OMj08wzAoF34P95J3eADw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdtJh8vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdtJh8vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471B2C4AF0B;
	Mon, 13 Oct 2025 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368767;
	bh=GmaWP9eZHmsu1as+u2ulSIRMIQFEqWXfYqrDvvpMYR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdtJh8vNMCAf3a0/6+MXJjxFv38H9jaqrHyVYX6Hg5wMEBPyPtJtAnsXJMk4EiPSG
	 74xwyUYA9fBPdnlXv7pD/FEXoT9bSYOoroB5sF+qe3RDVh/r6nI7Op7rvykBduFTUS
	 w5aUhbNX6zqhADdRb+Ls2xanFtH0A88DBWxhjzu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Andrew Price <anprice@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 013/563] gfs2: Remove space before newline
Date: Mon, 13 Oct 2025 16:37:54 +0200
Message-ID: <20251013144411.772390340@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit aa94ad9ab230d08741e6630a20fd1296b52c1009 ]

There is an extraneous space before a newline in a fs_err message.
Remove it

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Andrew Price <anprice@redhat.com>
Stable-dep-of: bddb53b776fb ("gfs2: Get rid of GLF_INVALIDATE_IN_PROGRESS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index edb105f9da059..3d5cf9c24d78b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -733,7 +733,7 @@ __acquires(&gl->gl_lockref.lock)
 		 */
 		if (ret) {
 			if (cmpxchg(&sdp->sd_log_error, 0, ret)) {
-				fs_err(sdp, "Error %d syncing glock \n", ret);
+				fs_err(sdp, "Error %d syncing glock\n", ret);
 				gfs2_dump_glock(NULL, gl, true);
 			}
 			spin_lock(&gl->gl_lockref.lock);
-- 
2.51.0



