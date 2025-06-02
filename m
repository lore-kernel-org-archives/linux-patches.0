Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B59821FF39;
	Mon,  2 Jun 2025 13:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872676; cv=none; b=ouWzOg/px71c13hutnzQqETw6CmkajqlX03OOpfGIJTfCOhLA4Z+p1eLcuhZA9AyBi5AaAipBm3dN9TzB8Be4lKknkjWL8LK3Wlu3IMalAhZUtJc9rBrcSmDmKsotV67Lz39WpDjZOlyOLyg1Ym7E1LtoNAKzfv5yi6XOqc6VMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872676; c=relaxed/simple;
	bh=1N7Wz8Dkc+aKJxqkt13qzXE6DV1JoVVMMX0/oHEKHRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7B7N/JiK1A012XIyUvpQZI5jlWeR/2zEjKZo83AmrXjgBdFRn1yseza6VYYJ5lgxV8c+ojG3Hn3anMIjMwARrPvhubiNj0eJGLIz6rrmq05YWLAO+SQnWJJSjZ8dBx5EjvP/fdRYi3tbnie5N2bPF87tPkB1ZxObA36/ZKKiK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csV6pdle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csV6pdle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381E4C4CEEB;
	Mon,  2 Jun 2025 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872675;
	bh=1N7Wz8Dkc+aKJxqkt13qzXE6DV1JoVVMMX0/oHEKHRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csV6pdlejSKyd3a5U/qNzPIOXcz67rSyxdGjjPTDvloE4a1vTrmJCcrzzlTNjg6xg
	 TEmK6oxYHWr2vYapYaCWSsVuIWETChBxDm9uxA/fXyJji/FPLKh8pK1cMDPaf6yT//
	 h4MQvlw/78FrAQLfsDdrhmYeKhY/dOALUrLNVSoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Karthik Sanagavarapu <quic_kartsana@quicinc.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.14 07/73] arm64: dts: qcom: sa8775p: Remove cdsp compute-cb@10
Date: Mon,  2 Jun 2025 15:46:53 +0200
Message-ID: <20250602134241.969417206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthik Sanagavarapu <quic_kartsana@quicinc.com>

commit d180c2bd3b43d55f30c9b99de68bc6bb8420d1c1 upstream.

Remove the context bank compute-cb@10 because these SMMU ids are S2-only
which is not used for S1 transaction.

Fixes: f7b01bfb4b47 ("arm64: qcom: sa8775p: Add ADSP and CDSP0 fastrpc nodes")
Cc: stable@kernel.org
Signed-off-by: Karthik Sanagavarapu <quic_kartsana@quicinc.com>
Signed-off-by: Ling Xu <quic_lxu5@quicinc.com>
Link: https://lore.kernel.org/r/4c9de858fda7848b77ea8c528c9b9d53600ad21a.1739260973.git.quic_lxu5@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -4973,14 +4973,6 @@
 						dma-coherent;
 					};
 
-					compute-cb@10 {
-						compatible = "qcom,fastrpc-compute-cb";
-						reg = <10>;
-						iommus = <&apps_smmu 0x214a 0x04a0>,
-							 <&apps_smmu 0x218a 0x0400>;
-						dma-coherent;
-					};
-
 					compute-cb@11 {
 						compatible = "qcom,fastrpc-compute-cb";
 						reg = <11>;


