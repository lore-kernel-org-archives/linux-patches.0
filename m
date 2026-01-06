Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F59C3557FD;
	Tue,  6 Jan 2026 17:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720497; cv=none; b=lkXW8LShGQJ5LvhvR1jsag5qww15i9A7tS8qOuDhYXzVGDn/ak/wGWFuOLgpPNaqt1m+ryrdauyy5r+ihXZgkL3ctmHonGTq5urURXUxQETUIaDwQsphumeolGAq9l8brHV1f6tQqycX+XYdzFp7EX/QCoHDp9D1sATOralxKNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720497; c=relaxed/simple;
	bh=UJXWtjbEXhKyTuCHoIM53o+1QD/7JOteW+GiZi7GVqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsP0i7CE6ey83OmEEgNkfDFrJSv3Pv1PGk58+r31sckZHwLIwcFNHArf4baL4JF9lL6iDEcZiDOf83ZQpMnwhcTBZhwV6c6Zs+l3hi3DI3Fio6ZOtCjbuXZO3DhPfciBVLRZP3EcsdUdvkaDVN1i5Tv6MrsAUUbDd5S5obKK8hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y2fBSiDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y2fBSiDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C9DC116C6;
	Tue,  6 Jan 2026 17:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720496;
	bh=UJXWtjbEXhKyTuCHoIM53o+1QD/7JOteW+GiZi7GVqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2fBSiDTYZpGOBrv7usDTweecApJmdePZ627/gE6aA5O6p+6yX7wjRdjuLSBfgF9r
	 2DxocC3BA8kETSu5FpIlfgFA9R5OqMuh+4JFAhbnZjBQvLKSUQ5gUuFq0K/mT+m826
	 bLi/O5Fvii5kAez2SQrXwe9tFcV1Q0yXNxNSNsxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tiago=20Martins=20Ara=C3=BAjo?= <tiago.martins.araujo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 255/567] drm/displayid: pass iter to drm_find_displayid_extension()
Date: Tue,  6 Jan 2026 18:00:37 +0100
Message-ID: <20260106170500.746482636@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


