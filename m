Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059730;
	b=h4J+ypQljIdU78NchoFgFAx+ar5EUIXiGTcEanD0wOPe5R/1K6U6HI8Gp7X2AaGnkcKq
	 fq5spDycWhTWHgEOQCOBNwM85nj1ePvVyHSgvWIRa3S4G9ovMz0sllg8G6RwmuTQoUCAl
	 aHZy+pVQyBdk8mmY/3JGE/bcydHmxQTSoeqnZFufb4qq2J8DDPWQfdIJFmdBHu6gpN/C7
	 qUQplNf1Tc7+P1e6nD8TrE1QxmfaQe5XcdsPCu6C4pHZkazVz53gnCaXimKVWiE/wP5mq
	 1hS0dgjGc6quYVd+Z4KlMYHBSoJXtGJDRdM6DqRFDABVVeGxFldus4w6YaUHGafg/kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mzbCy40321c9F852HlydS7Dtvk8YAtYb/ibWx2wOa80=;
	b=dP8sQu53ORJUUjAWt+rHa9cAxnHxaLptYqH3PYMSsEBWY+IWpti2klSQDxAqBLzTGE5X
	 T6V64u3KqnaCcB8Q8jAgOSiQRgGFMsfmUfh/kP+vkNR/3ZR8Kp520DXQXhA3SX5usm5KR
	 FVpEEHEstsoHOvB1ZCfGns+sYZB/9IK0cdhyOzSWCwVTe/8rZG7ZIk3KC/RNKYHguzkLB
	 wNZYDtc2wr1+7baaFhdeU75DKSADs7BkTTU/Dg8ECFWoZtzVNLLgswlO1ybouK9eRdnzN
	 7rT3mm+3SuTI6h7itdiRh7Xw/o6VYci8hPuiri7i/8gPrIn1oWGbL7oPL5K0DBFLsDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXzFfkwV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A439606A325;
	Thu, 19 Nov 2026 03:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KXzFfkwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F971F000C4;
	Thu, 19 Nov 2026 03:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059730;
	bh=mzbCy40321c9F852HlydS7Dtvk8YAtYb/ibWx2wOa80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KXzFfkwVXlsjjT70ByneOcUrrDoUWwMEHENZEkTK980fF+mbFfcVWrixL3vNuQao0
	 ZLcKFI/XrZskB9N0VtEX1JOnBbtjQDfzuKIUW46BLulrCvxV5SbAXvCE3qT6PuuuUm
	 Dt5SopkghmLp4y4TU+H0z5IS4XA1xfGVPMKRc+SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0947/1848] ceph: fix 32-bit overflow in readdir reply count check
Date: Wed, 18 Nov 2026 15:49:45 +0100
Message-ID: <20261118145956.689279930@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 52913831ba56efceaafd80b501d68fa00f79bde6 ]

parse_reply_info_readdir() checks how many entries are in a readdir
reply by computing the end pointer of the decoded array. That pointer
addition can wrap on 32-bit kernels and let an oversized count pass the
check. For example, a count of 0x40000000 with 156-byte entries wraps
to a zero offset, so the decoder can write past the preallocated buffer.

Check the count against the number of entries that fit in the allocation
before publishing dir_nr. Reject oversized replies through the existing
error path.

Cc: stable@vger.kernel.org
Fixes: 54008399dc0c ("ceph: preallocate buffer for readdir reply")
Assisted-by: LLM
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ sashal: adjusted context for existing pr_err() logging and an already absent WARN_ON(1) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 8154c08d54977..637f7aa82c0a2 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -355,10 +355,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 		goto done;
 
 	BUG_ON(!info->dir_entries);
-	if ((unsigned long)(info->dir_entries + num) >
-	    (unsigned long)info->dir_entries + info->dir_buf_size) {
+	if (num > info->dir_buf_size / sizeof(*info->dir_entries)) {
 		pr_err("dir contents are larger than expected\n");
-		WARN_ON(1);
 		goto bad;
 	}
 
-- 
2.53.0



