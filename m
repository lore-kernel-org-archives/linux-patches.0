Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA8B1DDA15;
	Wed,  6 Nov 2024 12:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896118; cv=none; b=EW331PmI9Q8niw142ky5ziT2LNC0+lvf04mdcmXlK3adRBYfcVuqPmtVCLCP6BkjVEw8F174G9t36+npMI2r/g+3wK1goJ+rmAjJ90ch/zKcz6CNYV5E7nJaF8G96WUnioKD6nTnUmJgEvcKNC8Ox1BUmIFvVhm2chs+/GQnvWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896118; c=relaxed/simple;
	bh=8MKVfIRX99245zKm6ugw6sJ0wQN1VKb/RJtmI2yi+Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJ2CY0sVWcIQBfD5yiI7WRHZYvW7z+3OTUOg/l9EvlItQyWvjTngyz/DukXAK+wE6+VWVpdLyg65wutL2jok+lNS9oH++T6T/UyT5SnbU3QifwkEBbCyoHIiuWNH/QRSJK6POTgi+XJyGl8oP3jYnAG6w9QiApX6t4oQTP3Uj94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhAChVbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhAChVbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCC1C4CECD;
	Wed,  6 Nov 2024 12:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896117;
	bh=8MKVfIRX99245zKm6ugw6sJ0wQN1VKb/RJtmI2yi+Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhAChVbWvPgyKNohRCBIom7R3r0Zu3tWb5s5dzpeNtZPtjJ5iaDTLhqtUqn8q2Mr0
	 US+4c0g42TRy9Rw8fYL1bVsQOUMlRg5jY9q55XugMmM/dlYxOkLEqPSusV3UHn/F6R
	 40PtdDb3lIt4Ph5S+qpX+r3fSOiPr9sEOHCe0k+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 096/245] powercap: intel_rapl_msr: Add PL4 support for Arrowlake-U
Date: Wed,  6 Nov 2024 13:02:29 +0100
Message-ID: <20241106120321.571596553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>

[ Upstream commit f517ff174ab79dd59f538a9aa2770cd3ee6dd48b ]

Add PL4 support for ArrowLake-U platform.

Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20240930081801.28502-5-rui.zhang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_msr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_rapl_msr.c
index 733a36f67fbc6..1f4c5389676ac 100644
--- a/drivers/powercap/intel_rapl_msr.c
+++ b/drivers/powercap/intel_rapl_msr.c
@@ -147,6 +147,7 @@ static const struct x86_cpu_id pl4_support_ids[] = {
 	X86_MATCH_VFM(INTEL_RAPTORLAKE_P, NULL),
 	X86_MATCH_VFM(INTEL_METEORLAKE, NULL),
 	X86_MATCH_VFM(INTEL_METEORLAKE_L, NULL),
+	X86_MATCH_VFM(INTEL_ARROWLAKE_U, NULL),
 	{}
 };
 
-- 
2.43.0



