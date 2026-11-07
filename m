Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061700;
	b=cM4MdTTBSx20gbVd94Zucr+Q3xRe63vsDcD/Qo5Z/WFGHiEfbeZzV58N2yx3n6859Uad
	 Ia1siECVfuxBi6yeNNEchlAjZkhY4Y4MG/rbDfaXaA8pKxOlBh2tt1RsWDEaNxRIRkjiP
	 vI2YBYFcXnvIE+LpcmoKiqs7tuZVIsBw0+f5pqiMQRXkycxPeyxIqHD/RK/P8y92N2CSr
	 NN5dr5XU6ZcDOUbdO4wtekBRcUhnlKy3WGJYWMGih8I8AWYd7ZMZieNDY6VD8joSn7eoG
	 lQ0n6cH5fXk/MVJqUA/TsbiXYaEKZZxah6xHLGRVxPSJZFZhb/3XDZwxwuW64xu/qdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rKyBPuzVTHVOaC916zPYgjYa4ChwXUs9riJNCnoS2Ns=;
	b=GlXYF9XHRpGCOaZTC+b8GPIuL+WOtdE0vlV1kPtEYBZFxp6vGPiVi+zCkyH4cuAmoOPi
	 MyQAF1QNGh3o6JsiOnU7d9K+QDV5nKC8IB+gSElqDPpBOjYzuWAbdyDR4RjEFLhIyPk9o
	 S3P7aULlcxgyjGGpglW3xcDptlcH4w+/xjSkHagW0JsJceK8KwfBc4werW/N+/WnZO6fD
	 m8v4HhIeyjv7uP9mQ/fFtfZv/q0PXZ+YXcvfaPGooahtzMmLoZXDAYmHouw72c4MInl1e
	 NMcXO724VfYF9oQfT8BN+jZVu1PLeISsF46OO9fbQjSoCNFd/j2oggohYMtrQfs9w9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3XU7WgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B072606A326;
	Sat,  7 Nov 2026 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3XU7WgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8BA1F0089F;
	Sat,  7 Nov 2026 14:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061700;
	bh=rKyBPuzVTHVOaC916zPYgjYa4ChwXUs9riJNCnoS2Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3XU7WgOhEpKuvBC9PrF3Yzp6VAvp14lIENjo6a+aHjbdRCTNdtSoBYpDZh+ul8FI
	 NNu0aod3IHv3I5CP9vcqm3WDBvbPbR1By0UbBo0mvDaIMLdWkJ6dra5KKWvF7cpGuN
	 hXT61QASPVVJX9cQvEr0sYdMpQcJ/KZZZ3Xqtpgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0701/1536] xfs: dont proceed with xattr repair if the live update fails
Date: Sat,  7 Nov 2026 08:45:17 -0500
Message-ID: <20261107135017.183144587@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 833f98b3be45bc7c6ce4c87bdc4892f546ab72ee upstream.

LOLLM observes that we ought to make one last check for failed live
updates before replacing the xattr structure.  Let's be cautious here.

Cc: stable@vger.kernel.org # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1477,6 +1477,9 @@ xrep_xattr_rebuild_tree(
 	if (error)
 		return error;
 
+	if (rx->live_update_aborted)
+		return -EIO;
+
 	/*
 	 * Exchange the blocks mapped by the tempfile's attr fork with the file
 	 * being repaired.  The old attr blocks will then be attached to the


