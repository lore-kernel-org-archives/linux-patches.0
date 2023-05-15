Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95472FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE79C433EF;
	Mon, 15 May 2023 17:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173382;
	bh=dikgG2imwo+P3cxb8MSGyr4TvK+hb3NCmkiOM0+zx7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3E5anmBQs45sbL1GyWTr97cqj3uw6sZULnsQB1jf2LQwbvcXdWQLImjQvUk822NZ
	 tACynN52HSg8DWbs/RyES0fYkEnKAU3ieKgejN5QtFxXvXOjbmBkIzT9OLI04Uf6Co
	 M58D/DpXHncRHNzl0OjTKx6U4qIhtfFQK4TYL3to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/282] firmware: qcom_scm: Clear download bit during reboot
Date: Mon, 15 May 2023 18:27:05 +0200
Message-Id: <20230515161723.670847006@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mukesh Ojha <quic_mojha@quicinc.com>

[ Upstream commit 781d32d1c9709fd25655c4e3e3e15370ae4ae4db ]

During normal restart of a system download bit should
be cleared irrespective of whether download mode is
set or not.

Fixes: 8c1b7dc9ba22 ("firmware: qcom: scm: Expose download-mode control")
Signed-off-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/1678979666-551-1-git-send-email-quic_mojha@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom_scm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
index b9fdc20b4eb9b..eda25d506059b 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -585,8 +585,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
 static void qcom_scm_shutdown(struct platform_device *pdev)
 {
 	/* Clean shutdown, disable download mode to allow normal restart */
-	if (download_mode)
-		qcom_scm_set_download_mode(false);
+	qcom_scm_set_download_mode(false);
 }
 
 static const struct of_device_id qcom_scm_dt_match[] = {
-- 
2.39.2



