Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046700;
	b=L9+abfPgrYk6x6G1ei31bOzACvdNBUqrWBBp7O+nGYGXbEvpyFP5sVMqMnCm05DSuyXz
	 JX1Ev11qIkYgLNU+2wqjYWVRWan6kcA8nQ4qopHd7Ckb+RUjiK8g1yUjwx+gyScqkn9N/
	 /8gPCu65r/am0k/7pLXATFXG/CBK/1nCoxSH8ORySGlm9Uf3UF5oijWsmjhgAoVhsYvMo
	 tDXRFC6TekoSX8VN0oZ3NpD359+8N9dFMLLndbUehMSPjn7AK84hb875Te/Vobko1EvuG
	 Zsx62kHCyUYSSEBONAXfurEn3uk35Oqqgsy/8pVEDXKRQ/FoqNml2ozr7jpX35e8CpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKD1Yqb6yUtR9ZNGKIJ07O40h1sPMmYIRvnQTTD2GoQ=;
	b=kn0A+zepQYXvXQ4F32h1I9VM1BSj2mlBvuWoAdKSfw9Uq9DFgJIe/CADE0jktO5VsbQV
	 3qHNWQMiMn7O3K4SOeqd9F7tY0fGm5cw5yVp/jK4tRBgXe74gmFRxSCSSSehlihSnA9Xx
	 gF3kVjSIAuBbU02ZdkTcivLQVQmqDMseCjlxOizLYvlh5Q9+GuWNGUiOosEa0TCEKqftH
	 jQMVLF5UMDbdrcA1qiVx77YO6yK5UWOnshMxTITXo6dcIucbCFroS5kSWJdsDflCbeg2Z
	 RjMbJvwUWfHM/2FBXn60jCYE1iBHlOkKoBQ3JjiARiSVRMFVONWfhEq9tvYF/D7qD5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMACK2yi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4829A606A31C;
	Thu, 19 Nov 2026 00:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMACK2yi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A162D1F000C4;
	Thu, 19 Nov 2026 00:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046700;
	bh=kKD1Yqb6yUtR9ZNGKIJ07O40h1sPMmYIRvnQTTD2GoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMACK2yiSO/dd9VrZwy+2U1OlMbI0p7d2WrOm4yewNdOWbpiRdhSDpI0eYt5pW2vK
	 3oX1lGkAZ8k5rwUofMVx/F8yu/voEnWgxp0/FwbjBKYQZ8nfz0Jo2YthBRyjN6k3JE
	 QTjKqSt63kV3GS9MQI9odnKdeu13TiyVQc0axOZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunpeng Tian <shionthanatos@gmail.com>,
	Gongming Wang <gmwgg05@gmail.com>,
	Mingda Zhang <npczmd@qq.com>,
	Qinrun Dai <jupmouse@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1337/2857] udf: Make sure theres enough space for LVID implementation use field
Date: Wed, 18 Nov 2026 15:39:31 +0100
Message-ID: <20261118150249.568950053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit a61fb39759d719a4f4966742b4d28387e33d81c4 ]

udf_lvid_valid() verifies that the LVID has enough space for all the
tables and the reported length of ImplementationUse field. However it
doesn't make sure the reported length is large enough to contain
logicalVolIntegrityDescImpUse structure which OSTA specification
requires. This can thus lead to accesses beyond the end of LVID buffer
for suitably corrupted UDF filesystem. Add the length check.

Reported-by: Yunpeng Tian <shionthanatos@gmail.com>
Reported-by: Gongming Wang <gmwgg05@gmail.com>
Reported-by: Mingda Zhang <npczmd@qq.com>
Reported-by: Qinrun Dai <jupmouse@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 781d2a9a2fc7 ("udf: Check LVID earlier")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index b091cc98406b4..f924a814874b3 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1581,7 +1581,10 @@ static bool udf_lvid_valid(struct super_block *sb,
 
 	parts = le32_to_cpu(lvid->numOfPartitions);
 	impuselen = le32_to_cpu(lvid->lengthOfImpUse);
-	if (parts >= sb->s_blocksize || impuselen >= sb->s_blocksize ||
+	if (sizeof(struct logicalVolIntegrityDescImpUse) > impuselen ||
+	    impuselen >= sb->s_blocksize)
+		return false;
+	if (parts >= sb->s_blocksize ||
 	    sizeof(struct logicalVolIntegrityDesc) + impuselen +
 	    2 * parts * sizeof(u32) > sb->s_blocksize)
 		return false;
-- 
2.53.0



