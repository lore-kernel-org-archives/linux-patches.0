Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C719F29A1;
	Tue, 17 Feb 2026 20:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361587; cv=none; b=E44H6/IitYcAeTU7eU3Fg0g5/M8V+pRe5fh4l5Qdfft/uySBkKSLtr4vtJxy624VA0jWLk61Rm7vizgHs8aGLZrt3YHeHjSc8N4DE72Ph414bgcpR47VssW7HRBflZVLuuFgHL6RiLws5782DSJH0Ad34PIM5DtCXXbyC/WH9y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361587; c=relaxed/simple;
	bh=5CjTl4uDFTjxuduZoouL5pkW3EjWhK1wacK3r+x2/ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sE8C4/sV1DFhXwmh+gFvMOCnQDEK2HK8dT60w+776kZC1nI4DeykD+owUarAkmzZ7StXmqpJrKDpGpU2PFYqAAx9FrTea3flQUXWT0j5aZAzcOFfnpzdteyDp1iHUB1GxNXVEroAf+W2Pfsq5PtcZ0Rl+3wXFfllz6LWwqui8n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiR6WHI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiR6WHI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DBDC4CEF7;
	Tue, 17 Feb 2026 20:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361587;
	bh=5CjTl4uDFTjxuduZoouL5pkW3EjWhK1wacK3r+x2/ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiR6WHI6NDe2N/QqXRdOhT6AowNDwL2HUVIkSB7puXVlxhoWr98ugsPFKSu4C3slW
	 eonQzoU3ufn7p4cGEmKKerxJdzXXKRNL6b6MxrBiJi2vlcypwBRl74V6WfKKP+FuE5
	 iv7C++DRX/9QjDxftRF2z3xM99Nah+zuzJCXVJR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 16/42] ASoC: amd: yc: Add quirk for HP 200 G2a 16
Date: Tue, 17 Feb 2026 21:32:07 +0100
Message-ID: <20260217200006.626340801@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Su <dirk.su@canonical.com>

[ Upstream commit 611c7d2262d5645118e0b3a9a88475d35a8366f2 ]

Fix the missing mic on HP 200 G2a 16 by adding quirk with the
board ID 8EE4

Signed-off-by: Dirk Su <dirk.su@canonical.com>
Link: https://patch.msgid.link/20260129065038.39349-1-dirk.su@canonical.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 4f75a7d9b0e70..6d073ecad6f02 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -633,6 +633,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8BD6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE4"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.51.0



