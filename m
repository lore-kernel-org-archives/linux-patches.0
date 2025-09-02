Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B172321CC5B;
	Tue,  2 Sep 2025 13:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819811; cv=none; b=gAr46GhAiYhmvIZKgS1z8uccbURA4Cy0MVn15Vwjnk4T5CV2BJtACsrKf5PizKDHjIUL8YoaKi5sdzC7Suh9KMP32M/9qIvdTd7IbLvr0CHQLLp6/F0em/0PCdEEf3vL1H4e+zBM6IzcGLi+71BWHfLE+gFvJwZr4iqRnsmQotk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819811; c=relaxed/simple;
	bh=Igk7ylJWW3R1dguOHUIS35e790vceeLNTi03gi1U/B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klH3Bn/wwrREcxaki0HeZQ33EIS8Ux4IkGPGLcenylyyb9gLox3TgoJe9flqhMFxlFuaxi72LCZo7kD8+uHLRH+SvlMIgOb/O4aCysexjKXAhCYXDNZF3suEOxWGc5tXvHT4k0o/e2mH9a2ZPiEOHsnrSGsU5dR6VpkdvE3bcnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sm2Tl41f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sm2Tl41f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C89C4CEED;
	Tue,  2 Sep 2025 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819811;
	bh=Igk7ylJWW3R1dguOHUIS35e790vceeLNTi03gi1U/B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sm2Tl41f7xN5bo/8Uk2TFUZgsyKgaHTInM3t2OXIxQlKmtuGMj78UwlVTCYDIMCQS
	 V3cALyeDznq75rk2vg6jw0+k2Up4P0hsvP66cBDJkrBvtUqe9GXga8DlsiaMYSlGSU
	 p+UOQDQDIjA03Balam6Yls3FiG3MuWUQPFb6Fn3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.16 135/142] firmware: qcom: scm: remove unused arguments from SHM bridge routines
Date: Tue,  2 Sep 2025 15:20:37 +0200
Message-ID: <20250902131953.454671704@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 23972da96e1eee7f10c8ef641d56202ab9af8ba7 upstream.

qcom_scm_shm_bridge_create() and qcom_scm_shm_bridge_delete() take
struct device as argument but don't use it. Remove it from these
functions' prototypes.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20250630-qcom-scm-race-v2-1-fa3851c98611@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_scm.c       |    4 ++--
 drivers/firmware/qcom/qcom_tzmem.c     |    8 ++++----
 include/linux/firmware/qcom/qcom_scm.h |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1631,7 +1631,7 @@ int qcom_scm_shm_bridge_enable(void)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_enable);
 
-int qcom_scm_shm_bridge_create(struct device *dev, u64 pfn_and_ns_perm_flags,
+int qcom_scm_shm_bridge_create(u64 pfn_and_ns_perm_flags,
 			       u64 ipfn_and_s_perm_flags, u64 size_and_flags,
 			       u64 ns_vmids, u64 *handle)
 {
@@ -1659,7 +1659,7 @@ int qcom_scm_shm_bridge_create(struct de
 }
 EXPORT_SYMBOL_GPL(qcom_scm_shm_bridge_create);
 
-int qcom_scm_shm_bridge_delete(struct device *dev, u64 handle)
+int qcom_scm_shm_bridge_delete(u64 handle)
 {
 	struct qcom_scm_desc desc = {
 		.svc = QCOM_SCM_SVC_MP,
--- a/drivers/firmware/qcom/qcom_tzmem.c
+++ b/drivers/firmware/qcom/qcom_tzmem.c
@@ -124,9 +124,9 @@ static int qcom_tzmem_init_area(struct q
 	if (!handle)
 		return -ENOMEM;
 
-	ret = qcom_scm_shm_bridge_create(qcom_tzmem_dev, pfn_and_ns_perm,
-					 ipfn_and_s_perm, size_and_flags,
-					 QCOM_SCM_VMID_HLOS, handle);
+	ret = qcom_scm_shm_bridge_create(pfn_and_ns_perm, ipfn_and_s_perm,
+					 size_and_flags, QCOM_SCM_VMID_HLOS,
+					 handle);
 	if (ret)
 		return ret;
 
@@ -142,7 +142,7 @@ static void qcom_tzmem_cleanup_area(stru
 	if (!qcom_tzmem_using_shm_bridge)
 		return;
 
-	qcom_scm_shm_bridge_delete(qcom_tzmem_dev, *handle);
+	qcom_scm_shm_bridge_delete(*handle);
 	kfree(handle);
 }
 
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -149,10 +149,10 @@ bool qcom_scm_lmh_dcvsh_available(void);
 int qcom_scm_gpu_init_regs(u32 gpu_req);
 
 int qcom_scm_shm_bridge_enable(void);
-int qcom_scm_shm_bridge_create(struct device *dev, u64 pfn_and_ns_perm_flags,
+int qcom_scm_shm_bridge_create(u64 pfn_and_ns_perm_flags,
 			       u64 ipfn_and_s_perm_flags, u64 size_and_flags,
 			       u64 ns_vmids, u64 *handle);
-int qcom_scm_shm_bridge_delete(struct device *dev, u64 handle);
+int qcom_scm_shm_bridge_delete(u64 handle);
 
 #ifdef CONFIG_QCOM_QSEECOM
 


