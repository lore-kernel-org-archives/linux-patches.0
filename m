Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061693;
	b=lt2ndvyoBJHf8nmBcGzYIigtaHf/C05BQHt9xjdtCn/yIo04bxJfFCL+ls2BPj3f7Xq7
	 eFkMfi3RynT+mvLREu2Qe4K9KlA56S4Ora5NYfX4JhXpjyxM0PO5jpcmxVUfD8s+bw3Bl
	 OCbQVu0VQaf6D6r7LMFMTrugg8PKQXkLHMhXsSRGWVq5r2OFNkWp3sijKWYnm72u09ZYS
	 1ykobcrm8jUPtgkfEf4X+UJBZp4IL0zzkz4WQLTRiz9GtJP7zblJ1irjqoqcfs3AhWA8t
	 GSRg0bHTOvwjgxdYU5HVYmVtVeu/N8FoZrfGPl3iswKrFFNq1qursISsikmXblQGsVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R350US8ajNw0fwnVv8QdJyU+dpfcQGlIwoGYv8fL6M4=;
	b=DiPf9BLOGoy0EjlqSxgYVM0VHpHOnl5DJGN3DXMer3qeMhFe8BWQMATONGrcwMXJq8yV
	 GOSNaOe568GtlhQJOyYoTECQfTZ+RoRm76fGw1/VfEaSHrBlg5AOh+9ppfEXqa2HMoVYn
	 W1rOJfBQSOCL3FgZEkwukfRD5NAiiT5RNsCVUpA3OUshHGf53hC566/UQf+sx5H/dwXGZ
	 yH4+M6gajGeJIlJCCetoY2Q9fpmeOtrRqfM0aL1/8rogBocBA5eb96Ep5mN7O9GnDQwyE
	 i7Dq6Y3TIfoAx+TtV5hGxgcIqB+zNtvP5EDAEksC6ux4E5U+qatO++5qoWCtiVtOBpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqfOpEOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D716606A326;
	Thu, 19 Nov 2026 04:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PqfOpEOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEEE1F000C4;
	Thu, 19 Nov 2026 04:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061693;
	bh=R350US8ajNw0fwnVv8QdJyU+dpfcQGlIwoGYv8fL6M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqfOpEOpZHXVaisPC7jDpPo7WfGzAYVHICR4qfo9KQWSW0eb14XEBiNF3Y7uR8PiA
	 7Pdvg5qY12E0wxjghMQvky2kyNoOT8XFNf86QZKXKTN4gIuauaRyzuuO++E3pTRLIW
	 zCnorVBRItQltHIjlhvopZAjos73A8soYgq3wtDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1603/1848] clk: qcom: mmcc-msm8996: Fix FD AHB clock register offset
Date: Wed, 18 Nov 2026 16:00:41 +0100
Message-ID: <20261118150026.679292493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 7cb2d65286b817d8d7e26f454a9c374d65e87072 ]

The FD AHB clock branch register is at offset 0x3b74, not 0x3ba74.
The incorrect offset exceeds the regmap maximum of 0xb008, so regmap
rejects accesses to it and the clock cannot be enabled.

Correct both the enable and halt register offsets so the driver can
enable the branch and check its status.

Assisted-by: LLM
Fixes: c252659770db ("clk: qcom: Add MSM8996 Multimedia Clock Controller (MMCC) driver")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916-clk-qcom-mmcc-msm8996-fix-fd-ahb-offset-v1-1-a575e1b9112c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8996.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/mmcc-msm8996.c b/drivers/clk/qcom/mmcc-msm8996.c
index 3b3aac07fb2d5..d982914b15f4a 100644
--- a/drivers/clk/qcom/mmcc-msm8996.c
+++ b/drivers/clk/qcom/mmcc-msm8996.c
@@ -2876,9 +2876,9 @@ static struct clk_branch fd_core_uar_clk = {
 };
 
 static struct clk_branch fd_ahb_clk = {
-	.halt_reg = 0x3ba74,
+	.halt_reg = 0x3b74,
 	.clkr = {
-		.enable_reg = 0x3ba74,
+		.enable_reg = 0x3b74,
 		.enable_mask = BIT(0),
 		.hw.init = &(struct clk_init_data){
 			.name = "fd_ahb_clk",
-- 
2.53.0



