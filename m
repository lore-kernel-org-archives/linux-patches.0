Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023093;
	b=0LNubxHJaq/Cvlq9CFBFaNcVlSuZ4IBwngLQTWykeE53qJOds+LgU/1RqmfQ7FYBukVm
	 Mv88kxxjQn+TEPxVJZz7dL4OLL/HGf740xL/JdtLWSEdtGQJFzNngHPhmq2j9hEhTf4lv
	 pc5Lyp8eAKQCC1V6tm0i226gJrK31A/q/jtoXASjGTco9JAtHZ0KYncGcub7MTrgY0HKS
	 ptYRYm3LI8fu86/w+2yg4owZmH4FM675h97EL8DruEDmB4WMOV3OIMr5IfKivIM3FwOZC
	 uN5PctkxOPO7I0wWJ4fh4gVyW/KLga5Kt8r5EyvSuj1acnAkKB/YnLYjhay1SRCtpyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OangW/kun5JdHHsT3TSDv31SDycjnlHSh8P+7Z5tohY=;
	b=ARt/PDEV2xELou35wD1NfLWdVs1z+c0DtzwqifA1i7tUDziZ+Mbwh6cJrrbl3dD+S3wJ
	 vIJacMpG0eMYo19VExtwahRhNKJGa4L7umMU4pdIamLPoC0jlMCMS/QdlN/zu0XvxPkXX
	 SOwJlfCfRta6WU33YxoMRZZ1xLTcfvCCXtFUJ9JzhWpTNBd6vrzCDl3NlDMvRcO4PS9lC
	 6OhhNrPZ7TBt89cg6/YGLIT0pjDl7mwW9l/Hw72lVqAXRmfwvia6sz8hep7yZn+/OZA6N
	 2SM9VTfszC9jOZdBltuxZLlG7DdQhwMPLMdOGx4KhkymhNfBd4odB/dVkXSUxCz92Qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyNl6DTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EC5606A320;
	Wed, 18 Nov 2026 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NyNl6DTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6703E1F000C4;
	Wed, 18 Nov 2026 17:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023093;
	bh=OangW/kun5JdHHsT3TSDv31SDycjnlHSh8P+7Z5tohY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NyNl6DTp+CSyD2SVYaKLGbJOSrvMWslV/VETSNvGKzXJ0UeLK8VQi1plx8jFipQOA
	 9fJrvsMg4NmH6sCvjfmpdh25GZzMU79Dbk76bGsdzeU283iToelwzZPXgRoITOEws9
	 lIHrL5UXG8XvgE7NW4Ux1ewx9gSjBbEiOXoYfQ3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Barnes <robbarnes@google.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0185/2151] platform/chrome: cros_ec_proto: Fix deferred response
Date: Wed, 18 Nov 2026 15:32:00 +0100
Message-ID: <20261118150128.474272893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Barnes <robbarnes@google.com>

[ Upstream commit c55749415623a58eba3eb527da023d29b43fbf5d ]

When cros_ec_wait_until_complete() succeeds after an
EC_RES_IN_PROGRESS status, it previously returned the 4-byte
transfer size of EC_CMD_GET_COMMS_STATUS. For 0-byte payload
commands (such as EC_CMD_FLASH_ERASE), userspace received 4
bytes instead of 0, causing response size validation errors.
For commands expecting non-zero response payloads, the kernel
exited without issuing EC_CMD_RESEND_RESPONSE, leaving response
buffers uninitialized.

Refactor cros_ec_wait_until_complete() to pass orig_msg, issue
EC_CMD_RESEND_RESPONSE into orig_msg->data when insize > 0, and
return 0 for 0-byte response commands.

Fixes: 2c7589af3c4d ("mfd: cros_ec: add proto v3 skeleton")
Signed-off-by: Rob Barnes <robbarnes@google.com>
Link: https://lore.kernel.org/r/20260901005126.3344929-1-robbarnes@google.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_proto.c      |  32 +++-
 drivers/platform/chrome/cros_ec_proto_test.c | 158 ++++++++++++++++++-
 2 files changed, 183 insertions(+), 7 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index 1d8d9168ec1aa..6d7c57e381e5e 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -138,7 +138,8 @@ static int cros_ec_xfer_command(struct cros_ec_device *ec_dev, struct cros_ec_co
 	return ret;
 }
 
