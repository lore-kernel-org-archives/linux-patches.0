Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C17F2765FF;
	Fri, 21 Nov 2025 13:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730971; cv=none; b=oRAp/I1JRo+kMzIiSxb5+Tm4Lxoiksb3R18uooCwzkgXhHy/rYpBjuU0/6jq0n6KAJpBa9ckBKbUqQTkAJNUjv4Uf6R6IXQfzB7Mbr1HqC4LBBUgz5CgMMEFlg57OFCyesGoGLCeX2in4oBBm+X+Lnmz7fRzgR7hw+9l9qkOoWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730971; c=relaxed/simple;
	bh=PKfU3GdScT5pBZI0gJWbTa1wXOHvJB/6ZKzRNY873XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNzIGXZDvuPZcpdqt59+FGKvaxneY+VrdQhV6gm23iKRi3nY24oxPwvwXZWgdXMhuvW8UAtcAy+yKllT5D0YSMdimQbpu8792AZNVKcmHFjfTXWnvHVYA0L+YRxnAe4CJ12GusohXg0q07QNrlTiqCuregDqt6JgqfAgBdZ8CZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xMMVXR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xMMVXR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4F8C4CEFB;
	Fri, 21 Nov 2025 13:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730970;
	bh=PKfU3GdScT5pBZI0gJWbTa1wXOHvJB/6ZKzRNY873XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xMMVXR16h5sfCgt5gi7zPzH4jHdQR2x+kxYgpbmfaJxyAINeiyn42JjZVLLGHwYP
	 UrBqFRv2mmzHFW5rCVDCP8eD78ovEj16BGLxv3P6/d1czgkk22YmqLZuy8EgIox/yM
	 lDib8MK2YjjmsKAMGIwM6do0gRyu4RcFULlsaAok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 012/247] drm/xe: Move declarations under conditional branch
Date: Fri, 21 Nov 2025 14:09:19 +0100
Message-ID: <20251121130155.041252327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit 9cd27eec872f0b95dcdd811edc39d2d32e4158c8 ]

The xe_device_shutdown() function was needing a few declarations
that were only required under a specific condition. This change
moves those declarations to be within that conditional branch
to avoid unnecessary declarations.

Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20251007100208.1407021-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit 15b3036045188f4da4ca62b2ed01b0f160252e9b)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Stable-dep-of: b11a020d914c ("drm/xe: Do clean shutdown also when using flr")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index d399c2628fa33..528e818edbd7f 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -962,12 +962,12 @@ void xe_device_remove(struct xe_device *xe)
 
 void xe_device_shutdown(struct xe_device *xe)
 {
-	struct xe_gt *gt;
-	u8 id;
-
 	drm_dbg(&xe->drm, "Shutting down device\n");
 
 	if (xe_driver_flr_disabled(xe)) {
+		struct xe_gt *gt;
+		u8 id;
+
 		xe_display_pm_shutdown(xe);
 
 		xe_irq_suspend(xe);
-- 
2.51.0



