Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE79F2DE6F8;
	Thu,  3 Jul 2025 15:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556306; cv=none; b=UE6CgR2geIUW8+En7TXxHIpMsRn40NvJhjW3mnwxOuD6xvaxowbl5NPELqDZlwe5m7uzbwC3HpOPfvRRDQam4KPEgBOLo7UwYY9sVi5BxhKJ2qKc0899if6Sqh1ZylIgPYkufm4tdvD8Gj3kewKr1AUNvoV2U52noIkjZGiTTRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556306; c=relaxed/simple;
	bh=ngYu9xN3S9RPNzswkKsR/hVSfjGvk7UE9F2c/fQIj9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mw0RhLztVf2MweFRiYnhtM+c0UeBlYEXRBOOdRNAq7eATuIDiqkn2b+AMNIIlv1BIDEDsJ2AjbjXWPsOhMbI1+SyRccLFAsq1kzP+XtE73i+ThoK6aq/fHheRUZPoG0Koxz5c5exh0QAOL8R+2T/42/TLeawlaZr7zYVgbKGrF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iveBPIRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iveBPIRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E67EC4CEE3;
	Thu,  3 Jul 2025 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556305;
	bh=ngYu9xN3S9RPNzswkKsR/hVSfjGvk7UE9F2c/fQIj9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iveBPIRSURJH1lQx/jOVibNEvEtKgzCW6l2QelyoQBfzrAj5C+h7Y562CJXkW3BoK
	 4DWQUA3p1p7jB7IBhx7FammXjBgDSeAK6fmaiqb4HAow2AVEzlT5YxlI6t9oohj/+S
	 uHBedTyAcy6jyfDlfpVKwxl2SiyHhuCT+28SWpgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Sibi Sankar <quic_sibis@quicinc.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 131/132] firmware: arm_scmi: Ensure that the message-id supports fastchannel
Date: Thu,  3 Jul 2025 16:43:40 +0200
Message-ID: <20250703143944.528422955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sibi Sankar <quic_sibis@quicinc.com>

commit 94a263f981a3fa3d93f65c31e0fed0756736be43 upstream.

Currently the perf and powercap protocol relies on the protocol domain
attributes, which just ensures that one fastchannel per domain, before
instantiating fastchannels for all possible message-ids. Fix this by
ensuring that each message-id supports fastchannel before initialization.

Logs:
  |  scmi: Failed to get FC for protocol 13 [MSG_ID:6 / RES_ID:0] - ret:-95. Using regular messaging
  |  scmi: Failed to get FC for protocol 13 [MSG_ID:6 / RES_ID:1] - ret:-95. Using regular messaging
  |  scmi: Failed to get FC for protocol 13 [MSG_ID:6 / RES_ID:2] - ret:-95. Using regular messaging

CC: stable@vger.kernel.org
Reported-by: Johan Hovold <johan+linaro@kernel.org>
Closes: https://lore.kernel.org/lkml/ZoQjAWse2YxwyRJv@hovoldconsulting.com/
Fixes: 6f9ea4dabd2d ("firmware: arm_scmi: Generalize the fast channel support")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
[Cristian: Modified the condition checked to establish support or not]
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20250429141108.406045-2-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/driver.c    |   76 +++++++++++++++++++---------------
 drivers/firmware/arm_scmi/protocols.h |    2 
 2 files changed, 45 insertions(+), 33 deletions(-)

