Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618022;
	b=wEWnP7MQXwj1lY2LL9ZXMR0I7TnmWHTtkv3dJ1NmrJd5y45nWb3ZYRPeaFoFbet3w7Bj
	 bgBSOzPRKgNn1gqYHsslxMcpFOioZM85t9Z3idmP5o1qEHuqCzIatBKIQlARAoYKrNYOF
	 vptfQgEXJliki+KYF3lWvednijPrahRXsOjJp9eS3K5ENcXp2aZQbYwrbQIuyiFDCy612
	 uNdu3sjHTU0G/UOnM9gONcYk/U9tYX0bbdaTN3NOMEysJ4IDWubySKGTExiyb/H0PBMCU
	 lnyq77i3vHC8bR5KG+ynDbsda02OtKISJuehJmTuOJwwjx+8zA2RfvRIYl6OA7Wkvaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tccT/uvn5r31QMw9NbXwQfdqsUSUXzCGOx7mqhCRuGY=;
	b=vTyxAkXMQjXqVsS9wOdHW1rq74belUuIp92Gx1sYJWqS2UTwC2EBLcKrFGbC9Y/ZhKHk
	 DqpfpfGgBaYM31q19jOEr0joJE/7DegcpT/kupBqjRr9kk+iDwF7hiDgGLOFY3E7SXhDd
	 dop1/0gPUE04m1dEBQNSGHb9jlbSQSU4QYnwr3x8PJIJ1/SSz9n+b9eGSwc/81GuhCfr6
	 sM0JetV92dKOZStUFwzqrP0yusnkFRdO31p5j6chKHj5HDpbmURGLfz8sApM9XZr3szfe
	 C06dQCTbCnhGGr0Q2/XCC8Mk/pYcLRUCdVu331Z4oNb0s7euvpPo7tfzmxPn+IiZKZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULbxitYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C354606A321;
	Wed, 25 Nov 2026 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ULbxitYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F60B1F000CA;
	Wed, 25 Nov 2026 14:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618021;
	bh=tccT/uvn5r31QMw9NbXwQfdqsUSUXzCGOx7mqhCRuGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ULbxitYWyOJN4uybN1WovDOtgPgAQzYiijrwIoy1eeClRnMlHFf5BGtXeGfwcQ86Y
	 cCBkPRwzTVvsB73/OYmVH3OjnQBaZ2SyuS6LsfD68AMZZT1As0DMDA4gRBCXzwGfD4
	 9dxSuoAYI4Ah4iXMBLL4kez9vsnhWXQqALzsTbbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@mit.edu>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0147/1005] ntfs: dont allow resident values to overlap the attribute header
Date: Wed, 25 Nov 2026 15:24:45 +0100
Message-ID: <20261125143825.180226819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 99afbf38a5c571157526b7b1c6d8dd7ad1a234d5 ]

The resident value bounds check allows value_offset to point inside the
attribute header. The reported image has an unnamed $DATA attribute with
a value_offset of zero and a value_length of two, which passes lookup.

Appending to this file makes ntfs_resident_attr_value_resize() shrink the
attribute record to eight bytes. Moving the following attributes then
overwrites the resident header fields, so the subsequent memset() uses a
corrupted value_offset and writes outside the MFT record buffer.

Require the resident value to start after the complete resident header.
Both lookup paths then return -EIO for the corrupt record, before callers
can resize or access its value.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Reported-by: Robert Morris <rtm@mit.edu>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index ee54ebdeb7c71..0bd4b20132df9 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -704,17 +704,20 @@ static bool ntfs_resident_attr_value_get(const struct attr_record *a,
 					 struct ntfs_resident_attr_value *value)
 {
 	u32 attr_len;
+	u32 min_len;
 	u16 value_offset;
 
 	attr_len = le32_to_cpu(a->length);
-	if (attr_len < offsetof(struct attr_record, data.resident.reserved) +
-			sizeof(a->data.resident.reserved))
+	min_len = offsetof(struct attr_record, data.resident.reserved) +
+		  sizeof(a->data.resident.reserved);
+	if (attr_len < min_len)
 		return false;
 
 	value->len = le32_to_cpu(a->data.resident.value_length);
 	value_offset = le16_to_cpu(a->data.resident.value_offset);
 
-	if (value->len > attr_len || value_offset > attr_len - value->len)
+	if (value_offset < min_len || value->len > attr_len ||
+	    value_offset > attr_len - value->len)
 		return false;
 
 	value->data = (const u8 *)a + value_offset;
-- 
2.53.0



