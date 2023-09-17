Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3816FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2438C433C8;
	Sun, 17 Sep 2023 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979984;
	bh=88b68nkyixpAw23If3mTEfs30JLyJSM9vPYISB9riXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/IUJPuAroxPbyz0XCrw90b99/DcxHk58tEjcGarBC6vM0Cp4Ab2XArdB4M+3XcWd
	 O9mmP7kjxFz0ge1DyTXnlFTBLM+dxT9Ys9V+dEzmMy7v4wksJKKvlxpqt9nB+W+Gtf
	 h/TgkwDhpGPVjNc36wDlPwPvkOIqSE/upa7opq98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 062/285] mailbox: qcom-ipcc: fix incorrect num_chans counting
Date: Sun, 17 Sep 2023 21:11:02 +0200
Message-ID: <20230917191053.850913867@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit a493208079e299aefdc15169dc80e3da3ebb718a ]

Breaking out early when a match is found leads to an incorrect num_chans
value when more than one ipcc mailbox channel is used by the same device.

Fixes: e9d50e4b4d04 ("mailbox: qcom-ipcc: Dynamic alloc for channel arrangement")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index 7e27acf6c0cca..f597a1bd56847 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -227,10 +227,8 @@ static int qcom_ipcc_setup_mbox(struct qcom_ipcc *ipcc,
 			ret = of_parse_phandle_with_args(client_dn, "mboxes",
 						"#mbox-cells", j, &curr_ph);
 			of_node_put(curr_ph.np);
-			if (!ret && curr_ph.np == controller_dn) {
+			if (!ret && curr_ph.np == controller_dn)
 				ipcc->num_chans++;
-				break;
-			}
 		}
 	}
 
-- 
2.40.1



