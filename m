Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035357;
	b=S8NF8P2pYg9056N5ut9jxIW7ieoD4DMK3I+YdHkFme2k/qpnViq6g5t4ZKok3yDliy50
	 nd57n5zn6nuFC1mvfQehX7ojEml1UGhXyMYAlFNfgs+e7lpXrfXOAFU1QnA9yzSzkX8Pa
	 jzolmQo5Y/wSBc+CLqeWBSOA2sPA+qs7tVsFR+rKlIRE6gEDp0cxPyafSb56IH9BD3B8M
	 qDXTexQg3G7Q6q0WXdIrpciJ96KGmYhjItNwLt6AkOeh1wZafa6M0E47x/S05Gwp90/Lm
	 w1VyWlMgDXLdf/irzIWCBVt1qLmLiU++9hJKrQd9voK3sAlmFQWFWQynWZDmfxlrcXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nZI0Z6+1a4dZ/ZxR0xRc96Q5FaUWNY9T31w9l0pJW9g=;
	b=GEBLnbRoImQYkD/N81qmehVUmJuRHwdsLFzcJUalup/wkcygtCJD6O5IJmOl0N86GN4o
	 GUbRqMAbl9DeLuba1Zoj+bf4hhxO7P+i7M15JeD75C/zdG8T/eeY8CWkb6dohhUXrbq2X
	 3nWcL2ia+mBeHF0bM/+X03ADEQFS7oIRoo9OI5JDVJFAKHOwtbnLPUm9nsKXZJM00poc5
	 2oqq1gGFZjvohH2Fkpac1Bxez77r/n4tUX7yaYQOiB1mkkve3GlDTzTI4ut1Sl9vntMZv
	 PXpiyk4+GiWcmtQJu3J/yL7mG3+eIr+BZVHYp3RN+BiT2k/lW35epMd6Px47wJ4iQMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEGfRSZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE06606A31C;
	Wed, 18 Nov 2026 20:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEGfRSZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714211F000C4;
	Wed, 18 Nov 2026 20:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035357;
	bh=nZI0Z6+1a4dZ/ZxR0xRc96Q5FaUWNY9T31w9l0pJW9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEGfRSZOUonMJgGEbcs8R2HnZDqPMhyKiJaRWLRf6FC52sP+pcwCgDN8n2rRi0eIH
	 7rFbtofUshOl3pI6EzwNfMCnj4KcPHd00v0UFwXiMD+op+faakIgMsBDpJbF72Wjuj
	 NhGrPnQZ0iLENPIW7UanY5otlcXoDi4/qo0RFp0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0674/3318] xfs: propagate errors while checking null siblings
Date: Wed, 18 Nov 2026 15:21:36 +0100
Message-ID: <20261118150338.367678142@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit e5bde75a816b3549942f4b09a8bf09006b7ea9de upstream.

LOLLM observes that if xfs_da3_path_shift returns an error here, scrub
doesn't handle it the way that it handles most runtime errors.  Instead,
it drops the error and keeps going, even though that's not how that's
supposed to work.  Fix that by calling xchk_da_process_error to set
corruption flags and then jump out of the flow of execution.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -237,9 +237,10 @@ xchk_da_btree_block_check_sibling(
 	if (sibling == 0) {
 		error = xfs_da3_path_shift(ds->state, altpath, direction,
 				false, &retval);
-		if (error == 0 && retval == 0)
+		if (!xchk_da_process_error(ds, level, &error))
+			goto out;
+		if (retval == 0)
 			xchk_da_set_corrupt(ds, level);
-		error = 0;
 		goto out;
 	}
 


