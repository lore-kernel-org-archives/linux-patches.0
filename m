Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851582B9A6;
	Thu,  3 Jul 2025 15:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555041; cv=none; b=rC/PeZvTUjg98F6J5dYHm+R5Q1AvuzS5u1XevZE0nEoDudpa6Aq9XiRUAQgpL0LpVyHZOUfNggzkXp1w8RHu4h8O0ZBbna64WK6sVYXcGaS4ozgbU6f035ifaA0v/rSs+h37Chlr+xifJ67y9rYmzgg4M/wiBkAnlYOibGDU9So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555041; c=relaxed/simple;
	bh=AY7xhSTNd9jy2SpoNZFfn9Dlu/rbm5nfUbcKWN9T8pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L3IlqGSeevo3twixQqEuVq7J1iueyaGhGT2zMVOM9PW1wsmbXlXMTTcayHHnfq9bjtS+RU0HW4+efXR7c7N4uvrQKLDC/sWu0t1k1Mm5iAxhP9rRsdtTvATFeR6NgRMwKNU1i8GVhnDu0zKXdG/1bstzrS33NM9Gb8HBDGKgM7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xp+7piym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xp+7piym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C206C4CEE3;
	Thu,  3 Jul 2025 15:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555041;
	bh=AY7xhSTNd9jy2SpoNZFfn9Dlu/rbm5nfUbcKWN9T8pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xp+7piymMES1xRdMa8VeRUdipGCdPJf/dxidSNajDNoRsyqYmfhfvQkz8hWmcPHW0
	 bdTGR50NUQY+HiKcW3LT2JbYNMSnIG7IlqQ8S7Nh2Hwh605tcbi0s3jwwR3eLnRoz4
	 ZBV3ppYICWyVfJDUQSH3WXjLAxV23HDE1Xsb9owg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.15 127/263] drm/xe/display: Add check for alloc_ordered_workqueue()
Date: Thu,  3 Jul 2025 16:40:47 +0200
Message-ID: <20250703144009.447952637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -104,6 +104,8 @@ int xe_display_create(struct xe_device *
 	spin_lock_init(&xe->display.fb_tracking.lock);
 
 	xe->display.hotplug.dp_wq = alloc_ordered_workqueue("xe-dp", 0);
+	if (!xe->display.hotplug.dp_wq)
+		return -ENOMEM;
 
 	return drmm_add_action_or_reset(&xe->drm, display_destroy, NULL);
 }


