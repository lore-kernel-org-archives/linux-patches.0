Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB6921A6FD;
	Tue, 12 Nov 2024 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408429; cv=none; b=X7uShvTxqfaXfkLU1SAZGrG2QkWqLO4r4zZiP7H1vdxX/hRsUMG/EHMwUSltPiIOCnIXrLFwctTZ3pZVskI+BWhRuBBWXg3blAuIQ3C4kHAs8jjErDdOKiSkDYz25Fr2dnX7bN+NNZ0zW9pnCpaDBspZOeSzUqYTi2/i8B4KdAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408429; c=relaxed/simple;
	bh=G3LNwDnpkTvFAOphIkmtN12mITvynHlpQ2jHGuFRmb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y03/kWeohF7UnSuAB5M4z5YOhaKdjk/Tau+5aJJfCumBg2pMWhHfuNuxUBItUDKP4KJN//5dLmDDBGee97Gio4tJbw7zOkBzfWAePxSwaxyBc+AvcnK7/u8Ewf3UOU29oWlYfgwVHFPGXj++0UcMS/4ZukWyrSX/T8Z/m/JfnTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eos/BAnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eos/BAnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18F3C4CEF9;
	Tue, 12 Nov 2024 10:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408429;
	bh=G3LNwDnpkTvFAOphIkmtN12mITvynHlpQ2jHGuFRmb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eos/BAnYDKvWwwCdsYkDCYy6K+9n+KDJQFtSoxuxAtMudbnp30Fr3Nfl4qWQIiUwq
	 LOaYFvMUeLXipX8GYlbukZUXqkhaEka8BFsmBqQ0vjwljMVxpx24fNM7I+Jm8IunpD
	 Osml9fd3DrO1lZjK9Lv6VUz9Mr9zWwD4UZpVXMn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Nie <rex.nie@jaguarmicro.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.11 158/184] usb: typec: qcom-pmic: init value of hdr_len/txbuf_len earlier
Date: Tue, 12 Nov 2024 11:21:56 +0100
Message-ID: <20241112101906.936217816@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rex Nie <rex.nie@jaguarmicro.com>

commit 029778a4fd2c90c2e76a902b797c2348a722f1b8 upstream.

If the read of USB_PDPHY_RX_ACKNOWLEDGE_REG failed, then hdr_len and
txbuf_len are uninitialized. This commit stops to print uninitialized
value and misleading/false data.

Cc: stable@vger.kernel.org
Fixes: a4422ff22142 (" usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Signed-off-by: Rex Nie <rex.nie@jaguarmicro.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Acked-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20241030133632.2116-1-rex.nie@jaguarmicro.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c
@@ -227,6 +227,10 @@ qcom_pmic_typec_pdphy_pd_transmit_payloa
 
 	spin_lock_irqsave(&pmic_typec_pdphy->lock, flags);
 
+	hdr_len = sizeof(msg->header);
+	txbuf_len = pd_header_cnt_le(msg->header) * 4;
+	txsize_len = hdr_len + txbuf_len - 1;
+
 	ret = regmap_read(pmic_typec_pdphy->regmap,
 			  pmic_typec_pdphy->base + USB_PDPHY_RX_ACKNOWLEDGE_REG,
 			  &val);
@@ -244,10 +248,6 @@ qcom_pmic_typec_pdphy_pd_transmit_payloa
 	if (ret)
 		goto done;
 
-	hdr_len = sizeof(msg->header);
-	txbuf_len = pd_header_cnt_le(msg->header) * 4;
-	txsize_len = hdr_len + txbuf_len - 1;
-
 	/* Write message header sizeof(u16) to USB_PDPHY_TX_BUFFER_HDR_REG */
 	ret = regmap_bulk_write(pmic_typec_pdphy->regmap,
 				pmic_typec_pdphy->base + USB_PDPHY_TX_BUFFER_HDR_REG,


