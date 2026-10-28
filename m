Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217251;
	b=qZQe/DruDomqCzIMgDv0BJKfK1L6pUfBBKUPb+GkjA9p7yC+z6OEb4dC3lS+ltg/E1Y7
	 oYww7jUhHT3WnA8GCIpYSUckP0lYzOwVCdznGk20xsVc9asn+8RrzPwfyCOSjn/AXHaM2
	 fBj9leIcabPU3X5cc/TH6DJ7OHOz2GDuRBRREJGFCixvFDlyllFiEVenGoAHPSnyqux8Z
	 zp+UTykpYRznIBTFDJr5mKtZ9VqnP60qIePdygTvhuymZKIiCsnVleCAQCjLYCFjtR0U2
	 r1+7aZDgHqzraTkzsrR+ZpZ8Uu7AFFcT2/IzdL4nrlNpxsQjE2d0zqMt8SRmfuL22cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7yyvAeSwjy+3Ua6nDLiM/x3Fb4BlxZDJ3bygM5KmCZo=;
	b=SfiGabpH0YVy5JghlB9KJhvak4HvIUZK7HtnPv8KCuSCkXL1LzjuAcAGX5cnCN5aIXEH
	 GLFgAkVU+gwmYP/oVfhXepQUCMY0Xwcr0mElZ8BQt7R7cF5TSgOx+Y+B6b4nvsm7SLrcg
	 C4pyjcyGpX/3TCJ9nZR+yzJmj6ZCec2cUzpnwqSDUGrFIti+cnofBSzamNJYKtg+0TY3K
	 bb38euTu6x2Q1kTexTuqiDkqat57gQdSZgZLY+KgYw+vHiqUNB8aDUjhmlrgq4SlZ1D0H
	 XmqLVe0pL9IU/FW5QQ/GnyUOSrHmgxU5j/QTm0gKOfKuneh1SuymMl0YNcocZ0cy8Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zZg/39ch";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94836606A31E;
	Wed, 28 Oct 2026 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZg/39ch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1AF1F01825;
	Wed, 28 Oct 2026 19:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217251;
	bh=7yyvAeSwjy+3Ua6nDLiM/x3Fb4BlxZDJ3bygM5KmCZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZg/39cha/wy58gr/99y6B/1KoayZU6At5ZImfvDqTYNkv3+oeZz0hbafivy552PY
	 my9Ma5x00FtJE+FrehkKQiHPMkRjdlXdyFPkCul5UE5eVqPkMs+03yI4you6ZKJIJg
	 fkF0N8mw1xdz21HoEp30FJHpv5lL226kTywLofjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1832/1887] firmware: arm_scmi: Move errors defs and code to common.h
Date: Wed, 28 Oct 2026 18:05:28 +0100
Message-ID: <20261028170541.135071766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 936a2b91c2e8ac9570e080e654bf53f799cbc028 ]

Move SCMI error codes definitions and helper to the common.h header
together with the delayed response timeout define.

