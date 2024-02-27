Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E40013B791;
	Tue, 27 Feb 2024 13:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040983; cv=none; b=DQiWSbN4b4iFyK8nTFX1uKv1pTLh8YvuA4TZirCkbnE2ZMW/+Au92iK8GPVnVLV8pzufUXg6wiTAp8TdhjbVVP13lkUZstwzvVRdpPVxr8dHuWm9axhafsCUz5eLF2ZPjFa1MGhFQ9Lr4+KrTfKGBRsTpO76/w55smUMW3JmkyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040983; c=relaxed/simple;
	bh=2KL+3kvGVnn4fh2czcuBXfjyYJnHYencw8V+2FfV4ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CEsSo1QgdaWJKMSZx74EPPL0m/vo8/bHY2259PQfE9W/5/0sIX0YVTyKj8SjwFo9HkctNkp5fsOnwytmtAU9h/zoPODKZv/SnlQX9gAxJsKJXzYZh7akxDDN3ylEIBxR1AXs/RG0KKoHvt0SkuCL/bzXeXlg/pxR5gNqP3aA2Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tz3EAa4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tz3EAa4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79B3C433F1;
	Tue, 27 Feb 2024 13:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040983;
	bh=2KL+3kvGVnn4fh2czcuBXfjyYJnHYencw8V+2FfV4ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tz3EAa4KZgy2mBxaL2WiDMkIOFo+vBXP5jzArnVjG8n26Q8YJUwg+3vOVp6zPOt+o
	 20aasSS0oKwmdV8Ve6zik+NkGBuuN/MtodZj1aYcDiAqOnobUkUsgADkKL5MMUpO1M
	 4kzFyPsjl4EZbS8uloBTKN/kPvEwVCs+tSReEKgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.7 150/334] drm/buddy: Modify duplicate list_splice_tail call
Date: Tue, 27 Feb 2024 14:20:08 +0100
Message-ID: <20240227131635.303005747@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>

commit 02f76a9cd4494719600baf1ab278930df39431ab upstream.

Remove the duplicate list_splice_tail call when the
total_allocated < size condition is true.

Cc: <stable@vger.kernel.org> # 6.7+
Fixes: 8746c6c9dfa3 ("drm/buddy: Fix alloc_range() error handling code")
Reported-by: Bert Karwatzki <spasswolf@web.de>
Signed-off-by: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240216100048.4101-1-Arunpravin.PaneerSelvam@amd.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_buddy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_buddy.c b/drivers/gpu/drm/drm_buddy.c
index c1a99bf4dffd..c4222b886db7 100644
--- a/drivers/gpu/drm/drm_buddy.c
+++ b/drivers/gpu/drm/drm_buddy.c
@@ -538,13 +538,13 @@ static int __alloc_range(struct drm_buddy *mm,
 		list_add(&block->left->tmp_link, dfs);
 	} while (1);
 
-	list_splice_tail(&allocated, blocks);
-
 	if (total_allocated < size) {
 		err = -ENOSPC;
 		goto err_free;
 	}
 
+	list_splice_tail(&allocated, blocks);
+
 	return 0;
 
 err_undo:
-- 
2.44.0



