Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062775;
	b=Z2cJH1fjiFVwgo7qmZy1I2SbOeuM3HWp9TLEHqsHGIwYjnMN/yxcbyXmIj5XCVZwqHsg
	 J7D66fT5X8i5M+FgGTO2o5lF9QdIcW26nUpSxSok4t+ibYKWV3IaiBL2vrBl7ygFjlp2n
	 ZsuAInH9H14srhQPYyHg2zRFtDnmGqJvAykbFllXl8AVOx6PHY1YA1O4WTcEfwNL83cYG
	 0C+ZajEJR43MGnpd0H+BQ2puSab2tXrpD1RQHYPT6vm7lUKcdhtU4mzf4Zd/swbRrT2yw
	 hK5wDeB/N6UN2gb4u7AqcUmJA8Ynh2wuxJEp9ovGq1ppA0Qzxc+u1NH8iXRVhG9ayIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yG5l3K6QXpE38e6LTZol7D4kWciM0ywiMeh0xB3SWX8=;
	b=ITjP3nzEfmeyfqsIiYf5G1cr6ji8t2cYojnanwK5ciP6K8t/eIN5Q+QXOAuXmZigjcL8
	 CPsoa3IS7SWUiwmgTYlw6TGq5VvXH+MsOFbWw7t4lXm6QTTYYayibk1E85r/PnbVojktz
	 Ii7VEPXQXf8TOLN3L8TQIhX34uSwfC+/DLLruDxELc+s1Vu2sFtURExY4IFfa+yCpzaev
	 vFsGC5DTHFilWBTn0BY5qT454ple5LNWBUyBtjBYoiKXWRchaQ5KFGfzVIewQDWWNnsxQ
	 ryPs0n+e/ciL8o9dkVyQna6TpWjBhK5dbS3cyPI57bkMW5RNFSGP8tWTMGAMVb6Y5Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnWeOaD0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2A7606A32C;
	Sat,  7 Nov 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YnWeOaD0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD3F81F0089F;
	Sat,  7 Nov 2026 14:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062775;
	bh=yG5l3K6QXpE38e6LTZol7D4kWciM0ywiMeh0xB3SWX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnWeOaD08WGhVBBggwpAWMNgxm/uS4ETBwIdmdeg8TiNU7XwialIM08U0XLSuK8vC
	 hURDBXdKqhxkvdwrGMJb7IDZvEfmh23ixIMoyXcSwHzDvXmKTErsgSlW45w0eJS4ZV
	 cUCGtiOa5FS/8DSh2uW9UaGZ5FYHAZXOmWXF0QKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/869] soc: qcom: geni-se: Fix endian conversion for serial_protocol comparison
Date: Sat,  7 Nov 2026 08:45:27 -0500
Message-ID: <20261107134853.651389834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

[ Upstream commit 0231382f070df26a8b267f9e68c5440928b87c89 ]

serial_protocol is declared as __le16 in struct se_fw_hdr, but was
decoded with le32_to_cpu(). On big-endian systems the extra byte swap
causes the field to always compare unequal to the protocol argument,
so no firmware segment is ever selected.

Use le16_to_cpu() to match the field width.

Fixes: d4bf06592ad6 ("soc: qcom: geni-se: Add support to load QUP SE Firmware via Linux subsystem")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260821-fix-write-to-read-only-firmware-buffer-v3-1-43e6a3abd651@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom-geni-se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom-geni-se.c b/drivers/soc/qcom/qcom-geni-se.c
index 2fa6a45904e97..53e53736766fc 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -1059,7 +1059,7 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 		if (le32_to_cpu(sefw->magic) != SE_MAGIC_NUM || le32_to_cpu(sefw->version) != 1)
 			continue;
 
-		if (le32_to_cpu(sefw->serial_protocol) != protocol)
+		if (le16_to_cpu(sefw->serial_protocol) != protocol)
 			continue;
 
 		if (fw_size % 2 != 0) {
-- 
2.53.0



