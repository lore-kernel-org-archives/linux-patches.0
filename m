Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099AB30567F;
	Wed, 20 May 2026 16:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295802; cv=none; b=TO9QoVF32VNfYw2dmhE3aqevQ99F6/TCZu2PNMEKd4Ujymt17Ikag3sa3sVDjJvuIkEHdb/2aKiMClQCthIpPXPvxbj8xP/GOwdiCLHtP+8wfujmHb1Dr/hX8BEBrrgTCTR9CLjq2GmMeTIgMThQ2So5HAwgfXikMUgAMLy/JQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295802; c=relaxed/simple;
	bh=Ic93zAU8PvaDrg6dzZFoHZKS8IJMVjpixyVpNjs+/O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqlOP9F6Bh4o6du6uJoz2rSuRxBnUpvFc72BzrZVpaSVxURaO+Yc4QrMA62avNi66xroDE227IfbI00xr/2Y1HrIKavuLtB/dlWU8Ao9dLlURJNfNd8KMsrk99wI4O896Du4xESHgS+5jk2qX6/vkrOy6f+bhThWUHtUFa9aDnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3RusHHC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3RusHHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972681F000E9;
	Wed, 20 May 2026 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295800;
	bh=SGKpHRkrARbkNgNuwI6G/7+3fIohRE/nqfIiozQTSr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3RusHHCr4jznpb6V8eWlasHpYRWr9L6bifYogBDzi5TuyoHuzMqDRnlus0d+sKif
	 PYE+KIzP64M/sEg4Rx3mh8+dO3lzl7VmO3o8EXmX6Dqm/en3pBaOyUgxWw3eCcyCW3
	 mOtG/EE6riyz83RV6GPL2MIyzHChzSEx/w2dtm0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0555/1146] soc/tegra: pmc: Add kerneldoc for wake-up variables
Date: Wed, 20 May 2026 18:13:25 +0200
Message-ID: <20260520162200.740193533@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit e6ad1988e56834d641ba4aa0d58970723c1c9c9b ]

Commit e6d96073af68 ("soc/tegra: pmc: Fix unsafe generic_handle_irq()
call") added the variables 'wake_work' and 'wake_status' to the
'tegra_pmc' structure but did not add the associated kerneldoc for these
new variables. Add the kerneldoc for these variables.

Fixes: e6d96073af68 ("soc/tegra: pmc: Fix unsafe generic_handle_irq() call")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index b889c44f8fddf..6debaabdaa36a 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -439,6 +439,8 @@ struct tegra_pmc_soc {
  *     cntrl register associated with each wake during system suspend.
  * @reboot_notifier: PMC reboot notifier handler
  * @syscore: syscore suspend/resume callbacks
+ * @wake_work: IRQ work handler for processing wake-up events.
+ * @wake_status: Status of wake-up events.
  */
 struct tegra_pmc {
 	struct device *dev;
-- 
2.53.0



