Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D66522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9C7C433C7;
	Sun,  9 Jul 2023 11:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901585;
	bh=bs1Dn+Mzt4E+EfFv6v0zxSgyHyw5B7OXmYAKbMN8Ip0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SBKGpwaSEZk8a5QstxlOg94BKZMvyAgViietYbdMvCsDuymDdo60+vgmBHlpMM47C
	 g9esjTjsWMykgrHWj9fr/5/QSRopdhywbioLsce1SrNTNA+EodBUg0UxQrdH5u22F9
	 j01oMoHSe+6RYYhXlYBiH+WWk7+xyWnJLTgnyJ7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 073/431] evm: Fix build warnings
Date: Sun,  9 Jul 2023 13:10:21 +0200
Message-ID: <20230709111452.864144321@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index 033804f5a5f20..0dae649f3740c 100644
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
index b1c2197473a21..c9b6e2a43478a 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -318,7 +318,6 @@ int evm_protected_xattr_if_enabled(const char *req_xattr_name)
 /**
  * evm_read_protected_xattrs - read EVM protected xattr names, lengths, values
  * @dentry: dentry of the read xattrs
- * @inode: inode of the read xattrs
  * @buffer: buffer xattr names, lengths or values are copied to
  * @buffer_size: size of buffer
  * @type: n: names, l: lengths, v: values
@@ -390,6 +389,7 @@ int evm_read_protected_xattrs(struct dentry *dentry, u8 *buffer,
  * @xattr_name: requested xattr
  * @xattr_value: requested xattr value
  * @xattr_value_len: requested xattr value length
+ * @iint: inode integrity metadata
  *
  * Calculate the HMAC for the given dentry and verify it against the stored
  * security.evm xattr. For performance, use the xattr value and length
-- 
2.39.2



