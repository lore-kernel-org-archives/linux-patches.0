Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9378F3750D6;
	Sat, 12 Sep 2026 16:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229779; cv=none; b=Hw+nTnOA1B2i7mMh/wgz9c4duT2My9lqFbeMVGKEmwZoNrWfXQRe7W3tAybLtFLQ9Rh9G89VtYBnCGtpnxSlkIIEBoIUzwoqD6TuW0pDTHibAYtK7nZatUIwVbMVNeqCp0jB5cy6jpnOzImaqo1uHaLIX+aFvhrk5XaEQ0x4kkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229779; c=relaxed/simple;
	bh=oycaXhB68DeKErO2Ys0IDjjvhGC9GoK3bfZPJgIV43E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu236Gtx//7vWgkJn5FttLhYw25CyWjEWeLCVTI5duwGbyVBiLY9X2nmozGjmLn+XyUbLagfC27D6F+6lqJn1coTSKKSfK5F1w0czdGCI35IJ6rddoNAPksEWpy6H/HVqEpILVg6kqES2dDoqWHS+ycFWSkUv0ghiWUcoUc9d2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwBwxBF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwBwxBF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D69C1F000FF;
	Sat, 12 Sep 2026 16:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229778;
	bh=HdCeTRfiLj/uQ4M4wSPjZUkt2VPlItz6EFgnPJCSFrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwBwxBF3i65hsN57lwVNZmjurCxKQvB2sFj6CEk0Mk0C+f9TpCya5Ekc+1fnOc+x4
	 T9bpLNiAILD2b+FSgFqSMUdi3VwXA0PjG+EfZs33yOouYZ4wWgON9lHd/J1rT1gXpe
	 hQOGairKMCqU5o8pKrytw13ifVJj0+UQMnc2FlvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0660/1191] software node: Fix software_node_get_reference_args() with index -1
Date: Sat, 12 Sep 2026 08:56:28 +0200
Message-ID: <20260912065603.081745646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fdea6b93eb30e..68cae105862a3 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -518,7 +518,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if ((index + 1) * sizeof(*ref) > prop->length)
+	if (index >= prop->length / sizeof(*ref))
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.53.0



