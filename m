Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018664;
	b=uqKIK8R4OYAxgIytsYuLzSj94tiERt7sExEilo/IM1sURQj4UCY09AfMBLlQe6W3nK/F
	 SFfyk3JM8EwyeVStTf1oZ51K/iv64hasLtdy68hclzaQAPJZYyF3aIdAFHUqtDSAD84tF
	 RqCDj1hYWHrgvZf+unOrjUjyQI3jrh9jwjqEA2UzYfejEIa8RXIce+IU3kU2uKKreBvLA
	 Uuvg2N8HT0+xF28E62t0NkiaxQTEgvinVxQQnl9oCm66EdvATPGD0FkPKmlpNGXhCQrKZ
	 ZaHvV0fJS3zCTVX5gIXh6XEsS35ZLhMjNvi2FtTK+kbkE3uIxnvquWfskw/DGIDO8lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bYwoY9hoNJ5q0eVpMo8dz8M0CjaUL0etxxJfX1X614c=;
	b=EyzsSrJna9qevgAjT4wDB+gyR9iQtX2MoLqjMIQFlczr/ATw1amtQ0QqITyNKLTe/ID9
	 JQcl6Kxn0kC5J6QOo7IA5ffCto2ABXxEKjIZbrJVDkrCGCsaO/sj0nJHuq9O1igwhV1yX
	 L2xJGPLx90jlomOA2SN20O6PQ/kBe+JrpJe04vIRRpyRYWJe4g6wTfD3DZGveH0ci0yMf
	 Hrz1qfk7urIEOhkgmS+OscOeI8OvCdCJA3RR9t+F1b7KHW9DGKOHbiJBzGokkoWK0Z9mW
	 IDs+Ln8A/Ik0TWbxfp6Yg8uND236m6Tr2PDxmjQ606MYJcowV8WS3TFW2avsXNNZ9aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ii056BeU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0B0606A320;
	Wed, 18 Nov 2026 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ii056BeU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613161F000C4;
	Wed, 18 Nov 2026 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018663;
	bh=bYwoY9hoNJ5q0eVpMo8dz8M0CjaUL0etxxJfX1X614c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ii056BeU0pRX3e9pdoju9vG7LcnW6QpCZ2iTMBY7biXCdv6lzArY8Te4jervbOOrh
	 NO+3APkOKYll/3ZK/ndRdsrOcs5a8sXWPRBcly3w5O1FU8p7KeQQEIslElZvtPgy9z
	 kzpzmvHyaOs2dW3/hmPyag2kQ0+cospcnDq0Isg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1321/2651] NFS: filelayout: calculate dense stripe width in 64 bits
Date: Wed, 18 Nov 2026 15:42:41 +0100
Message-ID: <20261118150335.555630545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 9ba13ef0e3ad033d3ddbaeb740b12d135a88363d ]

filelayout_get_dense_offset() calculates the stripe width from the
stripe unit and count, where both values are provided by the server.
Their product is stored on 32 bits, and can wrap to zero despite
passing individual checks. For example, a 1 GiB stripe unit (0x40000000)
and four stripes (4) cause the following div_u64() to raise a divide
error during the first read through the dense layout.

Update u32 to u64 and use div64_u64() instead of div_u64().
stripe_unit is a u32 and stripe_count is limited to 4096, so the
product cannot overflow a u64.

Fixes: cfe7f4120f8b ("NFSv4.1: filelayout i/o helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index 0d53277f972eb..727fe1270aab5 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -55,12 +55,13 @@ static loff_t
 filelayout_get_dense_offset(struct nfs4_filelayout_segment *flseg,
 			    loff_t offset)
 {
-	u32 stripe_width = flseg->stripe_unit * flseg->dsaddr->stripe_count;
+	u64 stripe_width = (u64)flseg->stripe_unit *
+			   flseg->dsaddr->stripe_count;
 	u64 stripe_no;
 	u32 rem;
 
 	offset -= flseg->pattern_offset;
-	stripe_no = div_u64(offset, stripe_width);
+	stripe_no = div64_u64(offset, stripe_width);
 	div_u64_rem(offset, flseg->stripe_unit, &rem);
 
 	return stripe_no * flseg->stripe_unit + rem;
-- 
2.53.0



