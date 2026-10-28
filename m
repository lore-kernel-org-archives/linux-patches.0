Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213061;
	b=0qQPQmy+j6Xl4mQDUiKQiLF8vJEh+8xwvMYb0ABZQw5rIgsmP/Vk/zv9Ah0K5IgAV5Xp
	 LjzCZ1f2rCgjfkFX9Kf2f/LYq4vtI4mw4GSQnPfKSG7m4zK9FkZBr8Pjgt/SvzK8Q67Li
	 eml/yXQvcCGd1KP2CQr3Eq/LErm0rcTTXJW9dxr1Z2YXm3KEk1qTFEi6IClpTqrbbf7yI
	 SBCfFeHhf2gwVeDpwgxXKU0lr4TmjSaEOK5c5cskzfw+6ocCJiziIc+ykNWKr63Re8NJV
	 s8GJz2x9YAUcUAq8qLaoLzVMhvyaO9G5uiJdmOjoMdIbhgufKFM5JZcqV1lqiJPSXbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r/E/X7IIIpU+T6jHYQBt1NJjeXG4nDPI5feqfXMLmqM=;
	b=S/dBLheR2JkJXgXvLxZilgkKkIyGWdzrPWaUxYIUZflU8/Zs3HSXBv3OfOPW+kLVbaGM
	 GLMC3nQhKEsgd8el4M5Y0g5rN5XCI1thkm37cKmjSCGKGMYqx+4G+omcntv4IVcjBl4WK
	 xA6gvO83ruS78w6x5Fn7dTAebMqDJ2wuzwGhxSIvU769oik65fMbVa5CE6/dNvra/gF/r
	 LkrF8joEZ+KsKW39qUq4Spyc77ouMEUYAFV05uvEJ/NoniR2iQ5qdVjHRmQwrBt0jP+vT
	 ccpzMZpCIrAOIBOQAjUSK3VmQbo8hmSOzIuzscExbqlwpAnAorG13d87cqE8G196tRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoO+upoh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651C5606A31A;
	Wed, 28 Oct 2026 18:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KoO+upoh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B125F1F01825;
	Wed, 28 Oct 2026 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213061;
	bh=r/E/X7IIIpU+T6jHYQBt1NJjeXG4nDPI5feqfXMLmqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KoO+upoh5/YlR8vBxwN0/MwwetrS/THgGRS+2w12ttC9AbfOkfNo925SUvfetMVHQ
	 wIYgvxyz4E8viwEO6wMWt86X+VrV7Zrg7NWgZmLXukG20XIfSDOy5h8KvaJJJffGoH
	 NX0RMED1KTAWtw17d2PjEpGOfS33RcmRQ2piBq4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0372/1887] soc: qcom: geni-se: Correct QUP Core ICC vote constants
Date: Wed, 28 Oct 2026 17:41:08 +0100
Message-ID: <20261028170507.696877926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



