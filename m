Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211186;
	b=2nYo+hlg9rqBBUdGlBjRs9Wxy+9DrlbeuXrDTVYT4KrAHOYKuBIadiBQFqE8nyCKVEsX
	 5p8aG38PBrQV/HpIPoPWGyeTdxX8ttT78KwTel+ooPgsguNVssxXs6B/4R/zmfG3JvE/2
	 fdUoDPMHyJy2lq9YQ06mjF/7Im2rEsMHYlwS86poePzSvrcoxt0h9IwzJ60IBe9VC7uZs
	 E3tKygWfdf0L7DJUsKcB64kxny9q5qLuKOSisTOzo5miekwk3ofs1JwUccB4cS/Xvmw/u
	 /gFnMv1ymYXTbDWtDp82+4yQj31FUFN5S0FTnJ81+6ewzVVaDe3N9lOMO6NAot+zN1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7GQAzSKYAWaUO4nfthQQmK6u0E3KnAEEXpjdkOa/1lo=;
	b=tuRt0C4LNvQVu2ozzlfWJCA3iWerRviJInM1H3LT3fCD6uh6HivA6lh8auj6QUffYav6
	 Y4FfS+6RM7ffsYXsG5fTVux12rr80hYXCeC3brJSI0x2eMSQMCt3VKOrk09JH0eOzDrU7
	 FxPsaO6UwxlfiVCFG0Cf3rttrbdjNrf+T5derLcaqyqzraRPRUZAF8zqbRNut/lKQKcAk
	 OIjRzEFQc2TwtBWdYJa8czMYnaWcGzO/gOAJFBq0uqEcsq3vW1Yw0PVY311ga4fEVF74C
	 VHMe9l+dcBC1dN40FCOeZcaZfc+T5Pbc7ff0/+0eJBJCW4yu5aGGVm9hzPAm94qPfqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bTgwX4KY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0247B60A5BFD;
	Wed, 28 Oct 2026 18:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bTgwX4KY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5778C1F031E4;
	Wed, 28 Oct 2026 18:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211185;
	bh=7GQAzSKYAWaUO4nfthQQmK6u0E3KnAEEXpjdkOa/1lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTgwX4KYVTAIjWxhHZQhduPTUhUr/AWYfL3dkeEnpfDVhCAnzRrnKl5A0SJOQTdyk
	 sJkVrEH0Jl/7PXw/mNzlamJkbsoP8EIse0PNQReFh6USw/QFK6prlEibbd1i1pX+5n
	 YvjASJARYC+ks3i/+MFZkT+ZbXLqJVZlajvDEh+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/571] soc: qcom: geni-se: Correct QUP Core ICC vote constants
Date: Wed, 28 Oct 2026 17:57:16 +0100
Message-ID: <20261028170014.857892556@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f5672785c0c4a..c54580c480768 100644
--- a/include/linux/qcom-geni-se.h
+++ b/include/linux/qcom-geni-se.h
@@ -265,17 +265,12 @@ struct geni_se {
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



