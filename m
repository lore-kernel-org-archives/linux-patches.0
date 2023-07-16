Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB688F40
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1327AC433C8;
	Sun, 16 Jul 2023 20:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539602;
	bh=1uN/UOtzFIE/L64BNWX6bk/aKSE64mDvyX0bnS08Tb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OscNLSlpCdEdE/mbELvcxGvxtE7PkVDKmiBRFLFW8NAyGCqQ7e0H3XdGxHIAlkZm+
	 3wu+HbbTwMqxZua3D5FhIoV2u4D6u/MIOii1OwbKq2ltLlgsFg2zKdTZaQexjHwR7/
	 d4tsMVz3jYcc4WmxfTkgzLD/Rhpw+lVHdn4+lwRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/591] ima: Fix build warnings
Date: Sun, 16 Jul 2023 21:43:24 +0200
Message-ID: <20230716194925.561043359@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 95526d13038c2bbddd567a4d8e39fac42484e182 ]

Fix build warnings (function parameters description) for
ima_collect_modsig(), ima_match_policy() and ima_parse_add_rule().

Fixes: 15588227e086 ("ima: Collect modsig") # v5.4+
Fixes: 2fe5d6def167 ("ima: integrity appraisal extension") # v5.14+
Fixes: 4af4662fa4a9 ("integrity: IMA policy") # v3.2+
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_modsig.c | 3 +++
 security/integrity/ima/ima_policy.c | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_modsig.c b/security/integrity/ima/ima_modsig.c
index fb25723c65bc4..3e7bee30080f2 100644
--- a/security/integrity/ima/ima_modsig.c
+++ b/security/integrity/ima/ima_modsig.c
@@ -89,6 +89,9 @@ int ima_read_modsig(enum ima_hooks func, const void *buf, loff_t buf_len,
 
 /**
  * ima_collect_modsig - Calculate the file hash without the appended signature.
+ * @modsig: parsed module signature
+ * @buf: data to verify the signature on
+ * @size: data size
  *
  * Since the modsig is part of the file contents, the hash used in its signature
  * isn't the same one ordinarily calculated by IMA. Therefore PKCS7 code
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 2edff7f58c25c..bdc40535ff489 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -694,6 +694,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
  * @secid: LSM secid of the task to be validated
  * @func: IMA hook identifier
  * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ * @flags: IMA actions to consider (e.g. IMA_MEASURE | IMA_APPRAISE)
  * @pcr: set the pcr to extend
  * @template_desc: the template that should be used for this rule
  * @func_data: func specific data, may be NULL
@@ -1885,7 +1886,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 
 /**
  * ima_parse_add_rule - add a rule to ima_policy_rules
- * @rule - ima measurement policy rule
+ * @rule: ima measurement policy rule
  *
  * Avoid locking by allowing just one writer at a time in ima_write_policy()
  * Returns the length of the rule parsed, an error code on failure
-- 
2.39.2



