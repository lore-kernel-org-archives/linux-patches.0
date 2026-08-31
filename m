Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2287A49483F;
	Mon, 31 Aug 2026 14:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185187; cv=none; b=C1KGJ91g/uA9m+5I7GsUXIRUHlimV8umHgCaCjXTxgaLwY7RcHOoRqjDbFdYicPr79IY6o6a3wxGGVhPnWb1NxefISdIxLUjZCDQS2mA0GSVi7wHe+l+S0EQymQVs5c1rUbliaixaZSLvZNJrrA4yp5oy40BXpPJ47ptq5xHxUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185187; c=relaxed/simple;
	bh=9jIsr5ZeOEtRY6iolzN/v3wPSMS5NRhAOGMLsA6q8zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFYidMZvUzc3sAe9jtrYzRtED3UHtcMHIlTpust/kKW0ulr7bMmjbAGICObP/qlFZj8odidimFtVmCsepH8mPy2VHrp4DSr2cvDWaCATGKYgKmDG1cubEftwWIs4rUewJ2vBrwDhsSXKUSF2O5giN/iXNXRoPtXQrNOK2E6RdHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDHeOQRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDHeOQRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B7B1F000E9;
	Mon, 31 Aug 2026 14:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185185;
	bh=o8oqnJQmez0ORCRexc9g51JUlQX4UKVb1cGBE5gFdPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDHeOQRjAzRySYrF+OJNx18NWyQFpxpAMnASA9/X4B5O1htMP6R+jZpxOLkWzIJaf
	 xgJ8oYGXiGMkrDEEC74Nf1+jPBCQFZ5797cbcwAQ/iAZaHzptvGhdjVS5Sky48dH/p
	 AVBmIc5c9MTju6g8SozpRx8JdCAserH57EHm6OLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/43] Revert "smb: client: use kvzalloc() for megabyte buffer in simple fallocate"
Date: Mon, 31 Aug 2026 15:35:22 +0200
Message-ID: <20260831133359.154636597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit a0c4a3e5387421ae252126a7bc29f3cd95b3cf06.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a520e90adf3ec..51f8ea0c89065 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3568,7 +3568,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3635,7 +3635,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 
  out:
 	kfree(out_data);
-	kvfree(buf);
+	kfree(buf);
 	return rc;
 }
 
-- 
2.53.0