-static int cros_ec_wait_until_complete(struct cros_ec_device *ec_dev, uint32_t *result)
+static int cros_ec_wait_until_complete(struct cros_ec_device *ec_dev,
+				       struct cros_ec_command *orig_msg)
 {
 	DEFINE_RAW_FLEX(struct cros_ec_command, msg, data,
 			sizeof(struct ec_response_get_comms_status));
@@ -161,7 +162,7 @@ static int cros_ec_wait_until_complete(struct cros_ec_device *ec_dev, uint32_t *
 		if (ret < 0)
 			return ret;
 
-		*result = msg->result;
+		orig_msg->result = msg->result;
 		if (msg->result != EC_RES_SUCCESS)
 			return ret;
 
@@ -170,8 +171,31 @@ static int cros_ec_wait_until_complete(struct cros_ec_device *ec_dev, uint32_t *
 			break;
 		}
 
-		if (!(status->flags & EC_COMMS_STATUS_PROCESSING))
+		if (!(status->flags & EC_COMMS_STATUS_PROCESSING)) {
+			u32 orig_cmd, orig_outsize, orig_version;
+
+			/* If no response payload is expected, return 0. */
+			if (orig_msg->insize == 0)
+				return 0;
+
+			/*
+			 * Request the response using EC_CMD_RESEND_RESPONSE.
+			 * Restore the original message fields so it appears
+			 * to be a direct response to the original command.
+			 */
+			orig_cmd = orig_msg->command;
+			orig_outsize = orig_msg->outsize;
+			orig_version = orig_msg->version;
+
+			orig_msg->command = EC_CMD_RESEND_RESPONSE;
+			orig_msg->outsize = 0;
+			orig_msg->version = 0;
+			ret = cros_ec_xfer_command(ec_dev, orig_msg);
+			orig_msg->command = orig_cmd;
+			orig_msg->outsize = orig_outsize;
+			orig_msg->version = orig_version;
 			return ret;
+		}
 	}
 
 	if (i >= EC_COMMAND_RETRIES)
@@ -185,7 +209,7 @@ static int cros_ec_send_command(struct cros_ec_device *ec_dev, struct cros_ec_co
 	int ret = cros_ec_xfer_command(ec_dev, msg);
 
 	if (msg->result == EC_RES_IN_PROGRESS)
-		ret = cros_ec_wait_until_complete(ec_dev, &msg->result);
+		ret = cros_ec_wait_until_complete(ec_dev, msg);
 
 	return ret;
 }
diff --git a/drivers/platform/chrome/cros_ec_proto_test.c b/drivers/platform/chrome/cros_ec_proto_test.c
index 3f281996a6863..cbaaf98d6877e 100644
--- a/drivers/platform/chrome/cros_ec_proto_test.c
+++ b/drivers/platform/chrome/cros_ec_proto_test.c
@@ -1744,7 +1744,7 @@ static void cros_ec_proto_test_cmd_xfer_protocol_v2_no_op(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, ret, -EIO);
 }
 
-static void cros_ec_proto_test_cmd_xfer_in_progress_normal(struct kunit *test)
+static void cros_ec_proto_test_cmd_xfer_in_progress_payload_0byte(struct kunit *test)
 {
 	struct cros_ec_proto_test_priv *priv = test->priv;
 	struct cros_ec_device *ec_dev = &priv->ec_dev;
@@ -1774,7 +1774,7 @@ static void cros_ec_proto_test_cmd_xfer_in_progress_normal(struct kunit *test)
 	}
 
 	ret = cros_ec_cmd_xfer(ec_dev, &msg);
-	KUNIT_EXPECT_EQ(test, ret, sizeof(struct ec_response_get_comms_status));
+	KUNIT_EXPECT_EQ(test, ret, 0);
 
 	KUNIT_EXPECT_EQ(test, msg.result, EC_RES_SUCCESS);
 
@@ -1799,6 +1799,156 @@ static void cros_ec_proto_test_cmd_xfer_in_progress_normal(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, cros_kunit_ec_pkt_xfer_mock_called, 2);
 }
 
