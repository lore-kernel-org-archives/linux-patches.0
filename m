Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831621;
	b=jiLpt+8iL8QWgbbE9RC79sB9L3ihblxyxu+QumPk9clRTRaKy1961RIOPKlju+ZP+W7f
	 vlgPsxiRqAtotOGWxzxBeK/lMQcnWwyB7TLMXmZKEYAHooG88W3Lq/CbJ+ML5g14r9KIp
	 M29J9hNQKIjJ6d1FO+HYCAjEdAuP8OfnPGPTd7cAfvnU4xIq8OcQ4tXAtXzzqvdyYZPZf
	 9mWBrEWdLmFQTpEoJ+XsatCv/AbiQKXk/qhMLrDLJJAGMfapneyWEWk3+uAbS6FFe+SCC
	 2qd/yLWESTfjkq7eO9WUbOe73vMh+084cnGohiX4Jqii3fhPoPqzGbupH/Rk4WdMAHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wex6xrIe9LjyPBTeQwz0KUXqsXbYMiBFcb7SIVa8rO4=;
	b=BsG+2Lck/ttC9p+bmpiuxwtB9tQLluj56tvQryLUeXZFLV53VjltpX42a8gVhQMoKWnU
	 2sJpfnQIlk8fqtxQmigKOzqwnq/cCz1Y7g+gKI1xbKuZry4NO01c314dm+sPg1aIeyzaL
	 kbd/zlUbwVgwpTN4FQcCeIRB87OnDnKxoJOv+v8irrJ6KiwZFOwrdtTgdjebdDZjLxAGG
	 7SDOrLEFA/MALUYHsF2sP4JBWrrCPxxoqbMhXoI0Oku8fA08wtzfQrTO1OlSgCV8JPtga
	 tpcFW46LGmQ3x0j6nqN8uiACucFRO29P8UIDhZlC0/J92hGC0Ki0eAw0kNLIVPAr5bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mR/1IaVw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27865606A326;
	Wed,  4 Nov 2026 22:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mR/1IaVw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F141F0093A;
	Wed,  4 Nov 2026 22:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831621;
	bh=Wex6xrIe9LjyPBTeQwz0KUXqsXbYMiBFcb7SIVa8rO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mR/1IaVwjl8fktqd638pqdgQyyUZK3iKmuVvwImcVuSW8lJG1wD+eeaTxzjvMwikF
	 50OpwxLH+lsbK5h8yjtpisc6Fzi/tvCHsMvvuk+5pKahZSAIbJwQfnD+DpjvydQhhN
	 sytVDpCBsb7LYjyeNGc4stcoSTCMxbcuM/c27FrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0798/1005] xfs: assign an owner to scrub_stats_fops
Date: Wed,  4 Nov 2026 16:08:51 -0500
Message-ID: <20261104211105.698559893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit fe67a493c7a76cf75556152af24285a114f69d34 upstream.

LOLLM complains that file_operations structs for debugfs files are
supposed to have an owner set so that the module can't get unloaded if
someone's sitting on a debugfs file long after unmount/rmmod.  Fix that.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -294,6 +294,7 @@ out:
 }
 
 static const struct file_operations scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.read			= xchk_scrub_stats_read,
 };
@@ -321,6 +322,7 @@ xchk_clear_scrub_stats_write(
 }
 
 static const struct file_operations clear_scrub_stats_fops = {
+	.owner			= THIS_MODULE,
 	.open			= simple_open,
 	.write			= xchk_clear_scrub_stats_write,
 };


