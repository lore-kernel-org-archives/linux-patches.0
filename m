Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062730;
	b=rQVhj4SWLj1GqNPlRV1YeURrC4kNIdjlf2KzV94snKO0Ss17NYVKurid7m5fmNatCG11
	 fYcP7qD8VZPMhcDiHmpj4zo2xh/onSjgsud87rm7OYg9X3Oy3tzfTvCdW+PKsSotnaK18
	 fSTNNYrwyQ5S6jscMw7rPalMuBhJ474xfyEywny9HkbUUcl++kz6eczPGEyyo37brfJuY
	 Rbn2o7zhDd+Cu3R37kklD16waUFfrfQKV+FbJFojYgbXJtI56iSbtxMFakpZzZsEui+pE
	 DVrwVBQ5e3NvAh3V1eKTVt8Xz8S6Di4pOTfuYLO2HC7n/iu/unZzXnlpuompzRGzFrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JX3OuKnAZ363tcW8WFwVEJ5Ih7NkVRowfCe+VZXYPG8=;
	b=wuaUgXm8ol7Hs2UDcjrG/ZzVBbjYizkokA3wOUfBc3y2gyO3cg21p6O/92DVPmt4AzDp
	 SziHs6JOtu2Qac6yyht2n+AK25REHCixex9TZCp6L9Sa1qqLWPc1al6xNVcbNlgbvdrII
	 djuthARaJXmFkTf0sfg4Yh7fxSQlLS0Bj6+SVt9c8Q2zPTEeROnVvwe2YTyc+tU8fZzGU
	 xN8oy0uwyflGJStScN8QvSeX+Lm34TBqgeXFr83fhpDGfEjk0bO4b+zqWc08qtyH7DCD7
	 q0HfacwTgbMAxsJuwY5tm7vBxL/+uzBNE/KfBJ+Df1C1oV7lMKL0jIlkJx9t1/3sgRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1Ukjn03;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF23606A32C;
	Sat,  7 Nov 2026 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q1Ukjn03
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3EA1F0089F;
	Sat,  7 Nov 2026 14:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062730;
	bh=JX3OuKnAZ363tcW8WFwVEJ5Ih7NkVRowfCe+VZXYPG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q1Ukjn03eIOUIsamok/8Yj6dMj60pgst37CrTs1/h630NiQ+61vESsRUf/ZWMJYoA
	 AJ8Flhiz6W3tlIPXbt8RPvcTcpaoBzLlMEks9wYqvpNYOxe2aNSgJg830EBr8X9BsZ
	 D89BXF+nXEwyXoChlemOm7GwvES30+DTTAAsnk7Q=
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
Subject: [PATCH 6.18 041/869] udf: Make sure theres enough space for LVID implementation use field
Date: Sat,  7 Nov 2026 08:45:23 -0500
Message-ID: <20261107134853.542632131@linuxfoundation.org>
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
index f91b231b7d7bd..556540f2797ae 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1611,7 +1611,10 @@ static bool udf_lvid_valid(struct super_block *sb,
 
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



