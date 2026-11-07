Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063009;
	b=cZtu9ReCd1ZqR10g5o8uUGcC+34GRZvjHviX0E0ghBIaq9NG7tCFAqB7TR6jla/fUX5e
	 tFU4BuLTLe/cnHpCrfexu+V0JTsupK2+WOc60Lh70YiGeub07Gc0wLChJGqODv6nIj0Fx
	 E1UdjTaHXw8jlFaq4lq5sXXfRNFbld//JIYj/SrhNG9XMk1+IOrAoIse+Jv2SwMr3P1VE
	 YjNgESnvLh6QwG5zZb6TuaNH79GW8S8GggwhGXc9kwFq+cs4ZUhs71YwDVFtTc0in2dhn
	 2q4pzhl/B8e8ATXyU1DepKJhLuhyhYxxqXU+QqZqeDW9pvTnDWS0K/nENujavMGEBLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fNfK738ct0hvmy24s2tx1WQ7mAmnjhS6CoVbTZU3/3w=;
	b=Z9llqZzoQdjxJ6Uq1NaSsiSslqQXSoOFXULDVrQvhmo7eMjwVnAomqTOxAvTWRAB1oQo
	 OLm0eMN4iRX8P5ozuX9DN5LFhs52WZJRrNZSYcBi7BfbyfsF/V5FGCT1KsOk1sBr9M/cb
	 kyeeNHkxUP5jSXvcbAgEXv3VLl5kqrB0Z76H4qSy1bRctJ4Wyy72ghFmyewmyL6HKeKPy
	 VpnXGLsd5M87g0qoNlNRDK0hlhhrZQAlc0XX8N4efgrn4iYe9m9VworYdnUioZJ0ZGqFQ
	 2f/ORBRTt6FbVDfshRJRBKdhZuTVJNgrOn7n7EkwEAz/TB8Z4muN5Y3uHQCjXEReIsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zyd/PfTC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6338C606D818;
	Sat,  7 Nov 2026 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zyd/PfTC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1243A1F008A1;
	Sat,  7 Nov 2026 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063009;
	bh=fNfK738ct0hvmy24s2tx1WQ7mAmnjhS6CoVbTZU3/3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zyd/PfTCiA/17XrnXPn8rnRaZU8LWSNnpJM1cpslBq4rUWb5Xbs3Ec9QcoGbJfJdR
	 DxmX5lAN+wuE5TrH3aKYuUq26T+wzS9PAFLZhBmtcS0HwICeQmbg5K+80bEdv82leB
	 /13O2Vs9VDL4OEMoGZ9nsGGw2d3npd9PcST9dXAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 261/869] arm64: dts: qcom: sdm845-xiaomi-beryllium: Extend the xbl_mem region
Date: Sat,  7 Nov 2026 08:49:03 -0500
Message-ID: <20261107134900.599523460@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 511c4fea32708a065e03503c0e4d44f48990c530 ]

Xiaomi's Oreo-era tree still had the CAF 1 MiB region, the 2 MiB version
arrived with the Pie import. This isn't a board-layout quirk, it tracks
the firmware. The later XBL wants one extra MiB below the old region.

Cc: stable@vger.kernel.org
Fixes: 77809cf74a8c ("arm64: dts: qcom: Add support for Xiaomi Poco F1 (Beryllium)")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-sdm845-xbl-mem-v1-1-6e3c88507997@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
index dbd5f08b5cdd3..3db935a7442ea 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium-common.dtsi
@@ -27,6 +27,7 @@
 /delete-node/ &slpi_mem;
 /delete-node/ &spss_mem;
 /delete-node/ &rmtfs_mem;
+/delete-node/ &xbl_mem;
 
 / {
 	chassis-type = "handset";
@@ -55,6 +56,11 @@ key-vol-up {
 
 	/* Reserved memory changes from downstream */
 	reserved-memory {
+		xbl-mem@85d00000 {
+			reg = <0 0x85d00000 0 0x200000>;
+			no-map;
+		};
+
 		tz_mem: memory@86200000 {
 			reg = <0 0x86200000 0 0x4900000>;
 			no-map;
-- 
2.53.0



