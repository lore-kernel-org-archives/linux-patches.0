Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061010;
	b=CBWj9abhhHLrbqA2SGB67fEbng0nhxF76CFhEb7wamShvru2Im5VebUO8YhjNweh9zXc
	 L6GxQQLGoXmRVkxyN2JobGqGV7epElPaN/WZXQUmLDTvRBXTMzUtAZdxw80EQogbNtThd
	 rLaNbcmUCKY3VkmbuE49UHiwd+lOB6zRZDbTG7Q321pF+OTJdhCEYVjUdtGRiVLTY+qq9
	 msGLMTB53qjMTfj2A/ENQA5bIPtCGbBsNtoFho7KHLGMLlkX4gtC9hSL0I2tBP7gEkCbh
	 8FVNvWfSt51lYb5r3MMBDHI2KiEUCI0m+3MyFo0YMKCJtMH84jLjpTwMM2lr+U+Zn5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rjEBcH0RnCBxDudztVP4w9J1j7R0hNp1A+wLJQSFoCQ=;
	b=hHDV30X+QIRb+ZsbNB4pYmpEudPU0dnncd5wUl++nvWWRuoHHFcN0CL6YxZT3783URqN
	 Q6XrhIBWd0hsAMRdtvmnAtG8UFs9ZUZX2f9fk3JYvqa0dfQo4qNc0MCfo7qNSlMmWmwJs
	 AOh2JipJid0qzHreshtuUzkGjZubpftej3CeoeVHrKYZKsM2tnXhs5s0smSvMVXtJ15o7
	 GHCK0ZI2RJmWRgbqb5E2QIZ83XPuYTMhTL5xmcIDXb7YkMyOJoibRBusZ4r73ibtEIJ16
	 4WfbIcEhgxFx7Eu30dpXj/ApX1PlVg+tqD8SVn/qUuR+oDP2MFXo80WG5oL97fYRhAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="evVT/+tP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDBD606D80E;
	Sat,  7 Nov 2026 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=evVT/+tP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3866E1F008A1;
	Sat,  7 Nov 2026 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061010;
	bh=rjEBcH0RnCBxDudztVP4w9J1j7R0hNp1A+wLJQSFoCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evVT/+tPDHysKU7JIjzPq4XdR1OCHFA7vbV/zujjZWSztev4oRD4x3xeKZ/TRtcTJ
	 hZPQiwJ+wOvWcS+4jrvGmGqfU0QEQZNWjJH5B42F5IA7bnm7AgnJcDaXVsWpy3i0ss
	 sEjtmiEwKq5hbwPuQWVfHCr5wy31Hn7+zyXQnZXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0353/1536] ksmbd: reject blocking compound lock requests
Date: Sat,  7 Nov 2026 08:39:29 -0500
Message-ID: <20261107135007.581500357@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 16a7f7c2ecf3c893b65f0fb78fa7a7171ae0ba9e ]

Clients set SMB2_LOCKFLAG_FAIL_IMMEDIATELY when a LOCK request contains
multiple lock elements, and servers reject requests that omit it.
Accepting such a request can leave earlier elements locked while a later
element waits asynchronously, enabling prolonged partial lock ownership
and avoidable deadlocks.

Return STATUS_INVALID_PARAMETER before processing any element when a
multi-element lock request contains a blocking lock. Unlock arrays remain
unaffected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e5d5a08022198..4bbff7f413003 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7706,6 +7706,13 @@ int smb2_lock(struct ksmbd_work *work)
 	}
 
 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
+		if (lock_count > 1 &&
+		    !(le32_to_cpu(lock_ele[0].Flags) & SMB2_LOCKFLAG_UNLOCK) &&
+		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (smb_lock->cmd < 0) {
 			err = -EINVAL;
 			goto out;
-- 
2.53.0



