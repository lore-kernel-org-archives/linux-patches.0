Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4683AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDB2C433EF;
	Wed,  4 Jan 2023 16:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848677;
	bh=iwQjpzbxGQaC1p9wQRoMDHO8sW9SFpnD8zA+bG90Rqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOasnxjG8gDyW+5ri6/W1ZPirhMcQw+xMFDa3AN4wawVbYRlQIzBAQqDv9TFcoLg1
	 dnqqZtgbzBiiyutxsiVs2LzbP47AJgCwsSHurBDiYd2b1ylWajVbG0nydb95PBUxds
	 ATfdDV5ssDtIaH6T7jSgSyr2VDaxsbyuj6AXSHOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/207] platform/x86: intel-uncore-freq: add Emerald Rapids support
Date: Wed,  4 Jan 2023 17:05:11 +0100
Message-Id: <20230104160513.593013667@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit 9c252ecf30360cb7b4dbcc275aebe5642174fd39 ]

Make Intel uncore frequency driver support Emerald Rapids by adding its
CPU model to the match table.

Emerald Rapids uncore frequency control is the same as in Sapphire
Rapids.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 8f9c571d7257..00ac7e381441 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -203,6 +203,7 @@ static const struct x86_cpu_id intel_uncore_cpu_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_uncore_cpu_ids);
-- 
2.35.1



