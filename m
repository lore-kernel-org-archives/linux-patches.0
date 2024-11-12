Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C282144B2;
	Tue, 12 Nov 2024 10:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407867; cv=none; b=JwkSrbcBfwM6AKJ8GpXnDR1cPXZnRIJsrRpYg7DPM87NeBVlVGCsFetLK1/XLquBtay/vuOHdrKbHd+cd0zdPg0pR+twqsSHqzHKt83lO9OdsaG1KRfmDA+cQLWLMZmflcNdwH6DlPmhhf7BmzrlLM55hybsCbGwOpHN8u+fAgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407867; c=relaxed/simple;
	bh=0IHPlhB2hyutvgS1iT6YASHPKARhvYnrR7az+UVrsq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+mhXiuXfYmD2MGeEw0h7B5SekbA79V7t3eZ3XTbigWtehl/N5mkti7CJ3RgFliq+RR+VBaUCvQBF/+171zf/yFfAZB1fye9xyNj4BT7cCdfxqFXZPEqBUM988ABBv3qu85U2VjbHFeh38MMdPi7bS3wQm7R1bJw87vOT4BIj6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgFVEuId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgFVEuId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E10C4CED6;
	Tue, 12 Nov 2024 10:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407867;
	bh=0IHPlhB2hyutvgS1iT6YASHPKARhvYnrR7az+UVrsq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgFVEuIdosbhJpk+v8Pu5P5NETGoRMfr7I3McabxPN1OJacc8yYRigz63j0/XPlEL
	 f67L0TD89kBp099wnsOKHBgZAhx76L7023u35KTr1ukKoj980AX2nw1zaKWpmF4G8c
	 tIky8Gnbzuf161lrf5IyD1fjBafD29dAvMHy08xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rex Nie <rex.nie@jaguarmicro.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.6 108/119] usb: typec: qcom-pmic: init value of hdr_len/txbuf_len earlier
Date: Tue, 12 Nov 2024 11:21:56 +0100
Message-ID: <20241112101852.849290371@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -161,6 +161,10 @@ qcom_pmic_typec_pdphy_pd_transmit_payloa
 
 	spin_lock_irqsave(&pmic_typec_pdphy->lock, flags);
 
+	hdr_len = sizeof(msg->header);
+	txbuf_len = pd_header_cnt_le(msg->header) * 4;
+	txsize_len = hdr_len + txbuf_len - 1;
+
 	ret = regmap_read(pmic_typec_pdphy->regmap,
 			  pmic_typec_pdphy->base + USB_PDPHY_RX_ACKNOWLEDGE_REG,
 			  &val);
@@ -178,10 +182,6 @@ qcom_pmic_typec_pdphy_pd_transmit_payloa
 	if (ret)
 		goto done;
 
-	hdr_len = sizeof(msg->header);
-	txbuf_len = pd_header_cnt_le(msg->header) * 4;
-	txsize_len = hdr_len + txbuf_len - 1;
-
 	/* Write message header sizeof(u16) to USB_PDPHY_TX_BUFFER_HDR_REG */
 	ret = regmap_bulk_write(pmic_typec_pdphy->regmap,
 				pmic_typec_pdphy->base + USB_PDPHY_TX_BUFFER_HDR_REG,


