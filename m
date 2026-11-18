Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052685;
	b=CpDiZvsuAU0w2Cm7osK19maKRdMP1tX0KveEJbGZLNrGjzncnzdzwf2Dxf9LFgOzN/Zv
	 y+gNDPcNXtX3wG7OiVe7qGrlrkEUkvowFor6sT5PRjK6edJJoicoWuxABTdPTuBpBPnkb
	 XYWXGiMD1qZg1PW3rOU/ci4uCnAAOcp8FcmbOdc3yGnoEyt4g7FIqM8gqBXbAN1DzUjs+
	 /UznMMRJvYaj1l8eniF6NpYghUzbxYxRSq21h5031HaqMzrfDxnPMzKElYpOl7xmDhju7
	 XOLh7LKA0tDSYgdhio14vvLHc197pLNKUu13fvFK+fiEOQZn1CddS5DADjp5oQunGBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052685;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1xvmVh4SJFMR7c1EFz7cU549BqzFgotlG8h6+u/fov4=;
	b=ZbPNItnCNxx8+L4GKqmIJ3KvCNtlmyCfP85EOcLgy3n5yiiCiJVB7CFY08yXnlQ0WmCV
	 wMEWBVUQpDY44Z7NFNFHsDN17He3caYFdZVU6KBqxBB4Gk9gHFpuwnRUHeGkcBPt/vsHD
	 jhuKSnoXY7XCj3M8QsN/WkaAbbw9z4tL6icUbaqSNCSQLG7+fsiQ99JdSLbPZHASFN8Wz
	 cjGHZ4TPC8qZLtfj5IqmtSlTgIfoeXkKGaplPKD2dwoykLbD2r58x9wK0KzZkEHHQ9JM2
	 3Fu6BtJ0HQ/QR0JL/5kiOverqGrFL6NcTjOJ7E7Is3lmZYPP9QCwyIG5s5vzonm/RcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xi7cD5Le;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0E9606A31C;
	Thu, 19 Nov 2026 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xi7cD5Le
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F021F000C6;
	Thu, 19 Nov 2026 01:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052685;
	bh=1xvmVh4SJFMR7c1EFz7cU549BqzFgotlG8h6+u/fov4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xi7cD5LevH4JwA1yXNh6gJwAcjvP4VjVVN9rFlwsx84i/exw3/cXI1FTzi/CAZU0l
	 N4GgCgrkp2eYx4R16ddJwyCezo4w52YL+nn5/49IKC54XOi6Jl35qUW+0Iac7VSZNs
	 ebePeFIHcSrnQLSc8yVykq/arprtvfMP2ER4ZUTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianyun Gao <jianyungao89@gmail.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0652/2214] dax: Return errors from dax_core_init()
Date: Wed, 18 Nov 2026 15:38:48 +0100
Message-ID: <20261118150037.608651535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianyun Gao <jianyungao89@gmail.com>

[ Upstream commit 4da700e2cadf84a6e858391d5be51d64dcba080f ]

dax_core_init() returns success when either the character device
number allocation or DAX bus registration fails, even though the
error paths have already released the initialized resources.

For modular DAX, this allows the module to remain loaded despite
failed initialization, leaving subsequent users and module removal
to access resources that have already been released.

Return the error code from the failed operation so that module
loading fails rather than reporting successful initialization
after the resources have been released.

Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
Cc: stable@vger.kernel.org
Signed-off-by: Jianyun Gao <jianyungao89@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20261012151857.22534-1-jianyungao89@gmail.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 7610e4a9ac4e2..7ed5ff2eb6c61 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -703,7 +703,7 @@ static int __init dax_core_init(void)
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 err_chrdev:
 	dax_fs_exit();
-	return 0;
+	return rc;
 }
 
 static void __exit dax_core_exit(void)
-- 
2.53.0



