Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215623;
	b=ZKPAdy4HXdZn3+tHKvjvEO9g919shyRq6Ajkv+7xm+JlIroZuSxDBxM2MlCgvxSmHtq0
	 NolkLw3nTYGWrtqF5CnVk2SNRxiQemxj6bnBwaaR1o1xjvJXCXpIGgOAKhXW8hlVbg8Lk
	 lh/Al89OKXHp/XcjSiQ+Izn+X3lK3EHkpRDVVqfd8DWeDsYBQVAg7eTBhMjkOCQOHc4sJ
	 zAulkqo+UOaLoVzj9JLP7umP11xgk1GlPb6YcE2+zPq8I56sWziBKYe7kYbfKI9zu+DIC
	 fnTbLyI5Y9XGoPBKuo4FIg78b9zdN6NPMI1yYphjqxlSGR8ug2FC6SktK6gTeY/QQBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ILfi2lnrs9ad/XSDf0wFWZczL7DDfCuYfds1xuPrYUY=;
	b=iT2AAGRWM0vShD8hi2VoktimCJim2h2XXXuIFu6tV73v15aqvntaaqhh4kf8TSS04CnS
	 zpkbpcQ8EPf/Cxei5Qn2IsGVxHU4KjpZzxsvdTgLO2qmFP/edCtRs/e7h8Qolv9P8dtlc
	 Zq07j0+G03uTdmyds+Bc88fRILHLEDMHvqdLj0ObyRs7y6T2h8MdUqPWLkNKsszb1wCl1
	 ob2wjCsDYERPInT637mOMG8MCumkvbBbIHfD3O5MQV2DihQ+OjJXTy45noP08dF1Qdm/j
	 gvhArFPI4wOLFjYNapcTG0sAxAiqd4Wq8FU0WWwy6FkkySLUg7g49+HotJzCj5kg54g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lfB/gCLq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BBE606A31F;
	Wed, 28 Oct 2026 19:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfB/gCLq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91A41F01828;
	Wed, 28 Oct 2026 19:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215623;
	bh=ILfi2lnrs9ad/XSDf0wFWZczL7DDfCuYfds1xuPrYUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfB/gCLqadw9biVbWT+hEKHVydA1A7c1wZPRZBgsUMI5K3iRE6lWG4T3mL9yHk6+G
	 NumFuA6Oxsxt5kcWTe35CsBmODvJ2QN3zPWohg1CBBfSqNHw5amqP96eRlV5q5EZLE
	 Nut/RVvWZ29ExjycM6W8wRDarUPxhB3C48SsWakk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1232/1887] ksmbd: reject undersized DACLs before parsing ACEs
Date: Wed, 28 Oct 2026 17:55:28 +0100
Message-ID: <20261028170527.459406959@linuxfoundation.org>
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

From: Haofeng Li <lihaofeng@kylinos.cn>

[ Upstream commit 60908f7ebcd9b6cde74ad5711fab0f49c7970949 ]

parse_dacl() limits the attacker-controlled ACE count by comparing it
with the number of minimal ACEs that fit in the DACL size. The DACL size
field is 16 bits, but the expression subtracts sizeof(struct smb_acl).
Because sizeof() is unsigned, a DACL size smaller than the ACL header
underflows to a large size_t.

A malicious client can reach this with:

SMB2_SET_INFO (InfoType=SMB2_O_INFO_SECURITY)
  -> smb2_set_info_sec()
  -> set_info_sec()
  -> parse_sec_desc()
  -> parse_dacl()
     -> init_acl_state(..., 0xffff)
     -> init_acl_state(..., 0xffff)
     -> kmalloc_objs(..., 0xffff)

Thus a malformed security descriptor can make num_aces pass the guard
and drive large temporary ACL state and pointer-array allocations.

Reject DACLs smaller than struct smb_acl before doing the subtraction,
so the ACE count check cannot be bypassed by the underflow.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 2209e7e655744..98ba287e3b2ed 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -387,6 +387,7 @@ static void parse_dacl(struct user_namespace *user_ns,
 {
 	int i, ret;
 	int num_aces = 0;
+	u16 dacl_size;
 	unsigned int acl_size;
 	char *acl_base;
 	struct smb_ace **ppace;
@@ -416,7 +417,11 @@ static void parse_dacl(struct user_namespace *user_ns,
 	if (num_aces <= 0)
 		return;
 
-	if (num_aces > (le16_to_cpu(pdacl->size) - sizeof(struct smb_acl)) /
+	dacl_size = le16_to_cpu(pdacl->size);
+	if (dacl_size < sizeof(struct smb_acl))
+		return;
+
+	if (num_aces > (dacl_size - sizeof(struct smb_acl)) /
 			(offsetof(struct smb_ace, sid) +
 			 offsetof(struct smb_sid, sub_auth) + sizeof(__le16)))
 		return;
-- 
2.53.0



