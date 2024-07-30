Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6F01A6166;
	Tue, 30 Jul 2024 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357966; cv=none; b=hTSjYrSuamzvgEY98BSDnBBv0uvElHHU2NUBWbfh9es/fYknlxV/m1uCLNu1/2yFCHXfnyCOgSH0bBtwfutbzj10v26KPaMZm7jtlnZvC7xJ4uKHixp4xryaFD9Fgw7VCbAIVXJ3yWj605pTl0FblT+0DjeEY/xq5VTaclSowuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357966; c=relaxed/simple;
	bh=MLRfugexmh8i5Go62UyfTKxqRCRi5XBMPaKTB0582LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/WbFDC0UKs6c1JD3Wo6gkpfbqNFU+TQgrf0g+TexXRodg5imtdh1zaUhu3gJJ934yq1KSWLVlA8WhX/KQwI9KXKk/omMLIxo0VgNW7QibE2nvMFXwlkrwVZgPUs7DYPmvEJ/GiEkj9n64FoR+b/Ly59zlMG2llEXQWgamRkTLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJsas22W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJsas22W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7568EC32782;
	Tue, 30 Jul 2024 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357965;
	bh=MLRfugexmh8i5Go62UyfTKxqRCRi5XBMPaKTB0582LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJsas22WPdoxPDRMKPWKfM9EgIqwpipHN/hw7Dgtw43IR3JvrRi5HJ7v4ZGikzmH4
	 w/igig8vxz9zg5wyy0rDa9sxtbGyn15q89KPH4psjhCbHkBy0Cszgawt1YVMV3W0ND
	 DhSj6QeAbAJAYiCatzqEw+dzkfGaxMszlD+HrRQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 310/809] media: c8sectpfe: Add missing parameter names
Date: Tue, 30 Jul 2024 17:43:06 +0200
Message-ID: <20240730151736.842271824@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit abb7a73b687dc82202f0203a112ef435fb598aa6 ]

clang 19 complains about the missing parameter name. Let's add it.

drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-debugfs.h:19:62: warning: omitting the parameter name in a function definition is a C23 extension [-Wc23-extensions]

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202406050908.1kL1C69p-lkp@intel.com/
Fixes: e22b4973ee20 ("media: c8sectpfe: Do not depend on DEBUG_FS")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-debugfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-debugfs.h b/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-debugfs.h
index 8e1bfd8605247..3fe177b59b16d 100644
--- a/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-debugfs.h
+++ b/drivers/media/platform/st/sti/c8sectpfe/c8sectpfe-debugfs.h
@@ -16,8 +16,8 @@
 void c8sectpfe_debugfs_init(struct c8sectpfei *);
 void c8sectpfe_debugfs_exit(struct c8sectpfei *);
 #else
-static inline void c8sectpfe_debugfs_init(struct c8sectpfei *) {};
-static inline void c8sectpfe_debugfs_exit(struct c8sectpfei *) {};
+static inline void c8sectpfe_debugfs_init(struct c8sectpfei *fei) {};
+static inline void c8sectpfe_debugfs_exit(struct c8sectpfei *fei) {};
 #endif
 
 #endif /* __C8SECTPFE_DEBUG_H */
-- 
2.43.0



