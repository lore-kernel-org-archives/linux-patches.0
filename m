Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063887;
	b=oSPHxIXEdYaWdu4RyWeRENo+OiD9zekjn014wv/0CgMZzkEdoCbaa0F8jveyVDMBbiTY
	 sx0AnaY2fOtBlkBdn5Buj5swUaA3h0Iim54c0Unk84aHXUgkDuAUYjoMHP3ynfP5B0Q0V
	 PSae7JaJekZCByJAvlyKFltIYa12NHIba3LtG2KpVa9ySHb+9WfxZ682w9naMhmTQ+i34
	 9i5FquVlXiQq/abrZdxSdMNKuSjxMwqasxEdLiupG05aequEaKDGIEiNMGjDjtOgge/1h
	 5QNb4ulRkkXc7CJZgfz7q9JmLslfgWeuwwXAbtqreRnVYgjtoWKSXrhVokPaP75eXSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WAmQ8UKfnfr1vj8JTJ7Sc+CkOi2y3Guzr+ft5sH6vIc=;
	b=RZjylUZPsLi+mvh8VEMRNs6leO5wKwfq4816FfGXIF70b+7VHk4EWUnotA9Ik1a064Lm
	 Ls0m3MeVkvwWEFQH53JfOF3Wd0bk1uuvW4Fk4LN2bfJa9TYdHO7x6AfYAoGyuSvOriE3L
	 JZRT2fV6a1c+tbU9y7nh2FZsoLmX+6BsChqlOwbq3Mq3DXv3/3h6+inPZa6WPyp/1yjG6
	 0m12onIYZDkYpHunbfTri1LXkFFdHPHGjGuv1rxOOkaR95Y9ACwBSfNoBmgpeDDQCgMHm
	 LB73h1ILoiszL9c3AmYlyboR8pOC+djOaApmFsv+N/zXFg8kM7ZX1lOVGRJpMHTsnaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=La3FRfWg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C33606B8B8;
	Sat,  7 Nov 2026 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=La3FRfWg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3571F008A1;
	Sat,  7 Nov 2026 15:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063887;
	bh=WAmQ8UKfnfr1vj8JTJ7Sc+CkOi2y3Guzr+ft5sH6vIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=La3FRfWg79Ws7MhD8mowqJD7f6OAVACmd7fuwUleRGVp8OkdiDyIAD18splpUo48g
	 3c0lz/C3HviOZBYXbTMLgIowfQ5w2uKrnDJa1LQ6HgFVEro+RJK9w1GKXZm0xyyvLk
	 KruInArFs3Er8c6/tHHQ29CfogKlBxFprrKyiFb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0042/1257] soc: qcom: geni-se: Fix endian conversion for serial_protocol comparison
Date: Sat,  7 Nov 2026 08:38:58 -0500
Message-ID: <20261107134940.569557188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 873bfbd6b2b7b..1d6e6611441d6 100644
--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -1298,7 +1298,7 @@ static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct
 		if (le32_to_cpu(sefw->magic) != SE_MAGIC_NUM || le32_to_cpu(sefw->version) != 1)
 			continue;
 
-		if (le32_to_cpu(sefw->serial_protocol) != protocol)
+		if (le16_to_cpu(sefw->serial_protocol) != protocol)
 			continue;
 
 		if (fw_size % 2 != 0) {
-- 
2.53.0



