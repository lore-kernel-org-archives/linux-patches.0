Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF10B26B950;
	Tue,  8 Apr 2025 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116801; cv=none; b=fjKv1cvUb2183HvAj81Vc1/riWlZYRTAJ3oN+XE8XNydhg9RuBEKiY299Zat1xk1Gfn4jr8c19eY04ILLPDp6tNpdCq6CLq0Rmd+RJl1lvuCVOK42wzvWnsWA4u9lk4jLKyHz0kvGHMyzjbQbVopiAxlZsxofot7jAs6lHB7dT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116801; c=relaxed/simple;
	bh=/o1qEpzo2FlFjKWRYP0RYPq9NwFEn++TEDBGZolSIAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RFeENWGrNTiqu4wds6VKRcQJoFB9iRZANPuGSsOIPoSCcFkAfmdLM1/QNqPatOLxZjS7DvZBdp+Q9NpqNJc7kO6CsMKxolr6f5roJLFqfzjsFolB0xhvcLWJciSlek1apLpTXNlfojiCbkBr9n7PddUhgQFQuOJoCe3BsrpLtSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSd6+TaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSd6+TaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEFCC4CEE5;
	Tue,  8 Apr 2025 12:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116800;
	bh=/o1qEpzo2FlFjKWRYP0RYPq9NwFEn++TEDBGZolSIAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSd6+TaRI+FLSo+vGyVn/aXmlPJANLdgVkLLjNwBcNBS4Py1ZYGzk5XDuQGVEihDb
	 Scl3+IzqN7gJFcJ5QXF5wwVbpWDq/Kte7zuTuZ/r80ugLkHBl4L1pyiDLF+aqMrZHG
	 q2RM9ymOSIVyV57qwb1l/a6H6/weASlYqTKBc/2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/423] platform/x86/amd/pmf: Update PMF Driver for Compatibility with new PMF-TA
Date: Tue,  8 Apr 2025 12:50:00 +0200
Message-ID: <20250408104852.147409757@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 376a8c2a144397d9cf2a67d403dd64f4a7ff9104 ]

The PMF driver allocates a shared memory buffer using
tee_shm_alloc_kernel_buf() for communication with the PMF-TA.

The latest PMF-TA version introduces new structures with OEM debug
information and additional policy input conditions for evaluating the
policy binary. Consequently, the shared memory size must be increased to
ensure compatibility between the PMF driver and the updated PMF-TA.

To do so, introduce the new PMF-TA UUID and update the PMF shared memory
configuration to ensure compatibility with the latest PMF-TA version.
Additionally, export the TA UUID.

These updates will result in modifications to the prototypes of
amd_pmf_tee_init() and amd_pmf_ta_open_session().

