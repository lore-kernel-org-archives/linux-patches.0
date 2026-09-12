Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03176363C6F;
	Sat, 12 Sep 2026 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231763; cv=none; b=p2445WpMp+f+qPzccmTeIiAMfYKyf7Sb3F9UrnlAa9CHSMZRK7b5KE7PQRuIVt/T2dNnrCpaKHbwL7UWvfMfskE5wvIJRy0dWAxkFI45UwnBxFVpcibKp4q/GFtG3Z0F2bIgyTkl2JqXeWmYNpCkDwhdVLmI4SXoWMQHMC/cZa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231763; c=relaxed/simple;
	bh=8/AGWDeJwyyU3jYr0MHSCWT52ENkz24JJAasnhhcNpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=InEtVXbf7Xo4VzziLTGzMG2jgEPSMSvDL298U2U0yMEb3j6hH6n2LuktUB2ld7ScrL3qaXXWxRt7IfAbNpC9PeGuAevr+lzyFuFq7usA/YWTtPp4pL6tvIaIMuVwM4xO3aVaAKp5JG77C3Nghb6BkMaFvzAgM8fi9wkewVzO9Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxWwZ00H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxWwZ00H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81C81F000FF;
	Sat, 12 Sep 2026 16:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231761;
	bh=VYAYySbWM0F7N5PG8YG8nXo2s5D+YvuBkwVwUD8k5/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxWwZ00Hia1fWEeHKmsY6gemVBrLCCgW/JNPrOdWWJlHh4W+74NTmfbczJ9SSQGW2
	 NMJ4rcX2SiO0yZmLOHpg0ZUbLHCyMyeMnwqaX4yXMf8YmNTIa2J/7YijxE0rGnaNNE
	 0T1gQbByeFT+8T4aFv2u1Vd5L6Qj7LK/drQJTVSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1066/1191] i3c: mipi-i3c-hci: Switch PIO data allocation to devm_kzalloc()
Date: Sat, 12 Sep 2026 09:03:14 +0200
Message-ID: <20260912065612.117621193@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 11d17c2855bfc04550557017eae02e92f3eeab1c ]

The driver already uses managed resources, so convert the PIO data
structure allocation to devm_zalloc().  Remove the manual kfree().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-7-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 308ecb824db3 ("i3c: mipi-i3c-hci: Fix missing STAT_IBI_STATUS_THLD in PIO mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/pio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/pio.c b/drivers/i3c/master/mipi-i3c-hci/pio.c
index 653cee2d0645a..9f0e12d2b906a 100644
--- a/drivers/i3c/master/mipi-i3c-hci/pio.c
+++ b/drivers/i3c/master/mipi-i3c-hci/pio.c
@@ -141,7 +141,7 @@ static int hci_pio_init(struct i3c_hci *hci)
 	struct hci_pio_data *pio;
 	u32 val, size_val, rx_thresh, tx_thresh, ibi_val;
 
-	pio = kzalloc(sizeof(*pio), GFP_KERNEL);
+	pio = devm_kzalloc(hci->master.dev.parent, sizeof(*pio), GFP_KERNEL);
 	if (!pio)
 		return -ENOMEM;
 
@@ -219,8 +219,6 @@ static void hci_pio_cleanup(struct i3c_hci *hci)
 		BUG_ON(pio->curr_rx);
 		BUG_ON(pio->curr_tx);
 		BUG_ON(pio->curr_resp);
-		kfree(pio);
-		hci->io_data = NULL;
 	}
 }
 
-- 
2.53.0



