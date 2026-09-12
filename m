Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3FD1FBEA6;
	Sat, 12 Sep 2026 19:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242758; cv=none; b=DKwBCVBXFCT26IJAsW+f0pJZIZu8N8AsTXTgWd2d21opnBBoQHg15KXo05odGUl45nq7/KtF+OUdhBA2YZXg1S99Y8C09s5gBMdgbQ8AxT648Xr99VYmMHAUj6Ig+/E/Xm8i6/dczuNAYK2tNvHXSy5f2jxDvW8KxmAuK3cfQHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242758; c=relaxed/simple;
	bh=ZdCT4/ytPMda2Ll7tvdwLOPwCi4bFlTurfHHdlcdhdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwBMK4tvFgF+AbZD6MHspDMEYzi1NGNYYWyWTNPmporjTrRu9yduX27n7I9jVOErE+3TJMRnpqchhbWLD5YVt+faHhGclDMrKDnBC+avO4a6QMOLJWbLYiGy9xos69t8+xUCMsqoswhac7o+Zt/DTY7La8QmangEV5WKoIjSa5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py4h1YHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py4h1YHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DCE1F000FF;
	Sat, 12 Sep 2026 19:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242757;
	bh=wPA4KfUzvVhtSuUSYmrEsZj6RTK/uVJngTYu4MENKXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=py4h1YHMRpTLru6j/G39qEJ9lk21UgC7/9CFk98LBykoDuJkVofxY8z3A2h4spOz2
	 KeC3daUnkf1klN6/06bjuGIHy7D5MOqEkA189mSG6NLkHXF24l7mJrdg2ZEEvTGS2+
	 nfAk0uy1oGql021UPQYdCD6vhonCy8UzSeFjCqKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Alban Bedel <alban.bedel@lht.dlh.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 473/798] software node: Fix software_node_get_reference_args() with index -1
Date: Sat, 12 Sep 2026 09:01:41 +0200
Message-ID: <20260912065527.985033791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 89b53ca086d6a..e11e715320199 100644
--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -508,7 +508,7 @@ software_node_get_reference_args(const struct fwnode_handle *fwnode,
 	if (prop->is_inline)
 		return -EINVAL;
 
-	if ((index + 1) * sizeof(*ref) > prop->length)
+	if (index >= prop->length / sizeof(*ref))
 		return -ENOENT;
 
 	ref_array = prop->pointer;
-- 
2.53.0



