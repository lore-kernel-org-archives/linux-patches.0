Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031661;
	b=BwMilqRJ6I7lDwGFy8Lsq28+hRsRK5p3KXv81hXl71hoHr42/apkuBNRisTEpR/1YnBO
	 qQmvP16wOgD49CDvKMqCwWOVA+IhJIW4wXbPLC3EBiuBx0UEFrGr2fOXxTe1ckuM0fQ+O
	 q5gmItZfUUXXKKTi4tPrumPSo0Qr7anWh3q9NmJHUFvLrYeRZ5bvmaKnpbkVcesV6cHnd
	 cncW1b8QKdidgAqYEDEpOmPbmRqRpjuSDwjtDKiw9qWh2DX1Qze0LTFXPD1xBxBWiLeVQ
	 jfqR/h0YGBD/dhDRE5oGzXdMiUsZvxPz9UvwNF3tcCW9AGON377tXbwiBIvinz/uxMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fUcbMoOvBvIQQiv7Ao8bF4vMUN2k/g94omi7cT5FWQ4=;
	b=HHtuoVWHK5UyH85y6BSlFzInB81VtMTKXUA38xfbIcJEiSA4nWk0D4H9zztp0o4Wkcc8
	 ZYsm40J8kfTOueDdC2KPpKZ683R3E/96kMmwOVUUZLsJnarmebOKWueQfvBrRiN4bVjgy
	 262rALZ6pkffh9n05b8BmycPeY4h/nC3rP9EowQ0kbsk1Hf47uB1+5MIS6V0kNEFalcJF
	 gcATQFNKqNCmE1oj4k50bm25hBWyAyAxtr4T0lXKsVzCtAYJ2EvpH6pG/JHvfduY2Jygq
	 f7NHUpw8VQ9tgMN993uGpkDWBX9rK4srhV190Qj6wt28H457zggT1byNSzNGIJRGirw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMvUSeZG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2BE606A31C;
	Wed, 18 Nov 2026 19:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eMvUSeZG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B551F000C4;
	Wed, 18 Nov 2026 19:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031660;
	bh=fUcbMoOvBvIQQiv7Ao8bF4vMUN2k/g94omi7cT5FWQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMvUSeZGPWvFZQDcGRvC/JMcVC+aGXkw1+IukKMEeNpsiBi2q21qM838muB+nWnjN
	 fafzgRWpBSS+cKUVniUKC4decsaFLrxfi4LST8Wqvhef0AgMOBSisTU1UMoZG9Cu+s
	 14+pIyr4jC5qgpfRbktgXpoXkiGrA6e8BthkN6v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1135/1756] clk: qcom: gcc-x1e80100: Dont poll the status bit of GCC_USB4_n_SYS_CLK
Date: Wed, 18 Nov 2026 15:54:22 +0100
Message-ID: <20261118150055.249351813@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit d42e0c55e6db7b8282e8dc63f7e70595da0f72f5 ]

These clocks are PHY-sourced and their halt bits seem not to update
reliably. Ignore it to prevent spurious warnings.

Fixes: 161b7c401f4b ("clk: qcom: Add Global Clock controller (GCC) driver for X1E80100")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-topic-hamoa_clk_usb4-v1-1-5d8d5225b598@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-x1e80100.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-x1e80100.c b/drivers/clk/qcom/gcc-x1e80100.c
index e96faa529d3c4..288e413aa29fb 100644
--- a/drivers/clk/qcom/gcc-x1e80100.c
+++ b/drivers/clk/qcom/gcc-x1e80100.c
@@ -5988,7 +5988,7 @@ static struct clk_branch gcc_usb4_0_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_0_sys_clk = {
 	.halt_reg = 0x9f054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x9f054,
 		.enable_mask = BIT(0),
@@ -6205,7 +6205,7 @@ static struct clk_branch gcc_usb4_1_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_1_sys_clk = {
 	.halt_reg = 0x2b054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x2b054,
 		.enable_mask = BIT(0),
@@ -6422,7 +6422,7 @@ static struct clk_branch gcc_usb4_2_sb_if_clk = {
 
 static struct clk_branch gcc_usb4_2_sys_clk = {
 	.halt_reg = 0x11054,
-	.halt_check = BRANCH_HALT,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x11054,
 		.enable_mask = BIT(0),
-- 
2.53.0



