Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F343491D0;
	Fri, 21 Nov 2025 13:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732796; cv=none; b=i+lfauz52JUU5nXq3HgburrzYhAArDPU4TC2MI0d6cqgMji+EVn1bO3l5d8JrvfjZrmfOSvXLG3kvJ23+f+0S1IuBPlUgrmGFzOvNZdDXuUekEKrUYiotSYOIw/fGjvCMvA+nd1JJpOXQkS9pbiRpeLPqdCUoDgRDpULfXQnRKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732796; c=relaxed/simple;
	bh=u5MAQ5VJ4syonu1MWhj9NZYYvmoM/LvqV/sDwVcnzJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKKcKrmB3lO2eyz8VlAYd5bbpZPSqTi83eGMp8toViiLMxUP31JV0AIEleLuuwiRe+gD00VyuWukH1R3WsyKRhVtq6F6+SSmLhRr7ko4LYiJ88lxBcAGHu5ev3wtEsbby+iBjt0G9vLdHAkrB7bf8v23Sw3r4t3LoRAgN8cuPlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AsWt/ehN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AsWt/ehN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187F5C4CEF1;
	Fri, 21 Nov 2025 13:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732796;
	bh=u5MAQ5VJ4syonu1MWhj9NZYYvmoM/LvqV/sDwVcnzJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AsWt/ehNqmiIB2FCc5VeLzkQnO7eD2OVItPI4+n3lNkGzLy1OzUqYN0BkSUk+IMdj
	 HjcatkZ5IdzwbgqYD9JKWt3pU6I8U+llV/FePgcFDOfLito+/9PrMfUSypgYmd2dcV
	 AR6YQwpuDFZRMf+tquJ8FUBy+PK2fBdJKSDSDh3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yao <hao.yao@intel.com>,
	Hans de Goede <hansg@kernel.org>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 203/529] media: ov08x40: Fix the horizontal flip control
Date: Fri, 21 Nov 2025 14:08:22 +0100
Message-ID: <20251121130238.239873094@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Yao <hao.yao@intel.com>

[ Upstream commit c7df6f339af94689fdc433887f9fbb480bf8a4ed ]

The datasheet of ov08x40 doesn't match the hardware behavior.
0x3821[2] == 1 is the original state and 0 the horizontal flip enabled.

Signed-off-by: Hao Yao <hao.yao@intel.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Tested-by: Hans de Goede <hansg@kernel.org> # ThinkPad X1 Carbon Gen 12 & Gen 13
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov08x40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov08x40.c b/drivers/media/i2c/ov08x40.c
index 637da4df69011..4d15fa6ac311e 100644
--- a/drivers/media/i2c/ov08x40.c
+++ b/drivers/media/i2c/ov08x40.c
@@ -2643,7 +2643,7 @@ static int ov08x40_set_ctrl_hflip(struct ov08x40 *ov08x, u32 ctrl_val)
 
 	return ov08x40_write_reg(ov08x, OV08X40_REG_MIRROR,
 				 OV08X40_REG_VALUE_08BIT,
-				 ctrl_val ? val | BIT(2) : val & ~BIT(2));
+				 ctrl_val ? val & ~BIT(2) : val | BIT(2));
 }
 
 static int ov08x40_set_ctrl_vflip(struct ov08x40 *ov08x, u32 ctrl_val)
-- 
2.51.0



