Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAB6158DC5;
	Mon,  6 Jan 2025 15:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177235; cv=none; b=TLC5l1eeEuh4UO/l0+Dd/Q0RLjFPG9usJIn4RuykEi9IlGATbe25JMbm0U4eVC+v80uumFj9+m3yLn/q0rycm9X+9P/ToXpAyeRc9tUlew4xcBDHaf0K6poEyYFlmj24s7A2d8a0CkGdt031fgEuqg8ol35QUTgl8vLVAD58pTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177235; c=relaxed/simple;
	bh=3RpcHIG7XfOn/5mWJdQL3PalmblX5norgdtZjdfk7io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8FL4V/CgM4/4X7RARG92n+1fqZJS3gJy/DnV+Nf9n3JEfKqMQ0Z0bs6jbDC3vIfvXlYBCN8iT0GbaPxAtUxqWzH3xafoew8vwQuXqNEURAO1I8qiwuKXPby9x9cePqU72jMvoa/QHmYYOODh5AEP5XA2UvZRO/6qnrN15Fjs5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptGZrCF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptGZrCF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB05C4CED2;
	Mon,  6 Jan 2025 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177235;
	bh=3RpcHIG7XfOn/5mWJdQL3PalmblX5norgdtZjdfk7io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptGZrCF+dBNgw8iFrn8gAQ7+DBDPwdmufc9iNnkO0msxvYRVjgS62XSJIl7qH5+gT
	 VxrYiP8kXwlQxZQMn4mXcLceuP6VE+WyLc8ctzTrSNFppRXrgmpDtWrJQkUxmkXZe2
	 qmrYSCuVoGZplMztdumQQUZdqxxaNRgK6+AMohgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/222] remoteproc: qcom: pas: enable SAR2130P audio DSP support
Date: Mon,  6 Jan 2025 16:14:19 +0100
Message-ID: <20250106151152.688374795@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 009e288c989b3fe548a45c82da407d7bd00418a9 ]

Enable support for the Audio DSP on the Qualcomm SAR2130P platform,
reusing the SM8350 resources.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241027-sar2130p-adsp-v1-3-bd204e39d24e@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 4a73723e375a..fd6bf9e77afc 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -1255,6 +1255,7 @@ static const struct of_device_id adsp_of_match[] = {
 	{ .compatible = "qcom,sa8775p-cdsp1-pas", .data = &sa8775p_cdsp1_resource},
 	{ .compatible = "qcom,sa8775p-gpdsp0-pas", .data = &sa8775p_gpdsp0_resource},
 	{ .compatible = "qcom,sa8775p-gpdsp1-pas", .data = &sa8775p_gpdsp1_resource},
+	{ .compatible = "qcom,sar2130p-adsp-pas", .data = &sm8350_adsp_resource},
 	{ .compatible = "qcom,sc7180-adsp-pas", .data = &sm8250_adsp_resource},
 	{ .compatible = "qcom,sc7180-mpss-pas", .data = &mpss_resource_init},
 	{ .compatible = "qcom,sc7280-mpss-pas", .data = &mpss_resource_init},
-- 
2.39.5



