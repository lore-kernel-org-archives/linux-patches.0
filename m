Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B0B1A315E;
	Wed, 19 Feb 2025 09:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956959; cv=none; b=ScKncZUUdjSwrp0aEImeffDJJDh5zS57+zuGPPz/AuJUK/GZHT7QPiHY+S5bSPuVYgZOAMfw0bl+d8ldyto19fQCG9hYrjPbHjbiFm/qs3FsQtBxogOq23qXMSTCOmQ0inUEjfQr7wWS5kEbNt7AJmRpwPV2fu8a1vc3kQl7Vcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956959; c=relaxed/simple;
	bh=LwYqZDiElZidE7aLjHw1ynKTPdrjEOTYTlT4gSoyA8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYLww3j7L/HhR8Lkx6znRKCrFedQ7Vx/RaM15GgF4NM0buPSYYGxvTbwaDpj85aIttyv1C78CW9yvn1LvVyaxJKE8cdH8Os0et5m2xOXKOI1uaYLC0NivLYITzW6HlAvXsGxGrvy2uHcdE4wP6MlxZzkyrN7HwJYaBjIy72Crr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mt793l2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mt793l2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6EBC4CED1;
	Wed, 19 Feb 2025 09:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956959;
	bh=LwYqZDiElZidE7aLjHw1ynKTPdrjEOTYTlT4gSoyA8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mt793l2tPxL24eVyYysd4f5p/1u8eNE4hbTTVwa/xnDu2FuV+AMqToMGYzTET8A1q
	 kaHc3k4IovqDx8fa9EYhF7nPRmPl66yyVm/k5s4++QlJHTm5WIH0ZmBnN906uGVUpB
	 DlWHDMooChH8C8jyhwpbiSCTuMB4OyszbKGngWDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 360/578] clk: qcom: gcc-mdm9607: Fix cmd_rcgr offset for blsp1_uart6 rcg
Date: Wed, 19 Feb 2025 09:26:04 +0100
Message-ID: <20250219082707.181229896@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

commit 88d9dca36aac9659446be1e569d8fbe3462b5741 upstream.

Fix cmd_rcgr offset for blsp1_uart6_apps_clk_src on mdm9607 platform.

Fixes: 48b7253264ea ("clk: qcom: Add MDM9607 GCC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241220095048.248425-1-quic_skakitap@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-mdm9607.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/qcom/gcc-mdm9607.c
+++ b/drivers/clk/qcom/gcc-mdm9607.c
@@ -536,7 +536,7 @@ static struct clk_rcg2 blsp1_uart5_apps_
 };
 
 static struct clk_rcg2 blsp1_uart6_apps_clk_src = {
-	.cmd_rcgr = 0x6044,
+	.cmd_rcgr = 0x7044,
 	.mnd_width = 16,
 	.hid_width = 5,
 	.parent_map = gcc_xo_gpll0_map,


