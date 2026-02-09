Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A1D23B604;
	Mon,  9 Feb 2026 14:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647498; cv=none; b=A81mVZBbwIPi8ilDEg33MtZdr/Iwe1IurHChx1VXQBLbtgtw33rlrmDyqUELkshInaeRwTRKrU4AYOCx0sPqp+JxwAxVyUMyNIXUbJTCF82MXy8ot2shYBOCo85cZ0FnmUPn61JCcqnNadh8lAQSpYQhsut0McKEggXIu3x1nR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647498; c=relaxed/simple;
	bh=ank8cTNq2ZloUwzf6WGlUS6vMliUhjngatmO8kAXEmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcSfNVnsuWuM0woKj9zyfIW0+I5okbNtaetd5tt6WbV5Q0zOQE7KUbQL5wOqBOsrfpZOCv26E6WZ57RlRKORL1QSb+HvnVGrpPQk/W3GfgQkEeILoCMe8LVTH9QrmOVsgFbrKDVY21EDeh39hcbO+sFt5LHy9FKI2UUSxrmJWhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KanZqBiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KanZqBiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C642C116C6;
	Mon,  9 Feb 2026 14:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647497;
	bh=ank8cTNq2ZloUwzf6WGlUS6vMliUhjngatmO8kAXEmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KanZqBivMt0mQF0ExiHGf16edtbv/BVCjd+v+V9k1XETjqM+BYfbH4h8TXYbB578j
	 9xNFsHqgQe3Q6+EVeQImwKUyo6YkPJ1t+YsWhBkkepPU4FnlwSVW+WW6SK+GfLxaMH
	 QFZGoMaOJ61stEb1skBFo6D0Wu9rsUDER7mEMPYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/175] platform/x86/intel/tpmi/plr: Make the file domain<n>/status writeable
Date: Mon,  9 Feb 2026 15:23:09 +0100
Message-ID: <20260209142324.585618789@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 008bec8ffe6e7746588d1e12c5b3865fa478fc91 ]

The file sys/kernel/debug/tpmi-<n>/plr/domain<n>/status has store and show
callbacks. Make it writeable.

Fixes: 811f67c51636d ("platform/x86/intel/tpmi: Add new auxiliary driver for performance limits")
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Link: https://patch.msgid.link/20260127-plr-debugfs-write-v1-1-1fffbc370b1e@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/plr_tpmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/plr_tpmi.c b/drivers/platform/x86/intel/plr_tpmi.c
index 58132da477457..05727169f49c1 100644
--- a/drivers/platform/x86/intel/plr_tpmi.c
+++ b/drivers/platform/x86/intel/plr_tpmi.c
@@ -316,7 +316,7 @@ static int intel_plr_probe(struct auxiliary_device *auxdev, const struct auxilia
 		snprintf(name, sizeof(name), "domain%d", i);
 
 		dentry = debugfs_create_dir(name, plr->dbgfs_dir);
-		debugfs_create_file("status", 0444, dentry, &plr->die_info[i],
+		debugfs_create_file("status", 0644, dentry, &plr->die_info[i],
 				    &plr_status_fops);
 	}
 
-- 
2.51.0



