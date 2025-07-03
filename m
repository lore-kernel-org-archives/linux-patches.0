Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D1F126BFF;
	Thu,  3 Jul 2025 14:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554131; cv=none; b=VuwsGIVxrlc7vFhU6BZtibsvG2YOTMLROxN0lZyYzgfcCkvnFsqBxM1NP2xrETXNiEHC2uhwmNgwDMThtBfePEvrr4SQlYZ2+eoIC3h+KI5R8SKbQZGHfGKHOhUfVYcPuY55sX9zi2A7HynRXXBw+ejR/zY5Xba0bysBtfnkWsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554131; c=relaxed/simple;
	bh=aq8yRtfIwZL0g4D2JSb1y2q+dVn9pdIr6DDraTHJUqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oOB8cBXBp0jfXvUNTXB4LMdmG7eTiO2CG3QXAQfFS6dSfl9sMoK+dXt4YGx7Qx0JRytgAhDzkMASTj0OOMw48Rj5xLxJ0El2tIWUyjAkco5TIeGzLEsvl6uxIv5sJoO+VCfMEzrVIjfpNR918JIDjdrR+1RPxiMBSmi4YhBatKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s7TMYy8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s7TMYy8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26D5C4CEE3;
	Thu,  3 Jul 2025 14:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554131;
	bh=aq8yRtfIwZL0g4D2JSb1y2q+dVn9pdIr6DDraTHJUqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s7TMYy8rJPWG/k34WPyKxgT5XYJFNypnwhIyXvz4xoO7k2VQM7zt7vGpO/0k4wdA1
	 RjU2PItZD/qcCsnqPdNvcP/4/UUquub1m/ZVX/34JmI00sEEEUHbD652THHW8DRzGD
	 IG93azFa5+0QbopNDtg8ReMpzUIRkrdM7D+BzodE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 089/218] drm/xe/display: Add check for alloc_ordered_workqueue()
Date: Thu,  3 Jul 2025 16:40:37 +0200
Message-ID: <20250703143959.503844912@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 62207293479e6c03ef498a70f2914c51f4d31d2c upstream.

Add check for the return value of alloc_ordered_workqueue()
in xe_display_create() to catch potential exception.

Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/4ee1b0e5d1626ce1dde2e82af05c2edaed50c3aa.1747397638.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 5b62d63395d5b7d4094e7cd380bccae4b25415cb)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/display/xe_display.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -96,6 +96,8 @@ int xe_display_create(struct xe_device *
 	spin_lock_init(&xe->display.fb_tracking.lock);
 
 	xe->display.hotplug.dp_wq = alloc_ordered_workqueue("xe-dp", 0);
+	if (!xe->display.hotplug.dp_wq)
+		return -ENOMEM;
 
 	return drmm_add_action_or_reset(&xe->drm, display_destroy, NULL);
 }


