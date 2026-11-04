Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829660;
	b=C9ZDC853I8EfwXZm8ycfPuwYgml7edv5nY0gnHpvbCizy1POGwKu9NtIParv2ACUzmmj
	 YLFAP9qSd3FKrc7MiwnAyefjmoKgRh1IMQwuUDFUB3wlhcL/aK/7wUGCplAmauklW3yIf
	 VT1MalMoPeLZHIQ7JXyZmu3PR1y8vYnL4cN3V31AVf8CB0nlp1SxfjiU0dWQSABbLQYe2
	 P99Z6qEpH+KqswTXDJvQxmNqW915cE43IjywqY9L5czAhmxGE7lhEWJRECqOD8WqSVK0o
	 4/3s7NV4dc2ujoXPO2kYTsuAut5XM9k8BM9Cqy5fjuQat7c/dCn9S1iwL7P5FE/ETfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p3tT2U5pbGH1q75DreUvqYOiZ3UM+3qqOWRSXRxZqV0=;
	b=lKzR0WetgVB+51f3K7gA788k9V9ysePimox7c+mv3qnvL6eiMpzklrG/l/6ConFZI3d3
	 dQDnorK0D8ktfd9/X4XLYFPHJfVPc4e2+2X6I6BVcrfFQoj8NafS7ccbIVPs1WuvGMF8F
	 S1ZmDBbJw5sBHQ4zy8BwcYilGt5X6q5hfk3nhwd1BKdzE1i91TPjY3Qc6P7VQmW/qLZAY
	 +C1gdmkJtjeV+6BFP+Wp2KVHyHZ9FIJ2BAF4Hihd4D/KActU1kdRjFjhOXFFPazalg5sW
	 qDqWuYVgJyB2J0/nkehtUwsd6JOEk85XqJSt8w3+VaCPIlYL3rSTgvlAso3FcrjtlEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AlTQsGky;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAFB606BA0F;
	Wed,  4 Nov 2026 22:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AlTQsGky
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5671F00A16;
	Wed,  4 Nov 2026 22:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829660;
	bh=p3tT2U5pbGH1q75DreUvqYOiZ3UM+3qqOWRSXRxZqV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AlTQsGkyKd89Qlq2FkWAOPzZMLXtF4vSfk2LbjdrZa2LR2YXsuj/oOQNQlXkUj6Oc
	 lEllfEki1o8gINgl60eZEw8jz94uHcpFscZ0ys5l18TztkZRTV0GR29wxhnjtvLG/I
	 UQ8z6burKHcrTcbvPcOOjGTnTq9a4uG/UttDk9Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Esteban Urrutia <esteuwu@proton.me>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0224/1005] iommu/arm-smmu-qcom: Add SM8450 MDSS compatible
Date: Wed,  4 Nov 2026 15:59:17 -0500
Message-ID: <20261104211050.093196702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Esteban Urrutia <esteuwu@proton.me>

[ Upstream commit d149c8b2c0146a01f1be326ddb1e182b55aee638 ]

Add the compatible for the MDSS client on the Snapdragon 8 Gen 1 so it can
be properly configured by the IOMMU driver.

Otherwise, there is an unhandled context fault, because the framebuffer is
already configured in UEFI.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Esteban Urrutia <esteuwu@proton.me>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index f7cb7de80cfb9..b6493e92343be 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -394,6 +394,7 @@ static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,sm6375-mdss" },
 	{ .compatible = "qcom,sm8150-mdss" },
 	{ .compatible = "qcom,sm8250-mdss" },
+	{ .compatible = "qcom,sm8450-mdss" },
 	{ .compatible = "qcom,x1e80100-mdss" },
 	{ }
 };
-- 
2.53.0



