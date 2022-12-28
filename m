Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5930D1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BA2C433D2;
	Wed, 28 Dec 2022 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243790;
	bh=gkL0b+bGDw0cxEvJWCLvHZNREAm743J0byI/YJOd0Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yICVRJZnlursmeS1SGasOTGbXOmohNaJJDjll1jeOmffj2E1RSWSsrQg0+fY5lTf
	 e9D/bUNbq7TTMhW6tIlTy2FXFcMoYjt9dGaWBL1DnGQDCK7uwrR810h98bjKCR2RuL
	 ppJucgE/1IJt2/bS5JD4OmBGIAcy2TpeA9bHwS+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inga Stotland <inga.stotland@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0556/1146] Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS
Date: Wed, 28 Dec 2022 15:34:55 +0100
Message-Id: <20221228144345.271466579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Inga Stotland <inga.stotland@intel.com>

[ Upstream commit 3b1c7c00b8c22b3cb79532252c59eb0b287bb86d ]

When validating the parameter length for MGMT_OP_ADD_EXT_ADV_PARAMS
command, use the correct op code in error status report:
was MGMT_OP_ADD_ADVERTISING, changed to MGMT_OP_ADD_EXT_ADV_PARAMS.

Fixes: 12410572833a2 ("Bluetooth: Break add adv into two mgmt commands")
Signed-off-by: Inga Stotland <inga.stotland@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index a92e7e485feb..0dd30a3beb77 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -8859,7 +8859,7 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 	 * extra parameters we don't know about will be ignored in this request.
 	 */
 	if (data_len < MGMT_ADD_EXT_ADV_PARAMS_MIN_SIZE)
-		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
+		return mgmt_cmd_status(sk, hdev->id, MGMT_OP_ADD_EXT_ADV_PARAMS,
 				       MGMT_STATUS_INVALID_PARAMS);
 
 	flags = __le32_to_cpu(cp->flags);
-- 
2.35.1



