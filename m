Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059303;
	b=cP98I8Sg4LLZ6DYrVBFqbcsbuq+lYsFDGiMMXLjqsicKFWeMwWl5Jya8aoV4YSfg749n
	 IPmU/tU2LbOROq5RXFmy8vGMg4YriKFYlio9Qv9nZZy9ysClxyngeW33MEZXR73YskDp2
	 JUW0Qk3mK/s3c+CBZuXNbPN8pepIHcr5PwVkhuCMp6u6I6qythCXST8HE8IX+IqRy7hjj
	 r+6UbiBS2g6vHE+yd0lVYIDGCmijVOgi+BBKyHvaMwpHqULFjqgCQ+HccvhlesErxBdon
	 Z6xrZ38hJTFt5+YZxtyRA2hIuyJixFVV0Qe1y9h/JKNlAGjNysOcKRrcahWX+77UeIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdZcvgqvSPjEOqYGeSSkw16LJOcwuWGKfxRphWoFpxc=;
	b=5dDKYrRdAVxpxyQvSxCOanFPhu8ot2chDKNjaMNkPObBfOFAnB6dd69et8xhH/UfkUNy
	 XBe5RpP0A4N4vBcnh1kYLKTqgtQapax0kRIMZWc3Rzqias7oZEPiXQfPDUym9q9vqs6sr
	 tvo4CuJWPKi3iJx+yl7wqua//LznxcuFh7rksaExtJ5Y5zcOqRtpFO9EK76gjF/lS0P4s
	 5QkAMbYQoIXNoAORWDS5bWP3NB8N/L8/XC1++7qn7VnqZE8cc+eVLguQV9+xqJ+Xc/FQA
	 WVImC3lENgCuBz3TaeLGbX8UvK4anBiJDPH+zht1dsHSPGlDCcxY7rQy/m8yZS3Lp0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUePPwyh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07B9606A325;
	Thu, 19 Nov 2026 03:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUePPwyh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB431F000C4;
	Thu, 19 Nov 2026 03:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059303;
	bh=bdZcvgqvSPjEOqYGeSSkw16LJOcwuWGKfxRphWoFpxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUePPwyhjK4nrT48LALAIIcYwj4K2fWlqeK0XypPwGAaZcOGluq1oyQ6quUgnaQgU
	 uoMw0DRerQUJ7/39h0exjRzF1jtRMB1gR54Js4T+5Mvoc4E5WxSBcO3Uac6FG1bcbk
	 kW3/OxwvwBmKqkISROuvl3xO1ZUCgbUH7SS8rXhw=
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
Subject: [PATCH 5.10 0791/1848] udf: Make sure theres enough space for LVID implementation use field
Date: Wed, 18 Nov 2026 15:47:09 +0100
Message-ID: <20261118145949.537002390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 58bc19b82afa4..6994cf6a09d66 100644
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



