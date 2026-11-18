Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017429;
	b=x9s4jyhNhYKWg286oShuIiXyygxlFetGGUDzJ1d1JDmjJ3OgVNaqma73t+UJgK1j5dMk
	 ghFSlUp+QCSRv1trE2+qIB8gE2xv/tDMld+IUlPy5u6GDKp76tkH+QL2bIx2BmwOsrFhS
	 pHPtPup9ja3qjVK0bi7ZeN6TLkHQA9ZXUi1uwpDwnI7WBxkp3SR+/+AAnr7p+BBJFg7aS
	 V8FMyWrixxokAaOBO38KWWQkmhT/MvnapFnnr0bDFqnP7qRlcguK/NSa7tJDG5pTqc7Ta
	 Y1CDc3AYUEIfNfjxo9WGrvNaqBVrATXTyYfn9W6Z4aI7IyrRy1wJXlL7VsPuMGzO95Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TgfFR7jJh/9yeG/hoCf0leWMboz6ezAVvWOFsFSaxuQ=;
	b=N63q71G3/GvbwdoHTfCvZqTPf3OMvRoLKCu7LCDe3hWUCqL3AufGXwHzdV4E6VnwmWsa
	 n0xsxfBxLll13L7nZwdF4ywlArkfqrZFJZrFME29RdXvxBTX2jq+r0Ddhm8JtTIa1FP9l
	 BoawKMm9Bu4VHpY6x51b1flYepmfFi3NmRqEdqNRnd0m+NGLD9InnbuGQ7QU5JG2mvzhT
	 EvwRD7FHUVrWzeucYEX4wCEXYluW159VPmb1/OeE6bduI19U0d1H4QqoePyKiDkwPos0m
	 pOPhLlnW0IhQyftfNKOAYRMrfgJaCnMhu57ljWWFEbMkWNtSDkJgsgmiNE1t7HtpZrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+dJD7Tt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7734C606A31C;
	Wed, 18 Nov 2026 15:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+dJD7Tt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D731F000C4;
	Wed, 18 Nov 2026 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017429;
	bh=TgfFR7jJh/9yeG/hoCf0leWMboz6ezAVvWOFsFSaxuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+dJD7TtDv4P+tGjA7kUgzgOSC/eHuOM6Pdu+iZHLMbUWCsNbbUdBxHYZcbLAGsSm
	 cK/dFDbcobqmeXvhgzde0ytq1++imBmbTwZFdoHPe7EZEyPp2lufvNjVZTUIx+EXwg
	 P5GwYlZ2l7OkWLHatKNAN+KePXzALagIcTn5Ujqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Obbard <chris.obbard@oss.qualcomm.com>,
	Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Vinayak Katoch <vinayak.katoch@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0882/2651] arm64: dts: qcom: agatti: Add memory-region for audio PD
Date: Wed, 18 Nov 2026 15:35:22 +0100
Message-ID: <20261118150319.611871422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinayak Katoch <vinayak.katoch@oss.qualcomm.com>

[ Upstream commit 3fbf3b85bf861e1f4eb32312a1e3f22ffc8e6ca1 ]

Reserve memory region for audio PD dynamic loading and remote heap
requirements. Add the required VMID list for memory ownership
transfers.

Fixes: 851d5ae6003b ("arm64: dts: qcom: agatti: enable FastRPC on the ADSP")
Tested-by: Christopher Obbard <chris.obbard@oss.qualcomm.com>
Reviewed-by: Ekansh Gupta <ekansh.gupta@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Vinayak Katoch <vinayak.katoch@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260807-agatti-audio-v2-1-3959b1ab8059@oss.qualcomm.com
Link: https://patch.msgid.link/20260908-agatti-audio-v4-1-b3db91d3fdec@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/agatti.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/agatti.dtsi b/arch/arm64/boot/dts/qcom/agatti.dtsi
index 590bd2432d85b..d010ef7fdf8c8 100644
--- a/arch/arm64/boot/dts/qcom/agatti.dtsi
+++ b/arch/arm64/boot/dts/qcom/agatti.dtsi
@@ -381,6 +381,14 @@ rmtfs_mem: memory@89b01000 {
 			qcom,client-id = <1>;
 			qcom,vmid = <QCOM_SCM_VMID_MSS_MSA QCOM_SCM_VMID_NAV>;
 		};
+
+		adsp_rpc_remote_heap_mem: adsp-rpc-remote-heap {
+			compatible = "shared-dma-pool";
+			alloc-ranges = <0x0 0x0 0x1 0x0>;
+			reusable;
+			alignment = <0x0 0x400000>;
+			size = <0x0 0x800000>;
+		};
 	};
 
 	smp2p-adsp {
@@ -2348,6 +2356,9 @@ fastrpc {
 					compatible = "qcom,fastrpc";
 					qcom,glink-channels = "fastrpcglink-apps-dsp";
 					label = "adsp";
+					memory-region = <&adsp_rpc_remote_heap_mem>;
+					qcom,vmids = <QCOM_SCM_VMID_LPASS
+						      QCOM_SCM_VMID_ADSP_HEAP>;
 
 					qcom,non-secure-domain;
 
-- 
2.53.0