--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1178,6 +1178,39 @@ out:
 }
 
 /**
+ * scmi_protocol_msg_check  - Check protocol message attributes
+ *
+ * @ph: A reference to the protocol handle.
+ * @message_id: The ID of the message to check.
+ * @attributes: A parameter to optionally return the retrieved message
+ *		attributes, in case of Success.
+ *
+ * An helper to check protocol message attributes for a specific protocol
+ * and message pair.
+ *
+ * Return: 0 on SUCCESS
+ */
+static int scmi_protocol_msg_check(const struct scmi_protocol_handle *ph,
+				   u32 message_id, u32 *attributes)
+{
+	int ret;
+	struct scmi_xfer *t;
+
+	ret = xfer_get_init(ph, PROTOCOL_MESSAGE_ATTRIBUTES,
+			    sizeof(__le32), 0, &t);
+	if (ret)
+		return ret;
+
+	put_unaligned_le32(message_id, t->tx.buf);
+	ret = do_xfer(ph, t);
+	if (!ret && attributes)
+		*attributes = get_unaligned_le32(t->rx.buf);
+	xfer_put(ph, t);
+
+	return ret;
+}
+
+/**
  * struct scmi_iterator  - Iterator descriptor
  * @msg: A reference to the message TX buffer; filled by @prepare_message with
  *	 a proper custom command payload for each multi-part command request.
@@ -1318,6 +1351,7 @@ scmi_common_fastchannel_init(const struc
 	int ret;
 	u32 flags;
 	u64 phys_addr;
+	u32 attributes;
 	u8 size;
 	void __iomem *addr;
 	struct scmi_xfer *t;
@@ -1326,6 +1360,15 @@ scmi_common_fastchannel_init(const struc
 	struct scmi_msg_resp_desc_fc *resp;
 	const struct scmi_protocol_instance *pi = ph_to_pi(ph);
 
+	/* Check if the MSG_ID supports fastchannel */
+	ret = scmi_protocol_msg_check(ph, message_id, &attributes);
+	if (ret || !MSG_SUPPORTS_FASTCHANNEL(attributes)) {
+		dev_dbg(ph->dev,
+			"Skip FC init for 0x%02X/%d  domain:%d - ret:%d\n",
+			pi->proto->id, message_id, domain, ret);
+		return;
+	}
+
 	if (!p_addr) {
 		ret = -EINVAL;
 		goto err_out;
@@ -1450,39 +1493,6 @@ static void scmi_common_fastchannel_db_r
 #endif
 }
 
-/**
- * scmi_protocol_msg_check  - Check protocol message attributes
- *
- * @ph: A reference to the protocol handle.
- * @message_id: The ID of the message to check.
- * @attributes: A parameter to optionally return the retrieved message
- *		attributes, in case of Success.
- *
- * An helper to check protocol message attributes for a specific protocol
- * and message pair.
- *
- * Return: 0 on SUCCESS
- */
-static int scmi_protocol_msg_check(const struct scmi_protocol_handle *ph,
-				   u32 message_id, u32 *attributes)
-{
-	int ret;
-	struct scmi_xfer *t;
-
-	ret = xfer_get_init(ph, PROTOCOL_MESSAGE_ATTRIBUTES,
-			    sizeof(__le32), 0, &t);
-	if (ret)
-		return ret;
-
-	put_unaligned_le32(message_id, t->tx.buf);
-	ret = do_xfer(ph, t);
-	if (!ret && attributes)
-		*attributes = get_unaligned_le32(t->rx.buf);
-	xfer_put(ph, t);
-
-	return ret;
-}
-
 static const struct scmi_proto_helpers_ops helpers_ops = {
 	.extended_name_get = scmi_common_extended_name_get,
 	.iter_response_init = scmi_iterator_init,
--- a/drivers/firmware/arm_scmi/protocols.h
+++ b/drivers/firmware/arm_scmi/protocols.h
@@ -29,6 +29,8 @@
 #define PROTOCOL_REV_MAJOR(x)	((u16)(FIELD_GET(PROTOCOL_REV_MAJOR_MASK, (x))))
 #define PROTOCOL_REV_MINOR(x)	((u16)(FIELD_GET(PROTOCOL_REV_MINOR_MASK, (x))))
 
+#define MSG_SUPPORTS_FASTCHANNEL(x)	((x) & BIT(0))
+
 enum scmi_common_cmd {
 	PROTOCOL_VERSION = 0x0,
 	PROTOCOL_ATTRIBUTES = 0x1,


