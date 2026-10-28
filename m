Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208866;
	b=YphXhFkVIlSGrpJD5w4jkA47bcheaN25Yp6T65vwKWnn5ctUZuRODGjLi6Hp2X3RnDF+
	 c3XOlybYYNhD+nsM6jYPMsQ9WN6JBxpsvnlL10d4WdQDOul9l87WKGvZp44yX+nQKsXTN
	 kP3/gZo3ZNMR3vuPLp+F4haUSS0goMBVTbxqmmiSfx9TSFwdrdFe0SzGjelLGptR3MN1Z
	 +bUmve9twJ3KMYow6yOZFdepTH5gaZaS5g7CnIJf2YS4JZDsP8G/rzdvjfawa8x91Ugqp
	 SNM4OfRQ0qJ7pG5q4Z7lRzyePmQn6FqI3FDf3ZhMIfAGJUIePdQ898yxq5bG9Y0swMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208866;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xONkWxlGolvkSxmeZS5DQo2WIfFhozLCZUQLmSXK0E8=;
	b=guMw7YuXdXzujSJXbrHocCACSL0JeHOo+zCCsB42nJdjFkdOo9mn9Yy9MYWrU4vm4SIh
	 3cLlGTlRVIEEATFH/cu79qlJZkUPhD346/IrvBIsuUUBtHoK/dGR4DE7LRnglB9QqDXWL
	 nTxCLkYf+6is5TnM6ukxan+0uj4hx8t71uoqXTlwLTFsupDhQjzFSa52dp2lpqIyp9CuG
	 kynmV0DeEXAQSPxO2cHx1nSzwpeGxoKogcjNgSQeMkSG5nyeLiKcYoa/bQDhaqpFzjHOF
	 15lpu5UKdRo8eTD/afzZVIOYtVSJCIGeCLD1lBuTp87yzkA5anKVov9nl2GVigOHLRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAKjl5FU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACDE606A31A;
	Wed, 28 Oct 2026 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pAKjl5FU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9AD1F01825;
	Wed, 28 Oct 2026 17:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208866;
	bh=xONkWxlGolvkSxmeZS5DQo2WIfFhozLCZUQLmSXK0E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAKjl5FUIDHJQG7FWuMfY13ofGvgCdEYanKNM452Sld930WNle8zzdK/K9I+GlTVV
	 eYGxD9CEw4kxb6vWPtRDU9B1mUSo9VuWX6Zu9kpCESQHshr30klI4pBaUAXfHcZVtt
	 JoKm8dJGGE5yTP0uaEe3LfEJWaHJMom1gGHhq6fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/516] soc: qcom: geni-se: Correct QUP Core ICC vote constants
Date: Wed, 28 Oct 2026 17:57:01 +0100
Message-ID: <20261028170009.865275467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit 1cd9b1be5a9c56fd69e3f555b200a1844f9b873e ]

The GENI_TO_CORE ("qup-core") ICC vote selects the QUP Core 2X clock
rate. The CORE_2X_*_MHZ constants are expressed in Bps, but their
values are several orders of magnitude too small. For example, the
50 MHz threshold is represented by 2500 rather than 25000000 Bps.

As a result, clients using these constants can severely under-vote the
QUP Core clock.

Correct the constants to their intended Bps thresholds so that the ICC
provider selects the corresponding QUP Core 2X clock rate. Drop the unused
definitions.

Fixes: 58ffbba6a399 ("soc: qcom: geni: Support for ICC voting")
Cc: stable@kernel.org
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-correct-icc-bandwidth-vote-constants-v2-1-f78eb611204e@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/qcom-geni-se.h | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/include/linux/qcom-geni-se.h b/include/linux/qcom-geni-se.h
index 964cfe68f72cc..9e98c4525a0ed 100644
--- a/include/linux/qcom-geni-se.h
+++ b/include/linux/qcom-geni-se.h
@@ -252,17 +252,12 @@ struct geni_se {
 #define QUP_SE_VERSION_2_5                  0x20050000
 
 /*
- * Define bandwidth thresholds that cause the underlying Core 2X interconnect
- * clock to run at the named frequency. These baseline values are recommended
- * by the hardware team, and are not dynamically scaled with GENI bandwidth
- * beyond basic on/off.
+ * QUP Core 2X clock votes used by GENI clients through the "qup-core" ICC
+ * path. Values are in Bps and must be converted with Bps_to_icc() before
+ * setting avg_bw.
  */
-#define CORE_2X_19_2_MHZ		960
-#define CORE_2X_50_MHZ			2500
-#define CORE_2X_100_MHZ			5000
-#define CORE_2X_150_MHZ			7500
-#define CORE_2X_200_MHZ			10000
-#define CORE_2X_236_MHZ			16383
+#define CORE_2X_19_2_MHZ		9600000
+#define CORE_2X_50_MHZ			25000000
 
 #define GENI_DEFAULT_BW			Bps_to_icc(1000)
 
-- 
2.53.0



