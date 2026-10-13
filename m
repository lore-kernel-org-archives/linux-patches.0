Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E174EF149;
	Tue, 13 Oct 2026 11:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892453; cv=none; b=PHHYnP+ZFJ4Fihgcmsuis5fcRasMj2Nglb4ZoewwMzLmlh05mIPmvp75NrvHKM6BKMWE1eKvq7HJTkq6Z0zBvkb7/lR+7Ht11v/EwNZ4svPlwHmYn2Ynb/WQ+8VoOVLG7M5sSmq+4w7fhgXYp+cvWE7+yJ0yxPOgOOiWXMR1VM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892453; c=relaxed/simple;
	bh=SldUdBMa5NBiyxs+L7r16UAC2Mt4S3L0/O6nIZ7BALw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4EsxlJaxoDp4JP3TvNSj2GKWge0yR8yjEKy6yZWVS6l2iNDhX5DsBQsFxgsgsCBv+O2DHWftxaPJ/Vr0i6dMZLVXOKN8HrnMI27vYILu19oBHcRURGx+QPGK6v80x7Kp277K5nh2LtASk5O5sE2AsDY7Q2F2hbbURVhxSxwJts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y064Q5od; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y064Q5od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B61D1F000FF;
	Tue, 13 Oct 2026 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892452;
	bh=IRki8R9+LtT0VoEVL28QmGjo6Yu4xZUkNi2w3OB8tsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y064Q5oddJp5fn2w09lFuz7jdNO8kA1ZKpDypdnuoYMj4oZzFDGNJ7D6qcc0b2uB0
	 I769wrPU2FtvZti3Y4yVbcYWfSG5nXWu1wb0zM1GFmu9L4Wtr9t7bK4DcFcmX85boy
	 UifH9XhXL+jQ/xSQyTZeFsxB0ZYI8PwHj96dKjqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 179/281] clk: qcom: gpucc-kaanapali: Mark the GPU CX GDSC as votable
Date: Tue, 13 Oct 2026 13:38:15 +0200
Message-ID: <20261013112859.509699978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 55981579b27b6541aeeab81c768f248dba0491ac ]

The GPU CX GDSC on Kaanapali is a votable power domain and hence
should not be polled for power-off status during GDSC disable. Also,
its power-on status should be read from the GDS hardware control
register.

Accommodate this by removing POLL_CFG_GDSCR and adding the VOTABLE
flag for the GPU CX GDSC, similar to other platforms (e.g. SM8750 and
Milos).

Fixes: 685ec348339b ("clk: qcom: Add support for GPUCC and GXCLK for Kaanapali")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260801-kaanapali-gpu-voteable-v1-2-fe804d24d2e9@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-kaanapali.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gpucc-kaanapali.c b/drivers/clk/qcom/gpucc-kaanapali.c
index ae5563e516f67..f75f2caa2205c 100644
--- a/drivers/clk/qcom/gpucc-kaanapali.c
+++ b/drivers/clk/qcom/gpucc-kaanapali.c
@@ -380,7 +380,7 @@ static struct gdsc gpu_cc_cx_gdsc = {
 		.name = "gpu_cc_cx_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
+	.flags = RETAIN_FF_ENABLE | VOTABLE,
 };
 
 static struct clk_regmap *gpu_cc_kaanapali_clocks[] = {
-- 
2.53.0



