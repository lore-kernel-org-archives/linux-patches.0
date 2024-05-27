Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A46E15FD1A;
	Mon, 27 May 2024 19:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836434; cv=none; b=M1LBZ91K8CUcBmN+4xGKoCplChuYycjGWMHuxUUHW41htdIm6R/OLGEuUKt6Q/X34NXx0982Xh4iOIDBAj87JNWKlcmL7c6zIAp6wwrMAvAAU/+izoQ3VMUR5Xpv35hPCfuhsblk4RmSAJO/wcGZrQCU633aCSF/jSzGZ10FUIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836434; c=relaxed/simple;
	bh=9WVSUnZKExRGio9Au9Zs5Qs3qrH/4dTVs9FkaurDISc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fhv3Fie+lkbOPYHCQmOc91sHdo9GyBscQEaD4gELJFPge/HC9OSCXX/ps9M42nGBcTJkri+9+0msV/Ac1QHQB/qBAz7mQyNETiGU/SjsZ+WjjBLdg7cSfBtaeWm+wqkL5xwZhOb8S+OCTF+eg1Uj6cFRMJJ16U/cMb0o0/munhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZgGIQju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZgGIQju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B4DC2BBFC;
	Mon, 27 May 2024 19:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836434;
	bh=9WVSUnZKExRGio9Au9Zs5Qs3qrH/4dTVs9FkaurDISc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZgGIQjuUblhdgF+t5uo0Fltac1amyfYb7MfbAru9vn8rPeT1DYuGiN4vjiOGridn
	 qf7n08Rvr4A3jtoPH6Bv5CfMrzQsmUF2Ucr2eAXTuTOLmP4FHeHvm6Nv+sTuxLJQ/4
	 iu4/EMUPuIiJUINa5D8/UAoDTx/FarDUSLnp3C/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 045/427] firmware: qcom: qcm: fix unused qcom_scm_qseecom_allowlist
Date: Mon, 27 May 2024 20:51:32 +0200
Message-ID: <20240527185605.952417447@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e478c5fb6aa10af7b7edbff69bc8aef6fbb5f0ed ]

For !OF builds, the qcom_scm_qseecom_allowlist is unused:

  drivers/firmware/qcom/qcom_scm.c:1652:34: error: ‘qcom_scm_qseecom_allowlist’ defined but not used [-Werror=unused-const-variable=]

Fixes: 00b1248606ba ("firmware: qcom_scm: Add support for Qualcomm Secure Execution Environment SCM interface")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311191654.S4wlVUrz-lkp@intel.com/
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20231120185623.338608-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 90283f160a228..ca381cb2ee979 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1624,7 +1624,7 @@ EXPORT_SYMBOL_GPL(qcom_scm_qseecom_app_send);
  * We do not yet support re-entrant calls via the qseecom interface. To prevent
  + any potential issues with this, only allow validated machines for now.
  */
-static const struct of_device_id qcom_scm_qseecom_allowlist[] = {
+static const struct of_device_id qcom_scm_qseecom_allowlist[] __maybe_unused = {
 	{ .compatible = "lenovo,thinkpad-x13s", },
 	{ }
 };
-- 
2.43.0



