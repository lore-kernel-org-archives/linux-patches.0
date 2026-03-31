Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F12E425CC4;
	Tue, 31 Mar 2026 16:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976313; cv=none; b=edUnwfzBqHUEseNQPJrFf6YjDO6JtwibL8bt7Ifybi32csw+GTtZPNagdXI0beMrYuK4Ym+U+RpLL8GajF94hjTBim1/qnzCex5HfcBKY73wqr90le5TZeMNpL1YkeN3+dWcTkM3RitJ6gZ7Tlthzes36RjOO6JQ7SGHw8+Ctlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976313; c=relaxed/simple;
	bh=poUT66zwBzn7MBVgPwvgEYzCyh0HLPZ05s5eQRU6ilQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEDbSGz7m134OcQFq1mIhT7HNY0Y0/3OwwBgsLQCoQOdTJgg0xu7EK8n67qpj63U28zhbinH+49DCZNgLB7JxPwkg2XWcGe+hvqV2nMu2HRdlo2Y9Mcp9pWdVfVKVIerK5olLw4xehO5m9lXHILEOIK9Ce4zA+TZhegsKYuKYPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+oLJkZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+oLJkZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA19AC19424;
	Tue, 31 Mar 2026 16:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976313;
	bh=poUT66zwBzn7MBVgPwvgEYzCyh0HLPZ05s5eQRU6ilQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+oLJkZoBsoOgOruOYP7hdzXjPsQYASlhZvVY3REiZKniebjwI+QrOGEM/ly0Lg3e
	 UfNeQRc5+R1+BmmDaC3SlNNlo1K/dGuwCY31gBOFqB/p2mUr3DNdkRLqv84tTWoWhG
	 rfKwEQE974Jy9D5to5urTAapsz1kQPS6OrZs4oFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Freyermuth <o.freyermuth@googlemail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/309] ASoC: Intel: sof_sdw: Add quirk for Alienware Area 51 (2025) 0CCD SKU
Date: Tue, 31 Mar 2026 18:19:07 +0200
Message-ID: <20260331161755.107025504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Freyermuth <o.freyermuth@googlemail.com>

[ Upstream commit 70eddf6a0a3fc6d3ab6f77251676da97cc7f12ae ]

This adds the necessary quirk for the Alienware 18 Area 51 (2025).
Complements commit 1b03391d073d ("ASoC: Intel: sof_sdw: Add quirk
for Alienware Area 51 (2025) 0CCC SKU").

Signed-off-by: Oliver Freyermuth <o.freyermuth@googlemail.com>
Tested-by: Oliver Freyermuth <o.freyermuth@googlemail.com>
Link: https://patch.msgid.link/20260224190224.30630-1-o.freyermuth@googlemail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 6c95b1f8fc1a5..465bf5fafecf7 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -749,6 +749,14 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
 	},
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0CCD")
+		},
+		.driver_data = (void *)(SOC_SDW_CODEC_SPKR),
+	},
 	/* Pantherlake devices*/
 	{
 		.callback = sof_sdw_quirk_cb,
-- 
2.51.0



