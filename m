Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A603615C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:24:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2710DC433C1;
	Mon,  5 Dec 2022 19:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268248;
	bh=WIRxJmD3ClaJLAQ6qB9INaJg3L9aBE5Y8tU25Fkz6OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0qY0szGQdZYqBuWn3IkQh4GVM7eOZGhXGzsn2Q1heRkMv7KLnQe8KpP94XyGFQYB
	 CWY35jjfLRwWa82FUbgKv1YP6gblRZEcz+LXT1dSDVxgpeNFc2FhBG3TNfJvAlowoM
	 EPh89KB0Xd24RBpfUrV1qdpJ/q+uClSgvpvo+w8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <KevinYang.Wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 006/124] drm/amd/pm: add smu_v13_0_10 driver if version
Date: Mon,  5 Dec 2022 20:08:32 +0100
Message-Id: <20221205190808.621621185@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Wang <KevinYang.Wang@amd.com>

[ Upstream commit 8e039cd176c61a9770e1956038c93738efc800f7 ]

add smu_v13_0_10 driver if version

Signed-off-by: Yang Wang <KevinYang.Wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: f2e1aa267f12 ("drm/amd/pm: update driver if header for smu_13_0_7")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h   | 1 +
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index 3e29fe4cc4ae..dd5867561068 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -32,6 +32,7 @@
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0 0x30
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_7 0x2C
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_10 0x1D
 
 #define SMU13_MODE1_RESET_WAIT_TIME_IN_MS 500  //500ms
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 33710dcf1eb1..e7380aa4f6be 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -304,6 +304,9 @@ int smu_v13_0_check_fw_version(struct smu_context *smu)
 	case IP_VERSION(13, 0, 5):
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_5;
 		break;
+	case IP_VERSION(13, 0, 10):
+		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_10;
+		break;
 	default:
 		dev_err(adev->dev, "smu unsupported IP version: 0x%x.\n",
 			adev->ip_versions[MP1_HWIP][0]);
-- 
2.35.1



