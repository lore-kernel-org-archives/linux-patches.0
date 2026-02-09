Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EDD37C0F1;
	Mon,  9 Feb 2026 14:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647948; cv=none; b=WehxUMlx6HaEOnFIOjpLi67gFVaZpnUMN3x3DJkXbyOOCHzuGho1qlxT0HV1bO4TYb+Jkb6w/zYMm9+ZV4WYI/xSrjlngfmdEiba10D9Tl81pGHJhNR5W6nsreHWCSRS7YIVY8bnCBCsY23twYMKbyygItsjpxAdGGVYuAOmjrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647948; c=relaxed/simple;
	bh=P1CO17NJg0j4Vt0gCktP1lxQgyIW+A8MC+0lSpA8mkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVZ0HlrLFtNrw58atXMrJ0geFspcr1lwKBLvJ7fDofrysp5x/Dq+ZopymkQ9TtjTfYNseheFEPKiykBBrWrsIDvuJDnmSni9ESR0Yor1nryvij6PnJRtSlGnKmsQ84XhSPIrNm/+jZwsaiLfwGw7v5rojqqbQ4XkGiiK/1YtjSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2Yj5YLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2Yj5YLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528DFC116C6;
	Mon,  9 Feb 2026 14:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647947;
	bh=P1CO17NJg0j4Vt0gCktP1lxQgyIW+A8MC+0lSpA8mkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2Yj5YLw2odmtRaex7snl/76565mvwrFQn8SC6JDVIoBtz1UdaDO14S+xlVI+uN4c
	 bLioLaqm9IqXIDxCEW9uYduxfBGNzcBSiiju3IdsEaXM7WCztngE9/o/AHNWfGVxS8
	 WpbuOYaqWaD74C1WyG9cFwMH5ZWezHueIG8X1nCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/113] platform/x86/intel/tpmi/plr: Make the file domain<n>/status writeable
Date: Mon,  9 Feb 2026 15:23:45 +0100
Message-ID: <20260209142312.916714665@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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
 drivers/platform/x86/intel/intel_plr_tpmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/intel_plr_tpmi.c b/drivers/platform/x86/intel/intel_plr_tpmi.c
index 69ace6a629bc7..ffb2f7ffc7b51 100644
--- a/drivers/platform/x86/intel/intel_plr_tpmi.c
+++ b/drivers/platform/x86/intel/intel_plr_tpmi.c
@@ -315,7 +315,7 @@ static int intel_plr_probe(struct auxiliary_device *auxdev, const struct auxilia
 		snprintf(name, sizeof(name), "domain%d", i);
 
 		dentry = debugfs_create_dir(name, plr->dbgfs_dir);
-		debugfs_create_file("status", 0444, dentry, &plr->die_info[i],
+		debugfs_create_file("status", 0644, dentry, &plr->die_info[i],
 				    &plr_status_fops);
 	}
 
-- 
2.51.0



