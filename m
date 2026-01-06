Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EE22E090B;
	Tue,  6 Jan 2026 17:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721239; cv=none; b=u0/0GVayDOTIaGK1n1CUcntZTnIExGCEjTzayzaeY2y2s4bxd36/d5oOmdd7xvTuQaAiUd8H4KxzwB7u9QqlbLifFvdIc/9iNXxbrplOs/e4hLgM/bpK5FJH4dLGT/nnmeOs5037ZGvmb2tHuGDswYcn6ZrAfG7+lZd/h25+cSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721239; c=relaxed/simple;
	bh=NZeGgkbFrONkVkUvkOLWTo90TVk/VcPIImNj+6I29wY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K48zBkoQGoOKAr9OY2fRUSzfT3ReKzKT6igkCigMQZ3XGG+baBIikSI7/qbtglUrav67cSnK7T1n4kYWtr2PkclfRvvKW9zIVqUFBNFJB3POByGKW6b/Rakqau/xyqkWkjMfvOu1GhJd4crwMX+G5WJsT9WxDDXKk60DzAalzW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggHkajWi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggHkajWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E686C116C6;
	Tue,  6 Jan 2026 17:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721239;
	bh=NZeGgkbFrONkVkUvkOLWTo90TVk/VcPIImNj+6I29wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggHkajWiN7WdSQ0pvLHLRZPgqI8I3mx/OOBJBJ0VBjgIWsBgg2Wkr7D+Ontp6h9Sq
	 0CiDDmjIQkgNZ+pDEsstvYW8eN4cgLiWcX0Li6szBHx87rcFmKOl2fu5D4Sd1okbX4
	 PcTsKCrPEMmWu88MgOUsqDPIMhO5zAvPJf+6/V1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Senna Tschudin <peter.senna@linux.intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Harish Chegondi <harish.chegondi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 477/567] drm/xe/oa: Disallow 0 OA property values
Date: Tue,  6 Jan 2026 18:04:19 +0100
Message-ID: <20260106170508.998931514@linuxfoundation.org>
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

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit 3595114bc31d1eb5e1996164c901485c1ffac6f7 upstream.

An OA property value of 0 is invalid and will cause a NPD.

Reported-by: Peter Senna Tschudin <peter.senna@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6452
Fixes: cc4e6994d5a2 ("drm/xe/oa: Move functions up so they can be reused for config ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Harish Chegondi <harish.chegondi@intel.com>
Link: https://patch.msgid.link/20251212061850.1565459-3-ashutosh.dixit@intel.com
(cherry picked from commit 7a100e6ddcc47c1f6ba7a19402de86ce24790621)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_oa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -1266,7 +1266,7 @@ static int xe_oa_user_ext_set_property(s
 		     ARRAY_SIZE(xe_oa_set_property_funcs_config));
 
 	if (XE_IOCTL_DBG(oa->xe, ext.property >= ARRAY_SIZE(xe_oa_set_property_funcs_open)) ||
-	    XE_IOCTL_DBG(oa->xe, ext.pad))
+	    XE_IOCTL_DBG(oa->xe, !ext.property) || XE_IOCTL_DBG(oa->xe, ext.pad))
 		return -EINVAL;
 
 	idx = array_index_nospec(ext.property, ARRAY_SIZE(xe_oa_set_property_funcs_open));


