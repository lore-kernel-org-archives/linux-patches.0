Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98B02D781B;
	Thu, 15 Jan 2026 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496983; cv=none; b=Fg5yQm3xVunqojOSF42dM6qm7/UUQd6ibBvtOkwrwn8G4h7Z5YLEZowmdvpKTbopHuPt7bnO64t+pV+HejzWQeBP9GHagzI2yEyltX35/CF4bRiwCOn3tRCnxo/pV+rnRvtKCvtAdnlWk9h3QujlIgJTa0+UOGpXyNG6gbXynpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496983; c=relaxed/simple;
	bh=WP2vDiEbfUaSj302+P5KlpZsM+iCcbGUlKKEE65MwdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BooRPPBTZpzcTqQFqRvvKsHY4584JnR8hevOK9wcNXjH7C096lS41HOJbVFmHDJxIaiJppnhSrT3rAnXtAJB8Zlj6cW0m+8Zzlmi3D+1dfG5f55YtD12a2NiAP6tBRSUZjyzCEkdt+pAxolPh2CYbB+ySC3onpaXQy+yYodEbQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytkBH+94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytkBH+94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4662BC19422;
	Thu, 15 Jan 2026 17:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496983;
	bh=WP2vDiEbfUaSj302+P5KlpZsM+iCcbGUlKKEE65MwdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytkBH+94wlTM1ODuC0yAC8BuDgTlUXH2Rvw6asLpBNcox1+V3lLLYxe0+iD/KeMtR
	 Ptd0l4/NdjH+XVD8sVbr3jZju+JVl/zyTiQ0Y6lpwKup/aWjxZxAdQBTYaNs8b/h5d
	 mbjhf9agpiNJzW15l/XQEeS4Oen8NmkhVB9jZRBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 85/88] ASoC: fsl_sai: Add missing registers to cache default
Date: Thu, 15 Jan 2026 17:49:08 +0100
Message-ID: <20260115164149.392079562@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0de878d64a3bd..95a502ec3a057 100644
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



