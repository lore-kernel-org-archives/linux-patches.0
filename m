Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183302F7461;
	Tue, 12 Aug 2025 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020492; cv=none; b=pQmfE/bnQdQfWNPBCrjXFOw3pI6bh2CpTZZus8JWbPhNnfMvRMpT5p1+uguTOkgYJLu3M6/cJY/WCxtOvW9DoNkQnOtnO69GsHB7mBanQpLs06ZH9Ph/z5deVHf8IJhXB0gqp6QyfFpeYb+dB19U5/lK2NskQsiAFQaz8k+TmQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020492; c=relaxed/simple;
	bh=4k+i45f0sBPrZ4NRfRtnNsyeCgOqKKP//j+DhyrMExg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2BKHaUFPVA2pkMRWp3y6ka0P42rYvb2AgNFmkCyxldnmGw5z+/Uwzo5DGgguE4AtgYjfPPM9WvbOs17YvAOiCc2NB6h2ta93X0GNFjqeYIcbF8y+RLuzT1ZfyLzfBN7Yv0u9vWjZKp6hxUwdIKhMiRQN7ptslLaKFE7xlxaFdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Vx3kY3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Vx3kY3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5E2C4CEF7;
	Tue, 12 Aug 2025 17:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020492;
	bh=4k+i45f0sBPrZ4NRfRtnNsyeCgOqKKP//j+DhyrMExg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Vx3kY3J8a93TCnrYv88vaUReA5/5vHjZ4tdUuNVmPaA2b7137iEbSW3iTNmyCBBb
	 o3g+u7OKErpvm1NcNPssWPvv6qqganUJrvvq6IjNVL7bRgM2ALE3VQd6B/sa/KT51K
	 sp7zJq4NAZ8VCPuE+WZulHRNzbuCbtjwDC+AfxFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Queler <queler+k@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/253] ASoC: amd: yc: Add DMI entries to support HP 15-fb1xxx
Date: Tue, 12 Aug 2025 19:27:30 +0200
Message-ID: <20250812172951.364371620@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Queler <queler@gmail.com>

[ Upstream commit 949ddec3728f3a793a13c1c9003028b9b159aefc ]

This model requires an additional detection quirk to
enable the internal microphone.

Signed-off-by: Adam Queler <queler+k@gmail.com>
Link: https://patch.msgid.link/20250715031434.222062-1-queler+k@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1f4c43bf817e..fce918a089e3 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -458,6 +458,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16z-n000"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Victus by HP Gaming Laptop 15-fb1xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



