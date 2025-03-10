Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F177E2D023;
	Mon, 10 Mar 2025 17:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629366; cv=none; b=IEzoTOZQqvJuTw4GopPz6bWATm+XvF1ZOKBC6qeTx99dk8jRTxn/CVtG+ITbtfULwpwhRg26/4Fd1WpnylPojFxGJ99JJt8n+T+iIG9nXycDWgi2NdUsuBqPzxZ9pyXXqgvYst5Prwd/NclILb+3FMpubPNMMFKdKDXNCNKZT/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629366; c=relaxed/simple;
	bh=jZswlRbssm3dmBuMvoBb312qMSBgwPqw/2z4QDzO7tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mtldd8qtQKGXGGUaEFtbLGazoH23kAfr3+sU24CKQShRaANXx0ScbDFCmwbCgZBQVSmMlR8xuq35BqCbjEg/11eEqTdHV3Geyf3vhMYqQN/7t4ChANRVXuVrc2aKyI2/1ju3ZDXSqqPWLWgO3+wwNydX/UVAful8rS4rjknPEsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Vo8ROrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Vo8ROrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759EAC4CEED;
	Mon, 10 Mar 2025 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629365;
	bh=jZswlRbssm3dmBuMvoBb312qMSBgwPqw/2z4QDzO7tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Vo8ROrWpa1XhW+858haazDA0C+P+18CYP4OCtFlkN71n9XA6RdJno2lB5VovtZxL
	 xXprCfi0rPEQ4nNqj7jiQD1pDD9iJNyoNbbCQq/b+XauImLwXccQx6bifuLfPbIk9Y
	 LvOGuUuLfgj6SYYX0Lt95bKtdAlCrdIipnDenAgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 269/620] clk: qcom: gcc-mdm9607: Fix cmd_rcgr offset for blsp1_uart6 rcg
Date: Mon, 10 Mar 2025 18:01:55 +0100
Message-ID: <20250310170556.238750968@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


