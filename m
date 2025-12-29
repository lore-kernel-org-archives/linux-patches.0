Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45E0334C1D;
	Mon, 29 Dec 2025 16:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025933; cv=none; b=WGBCXHOHa4PvV2sxE69CrIdVZY5oSIQ6duNmfU/JhoP4Gt38Ysd/xy3AJfBDPWDGhnwDid0k4FLmugWul3KkAB2YsgqSyVgxExEb6104qskICqQ8wFFBZwxCYpBfbyc/lxwFkAIeZW3EkJY/F85UA5+aWHoYpZc59SshYdFtaj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025933; c=relaxed/simple;
	bh=/PXXJQJ6js5Ho8ZHkk/Ro9Nw942WxNKJ+rD6k4muYDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qvhEvC+sM6SceVxMdwHKoDdn1/aaC7h2iLzdCeCzGoSVC4tr2reGX8nIWUukRvKHlKUeP8GIF/MzPVVJxzakJuUKHvAh/6K8JDdTS8BaRJGJSicLX+L8NOD6IX+xArjHc/CYZXz+UkbXdHBLOT08AQzk/qZ6xpRUoBHarCDr1Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1L9sG14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1L9sG14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C26C16AAE;
	Mon, 29 Dec 2025 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025933;
	bh=/PXXJQJ6js5Ho8ZHkk/Ro9Nw942WxNKJ+rD6k4muYDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1L9sG14yDOqAIt9+unVTC0Ni7AM0rgKJRYCv4fy0UoMLP6pzipi5sj2zyjsKlN5R
	 QFMk3nOiQBc/Tkl17VJCLnNH8XJNlD3rC0VMxoIPKcUwC6UR47DRYJOAw3g5QHMLBR
	 TEZzF6nmmlZPzEiwsUO6jYmPLI+KvspB8he4i814=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tiago=20Martins=20Ara=C3=BAjo?= <tiago.martins.araujo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.18 389/430] drm/displayid: pass iter to drm_find_displayid_extension()
Date: Mon, 29 Dec 2025 17:13:11 +0100
Message-ID: <20251229160738.634558035@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 520f37c30992fd0c212a34fbe99c062b7a3dc52e upstream.

It's more convenient to pass iter than a handful of its members to
drm_find_displayid_extension(), especially as we're about to add another
member.

Rename the function find_next_displayid_extension() while at it, to be
more descriptive.

Cc: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Tiago Martins Araújo <tiago.martins.araujo@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/3837ae7f095e77a082ac2422ce2fac96c4f9373d.1761681968.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_displayid.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/drm_displayid.c
+++ b/drivers/gpu/drm/drm_displayid.c
@@ -48,26 +48,24 @@ validate_displayid(const u8 *displayid,
 	return base;
 }
 
-static const u8 *drm_find_displayid_extension(const struct drm_edid *drm_edid,
-					      int *length, int *idx,
-					      int *ext_index)
+static const u8 *find_next_displayid_extension(struct displayid_iter *iter)
 {
 	const struct displayid_header *base;
 	const u8 *displayid;
 
-	displayid = drm_edid_find_extension(drm_edid, DISPLAYID_EXT, ext_index);
+	displayid = drm_edid_find_extension(iter->drm_edid, DISPLAYID_EXT, &iter->ext_index);
 	if (!displayid)
 		return NULL;
 
 	/* EDID extensions block checksum isn't for us */
-	*length = EDID_LENGTH - 1;
-	*idx = 1;
+	iter->length = EDID_LENGTH - 1;
+	iter->idx = 1;
 
-	base = validate_displayid(displayid, *length, *idx);
+	base = validate_displayid(displayid, iter->length, iter->idx);
 	if (IS_ERR(base))
 		return NULL;
 
-	*length = *idx + sizeof(*base) + base->bytes;
+	iter->length = iter->idx + sizeof(*base) + base->bytes;
 
 	return displayid;
 }
@@ -126,10 +124,7 @@ __displayid_iter_next(struct displayid_i
 		/* The first section we encounter is the base section */
 		bool base_section = !iter->section;
 
-		iter->section = drm_find_displayid_extension(iter->drm_edid,
-							     &iter->length,
-							     &iter->idx,
-							     &iter->ext_index);
+		iter->section = find_next_displayid_extension(iter);
 		if (!iter->section) {
 			iter->drm_edid = NULL;
 			return NULL;


