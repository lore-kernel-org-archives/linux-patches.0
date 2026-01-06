Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA75327C19;
	Tue,  6 Jan 2026 18:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722538; cv=none; b=bNdtdcipo4Zxk8dTjh57SKrg/qwVJzFRVt8bCXqbK8xgb6HU+8tELbgJhhWyWpu+ry2FwXKDIAGxXqTxfyph4lDkbylbkdtXKaK3FMdJN8XDp28Udoa9rp2wh1yWK3E3PYcD9CBwT6Sl0GE+yBSgwJl4rOpAHfmcTeguDaG4FjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722538; c=relaxed/simple;
	bh=4Bg00wOdEOI5Oi3rbWlLIO1RqlV4Dx8lJP63q/XIe+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWItPDz7kjpaX7qshFjrnXopEq0KSMfICFPhkS3aZPavIBxyq2l58D0Zge1Vaw9Wf+CSIpeHKS0N03EXCHRqORBrSH9QCfYhwAdoCjyYrcpigicKI/CUeqV9l6MtQ/skprBIf/9YrP4ROhHsL/PZfA4DElldAfHtxG3KscHObYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV8Vrwp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV8Vrwp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F163BC116C6;
	Tue,  6 Jan 2026 18:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722538;
	bh=4Bg00wOdEOI5Oi3rbWlLIO1RqlV4Dx8lJP63q/XIe+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV8Vrwp31z0ieDL7RxrZv2x6Wpqw1cQfUQLDoSg7ZCX5lmFcKlZ5udAWJqrWjtE7h
	 CkAo/IDOHP5TNYN0bfbPKUWJ/g6ANJgupUSCtWSS7jGTYxLkcdlp4Z5JcyAS2JX0RA
	 M7zEdlqn6SB2clnFxy8OAWP5SkHQX96IclOfXgzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Senna Tschudin <peter.senna@linux.intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Harish Chegondi <harish.chegondi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 294/312] drm/xe/eustall: Disallow 0 EU stall property values
Date: Tue,  6 Jan 2026 18:06:08 +0100
Message-ID: <20260106170558.491508407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit 3767ca4166ad42fa9e34269efeaf9f15995cd92d upstream.

An EU stall property value of 0 is invalid and will cause a NPD.

Reported-by: Peter Senna Tschudin <peter.senna@linux.intel.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6453
Fixes: 1537ec85ebd7 ("drm/xe/uapi: Introduce API for EU stall sampling")
Cc: stable@vger.kernel.org
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Harish Chegondi <harish.chegondi@intel.com>
Link: https://patch.msgid.link/20251212061850.1565459-4-ashutosh.dixit@intel.com
(cherry picked from commit 5bf763e908bf795da4ad538d21c1ec41f8021f76)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_eu_stall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_eu_stall.c
+++ b/drivers/gpu/drm/xe/xe_eu_stall.c
@@ -290,7 +290,7 @@ static int xe_eu_stall_user_ext_set_prop
 		return -EFAULT;
 
 	if (XE_IOCTL_DBG(xe, ext.property >= ARRAY_SIZE(xe_set_eu_stall_property_funcs)) ||
-	    XE_IOCTL_DBG(xe, ext.pad))
+	    XE_IOCTL_DBG(xe, !ext.property) || XE_IOCTL_DBG(xe, ext.pad))
 		return -EINVAL;
 
 	idx = array_index_nospec(ext.property, ARRAY_SIZE(xe_set_eu_stall_property_funcs));


