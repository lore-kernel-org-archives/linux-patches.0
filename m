Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0115C1EA8D;
	Mon, 12 Aug 2024 16:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478736; cv=none; b=YCMJaacJK9X5TRVC1EXib4IcRB/3bu01Fx8pCv9vMyUUseuA30w9uDB7WaLz6o2N0bXYnLSTBscPAyt8VgSEjHNeoXzmrc/yeyuEcWbEk+YFQNcayZ6QVbiGg0xpZqk9+qWF1wfKiwkIijMgHDAH27lMWR+BgdUnl+qrUW3yX/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478736; c=relaxed/simple;
	bh=eLdf2t6MQStkvQBX7Hllxss8uvOKSIkMp5O9FyGb43w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZaEqlWXC6Z99fRkZk3BztT9aaDlr2x5ozcVGSRDxc0txHLiF8nQfshza3G0A/L1c5asdK5PuZVD5QU4TtZgRrqKE5YEea/09RFhr1AKA6BXB/j5EZKKutqC4PCrTGl2DFJ7sReKvtYT5wQS03XQTCOfiDkyERB4VSoXOP+4kxfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1vVMis8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1vVMis8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642E8C32782;
	Mon, 12 Aug 2024 16:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478735;
	bh=eLdf2t6MQStkvQBX7Hllxss8uvOKSIkMp5O9FyGb43w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1vVMis8DyyFydVx0MIIN+SRGwrBmN1TqaM9HO8T+S8xE0T4Ra+/Yyvm8+5xAggMn
	 OixWvdzvIaqg7PYv4Wlaz62IXCNSYPINLmYnOKsjKBVJvj0HYiInEBD3dhfE5g2uFv
	 6+q4ewGWVUSVb16LAEY3yxsbQw5mf7qRYG6IU/Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/150] platform/x86/intel/ifs: Initialize union ifs_status to zero
Date: Mon, 12 Aug 2024 18:01:24 +0200
Message-ID: <20240812160125.280021245@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit 3114f77e9453daa292ec0906f313a715c69b5943 ]

If the IFS scan test exits prematurely due to a timeout before
completing a single run, the union ifs_status remains uninitialized,
leading to incorrect test status reporting. To prevent this, always
initialize the union ifs_status to zero.

Fixes: 2b40e654b73a ("platform/x86/intel/ifs: Add scan test support")
Suggested-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/20240730155930.1754744-1-sathyanarayanan.kuppuswamy@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/ifs/runtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index d6bc2f0b61a34..aeb6a3b7a8fd9 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -165,8 +165,8 @@ static int doscan(void *data)
  */
 static void ifs_test_core(int cpu, struct device *dev)
 {
+	union ifs_status status = {};
 	union ifs_scan activate;
-	union ifs_status status;
 	unsigned long timeout;
 	struct ifs_data *ifsd;
 	int to_start, to_stop;
-- 
2.43.0



