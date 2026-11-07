Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061893;
	b=gcBRqCCbD5O9+hBSGCzKb8+ZlpMm6x0Wl+jal87fX1SZm38pMgd2vRN41OH/pZpH4NOt
	 Tuz4f51uj1O5/4ZivNJpWbM43XpF9YYo+r/tlTlUvG9W/zzbr4PmWC5XD9HXjIE23lC8E
	 RZyf2Y+RNLr0lYRj6d4uUVyRB6xC/0AgLq/upRhD0orWSgdGOJsZa91LmymIE0N/0jWJb
	 pNDcQzhGqJCv1vLf0mbhbI7GT19EI4Rjsvpa8b9oSl1tWg4Yq+WR6v8qdOkqr9ioF4e6+
	 KuZ1NTkXMzBeKlb2+/5j3ndrb7EAH3imI6bIUSY0Qjn1JOLx5iWD2kBObp+1TYFhBHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vYTz4MVvQn1Wxt4C/X37zNSclKSJ3Ar58YJcYllMFLE=;
	b=W1cfX1ZB0g+G9oj5Xx8pkW1WhaJ6drrLbfU2iiygEIXkknvTEZquoBbOBr/2x2Qx3M1t
	 hEuOn+AZxgCesCLoxriKh5AFRNwIZW78b2EIh0xRnvHMOgjKkjW8IdgJbzC0xL7lZAyiw
	 IT76Rmp0S1rlZ5MJWGXaeLqn9IA5cGqlxckdH24+UZLnnpfrc4/C3nqRTGofOmwQfd3wl
	 fG27bFeGVQn9thjPgCnaiAH8EXmtd3l+0+/f1zIn145D4M1pH0JMdLLl0EhCAl1gHZ6P7
	 O6vTM0TnjBa2uWKR616vXO9j2g91gie4A4r0l3AGCDXetxdxzuPFuexFb5sLqXXq30A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H6zJiXs/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40244606A338;
	Sat,  7 Nov 2026 14:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6zJiXs/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83061F008A1;
	Sat,  7 Nov 2026 14:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061893;
	bh=vYTz4MVvQn1Wxt4C/X37zNSclKSJ3Ar58YJcYllMFLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6zJiXs/Li8kio1F67Kfb4JecyaIPjii/wnNEvfY/7ZdRmLICTHZb2O1DM3Dn0fra
	 n+4lQFwe9LiwDHcq0owNTvglBDvQx0K9QBu1P+NUebYOjRAmIjDo6b1YR8Y0iVlCxk
	 mTZVxruiWEYpqXB+n3jq/pHOZv7Yvyw3mbIIm8AM=
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
Subject: [PATCH 6.12 0903/1536] udf: Make sure theres enough space for LVID implementation use field
Date: Sat,  7 Nov 2026 08:48:39 -0500
Message-ID: <20261107135022.996663124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



