Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCFD1D5ABA;
	Wed, 25 Feb 2026 01:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982984; cv=none; b=OOna2wRLTtAJPmxLrYWx9RX6VGgZ1uQY6VjuMmHxa566WhUZU+EZT+tjK2VzMERBviqzSC2UK6XtNB7T1wJjKzPWUbXqEcpEqHwqwngpYgp8F82mZgGy+j8hJ625oxEuJmXYhqyhk9lhx3F4Z/8eqkzmGxMOBRsaxaxDTT2iqDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982984; c=relaxed/simple;
	bh=XhjNptZwd9oWtkee2WxYrbjQG/YnqtCne8zJJlaldbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFHmjt2C6sTBO9QIdfp+unN9CtUJOI7iWmZm3db3RhqC2bLpOBee3IFVJIE4ybJcHknLQGtBv4lf4YYUX1ytOyFrsIJd8U6xrG4UhjRNbr0IiT4DLh8Ym9QCvnQwjt5hh+kiSEDpUevLFxX5Arec9T9yOJUdIJXD/7FiTE2R/tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijc3Ncam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijc3Ncam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0F0C116D0;
	Wed, 25 Feb 2026 01:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982984;
	bh=XhjNptZwd9oWtkee2WxYrbjQG/YnqtCne8zJJlaldbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijc3NcamWpm9Fgcpxj/5z/RqrbKHf+az8ueFzfEuhXKN7Z41oNSIqNw/IGoRL0DS8
	 Mt2VzsmBXpsnHeU5J/34CZe713L6v9J+QpMwSECvHxaIhCtLpCvBR1BnEFLqULUSgD
	 sXRYObKqma5uWRo0zLX8PtnobYGH5MogZGPlJhoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingzhou Zhu <newwheatzjz@zohomail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 154/781] arm64: dts: qcom: sdm850-huawei-matebook-e-2019: Correct ipa_fw_mem for the driver to load successfully
Date: Tue, 24 Feb 2026 17:14:23 -0800
Message-ID: <20260225012403.435844863@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingzhou Zhu <newwheatzjz@zohomail.com>

[ Upstream commit bc11f6f1d2470fa59846be077555f9d4b7c2c0d3 ]

The ipa driver refuses to load with the old ipa_fw_mem in newer kernels.
Shrinking its size to 0x5a000 fixes the problem.

Fixes: aab69794b55d ("arm64: dts: qcom: Add support for Huawei MateBook E 2019")

Signed-off-by: Jingzhou Zhu <newwheatzjz@zohomail.com>
Link: https://lore.kernel.org/r/20251208031511.3284-3-newwheatzjz@zohomail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts b/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts
index a5f025ae7dbe6..f048653818702 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-huawei-matebook-e-2019.dts
@@ -144,12 +144,12 @@ wlan_msa_mem: wlan-msa@8c400000 {
 		};
 
 		ipa_fw_mem: ipa-fw@8df00000 {
-			reg = <0 0x8df00000 0 0x100000>;
+			reg = <0 0x8df00000 0 0x5a000>;
 			no-map;
 		};
 
-		gpu_mem: gpu@97900000 {
-			reg = <0 0x97900000 0 0x5000>;
+		gpu_mem: gpu@8df5a000 {
+			reg = <0 0x8df5a000 0 0x5000>;
 			no-map;
 		};
 
-- 
2.51.0



