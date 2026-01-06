Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA33327C19;
	Tue,  6 Jan 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722535; cv=none; b=IcpTjFIK6XMbGvGnc7IQy1XiUm9/nPsqMa58HPBIPZ9vrQsUzys1M+CvvMVRCr3Cn1duWo6mefEbETNMSmeTXf/Vi0uBVfug9JiIKo5lnSUp2q7us8xeaaDp0U/X0QijGAUnUYqQi27fplOyI4q0tVNY75kJnjJojGfSiLtdae0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722535; c=relaxed/simple;
	bh=08fv80oZAQAKqakRt8nLHmb195Cl/Z6QpE/qF6q1Y5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NQoBNmJFCcmIk415MHhuKmaW5IFm3iVboNSa/+XEbVYIIZP9LipnWmC7BOe9JI2YZcGTVvZvdGONNmR+D8WEUaqocNubpMlwILupVEPRL9CWDk/7L18C8A01viux9eukRcJZiECyAWCFo1iQ//wlBcfRH+9nWIJyPXGZ6tfEnzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDegD8Bx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDegD8Bx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFABDC116C6;
	Tue,  6 Jan 2026 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722535;
	bh=08fv80oZAQAKqakRt8nLHmb195Cl/Z6QpE/qF6q1Y5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDegD8BxRnxC7iah/iKCi2nuuIIAc3FkczO0yKCVbKl9iew/f4ix3cJM34kMwewAa
	 riW8RRs5hhwpwjcALOrkR0PAbjMYkTt2KnKLvCxm6dJQ/PnY9VlvHcN3JbKldS8LCG
	 NqQYN6RcjXq1gyfcYl5YJIaVsThPo1lY20NR/Z5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Senna Tschudin <peter.senna@linux.intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Harish Chegondi <harish.chegondi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 293/312] drm/xe/oa: Disallow 0 OA property values
Date: Tue,  6 Jan 2026 18:06:07 +0100
Message-ID: <20260106170558.455437411@linuxfoundation.org>
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
@@ -1346,7 +1346,7 @@ static int xe_oa_user_ext_set_property(s
 		     ARRAY_SIZE(xe_oa_set_property_funcs_config));
 
 	if (XE_IOCTL_DBG(oa->xe, ext.property >= ARRAY_SIZE(xe_oa_set_property_funcs_open)) ||
-	    XE_IOCTL_DBG(oa->xe, ext.pad))
+	    XE_IOCTL_DBG(oa->xe, !ext.property) || XE_IOCTL_DBG(oa->xe, ext.pad))
 		return -EINVAL;
 
 	idx = array_index_nospec(ext.property, ARRAY_SIZE(xe_oa_set_property_funcs_open));


