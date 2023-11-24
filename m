Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B033CFD;
	Fri, 24 Nov 2023 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+0C/t6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD87C433C8;
	Fri, 24 Nov 2023 18:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849977;
	bh=dc/rL+Kk0iF4uNnMbJNdHuBvjfxgfze4P+SpMljHdF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+0C/t6ea1FjW5OG6yPdexo9uemNpk3EnlgkciXwGAlURR5AxPDMkxNW+MFqHO1g+
	 4ZocPj/+Znh6uMCZX00J558ZkexFmpVkUQTfzoWOi8D7oBquT3aWpJm2fDh98vC3k2
	 Nhx8k1nlfJJ9kNnt4xW0KzaPGFU60AtmGDJEMYFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 396/530] apparmor: Fix kernel-doc warnings in apparmor/lib.c
Date: Fri, 24 Nov 2023 17:49:22 +0000
Message-ID: <20231124172040.076167311@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 8921482286116af193980f04f2f2755775a410a5 ]

Fix kernel-doc warnings:

security/apparmor/lib.c:33: warning: Excess function parameter
'str' description in 'aa_free_str_table'
security/apparmor/lib.c:33: warning: Function parameter or member
't' not described in 'aa_free_str_table'
security/apparmor/lib.c:94: warning: Function parameter or
member 'n' not described in 'skipn_spaces'
security/apparmor/lib.c:390: warning: Excess function parameter
'deny' description in 'aa_check_perms'

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 157a3537d6bc ("apparmor: Fix regression in mount mediation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index a630c951bb3b8..8e1073477c096 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -27,7 +27,7 @@ struct aa_perms allperms = { .allow = ALL_PERMS_MASK,
 
 /**
  * aa_free_str_table - free entries str table
- * @str: the string table to free  (MAYBE NULL)
+ * @t: the string table to free  (MAYBE NULL)
  */
 void aa_free_str_table(struct aa_str_table *t)
 {
@@ -85,6 +85,7 @@ char *aa_split_fqname(char *fqname, char **ns_name)
 /**
  * skipn_spaces - Removes leading whitespace from @str.
  * @str: The string to be stripped.
+ * @n: length of str to parse, will stop at \0 if encountered before n
  *
  * Returns a pointer to the first non-whitespace character in @str.
  * if all whitespace will return NULL
@@ -371,7 +372,6 @@ int aa_profile_label_perm(struct aa_profile *profile, struct aa_profile *target,
  * @profile: profile being checked
  * @perms: perms computed for the request
  * @request: requested perms
- * @deny: Returns: explicit deny set
  * @sa: initialized audit structure (MAY BE NULL if not auditing)
  * @cb: callback fn for type specific fields (MAY BE NULL)
  *
-- 
2.42.0



