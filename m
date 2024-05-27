Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F20A168C4;
	Mon, 27 May 2024 19:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837704; cv=none; b=hCIOn0PQcEesQXx1SULnhEyDbqkdKdzHLBCAhNwZM1h5U/nWJUJVDhQDlpxOR87Kl6MeeVs1f4Q42sPpX8cSVhtOyqHOAEAnvF51DYVeKt6Y7TPipu9yZjgvrj3pUMxMOcvXR2nkoOtjg5XKv7rOjbd9HuWLHfJCSctrO4ItH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837704; c=relaxed/simple;
	bh=7ejpEelsC30G6u5cQF7Swof/Xo+uWF3fkzGyW+nqkl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NkHT3McDrziwHG8zl1epmPdvyoYkUQMtSF1ezmHZRj71lI7aWj3zXqG0sCdw0xdb5v5nkXI6fT1aut6dN3cGQUB3a4JU6/KAfA4NsTMDpWCxLKSvs0gOrCiKLnehCwnIssn+q7RZYi2DXTirVMODbHgfbN6sl8O3s49YBBBAZ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+zm3mVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+zm3mVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166C4C2BBFC;
	Mon, 27 May 2024 19:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837704;
	bh=7ejpEelsC30G6u5cQF7Swof/Xo+uWF3fkzGyW+nqkl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+zm3mVRTJJv6PYuw5hRV9iOFAJYgk7wdPU/jVMLylJYk2jzNEjf3XDKix6rztbet
	 FPCbfoDhBgJwuOzhUFN3dRTCj2u8AyX8XBrNWttpbRNKZ/fDkrq/F+Z2mtdTJ0vXwc
	 QG0aR+nCVxI9xCjvboQTVNvuTGjy9eK76EwwOXvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 112/493] firmware: qcom: qcm: fix unused qcom_scm_qseecom_allowlist
Date: Mon, 27 May 2024 20:51:54 +0200
Message-ID: <20240527185634.191822712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



