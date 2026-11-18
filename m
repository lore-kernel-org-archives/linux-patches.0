Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016005;
	b=M2IH3/f4K5DHpIgHnzL/U81RFZPbVZrxvnGOGLhN3WDRFcz6mvYXAfSCjebnfS39Y6PH
	 7nr81RCG+/UQkhRb2ueqB/bL4UFm5UcCA02VUQHlIJ4ucsVE/uMQmbShHJVuLwUGWJEj8
	 f4Zh9DDZZHPMBC1qvbMfb9jn2qualN7u2wLjxRwRfJ+B3U6am/ysDyRc5foObErOPJM2D
	 XUAB6QtlDg0wzR56mRZCcSSA83we5f5kfnolC2Q4cxNWpoH5r1yP/aiu9BBeTaxHKIUZD
	 iAIWO/HfHWHq2mGae3XQc63q126OirlzOchp4L4eG+q0JNM2sGDoBItQIStuwS3AU6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=McbFvpeJKUb0Zyq82RnH82h7OarMbpGD5GheIkI6Lx8=;
	b=knp036Dfi+Q337RgsJ6AS/JhP1ZlX2CZT3LZoaKYhk/q8Tj1ljbOXSNwPWqXAjjOT/4n
	 XZuTkiQzuDgqD/HzhhJ8SQMHB0NjQhU08ydtIxi4QMCPmttd9WLuJOM7Pm544ZD34rro1
	 xsDrWy02bCayGagntjSoQLhr1RbgOzZmnZSIh0X8jRmdjLYMiw3DVAuPwWmtz0C74T6wq
	 6YnGghDqVRobBL43idrWbnZiBrWIOb39EFQ9IkTOX50dfnQT4dlObuI6vK9yUP8e9xakG
	 5W4RfRduZvBWUSatJV46SYy9ahY48+am0/nlfUyp+5+Bzl+tZVKXryqOVWsq+dM+1fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdSYxieQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B911606A31C;
	Wed, 18 Nov 2026 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdSYxieQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28201F000C4;
	Wed, 18 Nov 2026 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016005;
	bh=McbFvpeJKUb0Zyq82RnH82h7OarMbpGD5GheIkI6Lx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdSYxieQE7QUMBWTJOD148PjJLpxsCZGS+aM5N79me82f/f3mNqq6Y94PiwSQPOvh
	 52jvrILD8KoeowTilvodSCOCWb1AaILbS1QYP5nRqw0wKJr/sPeggoG+dYuBnwoUEP
	 qvK+Jx45baUfZvf5F/Hfv9t63+8+E7pVptdEy/bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0374/2651] arm64: dts: qcom: glymur-asus-zenbook-a16: Fix up the mic sample rate
Date: Wed, 18 Nov 2026 15:26:54 +0100
Message-ID: <20261118150301.299042343@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 73f0a1026210c008ba4414b3181fa679096ef968 ]

Set the correct value for the hardware, matching the readout from
Windows during audio recording.

The microphone seems to work fine either way.

Fixes: e8fbbca94db7 ("arm64: dts: qcom: glymur: Add Asus Zenbook A16 (UX3607OA)")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260910-topic-zenbook_mic_sampling-v1-1-2532136d5a9b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts b/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts
index 939e1a927a793..40433dc2d6cf9 100644
--- a/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts
+++ b/arch/arm64/boot/dts/qcom/glymur-asus-zenbook-a16-ux3607oa.dts
@@ -737,7 +737,7 @@ &lpass_vamacro {
 	pinctrl-0 = <&dmic01_default>;
 	pinctrl-names = "default";
 
-	qcom,dmic-sample-rate = <4800000>;
+	qcom,dmic-sample-rate = <2400000>;
 };
 
 &mdss {
-- 
2.53.0



