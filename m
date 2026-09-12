Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381F51A6813;
	Sat, 12 Sep 2026 07:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197629; cv=none; b=QXh1fVznQACSidzg8tblFj4RE/U6iJ7ouwY7+tY2qu8RuvLmCAMTkpPcix+ikSj7OsXobU4YmXV0mXQYETY7JhHi5ibXL4t+MTP49bz3GjWXXALjYNYk5zVxeH9ArpXWFQDR+4eAZvoaOORr4y8thstIs5I0m6vBJHwAmifLuiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197629; c=relaxed/simple;
	bh=tpZ+kEerZp9JBMNbBHah7puWCK2pe7tSXs59UWgrucA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLGQp5Er/YGsjOlENoxI29qudigodwkDbwnI9OQXv+ozPFNNkS0IhVXPTRd6q+tZEzfZjemu/DiRi9K6qD3CI/acF/sPv0yvseatAQ5uaeIKnrWKzia7E6nImYQw3z98sCzpexT0vPz7Guhs/Vxm372CNoNj1a5iXImuBFwdoFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1RCOlC4Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1RCOlC4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1061F000FF;
	Sat, 12 Sep 2026 07:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197627;
	bh=D0zTcg1zRvvRhhTRrXdXuksBxO9BHZGlLcb0lSd2oYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1RCOlC4QB03A871oJrLFhunwexYgG1ROzesYfXF2drT0cqXIun4ZhAd6477yNb2KZ
	 3oJqO/+4ioXLpqIst4SBhGEPDXW8AhDnhZzQm+CmWZqCntqzp3TEXwXHuwaRHgauVG
	 PNUTe8D7rct+idmcPOGp4VmrdcNQZu6prrZkmd1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Gan <jie.gan@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0213/1815] arm64: dts: qcom: monaco: fix wrong connection for the replicator
Date: Sat, 12 Sep 2026 08:32:43 +0200
Message-ID: <20260912065653.993887173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Gan <jie.gan@oss.qualcomm.com>

[ Upstream commit bf949e86fb5c3034b70b62c9ee31b3d88d5f7fb5 ]

Fix the wrong connection for the qdss replicator device.

Fixes: 4f791e008807a ("arm64: dts: qcom: monaco: Add CTCU and ETR nodes")
Signed-off-by: Jie Gan <jie.gan@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260428-fix-monaco-coresight-dt-v2-1-2293259bbd10@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/monaco.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
index a350a8ba48fa3..3a0749cd3e788 100644
--- a/arch/arm64/boot/dts/qcom/monaco.dtsi
+++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
@@ -3017,14 +3017,6 @@ in-ports {
 				#address-cells = <1>;
 				#size-cells = <0>;
 
-				port@0 {
-					reg = <0>;
-
-					swao_rep_out0: endpoint {
-						remote-endpoint = <&qdss_rep_in>;
-					};
-				};
-
 				port@1 {
 					reg = <1>;
 
@@ -3734,6 +3726,14 @@ out-ports {
 				#address-cells = <1>;
 				#size-cells = <0>;
 
+				port@0 {
+					reg = <0>;
+
+					swao_rep_out0: endpoint {
+						remote-endpoint = <&qdss_rep_in>;
+					};
+				};
+
 				port@1 {
 					reg = <1>;
 
-- 
2.53.0



