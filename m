Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D03C1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB0DC433C7;
	Mon, 11 Sep 2023 13:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440647;
	bh=rNy+Pite8bb3hRMkLlH4K1oWTfaGm5oNM/37R0qeLpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T97cVLTuzDaNJg0O2qQq743Ne2zsdgMk7NEKvUrgvEytA82GOObdcujtaATwq1yXr
	 YW0yev37l9WUt+mveY79zOmfxH3vYOb5Scc4TFVdrxmgRa7NtW8uGEdt0uT2baDyN6
	 7ZC7NMwCy5P/KfWG5XHQF1Jly87fjTCDDhdIXljI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu Liao <liaoyu15@huawei.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 108/739] power: supply: qcom_pmi8998_charger: fix uninitialized variable
Date: Mon, 11 Sep 2023 15:38:27 +0200
Message-ID: <20230911134654.115614313@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Yu Liao <liaoyu15@huawei.com>

[ Upstream commit 13a0d1088c8fea1565e30a169188b59bdd77759e ]

smatch warnings:
  drivers/power/supply/qcom_pmi8998_charger.c:565 smb2_status_change_work() error: uninitialized symbol 'usb_online'.

usb_online is used uninitialized whenever smb2_get_prop_usb_online()
returns a negative value.

Thus, fix the issue by initializing usb_online to 0.

Fixes: 8648aeb5d7b7 ("power: supply: add Qualcomm PMI8998 SMB2 Charger driver")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202307280638.556PrzIS-lkp@intel.com/
Signed-off-by: Yu Liao <liaoyu15@huawei.com>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org
Link: https://lore.kernel.org/r/20230802023130.2516232-1-liaoyu15@huawei.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_pmi8998_charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/qcom_pmi8998_charger.c b/drivers/power/supply/qcom_pmi8998_charger.c
index d16c5ee172496..cac89d233c388 100644
--- a/drivers/power/supply/qcom_pmi8998_charger.c
+++ b/drivers/power/supply/qcom_pmi8998_charger.c
@@ -556,7 +556,8 @@ static int smb2_set_current_limit(struct smb2_chip *chip, unsigned int val)
 static void smb2_status_change_work(struct work_struct *work)
 {
 	unsigned int charger_type, current_ua;
-	int usb_online, count, rc;
+	int usb_online = 0;
+	int count, rc;
 	struct smb2_chip *chip;
 
 	chip = container_of(work, struct smb2_chip, status_change_work.work);
-- 
2.40.1



