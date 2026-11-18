Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037981;
	b=jR5ziMVCel1kyd0a8mzIck35LVSTYIRzDwmcgGm6XtRsQUTYnbnJiY7C+IEIzHH5cpGo
	 sZmIYAsX0A5leiTvX9JpaVEJMB+UpaSp9UwszmXaHU+57jVyWDgiMYM4KOOn9sVXHUokY
	 8nVrgUuMEFrkCWVSJfnnlC+cpVHuNV0nWdYozHVZXDxPSVwr/+VjIiy7bqwAoR/bN7G5+
	 KVCHpoGFqRKBreLRAf1F3sM22nu4sUEIQQlawXm9Zzmk+TyTx+gt5eBe8Vz0H/S2VURbq
	 ny2H7OcC28xEJn3lw42VPAF7lyxqY7oslAXt3WBG5UcwtV2P/r9shnNm8VdNSBE7ltQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=00PyktTTquPHRhlUH46nVWqnQ1CQ4m+Pgob0gbVPAJc=;
	b=MhfnVIYE/ZBpwNqK19RQhEKk0mobhV6dCovVzGIE9UdxJ+OzRtd7hI9aCueHGoeNXPx1
	 lpvLIp3LQGlOHynbEpjmMNcqYLLdGi3xZL+Ba7e0g7SRr1Q4RY4dc6FCx7n5P1/EBJR+k
	 NHUNzv1F+8FlXYGJl6rXMD0DiW30CKYtOwLucRgyOtMqKShnDXXHh0ekxs2z9nbcv3FVx
	 eQ9f9WRzk7ihyZuJapY6S0YISdtMgFXfjXZk40NsRkHkucx5jMH7EnxWF6YvJnZGMW43o
	 OcB/b0srZ9Rspe6eHUA4ij/sAW/s5tbJ9tOgkW+yKM2EUDj3ltdMcNGZFQCCC2SOkCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yOG4/g1h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69356606A320;
	Wed, 18 Nov 2026 21:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOG4/g1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DD21F000C4;
	Wed, 18 Nov 2026 21:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037981;
	bh=00PyktTTquPHRhlUH46nVWqnQ1CQ4m+Pgob0gbVPAJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOG4/g1hHrKfcO1JDfOLgTea/7k7fSSDFxlYNh7UZwQNL/UCYcEwKA95LTfWMnjP4
	 PAk8jOFFN6jWnceUIOu/AYi9RZWtVOQ3gxcAdytysXHmCUGqyq8FxDi4Lk6/Sm2TvI
	 eWdRIAU9Gwy5cNQjwBhbiO2ny9kbT2gYVhb4V0s4=
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
Subject: [PATCH 6.6 1585/3318] udf: Make sure theres enough space for LVID implementation use field
Date: Wed, 18 Nov 2026 15:36:47 +0100
Message-ID: <20261118150408.680427962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 67c9111624d84..7f71ce6b9b491 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1657,7 +1657,10 @@ static bool udf_lvid_valid(struct super_block *sb,
 
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



