Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036960;
	b=hQ1sg2no8VZY4bRoG82zFuB9p1ZswMaFTTM2R8j4xY0MYj+sUDxtWLAJE+oykHKdaCrr
	 kjuj8Mo3rTEySQ9xITRobjeAd24dCJXLd0a5A6YqkdOvEbHrEQnca21rSHyX9McytaN5K
	 /nWYuXBCnzXQt8/KEm6NhCpe+58PUbZGkSqe9E/gukwe9Gxjx7aQu2Inid4iCr1k+Wtho
	 FWjXZhPCVUUJGMfCm9GMXfFLGotqKbujrP7GMwFjFC1u/xoRm06Modj+E5a5w2El23bD+
	 KrcjRpgwkEJX7/gqf1ZBBJxzXQm6F0SaxzB1IogFikTr53Uwl6aKDS+8IWqpP1LCVIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kHAS3XxMcDvXhYuDo0OFqSB0sd1wO9Jv3fX3nbPSrYI=;
	b=Sw0RuvQjLo9VrHjtOveeWS7YqQVTL0lV+6RkyjrWiJXeEVlCPf+v81vI3Hj0GarJW2Ut
	 //wmsj9JmQTmG2oclJOqYydToJu1/Rr6AzKuK8PdpXZk08fRVj72yTAD1rZ61V4JOhdaW
	 TE09qYrdBQ+TvSLQF66fKOMhOmhXeu4PxWvp/FgyJfjn56AosKcYn6jyzQAT5JvkK0hhJ
	 Ey5gBD2QfTtH0Q/tR3VvVtWkxpU9lD1Ny75HNFZYB5xwMC5lhnpj/+HUSRHNgC7Hos1JY
	 mr5Ju/YeoE3SLCM0R1CCXpgjh4xJLWyq/WTOrtxtSWJPa0yHCK+UGklZ0lID43Tq67w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NViaZzPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C94606A325;
	Wed, 18 Nov 2026 21:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NViaZzPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CD1F000C4;
	Wed, 18 Nov 2026 21:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036960;
	bh=kHAS3XxMcDvXhYuDo0OFqSB0sd1wO9Jv3fX3nbPSrYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NViaZzPEOEmuLEDfaY3ctHIGqs+VEusMXaINxOQpCzAW5Gsr+8X2UW/L1in3ZtREg
	 BEEq3gJdTgWazESBVyTP6Esa74oC/3gt6QvCzxwTKcmRhvFf0Mmwe2ng7h7wkFWstV
	 Hkd6krbOwbgsirk6bkLc/S/F0X2C2Jo61QixE9VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sung byeongchan <tjdqudcks0424@naver.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1242/3318] ceph: validate fscrypt auth blob length
Date: Wed, 18 Nov 2026 15:31:04 +0100
Message-ID: <20261118150357.448272732@linuxfoundation.org>
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

From: sung byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit bc418e234e5be14b97dec90e84a680e615b4134e ]

ceph_crypt_get_context() trusts cfa_blob_len after checking only that the
inode-owned fscrypt_auth allocation contains the fixed header and one byte.
An MDS can therefore place a larger inner length in a shorter outer object,
causing memcpy() to read beyond the allocation when a caller requests the
encryption nonce.

Require the complete blob to fit in the inode-owned allocation before using
the inner length.

On the tested baseline, the malformed reply produced the same KASAN
slab-out-of-bounds read twice. An ordinary UID obtained sixteen wire-absent
SLUB redzone bytes in two non-KASAN production-path runs. The input was
rejected twice after this change, while a complete context still worked.

Cc: stable@vger.kernel.org
Fixes: 2d332d5bc424 ("ceph: fscrypt_auth handling for ceph")
Assisted-by: LLM
Signed-off-by: sung byeongchan <tjdqudcks0424@naver.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 29ec2f705a504..62f33516e8bb6 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -83,6 +83,9 @@ static int ceph_crypt_get_context(struct inode *inode, void *ctx, size_t len)
 		return -ENOBUFS;
 
 	ctxlen = le32_to_cpu(cfa->cfa_blob_len);
+	if (ctxlen > ci->fscrypt_auth_len -
+		     offsetof(struct ceph_fscrypt_auth, cfa_blob))
+		return -ENOBUFS;
 	if (len < ctxlen)
 		return -ERANGE;
 
-- 
2.53.0



