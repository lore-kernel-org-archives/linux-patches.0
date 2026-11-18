Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036949;
	b=IBM9DC0KqjbfC0tytqXhtZWjR1ks9pA0euQCJ51TI/5v37EUkhSWT5ke1f+VSfnyxemD
	 SyLle1Boy6dUXAE0bTahNV/bXfQxJIlHBWoiYWqPZ12fUpOttiB5L8amWANYpWid08qBA
	 AzdZwil57TXHtPnU+w5wNN94fN9O4iPQD2P0Iulqt7NKiGXoCxoQnOUbXwMB9f32Kmh1V
	 q1ibdmrJUoHd+86GQthiLIuESoGrsn6qS4zzxD/d2wfa/YpQs/n4W5lKjbSy5eJhmzt3E
	 10E3G2+3ceVPK4l+9E+4GM+LaaGZpusuRyXyEG49QEit8eMpTjgGj5ehp9aMrnuvnLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=65uRxJvWQepV0cSEC+K6s3Y1+b8eLrX8pOYmxgQkygU=;
	b=gONtUMYkN8M79EybX7NFKG4RJTypzBzh7AnF4Jbw9U9kiI+5ljmFnSP+E1lDFy1mtw/M
	 yBFhnP1eOonx7Thlwlk+sJNZkhPSfYylKGD7+84lDNHhrilxdc/MKgd8pupHv18Hfs//t
	 LDkA1nfBM0WqjFlrmll6fhP4YqEJOAmUOUVueWBD1VptfiQxGJZxQrbc4UPwwVmxjS4OM
	 hCJCRHICx57aMhxKGp8lkpgcFts1lv8YVGeA7F0RD5ZRfCo2qQYPhrUsUtyYqmZJiVOJy
	 +hBtNbIAGXy8nt2+f5IV/1f4Ve5Rbgqhd4Q0u3RACO+ZRaW59lirA2BO2k6yjfi67Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBkTNQT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B5C606A31C;
	Wed, 18 Nov 2026 21:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sBkTNQT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F26C1F000C4;
	Wed, 18 Nov 2026 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036949;
	bh=65uRxJvWQepV0cSEC+K6s3Y1+b8eLrX8pOYmxgQkygU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sBkTNQT50eWMEXI6pEUFfuEhEKBLPnjRFhdGo8/8I830W8P/YcID/z4Ug59bkPWKa
	 2T1DsrmaJ6X+Toa6j3A3vicwkkrlC9MJiFrHqOa/Ijtp0qkjc91i3BP4jy9gFG1cq/
	 PEFeLoyX6nHpBfQC7f9/B2V/Dhun0z9wp6y4EH44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1238/3318] ceph: fix 32-bit overflow in readdir reply count check
Date: Wed, 18 Nov 2026 15:31:00 +0100
Message-ID: <20261118150357.331977186@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 07dd43f4d472c..b3b7ce548ecb4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -435,10 +435,8 @@ static int parse_reply_info_readdir(void **p, void *end,
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