No functional change.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230118121426.492864-7-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: a71a3d4d8a6e ("firmware: arm_scmi: Use channel ID for transport teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h | 40 ++++++++++++++++++++++++++++++
 drivers/firmware/arm_scmi/driver.c | 40 ------------------------------
 2 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index a08d8da198be1..39bf362affa76 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -27,6 +27,46 @@
 #include "protocols.h"
 #include "notify.h"
 
+#define SCMI_MAX_RESPONSE_TIMEOUT	(2 * MSEC_PER_SEC)
+
+enum scmi_error_codes {
+	SCMI_SUCCESS = 0,	/* Success */
+	SCMI_ERR_SUPPORT = -1,	/* Not supported */
+	SCMI_ERR_PARAMS = -2,	/* Invalid Parameters */
+	SCMI_ERR_ACCESS = -3,	/* Invalid access/permission denied */
+	SCMI_ERR_ENTRY = -4,	/* Not found */
+	SCMI_ERR_RANGE = -5,	/* Value out of range */
+	SCMI_ERR_BUSY = -6,	/* Device busy */
+	SCMI_ERR_COMMS = -7,	/* Communication Error */
+	SCMI_ERR_GENERIC = -8,	/* Generic Error */
+	SCMI_ERR_HARDWARE = -9,	/* Hardware Error */
+	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
+};
+
+static const int scmi_linux_errmap[] = {
+	/* better than switch case as long as return value is continuous */
+	0,			/* SCMI_SUCCESS */
+	-EOPNOTSUPP,		/* SCMI_ERR_SUPPORT */
+	-EINVAL,		/* SCMI_ERR_PARAM */
+	-EACCES,		/* SCMI_ERR_ACCESS */
+	-ENOENT,		/* SCMI_ERR_ENTRY */
+	-ERANGE,		/* SCMI_ERR_RANGE */
+	-EBUSY,			/* SCMI_ERR_BUSY */
+	-ECOMM,			/* SCMI_ERR_COMMS */
+	-EIO,			/* SCMI_ERR_GENERIC */
+	-EREMOTEIO,		/* SCMI_ERR_HARDWARE */
+	-EPROTO,		/* SCMI_ERR_PROTOCOL */
+};
+
+static inline int scmi_to_linux_errno(int errno)
+{
+	int err_idx = -errno;
+
+	if (err_idx >= SCMI_SUCCESS && err_idx < ARRAY_SIZE(scmi_linux_errmap))
+		return scmi_linux_errmap[err_idx];
+	return -EIO;
+}
+
 #define MSG_ID_MASK		GENMASK(7, 0)
 #define MSG_XTRACT_ID(hdr)	FIELD_GET(MSG_ID_MASK, (hdr))
 #define MSG_TYPE_MASK		GENMASK(9, 8)
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index c88b8d4aae926..49b4a938cdb20 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -37,20 +37,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/scmi.h>
 
-enum scmi_error_codes {
-	SCMI_SUCCESS = 0,	/* Success */
-	SCMI_ERR_SUPPORT = -1,	/* Not supported */
-	SCMI_ERR_PARAMS = -2,	/* Invalid Parameters */
-	SCMI_ERR_ACCESS = -3,	/* Invalid access/permission denied */
-	SCMI_ERR_ENTRY = -4,	/* Not found */
-	SCMI_ERR_RANGE = -5,	/* Value out of range */
-	SCMI_ERR_BUSY = -6,	/* Device busy */
-	SCMI_ERR_COMMS = -7,	/* Communication Error */
-	SCMI_ERR_GENERIC = -8,	/* Generic Error */
-	SCMI_ERR_HARDWARE = -9,	/* Hardware Error */
-	SCMI_ERR_PROTOCOL = -10,/* Protocol Error */
-};
-
 static DEFINE_IDR(scmi_protocols);
 static DEFINE_SPINLOCK(protocol_lock);
 
@@ -167,30 +153,6 @@ struct scmi_info {
 #define bus_nb_to_scmi_info(nb)	container_of(nb, struct scmi_info, bus_nb)
 #define req_nb_to_scmi_info(nb)	container_of(nb, struct scmi_info, dev_req_nb)
 
-static const int scmi_linux_errmap[] = {
-	/* better than switch case as long as return value is continuous */
-	0,			/* SCMI_SUCCESS */
-	-EOPNOTSUPP,		/* SCMI_ERR_SUPPORT */
-	-EINVAL,		/* SCMI_ERR_PARAM */
-	-EACCES,		/* SCMI_ERR_ACCESS */
-	-ENOENT,		/* SCMI_ERR_ENTRY */
-	-ERANGE,		/* SCMI_ERR_RANGE */
-	-EBUSY,			/* SCMI_ERR_BUSY */
-	-ECOMM,			/* SCMI_ERR_COMMS */
-	-EIO,			/* SCMI_ERR_GENERIC */
-	-EREMOTEIO,		/* SCMI_ERR_HARDWARE */
-	-EPROTO,		/* SCMI_ERR_PROTOCOL */
-};
-
-static inline int scmi_to_linux_errno(int errno)
-{
-	int err_idx = -errno;
-
-	if (err_idx >= SCMI_SUCCESS && err_idx < ARRAY_SIZE(scmi_linux_errmap))
-		return scmi_linux_errmap[err_idx];
-	return -EIO;
-}
-
 static const struct scmi_protocol *scmi_protocol_get(int protocol_id)
 {
 	const struct scmi_protocol *proto;
@@ -1015,8 +977,6 @@ static void reset_rx_to_maxsz(const struct scmi_protocol_handle *ph,
 	xfer->rx.len = info->desc->max_msg_size;
 }
 
-#define SCMI_MAX_RESPONSE_TIMEOUT	(2 * MSEC_PER_SEC)
-
 /**
  * do_xfer_with_response() - Do one transfer and wait until the delayed
  *	response is received
-- 
2.53.0



