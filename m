Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CC43DB983;
	Sat, 12 Sep 2026 12:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215748; cv=none; b=UAqwdbqaOuc22ukW5HdDjHZoPRmjkxk1NXYZB2Hi4trmqLERQv66FLd4/5+Q3OJWHfw9mJ7Z+EqOhLga1XnFBmtBGti7l+TPJaRlxQnZHVvkP6BCTjUbeI9mLlS0rGZbMn1YGWAedhqCVIxTFXsk0uXbkxUr7gOCBP9Y+l65HQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215748; c=relaxed/simple;
	bh=R4bTCQJE8mJZwe0IK5p/gU2Gyt8FZBd2LgcIEm+oHQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzOOrAi7BSiwt6X1E1sn4S/tvfTy3aAhkBIv1veZScAiWYunlbFw7Bpzfpzxtv/QB+piXxzmhO0PItIK+YeY7ObQ6p5kHrF9yzx6nPWnR0jMAt6KeGw2X3/8wFuvyfta2Jv4Rx2/1ERNTL5wu5bSZqa4QrT5i0GAr8s41lIGPaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xre6HoSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xre6HoSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9FC1F000FF;
	Sat, 12 Sep 2026 12:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215746;
	bh=v8PduRP7xDsZSx/KkKryI11c6p/S2g7hRPWCLzN8wa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xre6HoSN8G98U3OdA5f6ZUxcl8luTPDsBmfufn1jdI8NPHNFXg8tjkqEOKryI9rdl
	 Mu89DcuSCbGUbzywSC6hJfWXGBv0b4SpG5Okd+fP6GpyTWiKffiNCvguGlhoUPeS3s
	 OatHIeF+WhRZ58hm53U5F649Ru9xjwHNNdcxSD6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0594/1376] software node: Fix software_node_get_reference_args() with index -1
Date: Sat, 12 Sep 2026 08:50:20 +0200
Message-ID: <20260912065620.773740580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Bedel <alban.bedel@lht.dlh.de>

[ Upstream commit ba3dedcf3bd47017307595a7e54924198f018246 ]

The bounds check for the index passed to
software_node_get_reference_args() was failing when passed UINT_MAX,
this in turn would lead to an out of bound access in the property
array. Fix the bound check to also cover the UINT_MAX case.

Fixes: 31e4e12e0e960 ("software node: Correct a OOB check in software_node_get_reference_args()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/20260611103904.7CB131F00893@smtp.kernel.org/
Signed-off-by: Alban Bedel <alban.bedel@lht.dlh.de>
Link: https://patch.msgid.link/20260611164005.2930205-1-alban.bedel@lht.dlh.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/swnode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/swnode.c b/drivers/base/swnode.c
index 53b3f0061ad12..49295a1a3ea92 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -529,7 +529,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if ((index + 1) * sizeof(*ref) > prop->length)
+	if (index >= prop->length / sizeof(*ref))
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.53.0



