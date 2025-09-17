Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7C93161B0;
	Wed, 17 Sep 2025 12:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113649; cv=none; b=AXcDnOMrYeTlCD9a9d8uuzlPMoc6Y3RhABO8y2oxIfhDWfvgJZTFN4qyz95VzNGWVb38zNwt3PeScLcX2Tl1iwzCR99afEft45dQ9M5W9LiG/4DPAMjko5wo5hvS1UVDSPf2uuE9Lnb0iWQkN5geOxGlHlPvz62s1Q01u9So7fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113649; c=relaxed/simple;
	bh=0+4LrkrBjhe4ZEx9HIkujFHxCwzv9fkvi8dTN/EnKy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BahQKhAixvae5bp/n1H0zOrOU1YNpW63lrgCYEnlhWHlLBtzBaXnX/32uMo1etXy1o3uB9XlEA4dj+JHSyUSdXwqlohW8LSW2jtzWdwDaLvK+nB2aAFO5Dwy4D8onnr3PVe93fgUNmjUOELLs5K9lO4UQQjM+iXl0jHukEiovos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=grl6tgMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="grl6tgMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EEBC4CEFA;
	Wed, 17 Sep 2025 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113649;
	bh=0+4LrkrBjhe4ZEx9HIkujFHxCwzv9fkvi8dTN/EnKy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=grl6tgMcuUf//IrjEVoCNgKPM03hw3y1z8qb530nadhOPB2UqVRXsNNcWYgyTKbhp
	 D/ZbjcGWYQCWI159G9cjmrut1VxWa3TLpq//ZO46ycqQcdojZQkUj93TzomTcLcGX9
	 TEZID1SgARwf2WSzLKDIHwKbyq43w4nB4eoB4WBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Haiden <scott.b.haiden@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/101] NFSv4: Dont clear capabilities that wont be reset
Date: Wed, 17 Sep 2025 14:33:54 +0200
Message-ID: <20250917123337.140028537@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 31f1a960ad1a14def94fa0b8c25d62b4c032813f ]

Don't clear the capabilities that are not going to get reset by the call
to _nfs4_server_capabilities().

Reported-by: Scott Haiden <scott.b.haiden@gmail.com>
Fixes: b01f21cacde9 ("NFS: Fix the setting of capabilities when automounting a new filesystem")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6debcfc63222d..bc1eaabaf2c30 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3951,7 +3951,6 @@ int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
 	};
 	int err;
 
-	nfs_server_set_init_caps(server);
 	do {
 		err = nfs4_handle_exception(server,
 				_nfs4_server_capabilities(server, fhandle),
-- 
2.51.0



