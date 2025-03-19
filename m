Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9EA1D514F;
	Wed, 19 Mar 2025 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395040; cv=none; b=NPDrDUVI8W9rw9/Nou9q69RqRhMu9+tGWD3mFz37RmHP7djFI9dbjdzKFyahf9yXiUHE+T2byJ+XixWF2HqIIuqYr9t9S/4IooJKvblcyIsiJh7knzfEO08PwcwpybsaLPUuTf+ndkH75g7mgS6LkX6q4CfkfKs/IUf4eZms24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395040; c=relaxed/simple;
	bh=FP/jPe3AMPGh6i28fNtBgBXSDcjbvNMxmp1CxVsQ4tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XEZKZh10kJVg5JMYhIqGrR9WsELRP2ABtNmC8mPXWnTYIQUr3kVTIEbxe7v9JZuKzqoFAed53fYhbbSwV9gitbe+gEmNSl1Qz6Zc5vyoA+PMIvCM/a5pWrcxF5x1VvbePirNlaR2//qcysSYl1YnledNWyHkhSal0hkF3F0A9XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txdnxbxc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txdnxbxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBFEC4CEE4;
	Wed, 19 Mar 2025 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395040;
	bh=FP/jPe3AMPGh6i28fNtBgBXSDcjbvNMxmp1CxVsQ4tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=txdnxbxcnu2sQXI2j6tOGZONIaaRi+N6FuQ9BcM2/1MFU21F6/OSe8WREP0jZg6w1
	 r57UqCb0d+sYtItq6fiGiF5FHsvUZc5n4MkG4go3OrNXn8f5rn3kj/H0BAfMfoL/FE
	 hTtp+yej8W4YuYCCBPC8nKLlEKeUYAUWQ0otErDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/231] platform/x86/intel: pmc: fix ltr decode in pmc_core_ltr_show()
Date: Wed, 19 Mar 2025 07:29:17 -0700
Message-ID: <20250319143028.407262485@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 583ef25bb2a094813351a727ddec38b35a15b9f8 ]

In pmc_core_ltr_show(), promote 'val' to 'u64' to avoid possible integer
overflow. Values (10 bit) are multiplied by the scale, the result of
expression is in a range from 1 to 34,326,183,936 which is bigger then
UINT32_MAX. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Reviewed-by: Rajneesh Bhardwaj <irenic.rajneesh@gmail.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250123220739.68087-1-d.kandybka@gmail.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index 4e9c8c96c8cce..257c03c59fd95 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -625,8 +625,8 @@ static u32 convert_ltr_scale(u32 val)
 static int pmc_core_ltr_show(struct seq_file *s, void *unused)
 {
 	struct pmc_dev *pmcdev = s->private;
-	u64 decoded_snoop_ltr, decoded_non_snoop_ltr;
-	u32 ltr_raw_data, scale, val;
+	u64 decoded_snoop_ltr, decoded_non_snoop_ltr, val;
+	u32 ltr_raw_data, scale;
 	u16 snoop_ltr, nonsnoop_ltr;
 	unsigned int i, index, ltr_index = 0;
 
-- 
2.39.5



