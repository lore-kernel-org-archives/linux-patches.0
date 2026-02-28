Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1DC35AC01
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302693; cv=none; b=RtWIRh4t47I4zeFflHUGvu0NKV7rcAc2KwvVZMOt10lZ/a0HVDasNgxo1i73DIXwtSqOSQCgVkUwe8WFRcmL5/a99FkH2F3+n7WVyIavMf6MqYR1JP1M9ZxNJl4wYXl/xA81DOi4vBAUGAsGv8/AooOGeMdn3kUlDlVTgGL+vIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302693; c=relaxed/simple;
	bh=j0IWsAu2YEKV/ost24opFd4rdfDRngzmJL4Mivcb5nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYOK5IvcpsjOEUsdG4nqI/Z6ChDO0xr2fKsKp92hxhXAr0qGP37yn2FNlNiNujlPGNkHDSX1Q5ePEp+p/AtPC+2zsGZiDpLThprfQvXdHJSYc2/eFLJ7J+IjCKXydr9nO8AFQd88h9UXAK4ao1yvY7eZWC2bQDkE/B4b4JbnhDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/3NQ9EJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/3NQ9EJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A508BC19423;
	Sat, 28 Feb 2026 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302693;
	bh=j0IWsAu2YEKV/ost24opFd4rdfDRngzmJL4Mivcb5nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/3NQ9EJq5LSkvPDOe7wMEvVwewkmh7Wgu8r9y/cOGb3maHxBy2cpDQaiPSmSmVB0
	 3XpdIWgJZ6eoZIChMVvrD9ZvNOO5G9w0+v3xLsR4BTVoCUPNU1Isq99udp8FBjnpvL
	 USPOzdXmxjlfTYh6JiTc9+UEl3ItfYW3eU9zvTeH7XX4D2qAP6JtwzFuGj+IoBHe7O
	 OA1Ad+MpZIVocsF5Z5UL+evdEHZyAngPVG3NFsLpH9R//QipvQYuZxRcNb0MJTe1Jb
	 JQ3CEpe0mT50m9F+mgQpJpSY+5WpCw4cq5kqe4YvXH62uVeKF2abDLNeMYcQHN7vQS
	 /syD2ZnZz5CuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/147] smack: /smack/doi must be > 0
Date: Sat, 28 Feb 2026 13:15:55 -0500
Message-ID: <20260228181736.1605592-47-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit 19c013e1551bf51e1493da1270841d60e4fd3f15 ]

/smack/doi allows writing and keeping negative doi values.
Correct values are 0 < doi <= (max 32-bit positive integer)

(2008-02-04, Casey Schaufler)
Fixes: e114e473771c ("Smack: Simplified Mandatory Access Control Kernel")

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smackfs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index 6402626e47c69..c9de9e9bfe63e 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -138,7 +138,7 @@ struct smack_parsed_rule {
 	int			smk_access2;
 };
 
-static int smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
+static u32 smk_cipso_doi_value = SMACK_CIPSO_DOI_DEFAULT;
 
 /*
  * Values for parsing cipso rules
@@ -1580,7 +1580,7 @@ static ssize_t smk_read_doi(struct file *filp, char __user *buf,
 	if (*ppos != 0)
 		return 0;
 
-	sprintf(temp, "%d", smk_cipso_doi_value);
+	sprintf(temp, "%lu", (unsigned long)smk_cipso_doi_value);
 	rc = simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
 
 	return rc;
@@ -1599,7 +1599,7 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
 	char temp[80];
-	int i;
+	unsigned long u;
 
 	if (!smack_privileged(CAP_MAC_ADMIN))
 		return -EPERM;
@@ -1612,10 +1612,12 @@ static ssize_t smk_write_doi(struct file *file, const char __user *buf,
 
 	temp[count] = '\0';
 
-	if (sscanf(temp, "%d", &i) != 1)
+	if (kstrtoul(temp, 10, &u))
 		return -EINVAL;
 
-	smk_cipso_doi_value = i;
+	if (u == CIPSO_V4_DOI_UNKNOWN || u > U32_MAX)
+		return -EINVAL;
+	smk_cipso_doi_value = u;
 
 	smk_cipso_doi();
 
-- 
2.51.0

