Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7912BEC2F;
	Tue, 12 Aug 2025 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022012; cv=none; b=GFzsI65vmjTcjVmFqhgTLjBLkRZkQ5Fb8fWcYVx7SOnAxpwhW2PgbAhZeAawiUMjzcvV4RVvA9EMD9zemNaLq3riY0Mhk0jiKYsaMqn26Jx3i23vrCfwt0bPW0K8yPi3tXTXp6TKq8vmfcmYaQn6ijVgts85yozzp6znfaXQEPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022012; c=relaxed/simple;
	bh=hsVWuIzjyF+wpB8RtLSIqD1ixvgxz45OUnfapmp9XQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9Fi7JMt+oQ3+xjnMY29WfHkS68+vTqg5PEPmWGh2+6u+xn4aAZMkPU/HWHyLWaISeaCcpCYK0oX9yyzNO2Gi7yX9f9FHdUjVSdo+9Xk3n2606d/z5zdWi2OmTslEYMVATQpXuMOL9uRNp4Utht9MjuAlIjZZyyqYQWxLBLJ+hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0epKeytN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0epKeytN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8EBC4CEF7;
	Tue, 12 Aug 2025 18:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022012;
	bh=hsVWuIzjyF+wpB8RtLSIqD1ixvgxz45OUnfapmp9XQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0epKeytNwzpx8tjiPRKOCAPgcvNdXcNwQ0BNof+vHFyhH3XsRU69qxvHBo2dUE1ta
	 7Otd3dEktMRavDOf8SM6KHqmT2kVWn/5anIRhCNZTBKTLa0T3Rquexx43IQl6FPWW5
	 g3s93SBqFVgnt2W3mtYLSI5mFgKUEIeNfrPU/qHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Queler <queler+k@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/369] ASoC: amd: yc: Add DMI entries to support HP 15-fb1xxx
Date: Tue, 12 Aug 2025 19:25:00 +0200
Message-ID: <20250812173014.873778286@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index 42d123cb8b4c..4bde41663f42 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -528,6 +528,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
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