+static void cros_ec_proto_test_cmd_xfer_in_progress_payload_4bytes(struct kunit *test)
+{
+	struct cros_ec_proto_test_priv *priv = test->priv;
+	struct cros_ec_device *ec_dev = &priv->ec_dev;
+	struct ec_xfer_mock *mock;
+	u8 resp_data[4] = {0x11, 0x22, 0x33, 0x44};
+	struct {
+		struct cros_ec_command msg;
+		u8 data[4];
+	} buf;
+	struct cros_ec_command *msg = &buf.msg;
+	int ret;
+
+	memset(&buf, 0, sizeof(buf));
+	msg->version = 1;
+	msg->command = 0x1234;
+	msg->insize = sizeof(buf.data);
+
+	ec_dev->max_response = sizeof(buf.data);
+	ec_dev->pkt_xfer = cros_kunit_ec_pkt_xfer_mock;
+
+	/* For initial command returning EC_RES_IN_PROGRESS. */
+	{
+		mock = cros_kunit_ec_xfer_mock_addx(test, 0, EC_RES_IN_PROGRESS, 0);
+		KUNIT_ASSERT_PTR_NE(test, mock, NULL);
+	}
+
+	/* For EC_CMD_GET_COMMS_STATUS status polling. */
+	{
+		struct ec_response_get_comms_status *data;
+
+		mock = cros_kunit_ec_xfer_mock_add(test, sizeof(*data));
+		KUNIT_ASSERT_PTR_NE(test, mock, NULL);
+
+		data = (struct ec_response_get_comms_status *)mock->o_data;
+		data->flags = 0;
+	}
+
+	/* For EC_CMD_RESEND_RESPONSE returning 4 bytes payload. */
+	{
+		mock = cros_kunit_ec_xfer_mock_add(test, sizeof(resp_data));
+		KUNIT_ASSERT_PTR_NE(test, mock, NULL);
+		memcpy(mock->o_data, resp_data, sizeof(resp_data));
+	}
+
+	ret = cros_ec_cmd_xfer(ec_dev, msg);
+	KUNIT_EXPECT_EQ(test, ret, 4);
+	KUNIT_EXPECT_EQ(test, msg->result, EC_RES_SUCCESS);
+	KUNIT_EXPECT_EQ(test, msg->command, 0x1234);
+	KUNIT_EXPECT_EQ(test, msg->insize, sizeof(buf.data));
+	KUNIT_EXPECT_EQ(test, msg->version, 1);
+	KUNIT_EXPECT_EQ(test, memcmp(msg->data, resp_data, sizeof(resp_data)), 0);
+
+	/* Verify mock sequence */
+	{
+		mock = cros_kunit_ec_xfer_mock_next();
+		KUNIT_EXPECT_PTR_NE(test, mock, NULL);
+
+		mock = cros_kunit_ec_xfer_mock_next();
+		KUNIT_EXPECT_PTR_NE(test, mock, NULL);
+		KUNIT_EXPECT_EQ(test, mock->msg.command, EC_CMD_GET_COMMS_STATUS);
+
+		mock = cros_kunit_ec_xfer_mock_next();
+		KUNIT_EXPECT_PTR_NE(test, mock, NULL);
+		KUNIT_EXPECT_EQ(test, mock->msg.command, EC_CMD_RESEND_RESPONSE);
+		KUNIT_EXPECT_EQ(test, mock->msg.outsize, 0);
+		KUNIT_EXPECT_EQ(test, mock->msg.version, 0);
+		KUNIT_EXPECT_EQ(test, mock->msg.insize, 4);
+	}
+
+	KUNIT_EXPECT_EQ(test, cros_kunit_ec_pkt_xfer_mock_called, 3);
+}
+
+static void cros_ec_proto_test_cmd_xfer_in_progress_payload_gt4bytes(struct kunit *test)
+{
+	struct cros_ec_proto_test_priv *priv = test->priv;
+	struct cros_ec_device *ec_dev = &priv->ec_dev;
+	struct ec_xfer_mock *mock;
+	u8 resp_data[16];
+	struct {
+		struct cros_ec_command msg;
+		u8 data[16];
+	} buf;
+	struct cros_ec_command *msg = &buf.msg;
+	int ret, i;
+
+	for (i = 0; i < sizeof(resp_data); ++i)
+		resp_data[i] = (u8)(i + 1);
+
+	memset(&buf, 0, sizeof(buf));
+	msg->version = 0;
+	msg->command = 0x5678;
+	msg->insize = sizeof(buf.data);
+
+	ec_dev->max_response = sizeof(buf.data);
+	ec_dev->pkt_xfer = cros_kunit_ec_pkt_xfer_mock;
+
+	/* For initial command returning EC_RES_IN_PROGRESS. */
+	{
+		mock = cros_kunit_ec_xfer_mock_addx(test, 0, EC_RES_IN_PROGRESS, 0);
+		KUNIT_ASSERT_PTR_NE(test, mock, NULL);
+	}
+
+	/* For EC_CMD_GET_COMMS_STATUS status polling. */
+	{
+		struct ec_response_get_comms_status *data;
+
+		mock = cros_kunit_ec_xfer_mock_add(test, sizeof(*data));
+		KUNIT_ASSERT_PTR_NE(test, mock, NULL);
+
+		data = (struct ec_response_get_comms_status *)mock->o_data;
+		data->flags = 0;
+	}
+
+	/* For EC_CMD_RESEND_RESPONSE returning 16 bytes payload. */
+	{
+		mock = cros_kunit_ec_xfer_mock_add(test, sizeof(resp_data));
+		KUNIT_ASSERT_PTR_NE(test, mock, NULL);
+		memcpy(mock->o_data, resp_data, sizeof(resp_data));
+	}
+
+	ret = cros_ec_cmd_xfer(ec_dev, msg);
+	KUNIT_EXPECT_EQ(test, ret, 16);
+	KUNIT_EXPECT_EQ(test, msg->result, EC_RES_SUCCESS);
+	KUNIT_EXPECT_EQ(test, msg->command, 0x5678);
+	KUNIT_EXPECT_EQ(test, msg->outsize, 0);
+	KUNIT_EXPECT_EQ(test, msg->insize, sizeof(buf.data));
+	KUNIT_EXPECT_EQ(test, msg->version, 0);
+	KUNIT_EXPECT_EQ(test, memcmp(msg->data, resp_data, sizeof(resp_data)), 0);
+
+	/* Verify mock sequence */
+	{
+		mock = cros_kunit_ec_xfer_mock_next();
+		KUNIT_EXPECT_PTR_NE(test, mock, NULL);
+
+		mock = cros_kunit_ec_xfer_mock_next();
+		KUNIT_EXPECT_PTR_NE(test, mock, NULL);
+		KUNIT_EXPECT_EQ(test, mock->msg.command, EC_CMD_GET_COMMS_STATUS);
+
+		mock = cros_kunit_ec_xfer_mock_next();
+		KUNIT_EXPECT_PTR_NE(test, mock, NULL);
+		KUNIT_EXPECT_EQ(test, mock->msg.command, EC_CMD_RESEND_RESPONSE);
+		KUNIT_EXPECT_EQ(test, mock->msg.outsize, 0);
+		KUNIT_EXPECT_EQ(test, mock->msg.version, 0);
+		KUNIT_EXPECT_EQ(test, mock->msg.insize, 16);
+	}
+
+	KUNIT_EXPECT_EQ(test, cros_kunit_ec_pkt_xfer_mock_called, 3);
+}
+
 static void cros_ec_proto_test_cmd_xfer_in_progress_retries_eagain(struct kunit *test)
 {
 	struct cros_ec_proto_test_priv *priv = test->priv;
@@ -2703,7 +2853,9 @@ static struct kunit_case cros_ec_proto_test_cases[] = {
 	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_protocol_v3_no_op),
 	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_protocol_v2_normal),
 	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_protocol_v2_no_op),
-	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_in_progress_normal),
+	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_in_progress_payload_0byte),
+	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_in_progress_payload_4bytes),
+	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_in_progress_payload_gt4bytes),
 	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_in_progress_retries_eagain),
 	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_in_progress_retries_status_processing),
 	KUNIT_CASE(cros_ec_proto_test_cmd_xfer_in_progress_xfer_error),
-- 
2.53.0



