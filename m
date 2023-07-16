Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580F8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39092C433C8;
	Sun, 16 Jul 2023 19:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537445;
	bh=Af3akyJZKWEk9jEvFiu/czphOhqfKD4j3CXft1loaus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbVyIIv266UJ0AuL8/XdE4/wcnvjR3/x4ndDhd8EwXxOQo70sjoASUQxune4psCZD
	 ZuBtTBBfnAsyHBZt5yuFVpxHjqGWPDFb/6DJ/D5JhbphNwzXnV8nsYq6p0sBmCvRl5
	 P2L9lg79m/2PZwzK6HLMRK42vNm/SnOr/u0JlLPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 099/800] evm: Complete description of evm_inode_setattr()
Date: Sun, 16 Jul 2023 21:39:12 +0200
Message-ID: <20230716194951.412940955@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit b1de86d4248b273cb12c4cd7d20c08d459519f7d ]

Add the description for missing parameters of evm_inode_setattr() to
avoid the warning arising with W=n compile option.

Fixes: 817b54aa45db ("evm: add evm_inode_setattr to prevent updating an invalid security.evm") # v3.2+
Fixes: c1632a0f1120 ("fs: port ->setattr() to pass mnt_idmap") # v6.3+
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index cf24c5255583c..b1c2197473a21 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -795,7 +795,9 @@ static int evm_attr_change(struct mnt_idmap *idmap,
 
 /**
  * evm_inode_setattr - prevent updating an invalid EVM extended attribute
+ * @idmap: idmap of the mount
  * @dentry: pointer to the affected dentry
+ * @attr: iattr structure containing the new file attributes
  *
  * Permit update of file attributes when files have a valid EVM signature,
  * except in the case of them having an immutable portable signature.
-- 
2.39.2



