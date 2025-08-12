Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94D27FB12;
	Tue, 12 Aug 2025 18:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023304; cv=none; b=Wymzypxq+cy5CUxKaK/QmmiUN/B74G6nPKO5B5omjVbvnbCEPrp2i9fbyOsy9rdLVIt8NGheMmW60PulHjVMls/g5MfzUKdtJJeMsHlGLiiQ/isgNbPQVXwQBab9tr/liSfO6/L4IUkREXsLeVbmr/Bh5TBzdwHiAy0+BvjYajE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023304; c=relaxed/simple;
	bh=q08r3KqPmjqgbLFB54Ii1elmFAQW5MXl1Mc55q7epwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/wPbc/OM+6j7aCozUzaCLkQqYvKasD3gc1oWbV1w+epXoPZTWb2ft46nD4kHN2pRb5nRRjMYxPj031dWmniCVU6zWvGheQW4XvEa2SvJX2nWrvG1ll4iJH0/1lkGGgwJbTorDLvLQU+3F7xFwQauqbT1mO4gZjh8pGgctPRkH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdMnN3os; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdMnN3os"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDFFC4CEF1;
	Tue, 12 Aug 2025 18:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023304;
	bh=q08r3KqPmjqgbLFB54Ii1elmFAQW5MXl1Mc55q7epwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdMnN3os1CBZHsIDrXhtqUmF7gCTIy4Tg4lSQjOxzto+ef7RnbEc2orKl6h8MK1wP
	 +dvf0eiBgzO0+MPzQlA68i5H5U8tHO1cSmtMZy/DZ+6GYXKDeRbBeEEqqDXi0T5bmi
	 Yvt5zzVTRbj1v+7Wo291Z1mh9TwDJ0FoAAzDSKAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 041/627] soc: qcom: fix endianness for QMI header
Date: Tue, 12 Aug 2025 19:25:36 +0200
Message-ID: <20250812173420.897847488@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wilhelm <alexander.wilhelm@westermo.com>

[ Upstream commit 07a4688833b237331e5045f90fc546c085b28c86 ]

The members of QMI header have to be swapped on big endian platforms. Use
__le16 types instead of u16 ones.

Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>
Fixes: 9b8a11e82615 ("soc: qcom: Introduce QMI encoder/decoder")
Fixes: 3830d0771ef6 ("soc: qcom: Introduce QMI helpers")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250522143530.3623809-3-alexander.wilhelm@westermo.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qmi_encdec.c    | 6 +++---
 drivers/soc/qcom/qmi_interface.c | 6 +++---
 include/linux/soc/qcom/qmi.h     | 6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/soc/qcom/qmi_encdec.c b/drivers/soc/qcom/qmi_encdec.c
index dafe0a4c202e..7660a960fb45 100644
--- a/drivers/soc/qcom/qmi_encdec.c
+++ b/drivers/soc/qcom/qmi_encdec.c
@@ -776,9 +776,9 @@ void *qmi_encode_message(int type, unsigned int msg_id, size_t *len,
 
 	hdr = msg;
 	hdr->type = type;
-	hdr->txn_id = txn_id;
-	hdr->msg_id = msg_id;
-	hdr->msg_len = msglen;
+	hdr->txn_id = cpu_to_le16(txn_id);
+	hdr->msg_id = cpu_to_le16(msg_id);
+	hdr->msg_len = cpu_to_le16(msglen);
 
 	*len = sizeof(*hdr) + msglen;
 
diff --git a/drivers/soc/qcom/qmi_interface.c b/drivers/soc/qcom/qmi_interface.c
index bc6d6379d8b1..6500f863aae5 100644
--- a/drivers/soc/qcom/qmi_interface.c
+++ b/drivers/soc/qcom/qmi_interface.c
@@ -400,7 +400,7 @@ static void qmi_invoke_handler(struct qmi_handle *qmi, struct sockaddr_qrtr *sq,
 
 	for (handler = qmi->handlers; handler->fn; handler++) {
 		if (handler->type == hdr->type &&
-		    handler->msg_id == hdr->msg_id)
+		    handler->msg_id == le16_to_cpu(hdr->msg_id))
 			break;
 	}
 
@@ -488,7 +488,7 @@ static void qmi_handle_message(struct qmi_handle *qmi,
 	/* If this is a response, find the matching transaction handle */
 	if (hdr->type == QMI_RESPONSE) {
 		mutex_lock(&qmi->txn_lock);
-		txn = idr_find(&qmi->txns, hdr->txn_id);
+		txn = idr_find(&qmi->txns, le16_to_cpu(hdr->txn_id));
 
 		/* Ignore unexpected responses */
 		if (!txn) {
@@ -514,7 +514,7 @@ static void qmi_handle_message(struct qmi_handle *qmi,
 	} else {
 		/* Create a txn based on the txn_id of the incoming message */
 		memset(&tmp_txn, 0, sizeof(tmp_txn));
-		tmp_txn.id = hdr->txn_id;
+		tmp_txn.id = le16_to_cpu(hdr->txn_id);
 
 		qmi_invoke_handler(qmi, sq, &tmp_txn, buf, len);
 	}
diff --git a/include/linux/soc/qcom/qmi.h b/include/linux/soc/qcom/qmi.h
index 469e02d2aa0d..291cdc7ef49c 100644
--- a/include/linux/soc/qcom/qmi.h
+++ b/include/linux/soc/qcom/qmi.h
@@ -24,9 +24,9 @@ struct socket;
  */
 struct qmi_header {
 	u8 type;
-	u16 txn_id;
-	u16 msg_id;
-	u16 msg_len;
+	__le16 txn_id;
+	__le16 msg_id;
+	__le16 msg_len;
 } __packed;
 
 #define QMI_REQUEST	0
-- 
2.39.5