Link: https://lore.kernel.org/all/55ac865f-b1c7-fa81-51c4-d211c7963e7e@linux.intel.com/
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20250305045842.4117767-2-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/pmf.h    |  5 ++-
 drivers/platform/x86/amd/pmf/tee-if.c | 50 +++++++++++++++++++--------
 2 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index 8ce8816da9c16..43ba1b9aa1811 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -105,9 +105,12 @@ struct cookie_header {
 #define PMF_TA_IF_VERSION_MAJOR				1
 #define TA_PMF_ACTION_MAX					32
 #define TA_PMF_UNDO_MAX						8
-#define TA_OUTPUT_RESERVED_MEM				906
+#define TA_OUTPUT_RESERVED_MEM				922
 #define MAX_OPERATION_PARAMS					4
 
+#define TA_ERROR_CRYPTO_INVALID_PARAM				0x20002
+#define TA_ERROR_CRYPTO_BIN_TOO_LARGE				0x2000d
+
 #define PMF_IF_V1		1
 #define PMF_IF_V2		2
 
diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 0ad571783d126..35495ef2c87df 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -27,8 +27,11 @@ module_param(pb_side_load, bool, 0444);
 MODULE_PARM_DESC(pb_side_load, "Sideload policy binaries debug policy failures");
 #endif
 
-static const uuid_t amd_pmf_ta_uuid = UUID_INIT(0x6fd93b77, 0x3fb8, 0x524d,
-						0xb1, 0x2d, 0xc5, 0x29, 0xb1, 0x3d, 0x85, 0x43);
+static const uuid_t amd_pmf_ta_uuid[] = { UUID_INIT(0xd9b39bf2, 0x66bd, 0x4154, 0xaf, 0xb8, 0x8a,
+						    0xcc, 0x2b, 0x2b, 0x60, 0xd6),
+					  UUID_INIT(0x6fd93b77, 0x3fb8, 0x524d, 0xb1, 0x2d, 0xc5,
+						    0x29, 0xb1, 0x3d, 0x85, 0x43),
+					};
 
 static const char *amd_pmf_uevent_as_str(unsigned int state)
 {
@@ -321,7 +324,7 @@ static int amd_pmf_start_policy_engine(struct amd_pmf_dev *dev)
 		 */
 		schedule_delayed_work(&dev->pb_work, msecs_to_jiffies(pb_actions_ms * 3));
 	} else {
-		dev_err(dev->dev, "ta invoke cmd init failed err: %x\n", res);
+		dev_dbg(dev->dev, "ta invoke cmd init failed err: %x\n", res);
 		dev->smart_pc_enabled = false;
 		return res;
 	}
@@ -390,12 +393,12 @@ static int amd_pmf_amdtee_ta_match(struct tee_ioctl_version_data *ver, const voi
 	return ver->impl_id == TEE_IMPL_ID_AMDTEE;
 }
 
-static int amd_pmf_ta_open_session(struct tee_context *ctx, u32 *id)
+static int amd_pmf_ta_open_session(struct tee_context *ctx, u32 *id, const uuid_t *uuid)
 {
 	struct tee_ioctl_open_session_arg sess_arg = {};
 	int rc;
 
-	export_uuid(sess_arg.uuid, &amd_pmf_ta_uuid);
+	export_uuid(sess_arg.uuid, uuid);
 	sess_arg.clnt_login = TEE_IOCTL_LOGIN_PUBLIC;
 	sess_arg.num_params = 0;
 
@@ -434,7 +437,7 @@ static int amd_pmf_register_input_device(struct amd_pmf_dev *dev)
 	return 0;
 }
 
-static int amd_pmf_tee_init(struct amd_pmf_dev *dev)
+static int amd_pmf_tee_init(struct amd_pmf_dev *dev, const uuid_t *uuid)
 {
 	u32 size;
 	int ret;
@@ -445,7 +448,7 @@ static int amd_pmf_tee_init(struct amd_pmf_dev *dev)
 		return PTR_ERR(dev->tee_ctx);
 	}
 
-	ret = amd_pmf_ta_open_session(dev->tee_ctx, &dev->session_id);
+	ret = amd_pmf_ta_open_session(dev->tee_ctx, &dev->session_id, uuid);
 	if (ret) {
 		dev_err(dev->dev, "Failed to open TA session (%d)\n", ret);
 		ret = -EINVAL;
@@ -489,7 +492,8 @@ static void amd_pmf_tee_deinit(struct amd_pmf_dev *dev)
 
 int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 {
-	int ret;
+	bool status;
+	int ret, i;
 
 	ret = apmf_check_smart_pc(dev);
 	if (ret) {
@@ -502,10 +506,6 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 		return -ENODEV;
 	}
 
-	ret = amd_pmf_tee_init(dev);
-	if (ret)
-		return ret;
-
 	INIT_DELAYED_WORK(&dev->pb_work, amd_pmf_invoke_cmd);
 
 	ret = amd_pmf_set_dram_addr(dev, true);
@@ -534,8 +534,30 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 		goto error;
 	}
 
-	ret = amd_pmf_start_policy_engine(dev);
-	if (ret)
+	for (i = 0; i < ARRAY_SIZE(amd_pmf_ta_uuid); i++) {
+		ret = amd_pmf_tee_init(dev, &amd_pmf_ta_uuid[i]);
+		if (ret)
+			return ret;
+
+		ret = amd_pmf_start_policy_engine(dev);
+		switch (ret) {
+		case TA_PMF_TYPE_SUCCESS:
+			status = true;
+			break;
+		case TA_ERROR_CRYPTO_INVALID_PARAM:
+		case TA_ERROR_CRYPTO_BIN_TOO_LARGE:
+			amd_pmf_tee_deinit(dev);
+			status = false;
+			break;
+		default:
+			goto error;
+		}
+
+		if (status)
+			break;
+	}
+
+	if (!status && !pb_side_load)
 		goto error;
 
 	if (pb_side_load)
-- 
2.39.5



