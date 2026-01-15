Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5033BFE3A;
	Thu, 15 Jan 2026 17:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497195; cv=none; b=DROsxwY5U0lY94kwhuheMxnBeiZYFeZbcj2t6nKjkdroA8A68trCwdVGjhVYmzIBue2QCNf9I2Jwms2IWDtu05U1cSu4Sq/HBv5K2lXmRFMibVJQFTqvHM2pR0f3WpVHKJPZW471a0SqfsCpJNuznQ5RYWpzZmQDSJI2zCpjcvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497195; c=relaxed/simple;
	bh=c+k+Xu9caJ0L1TTzKglZ6W4wTUykHL7kpeYawDZeqAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu+BwrH5bSl7w58Yux+uMgsWUGgZGVMlTm0U3k3duEYp78Fyy8rzNH4NiebYIOyLHXeE3ob2nE45sjGZ8w1Hi6cRJmTtAIeWF/4O5+bHJjJIKrqGUo58D9F2URoODC2UJW4NTygNmb/tMRRUxqvwLSZvvSMvsACNCuO1xbQZDWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNZwcP/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNZwcP/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5EC6C116D0;
	Thu, 15 Jan 2026 17:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497195;
	bh=c+k+Xu9caJ0L1TTzKglZ6W4wTUykHL7kpeYawDZeqAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNZwcP/HVsLzIJsqndqIuuDo3pYSWXLv+yr7vWSE5f1F8bmbsq2TD5CrBuPy16dYJ
	 2G/SpRUU8i6R+7Bf7oj5SbeUNPUgUvTqRfurkCyq7PWXFqeIrCvz0Hea8U6tmL6Gq8
	 0/luFBCeXgS46ZNjf5lIBmo6n/AZkd3s9FUO87Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 70/72] ASoC: fsl_sai: Add missing registers to cache default
Date: Thu, 15 Jan 2026 17:49:20 +0100
Message-ID: <20260115164146.042394873@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 90ed688792a6b7012b3e8a2f858bc3fe7454d0eb ]

Drivers does cache sync during runtime resume, setting all writable
registers. Not all writable registers are set in cache default, resulting
in the erorr message:
  fsl-sai 30c30000.sai: using zero-initialized flat cache, this may cause
  unexpected behavior

Fix this by adding missing writable register defaults.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20251216102246.676181-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index f5266be2bbc22..9a5be1d72a907 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -979,6 +979,7 @@ static struct reg_default fsl_sai_reg_defaults_ofs0[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(0), 0},
 	{FSL_SAI_RCR2(0), 0},
 	{FSL_SAI_RCR3(0), 0},
@@ -1002,12 +1003,14 @@ static struct reg_default fsl_sai_reg_defaults_ofs8[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(8), 0},
 	{FSL_SAI_RCR2(8), 0},
 	{FSL_SAI_RCR3(8), 0},
 	{FSL_SAI_RCR4(8), 0},
 	{FSL_SAI_RCR5(8), 0},
 	{FSL_SAI_RMR, 0},
+	{FSL_SAI_RTCTL, 0},
 	{FSL_SAI_MCTL, 0},
 	{FSL_SAI_MDIV, 0},
 };
-- 
2.51.0



