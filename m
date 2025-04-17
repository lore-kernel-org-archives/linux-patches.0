Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176D9264A6D;
	Thu, 17 Apr 2025 18:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914108; cv=none; b=NJJabWIGWfNcucDHGJMy0+xIo9JDK5ej50Fe5qe1cdB2d2uMvDZ2saxIq9VHKft8eG2j4qtn22WgoVp8YYw/mSf40PwX8stakgsYupaNHklXv9Kbacf6G9OpbJHH8sjSzt1aJOEcwsRD7V1IEtJ4kCpe9jDvDFk4HS1SavdDOz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914108; c=relaxed/simple;
	bh=hG6C86TSQs93saaqdyX9OETbYZAwUv3kQL2Q9w9jaU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lvpv0XWtmzyOlNH5siKGMSE+6HLe4+pnbNID5aCBIAVOEF4oD5J4QHJqd6orGYqFFaU+okHkVVD1b0iIqzeLli5dGtCB9eaqOzGQtAMElUhsEWX6U1H2jaQL62Q+zEeZiOszuearChutDcBUw6Rdph1Yxke0aHwJDNJHTV9sfns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuZLE8z4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuZLE8z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22555C4CEE4;
	Thu, 17 Apr 2025 18:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914107;
	bh=hG6C86TSQs93saaqdyX9OETbYZAwUv3kQL2Q9w9jaU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuZLE8z4baGEa3Qk6BDSu9Z0Pjg8dOIDyHn/GyxbQm7A1xDNdi5fRK/kIMATX4IYu
	 X3URt4eCD7xy0W5emPjpvKUJuvU1DqLLh3WMwoJWU3hQjrqFUr8siirmL/kQS3+tJm
	 UYQKAvwPrH+atKftTQMK8fJ74sUrigwl3CKt7IXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Syed Saba kareem <syed.sabakareem@amd.com>,
	Reiner <Reiner.Proels@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 081/414] ASoC: amd: yc: update quirk data for new Lenovo model
Date: Thu, 17 Apr 2025 19:47:19 +0200
Message-ID: <20250417175114.702775236@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Saba kareem <syed.sabakareem@amd.com>

[ Upstream commit 5a4dd520ef8a94ecf81ac77b90d6a03e91c100a9 ]

Update Quirk data for new Lenovo model 83J2 for YC platform.

Signed-off-by: Syed Saba kareem <syed.sabakareem@amd.com>
Link: https://patch.msgid.link/20250321122507.190193-1-syed.sabakareem@amd.com
Reported-by: Reiner <Reiner.Proels@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219887
Tested-by: Reiner <Reiner.Proels@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index bd3808f98ec9e..e632f16c91025 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -339,6 +339,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83J2"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.39.5



