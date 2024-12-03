Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8291F33FE;
	Tue,  3 Dec 2024 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238238; cv=none; b=rA1JQ1y2FWCzsfAv5Ah5F+oNqrf7fuGzlmtqy+nBL24KkaEJTbNry5Cr07IiOMxjzr+lzYZOS9PkxF27BOo0icy+f0pOj8m4Er55PMLdUTuqmlB0Rls7v0bMSXDNDYfOldUmk7oojA0d8z5pFo2cWRmZBlH3OxxNnF3rSdhZ4yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238238; c=relaxed/simple;
	bh=l4vJl4Ueh1KcKjj/yQdkrqmdHiuFIbZCjtskqA19T/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g59BHZP3nr9P5Ok3QA9SZysnHWXZOMzDN1Nza4jpRv8u25sHFQDBuaaQKNs2/oK0C7wHQsvd5iGqvT4zUeBmmOKQ9qkab3pcsCLSdZNinDFdcWRw6KYP/XX2tqPCM7AkfxjCCjGz6aHnapquavMCTzm3AN3EXfOxYg3sVnOWPOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsPPVho5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsPPVho5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093D9C4CECF;
	Tue,  3 Dec 2024 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238238;
	bh=l4vJl4Ueh1KcKjj/yQdkrqmdHiuFIbZCjtskqA19T/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsPPVho5bSo2tUjl3GzP7Y92qpeUL5EThW+ZxqFV0xfYqdrfCkkQ5KF8Dw5wNKbnd
	 M2OWGW/MBud8VcnnDaLTqXEmjwOdNeyV9/r/4G6UJiely0c3jnIS3N6tGhJHSTbmUw
	 3INWusUg32da15i2IkP5GFPtZic6QojsLkmic1gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Morrisson <nmorrisson@phytec.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 168/817] arm64: dts: ti: k3-am62x-phyboard-lyra: Drop unnecessary McASP AFIFOs
Date: Tue,  3 Dec 2024 15:35:40 +0100
Message-ID: <20241203144002.285374572@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Morrisson <nmorrisson@phytec.com>

[ Upstream commit c33a0a02a29bde53a85407f86f332ac4bbc5ab87 ]

Drop the McASP AFIFOs for better audio latency. This adds back a
change that was lost while refactoring the device tree.

Fixes: 554dd562a5f2 ("arm64: dts: ti: k3-am625-phyboard-lyra-rdk: Drop McASP AFIFOs")
Signed-off-by: Nathan Morrisson <nmorrisson@phytec.com>
Reviewed-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://lore.kernel.org/r/20241002224754.2917895-1-nmorrisson@phytec.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
index e4633af87eb9c..d6ce53c6d7481 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
@@ -433,8 +433,6 @@ &mcasp2 {
 			0 0 0 0
 			0 0 0 0
 	>;
-	tx-num-evt = <32>;
-	rx-num-evt = <32>;
 	status = "okay";
 };
 
-- 
2.43.0



