Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936DC39B949
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302547; cv=none; b=eLyb6NA7oIzVe0jUykwy3WfRcaLoDBxnZVbT63t1335cJSrltI1C1LrOmOlMcB2ILWvRbjgq0ptgO2l+8nKGL5WwxWyWmaWzeU/Osce1p0cQK8cYfkkDLMaVITu4SQhLjYBhHjdF1l9n6efPAIS0ah/SC+4V2gu57y4cTQHXXQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302547; c=relaxed/simple;
	bh=BXRqp965XUMEsR4kfNjdV/kGJzXXocdeS1aPBSS6Cgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMiksDnaOTElaDRzfTgKYKpwVUZPdnJwUEZg8Jdr68ZZ7mRgjIRFVg5d8bqV19Zexdaalt4VLIpOgbPo6ihF9g+3sZJIWcwU5ZHVwbc0mK0pmKYso9WroVCsWWDXZTBYefDFHC+slURQBWNu2Iw8CZhs2TT0+/s+Cea5e9zD0aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sq/tiFF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sq/tiFF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03EA0C116D0;
	Sat, 28 Feb 2026 18:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302547;
	bh=BXRqp965XUMEsR4kfNjdV/kGJzXXocdeS1aPBSS6Cgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq/tiFF3k8jwirGesoN9Kx5MNz+5eu15TAUC0rmYbWwDJS+hJkFrILg1Lhc58Aujo
	 dOK9levg6PP8MAZlwaYaZgUvSIXS0wdcUeSt/1UiN/gRzOIK23UWVbIg1TA6RDpyWt
	 2D2AsxCEu7s+A4CD1ubLOk//szXVpvtwzf2EYYqJcqRpcumBot98IFyapZzIdCO8oT
	 PDKyfIqxpT0O1+CLzUpyK8DNiZ4CnCKJx+ohVeZmuM+1v/Wx/dQ4DnFFEUjXWv6F8L
	 CfELJ9YVXCULnqC3FGt7bgOZYtsNVvB7sYYHdw71fcf5KosR9yXIxcq21nzxKCDGWO
	 q/X4aARRlFusg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 050/164] smack: /smack/doi must be > 0
Date: Sat, 28 Feb 2026 13:13:09 -0500
Message-ID: <20260228181505.1600663-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 0feaa29cc0243..c0811defd2086 100644
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

