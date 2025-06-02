Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF4E2C327B;
	Mon,  2 Jun 2025 14:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872886; cv=none; b=NNHDdfdfhyU7DSy+Un/+yFDc6DethjSluDPPWYOxKR7NKiKkzQl5LFwSRT//E757ibjmMOz6ZJGta9i/80hzp+kgASLdKSnY+gJPp2ifmJpBbvwKsywvQD9x61cnlLI3SKEPnJ2x/Q5jpgW3loawkVlf4b7WsMxSsoaaN2PdoQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872886; c=relaxed/simple;
	bh=vY9qoWKbpqhiIZFOBO48+Mu4ej9pbeaRgQeYiZ6vmGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJC8cy3dDUVDJHnWM66XzDsPO0rJ0yutg7Hv78t6i43wSa2gdRTzqm3NdUP2bs7gw4gqUOnKovhcosOGREpDqJUbgNVh4Mcfz0OFdzCbLZFrsloHXIobLRZQsvXAVuElV71bSt1aX2QmX4fwKAb3c+IqB7I3dDREDka8nY6n9KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCHmI1af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCHmI1af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D345C4CEEB;
	Mon,  2 Jun 2025 14:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872885;
	bh=vY9qoWKbpqhiIZFOBO48+Mu4ej9pbeaRgQeYiZ6vmGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCHmI1afxnHbAguQiF+U1KBWrgj6S3F3lLRTn3RBclxyp6LHdCWtXercJh2xE//2A
	 2ZJOq9YEis94ohF5kuWIQ0BuyBexOYPlnLryW7zsjSHW0XJJds5msol35XUJ3sYcVm
	 f7kIs0WqQUxzT9rBwq4T5y7Nn+/3ozDaF0ruk+Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Karthik Sanagavarapu <quic_kartsana@quicinc.com>,
	Ling Xu <quic_lxu5@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 04/55] arm64: dts: qcom: sa8775p: Remove cdsp compute-cb@10
Date: Mon,  2 Jun 2025 15:47:21 +0200
Message-ID: <20250602134238.442345504@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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
@@ -4080,14 +4080,6 @@
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


