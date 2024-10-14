Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF981ABEBF;
	Mon, 14 Oct 2024 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918086; cv=none; b=ezbSrD3ZwOJxkf9+zwpO/n0fjz1Z5LPz7avACCpGqELH9I6bGUQ2ZjWa6PkWuosrE7IjNjnIY0hBvNrraHiMZ+I99E3UzzREdspySx7UP0IRB+rV+u0PyRj1Grd23UU60gACj0K0RrKc9GLa1fj1AmgoyfUsEkqFQOQokFPRX4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918086; c=relaxed/simple;
	bh=Hs506wZfFjvYSNm8PJUPIL7e2BIoxMKNC8exGSjWqBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xa0/AnpbQdE0VY4BWDABCmGvnOjhcfX5TA0pcEpoUOI6vpAY+oYbDq8m5fekbWM4MLXDrbBURLx8irgZm/ALk3yMXyFXEH5H3GG7EDozQxdoIUQHqobqALWkF5CvQS3/NlhaPtmxAvi8IXD8m03NOP945sbtN8Q0209AnlpNSuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTBxMEpa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTBxMEpa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043B7C4CEC3;
	Mon, 14 Oct 2024 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918086;
	bh=Hs506wZfFjvYSNm8PJUPIL7e2BIoxMKNC8exGSjWqBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTBxMEpaffR89NQJyt6eUJidc6PTw8GeJCgBIry0eqj9HaJ3mMym+JQ2aacgnt7oh
	 ORCwYtIXNPga39o33jrfcoYwwulCURzXVANAgE2IIoJOSxUR3isnYmtoFzT7B+FKko
	 CwHTdlekBQK/PuPlTDG53XtwAveVONBCskBxeVjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Lv <terry.lv@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/798] remoteproc: imx_rproc: Correct ddr alias for i.MX8M
Date: Mon, 14 Oct 2024 16:12:25 +0200
Message-ID: <20241014141225.434491224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit c901f817792822eda9cec23814a4621fa3e66695 ]

The DDR Alias address should be 0x40000000 according to RM, so correct
it.

Fixes: 4ab8f9607aad ("remoteproc: imx_rproc: support i.MX8MQ/M")
Reported-by: Terry Lv <terry.lv@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20240719-imx_rproc-v2-1-10d0268c7eb1@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index bc26fe5416627..7dad5cbec7ede 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -160,7 +160,7 @@ static const struct imx_rproc_att imx_rproc_att_imx8mq[] = {
 	/* QSPI Code - alias */
 	{ 0x08000000, 0x08000000, 0x08000000, 0 },
 	/* DDR (Code) - alias */
-	{ 0x10000000, 0x80000000, 0x0FFE0000, 0 },
+	{ 0x10000000, 0x40000000, 0x0FFE0000, 0 },
 	/* TCML */
 	{ 0x1FFE0000, 0x007E0000, 0x00020000, ATT_OWN  | ATT_IOMEM},
 	/* TCMU */
-- 
2.43.0



