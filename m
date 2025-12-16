Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DF231ED9A;
	Tue, 16 Dec 2025 11:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884512; cv=none; b=Notg3e/NuV0m46CLnLPCnsrHo8gEcezsMfoVP0fRHXg/QR9kfLTggNKmaFk6iLjhurlGgCkO8JardbhmhyBrkKWM+B15Fb5HJiFXks4xeEdqxbsSZGwxZdBnLzX/o0+YIMifGXFYIFgpMeUcHVnsfkQz2n7fxWiY8+66FOiI6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884512; c=relaxed/simple;
	bh=J0buNbhCdodVZBU+/MBR6C+ayutUFc+r5/ONxCldvqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKIg4m8e4EqNGeGCZm1w4dZ86LydtenzItCN9KKOY6tqrfxfnDteANWYGhFHupNYmbbr1tob5jTXxPG40RrTVofpVKWbvq1Iovrb0h36fZ6wdw60kcaHjgdiuwhS0JxPWSaFZlMbuIHWL60w4XgSNBgMtfgT9KU39shhqqIhx+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+OqlU7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+OqlU7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB83C4CEF1;
	Tue, 16 Dec 2025 11:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884512;
	bh=J0buNbhCdodVZBU+/MBR6C+ayutUFc+r5/ONxCldvqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+OqlU7a1F+3LI8h7Bcvo/Cu5HNgHIMpKpmznEr08DYG53QZGUQJOJxTl7lOyt0De
	 Y3o0wl9DQckVfT8QuWcVAMXQhSim+Jk64eIg+Rqb2zFoIofZMH75XoDC2rxFSrAUKE
	 3cSphMu+/fDzpfdI0pKJdt/IayNsYfn15RZWsqDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/354] firmware: stratix10-svc: fix make htmldocs warning for stratix10_svc
Date: Tue, 16 Dec 2025 12:13:04 +0100
Message-ID: <20251216111328.780306106@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

[ Upstream commit 377441d53a2df61b105e823b335010cd4f1a6e56 ]

Fix this warning that was generated from "make htmldocs":

WARNING: drivers/firmware/stratix10-svc.c:58 struct member 'intel_svc_fcs'
not described in 'stratix10_svc'

Fixes: e6281c26674e ("firmware: stratix10-svc: Add support for FCS")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/linux-next/20251106145941.37920e97@canb.auug.org.au/
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://patch.msgid.link/20251114185815.358423-1-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 554b6b95187b4..4627a00a5590b 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -52,6 +52,7 @@ struct stratix10_svc_chan;
 /**
  * struct stratix10_svc - svc private data
  * @stratix10_svc_rsu: pointer to stratix10 RSU device
+ * @intel_svc_fcs: pointer to the FCS device
  */
 struct stratix10_svc {
 	struct platform_device *stratix10_svc_rsu;
-- 
2.51.0



