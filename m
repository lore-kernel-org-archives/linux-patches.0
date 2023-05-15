Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C44BFC10
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACFBC433D2;
	Mon, 15 May 2023 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172254;
	bh=1aiFNeU6FZ6PQ1Smd1a41ssMmmiQsYLg61m66KZYdK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjNlO/7+F/H1xAuxW0kvwh7iPOq7JOW78rjzEXdqaojmU+bUgXZtqdI7i482OOmCY
	 19HMB2JeOPamdKsFpdPvXEojE3q1by/9VMO46jU/SQo7yjTsGUHypZFNkJ2c/lOkOw
	 fBB+PvV8Dul2hRTXqqp3N6rJmR0hEiqeKtOUNhk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 093/381] firmware: qcom_scm: Clear download bit during reboot
Date: Mon, 15 May 2023 18:25:44 +0200
Message-Id: <20230515161741.014397949@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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
index d417199f8fe94..96086e7df9100 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1256,8 +1256,7 @@ static int qcom_scm_probe(struct platform_device *pdev)
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



