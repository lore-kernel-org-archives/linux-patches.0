Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C633EDF59;
	Wed,  5 Feb 2025 15:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768579; cv=none; b=gm3w0eEEI+7tJR3H8rsXluzAHrB+snq3MsXLKgdqvyU3gqPybfFt9w0A0YtqNhZqjt4YAOFwaQLIQIim0F1WtaPVNmlgs8TAzyTtaP6yG4WEU2mRCuRCeAukvyLif5ihIhvUZl5icpmGvOiCH6n5tizy8q9Qf/pBVBdNtq9KPCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768579; c=relaxed/simple;
	bh=//24MxUuKcUVc0ZOJ41Z4ZqfG20+aHyve3LD4zOW8n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6hhWScTRXCVIPPWLHJn0Of1V9HAyccsB2QY1f/iWZt7kVvPV4W1wABlKHYQVGl18eo2p567zi+DDPL08RYO5fNpE89KiLMoalFUGHKHP9uzo0izPbEtBO6//LmEZnIa7ZrQSts/Q/FWdzKdt/6APoGGLN/wrBzltAfx1R+D0GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsknAQDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsknAQDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFABC4CED1;
	Wed,  5 Feb 2025 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768579;
	bh=//24MxUuKcUVc0ZOJ41Z4ZqfG20+aHyve3LD4zOW8n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsknAQDqMyzipc3Ne5wj2KW6mM34A2bUQw0DtYsFpvc9FEHvlGWYQ/RanAzmnauMM
	 i3LjV6Gry31AV8TYY6T/gEia3xqZpqZLrz3IA6Yqw5IV9HMI9BsP1E2y0hTyDDe/kE
	 eChxsWnNGO8f3cI7gdfc71qWcSMFLeHOjJp7Dkm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 598/623] clk: qcom: gcc-x1e80100: Do not turn off usb_2 controller GDSC
Date: Wed,  5 Feb 2025 14:45:40 +0100
Message-ID: <20250205134519.100683031@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit d26c4ad3fa53e76a602a9974ade171c8399f2a29 upstream.

Allowing the usb_2 controller GDSC to be turned off during system suspend
renders the controller unable to resume.

So use PWRSTS_RET_ON instead in order to make sure this the GDSC doesn't
go down.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Cc: stable@vger.kernel.org      # 6.8
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250107-x1e80100-clk-gcc-fix-usb2-gdsc-pwrsts-v1-1-e15d1a5e7d80@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-x1e80100.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -6083,7 +6083,7 @@ static struct gdsc gcc_usb20_prim_gdsc =
 	.pd = {
 		.name = "gcc_usb20_prim_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_RET_ON,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 


