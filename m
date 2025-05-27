Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D3D1F4CB1;
	Tue, 27 May 2025 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365427; cv=none; b=Rl9EUkRKu0F7D9bQVQzopW669BPQ6j7sQB2oVtqrq7E7uCvilpNivYHBQ32BqSnhV206J8f1e3DlIhL6VKeXuK+NDBOo0Kdz7n8j8S7+bY/mLSfQeMhtHSE6amDuQLjvuTVIOiI64GOvvWpnZDTdpIRwEXhNqX2CUYOuDrWcHpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365427; c=relaxed/simple;
	bh=1lHEilUeCZMF3bay4IvdGS9sJOtCu+INUymbm2lAtKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6WMUVe2iX9/SIdxSm6FfAtD9f4CtLlm7Ckb6PfqmNWa52MLYj4q46/4Siq0FeXeAdde1tv8RX3UJBpJkLynUGhnnZuyHhDg8BQqAZHtHTlLnXIAQyz12Vn/yDoRRYKMHpWhIPNEAU7pGGfkaqoDT2CVyexg+HXSuKcBXewnz7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uV9rI6M9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV9rI6M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4F9C4CEE9;
	Tue, 27 May 2025 17:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365427;
	bh=1lHEilUeCZMF3bay4IvdGS9sJOtCu+INUymbm2lAtKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV9rI6M9ipgf7yzVyFv1gEXrLVMGVKjYjAc30etrzPr13JmtaqYsjxGvI+WlSB6xD
	 0pt1A8EqYkt1F3zVEu86esvM6S5eYgVShSRgMPlNDKreCWQpJUgP0hv9WkXQPPYI/N
	 tFNHbLxMdJfX+fRnUDE35D3BxKYNxg2nxSKK31Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Chan <exxxxkc@getgoogleoff.me>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 372/626] clk: qcom: ipq5018: allow it to be bulid on arm32
Date: Tue, 27 May 2025 18:24:25 +0200
Message-ID: <20250527162500.138422904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Chan <exxxxkc@getgoogleoff.me>

[ Upstream commit 5d02941c83997b58e8fc15390290c7c6975acaff ]

There are some ipq5018 based device's firmware only can able to boot
arm32 but the clock driver dont allow it to be compiled on arm32.
Therefore allow GCC for IPQ5018 to be selected when building ARM32
kernel

Signed-off-by: Karl Chan <exxxxkc@getgoogleoff.me>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241007163414.32458-4-exxxxkc@getgoogleoff.me
[bjorn: Updated commit message, per Dmitry's suggestion]
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 16145f74bbc85..fd605bccf48dc 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -199,7 +199,7 @@ config IPQ_GCC_4019
 
 config IPQ_GCC_5018
 	tristate "IPQ5018 Global Clock Controller"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARM || ARM64 || COMPILE_TEST
 	help
 	  Support for global clock controller on ipq5018 devices.
 	  Say Y if you want to use peripheral devices such as UART, SPI,
-- 
2.39.5



