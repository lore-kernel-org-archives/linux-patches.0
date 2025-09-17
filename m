Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF0D7335957;
	Wed, 17 Sep 2025 12:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113978; cv=none; b=QI71m4BUmO9pXq5NlHniwZcs7WXG2nfQ05uB8V+bsthB4wzEi9BlnuH57XKDblUBm75ChzYtrEkqQHQ+6XTQAsLjsVTEokT/BAvKOeXXrie/4vVmIhd1K77zqxQ4V6SSIsmruRGNa3r0RRg0Ngi1oCWbqtYie+NLq/HFkVElHzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113978; c=relaxed/simple;
	bh=WOri9CPEspaHYvq0r2M8epBJ3Gd24wovBUVyyELI9CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5xb0U54LaT1SCW7u9KfegWQ9TuI9wfeVntYqGjAaFaym5m4FhfzgJ7bjKeWtBMPftMqWtSLJlwLLRhEQ90UhAA+xhvq8BOwsPGjyVL3E3ia+9bq1kCuYP1wSUKxlhejVUUmPHSbLF1koNRmmqIOP9GaBfM/LDwMvCQ7olC9N5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dYU9N7a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dYU9N7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27086C4CEF0;
	Wed, 17 Sep 2025 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113977;
	bh=WOri9CPEspaHYvq0r2M8epBJ3Gd24wovBUVyyELI9CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dYU9N7aN2fpiiPWC3cCP3lg+K11TKtSn8zcDaNKZup54iwtMBvUupFgxfvof0xng
	 ze1+EC6sQOZ6i+yCHq8Vua84Z+0qF6d28pMgIUPPAtLLN90DbMc2AII92ELzmfUgMd
	 ZKKB7W0DDKa52U7ml2O/RpajSnGFezYS7k/RQDfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Haiden <scott.b.haiden@gmail.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/78] NFSv4: Dont clear capabilities that wont be reset
Date: Wed, 17 Sep 2025 14:34:31 +0200
Message-ID: <20250917123329.821830329@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 71e96fddc6cb5..29f189dc334fd 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3957,7 +3957,6 @@ int nfs4_server_capabilities(struct nfs_server *server, struct nfs_fh *fhandle)
 	};
 	int err;
 
-	nfs_server_set_init_caps(server);
 	do {
 		err = nfs4_handle_exception(server,
 				_nfs4_server_capabilities(server, fhandle),
-- 
2.51.0



