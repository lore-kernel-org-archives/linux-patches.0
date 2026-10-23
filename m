Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774470;
	b=jtLh4a6pnmrSyPLyMNChmmueBGbj53WNbShR2tVnQlzNNpbGrafxmukxmKHOxA2ncuCt
	 XDeoOv6gwyU9ZxxoiNjOJP61E1T2SywW46bNedkOHONs4/8bNz1XLvkrIJ9NvmcU1AfbF
	 bXnMs8peekkjQCVwGfHw1mi6o9BZBxrsgLm2jYQpx/3sG3K56oFAf59aFwjT+1MYCnwPH
	 8DBSa/jHFo3WT1JSYkzSkT5a9gDM8L+/ZDnY953ACcRBVEPHebnb6261Biv7RCRzNWZNE
	 l4cwJLMutJcvYrKDn+Qc2AJLvJ5hRrY8XBhOzLuLANmjlYgH+TxKD9ZlA5I3RCD9/Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Z/R7fH3jSHOQrnO+5JCpuqEqxx+MM6HsbSd69L9og8=;
	b=saQ2qyPc4OXXdoU0n8OAogkHAL516oKwxPCBwOWm9MO4a3VzYkuLPJF4Kfk13Ty6DnXf
	 8Cb8pK63woir/HNI5tuahh8Liqqi7C/335QZhlOkFpJ10H+wUgL6AmUFZ1JcGXV0MGM4a
	 8oSxz0H/D2igd+i3YJcJL7IzWWJerg7l25osGhZ43amW6ZG8nYXB+TsBtDrCtmuiV5hvq
	 uUU4J1CyKxHLd61XrGClgw6AE+3Zxon/l4zgrw4k1LjkBam1jwGRPOn7FieH56UPY954+
	 GEtEI1CJSeip/WrhzkdWffnZ3iUX/BLoH2Hqi76H9y60bJWNh/FcmEvCbCWpH2AZ04A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBBpPf8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67233606A31E;
	Fri, 23 Oct 2026 16:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBBpPf8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1C91F031E3;
	Fri, 23 Oct 2026 16:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774470;
	bh=8Z/R7fH3jSHOQrnO+5JCpuqEqxx+MM6HsbSd69L9og8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBBpPf8qoU4nA7CqX9wa34+97UpSOeaj7PEX1OnJa4Q1wx9kSQw+wCbCA1B4j23WO
	 K7BEORTkVw9HvVmHyTnWVwlKcyfhsJP96+hSfiZTmr2Jy8VasKtv6ljnNwXeoYzfyL
	 8ubB9En+Q+pg32V4nyuPHJzvCP7aYTx+3RE7FKho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 013/242] pinctrl: qcom: qcs8300: Fix intr_target_width
Date: Fri, 23 Oct 2026 18:37:35 +0200
Message-ID: <20261023163714.106738668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit dcb5df182b37587d5ad6bb4388751bf5180957ac ]

The default width of the interrupt target field doesn't match the actual
register layout. Fix it.

Fixes: 0c4cd2cc87c8 ("pinctrl: qcom: add the tlmm driver for QCS8300 platforms")
Assisted-by: LLM
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20260917-topic-tlmm_intr_width_fixes-v1-3-3bc1d056aa6b@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcs8300.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcs8300.c b/drivers/pinctrl/qcom/pinctrl-qcs8300.c
index 9a904d809e11d..fec86818c5118 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcs8300.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcs8300.c
@@ -45,6 +45,7 @@
 		.intr_enable_bit = 0,		\
 		.intr_status_bit = 0,		\
 		.intr_target_bit = 5,		\
+		.intr_target_width = 4,		\
 		.intr_target_kpss_val = 3,	\
 		.intr_raw_status_bit = 4,	\
 		.intr_polarity_bit = 1,		\
-- 
2.53.0



