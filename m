Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5224421ADC7;
	Tue, 29 Apr 2025 17:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947211; cv=none; b=RlUQrCBRz6iJm+/7ywzkE27ixxBKRn9S2wr5fg354XhxGUVAqE6xVvbtFK4JKEGb1SNyuZB2dEfTp5I6re87X7iyGx/lpLi5KoPaZLkekNr9IyuRm1sW7GKwotD9aE9DAy1YBdci6Nx1IeszkjVfiqMLGdESaGvVYGd8Yd9BaYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947211; c=relaxed/simple;
	bh=62wo0MnCj3Irl8F+fWF/VgK6gxJEVydVmwQzk6LIFAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+I8AXOpaGRUNzE3H6FO2oVCHe0AFVGk0fCdybMd3UWegDv+VGT2mM5MIki/FSr7FkloxQUgYcDrn4pLHtxIEyNwGu4owX+FgT0/rxyQFqQWkew6ZFd0WJI6jmBCJfN6jzitdtHUOzOL9WmbJwOD7Be9K48Hy7Jv0IHHXaRMG5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtRYu52U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtRYu52U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E10C4CEE9;
	Tue, 29 Apr 2025 17:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947211;
	bh=62wo0MnCj3Irl8F+fWF/VgK6gxJEVydVmwQzk6LIFAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtRYu52UtIArgVii8w2QZXPC/PI2zuObMwMP7Xl81S6lQ3ptSG2pWf6qJStrSFBbj
	 YlWvQ8JYPQjRmxUiGuGaKtodz/OgwPkQXnPggg5enBb1tTe5cfAtyN0sH1DrJnhMxt
	 LxUg48C0JtmQHzk82Ck+69RBBosrhLZmCT84uqp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/286] media: venus: hfi_plat: Add codecs and capabilities ops
Date: Tue, 29 Apr 2025 18:41:52 +0200
Message-ID: <20250429161116.508942854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanimir Varbanov <stanimir.varbanov@linaro.org>

[ Upstream commit 9822291e031f6d7149ae4f3fc00bd9c33ac2a084 ]

Add ops to get the supported by the platform codecs and capabilities.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 9edaaa8e3e15 ("media: venus: hfi_parser: refactor hfi packet parsing logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_platform.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi_platform.h b/drivers/media/platform/qcom/venus/hfi_platform.h
index 6794232322557..50512d142662f 100644
--- a/drivers/media/platform/qcom/venus/hfi_platform.h
+++ b/drivers/media/platform/qcom/venus/hfi_platform.h
@@ -47,6 +47,8 @@ struct hfi_platform_codec_freq_data {
 struct hfi_platform {
 	unsigned long (*codec_vpp_freq)(u32 session_type, u32 codec);
 	unsigned long (*codec_vsp_freq)(u32 session_type, u32 codec);
+	void (*codecs)(u32 *enc_codecs, u32 *dec_codecs, u32 *count);
+	const struct hfi_plat_caps *(*capabilities)(unsigned int *entries);
 };
 
 extern const struct hfi_platform hfi_plat_v4;
-- 
2.39.5



