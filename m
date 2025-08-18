Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5B831A068;
	Mon, 18 Aug 2025 12:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521564; cv=none; b=bNP9ww+4ZUM6RLfeBfDoKzUTbeOK0i+OiI2OpHfRaQjoBL1AvHSZmZQ+IZPwbrN3eRAGGMmc0pVO3L1dlFamenwNYzB6BDpFRS7ToRmOcwXTkv//wBKWA4eruPwSOvYb1cyepuQXCEd4i4VGyoKU3szxpIZyrKhR2DTbU5PD4nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521564; c=relaxed/simple;
	bh=WYS74mdY2S4vY4NhaAx/iOVWN7dmAd3h2BlUTAsY1l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3u29ipwDzbX545Ip2Qzpj51f2jMzP5tZWBB5DDrw2DlaRYOz834orZEXVDd+B+5Qc3I/fvRA4dn0p893mxig60b7X+9sbA9OeEvoqadUDynycD4SGYicd9ErbzjGzUHyX/fcaGW6sBCSnUc4/aKby1aPwyz+FzuBeQMMOQ/SyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Ehx4cyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Ehx4cyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2689C4CEF1;
	Mon, 18 Aug 2025 12:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521564;
	bh=WYS74mdY2S4vY4NhaAx/iOVWN7dmAd3h2BlUTAsY1l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Ehx4cyOX2Gdzh3AM/FUrTisPrFk/BvJoPIpHL4qzmDVFrUrWrkuAP5T2wZKQjuuJ
	 BhyWFlifhRxo6q9HutujV8gvXBIdL1gXdFZkuEthf2K7ZeXYT28a1mBp2gyhOMc7Nm
	 4jU7/S1mXaN4GgrWAFpRYkFYLNDRHGwYGqoat7LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/444] intel_idle: Allow loading ACPI tables for any family
Date: Mon, 18 Aug 2025 14:41:25 +0200
Message-ID: <20250818124451.155201030@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit e91a158b694d7f4bd937763dde79ed0afa472d8a ]

There is no reason to limit intel_idle's loading of ACPI tables to
family 6.  Upcoming Intel processors are not in family 6.

Below "Fixes" really means "applies cleanly until".
That syntax commit didn't change the previous logic,
but shows this patch applies back 5-years.

Fixes: 4a9f45a0533f ("intel_idle: Convert to new X86 CPU match macros")
Signed-off-by: Len Brown <len.brown@intel.com>
Link: https://patch.msgid.link/06101aa4fe784e5b0be1cb2c0bdd9afcf16bd9d4.1754681697.git.len.brown@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/idle/intel_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 524ed143f875..4506e1cc4b65 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -1608,7 +1608,7 @@ static const struct x86_cpu_id intel_idle_ids[] __initconst = {
 };
 
 static const struct x86_cpu_id intel_mwait_ids[] __initconst = {
-	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, 6, X86_FEATURE_MWAIT, NULL),
+	X86_MATCH_VENDOR_FAM_FEATURE(INTEL, X86_FAMILY_ANY, X86_FEATURE_MWAIT, NULL),
 	{}
 };
 
-- 
2.50.1



