Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B82B48988D;
	Mon, 31 Aug 2026 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184994; cv=none; b=ZTWRUaMY4E9q0EL74N2brNDRerlETnRmtAmae6m30BZ+bvQlouj/Xu0dmOMAnafH4leMSJ0wMPw/CVBW5bkFkOk+gFhnOJWI8RngshwKPP89OgMTMuw6ROF0EeGsm4QMx3XvOYotEmjzM4pRf4Ffn6RoanFxUG1fTuzBboCMipA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184994; c=relaxed/simple;
	bh=zTnzmJAdV3azDYkCqneNNAvhYo4yMc9ufg1CZ9IOHa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikODgscSRGW+bBtNrCcoIWpEez5UK4fKoe7b5GYjRMosf7q9liYcXmx5MQalem2Dx6C3wO/Nigkcge/QnCKLTMpiyFCqeIUAF0gmqkFeQ0gTFg4QAOduM41DeqphRmkFNNZZBvZvdJsALyVBvL1egtIeC5zvuH6PveU9BKt6pBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSpzx0gH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSpzx0gH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C1F1F000E9;
	Mon, 31 Aug 2026 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184993;
	bh=IKr9QPdvMrsuslKXeI248qe9YBhS69H/oM/gMkgVEtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSpzx0gHpkczkkIiM3f5VDyp2vlifCxf06TlxZSy4Mpmfc43Tk0RcMJIox/LgPenH
	 GVPEs+qszk0xMbaVnRFoVGGawtbBmFfnEXJFsQO5mPDJRY/Gyrw0i65hrS66ZOfnVa
	 JmFJ74LNve40tJt+CDds+C28tnma8H7ZAnF5SSDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/69] Revert "smb: client: use kvzalloc() for megabyte buffer in simple fallocate"
Date: Mon, 31 Aug 2026 15:34:50 +0200
Message-ID: <20260831133359.326291950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit d1bc345f6229412d45bab2baf81d45d0e678253a.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 9727cb9250807..3aaa45375d8ba 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3736,7 +3736,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	if (rc)
 		goto out;
 
-	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
+	buf = kzalloc(1024 * 1024, GFP_KERNEL);
 	if (buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
@@ -3803,7 +3803,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 
  out:
 	kfree(out_data);
-	kvfree(buf);
+	kfree(buf);
 	return rc;
 }
 
-- 
2.53.0



