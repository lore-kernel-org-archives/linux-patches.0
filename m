Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065468;
	b=kIZgf47oQTnepvuY9LCF1FZK3EarmBHAKwCnD0EFXFfCnhwp8VV3J4mqyGMc4wfhfL3q
	 3ew18LxywlDosMS/WotC37GhFSZNwzr2LcPb0cQLufLUgoEBo5UBpoBmVnDfZv8WQh5tb
	 4rFZ5GJHrEh0Y+2JsfwHRsWXpo18Ln/6Ibbf6vB4SGwBjhzRP/e0oTuJPDIxxfToJwptB
	 1aHebjaf6A2uXzWQ+wZQNA13x+JBbFsl+fdHxvbUaw/zDxdwqpd1XcE2ihBmbp5xbf4pV
	 PTTKRnrV+aXKHaJniS3DS01id3zV8cU8BTCbEwI1IuuiUPUvxJcRr+/Copc26Aspy8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=h9+NAQOO1PL/IgkLcEAZMPdJDPEnd/BVMxCOTnRPbyY=;
	b=Vx3U5vQ3Wka0ADAk1c95LzF/bhdLE4XtdNjTaxVfCsAcRwzSJyNBjXErXf3OWaQDnU+i
	 mLnEYT8LkqcE2wgTkN2nyqTEz1/EHDqDzxT/V+3jjRyd7Mn6kVT9G9y8bBNfxCa5iWFop
	 GwWB8gi1HbCKojeCcfhi0uIhtG40Hk+h+qn8Px3U/Kq6rukktf9GQAqxnKml+L62FKz5o
	 ijhS0v7831WvHD+PZc54RvX8Ak6JKu967k+f1i/R6ShAN5rxf7YCEhcw4Y53N71qp5JqW
	 38ICbrwOHpWS/ZQNBYQ8N3ttYwu3yyDRnoiwm2q3/3CsvA8fg/WQViqDlmhuSrX5leQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0NVYGVn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39856606A339;
	Sat,  7 Nov 2026 15:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U0NVYGVn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96711F008A1;
	Sat,  7 Nov 2026 15:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065468;
	bh=h9+NAQOO1PL/IgkLcEAZMPdJDPEnd/BVMxCOTnRPbyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0NVYGVnYk1r31QEK+xJcD5biW5zGpeleGICCIh5C9ngoQcgxYqSoCG/V7WdNQeLk
	 2+VTR3MSuMdl41o+CsCAEOBoXYFT/GhnR17IO/q+9SFqmlfnLcr4UnTLYrGD6LgehV
	 c7C5Xyr5IZtx97opUYcfUCqkqJLg9ZTyqt5CFyuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1127/1257] ceph: fix 32-bit overflow in readdir reply count check
Date: Sat,  7 Nov 2026 08:57:03 -0500
Message-ID: <20261107135010.360964525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 1c5c9abd7e5ae..d370c43cf02f5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -481,10 +481,8 @@ static int parse_reply_info_readdir(void **p, void *end,
 		goto done;
 
 	BUG_ON(!info->dir_entries);
-	if ((unsigned long)(info->dir_entries + num) >
-	    (unsigned long)info->dir_entries + info->dir_buf_size) {
+	if (num > info->dir_buf_size / sizeof(*info->dir_entries)) {
 		pr_err_client(cl, "dir contents are larger than expected\n");
-		WARN_ON(1);
 		goto bad;
 	}
 
-- 
2.53.0



