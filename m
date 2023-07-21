Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACC21ED41
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C854C433C8;
	Fri, 21 Jul 2023 18:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965553;
	bh=mB05/jzrqoGMG8ou8bdbwbJqh6ecr80VuouS/LR6CYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXlACRiqlzOHAlHjhqWvYa1tYNnsxa7l3YlI523D2vJMa9IaEvzh3z5fpmlrTZGjh
	 3Na1gzEnv/WATDLTvRfgdzZP399Fkm6p4nVxaHQjt8Br7vHLcyFkfTodqJprls+q+a
	 HrfT4aE7LxAewvxEfUiVvZJ4YJyPauTrh3SIgaSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/532] evm: Fix build warnings
Date: Fri, 21 Jul 2023 17:58:55 +0200
Message-ID: <20230721160616.342546525@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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

[ Upstream commit 996e0a97ebd7b11cb785794e2a83c20c1add9d92 ]

Fix build warnings (function parameters description) for
evm_read_protected_xattrs(), evm_set_key() and evm_verifyxattr().

Fixes: 7626676320f3 ("evm: provide a function to set the EVM key from the kernel") # v4.5+
Fixes: 8314b6732ae4 ("ima: Define new template fields xattrnames, xattrlengths and xattrvalues") # v5.14+
Fixes: 2960e6cb5f7c ("evm: additional parameter to pass integrity cache entry 'iint'") # v3.2+
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 2 +-
 security/integrity/evm/evm_main.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index b862f0f919bfc..99c7452555c3c 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -40,7 +40,7 @@ static const char evm_hmac[] = "hmac(sha1)";
 /**
  * evm_set_key() - set EVM HMAC key from the kernel
  * @key: pointer to a buffer with the key data
- * @size: length of the key data
+ * @keylen: length of the key data
  *
  * This function allows setting the EVM HMAC key from the kernel
  * without using the "encrypted" key subsystem keys. It can be used
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index baddd99c38a43..b0e791e184329 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -324,7 +324,6 @@ int evm_protected_xattr_if_enabled(const char *req_xattr_name)
 /**
  * evm_read_protected_xattrs - read EVM protected xattr names, lengths, values
  * @dentry: dentry of the read xattrs
- * @inode: inode of the read xattrs
  * @buffer: buffer xattr names, lengths or values are copied to
  * @buffer_size: size of buffer
  * @type: n: names, l: lengths, v: values
@@ -396,6 +395,7 @@ int evm_read_protected_xattrs(struct dentry *dentry, u8 *buffer,
  * @xattr_name: requested xattr
  * @xattr_value: requested xattr value
  * @xattr_value_len: requested xattr value length
+ * @iint: inode integrity metadata
  *
  * Calculate the HMAC for the given dentry and verify it against the stored
  * security.evm xattr. For performance, use the xattr value and length
-- 
2.39.2



