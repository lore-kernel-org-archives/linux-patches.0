Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831581;
	b=djo1rowT5Mw2dtM3Im0UacoLja7PtW7zBpxdGTm7++ji00dLY4wkFUaOCv8SwQqx71KW
	 iynoxA00UAwgMszYSa4Jg9magFPRoGb1Kmh4LwPpVUCGW3+fnyo6xrdaQSbMweqfmPChZ
	 knwjszCyiTh6fq4ILw71ShR3ISJaEFCBH/PHYCMhXWjXGtySqKAydnPIOpdr8ObSaobOb
	 9DlyMe9kxDd0hXzElUvM3R62QuU/7Zpe2JjAptyY6KXWFsAGKccTJcTDFn06Ryth9A2UM
	 OsyxeM6P3Ij7ty9sJKxd1pmhMgtEF4HDbQGjq4Z+xKz4kEwzoENXOO19XrKOLQMjQtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1XR5e2qlmBukVtiXBwfmN+IKkKW82kfLpSvpnyruwE0=;
	b=kSFkMvYr6eXOFJ41d2J354pSZwSQlbCNsXxYEk4k+ecXLkHVskjjF81b/bDrQ9Sw1c0w
	 XgewAwAV/CnxMYJxzKROi1VWu0wQYeVy4WWQSYcR4Xm6b/NcmQ2WBPljG4rOKYXDxaG4J
	 FTVuzFUN32w0aVAIGaEdIJNlmx6tpLTDvs0ZoJ/X8Wy2rPSKYhlePa7AIb1/o/8Qloy1K
	 SUu0OKd346xVIrWFlWObKwOO6V7V3eN+5zVtDwB19DeP54MXihqyVoEXOHJ12ohPpBGMb
	 8KQT0W7uXgpG6RKbrcZOeyewg5550fAkpK2ukXfGtsTlaSMN5+KUvbN0M4wPRRsZ4QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="na/bYIBv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1B5606A844;
	Wed,  4 Nov 2026 22:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=na/bYIBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727671F000C1;
	Wed,  4 Nov 2026 22:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831580;
	bh=1XR5e2qlmBukVtiXBwfmN+IKkKW82kfLpSvpnyruwE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=na/bYIBvya0JGWZ5pTxG7iuMflLWJX4J4gLjRPODC0heZcSKhb3teHpFYIuIWMk/F
	 ilTyNv3rdFoRJINdkT/h/sUKXkcOrlTxgbyyNcaN696DBYcyziwCC7dpULhETF42px
	 qs1/BDvOvWWR7MHoNQGpY3PaGnrg7stN+5M7cQv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0788/1005] xfs: dont pass iget failures up when marking ondisk inodes
Date: Wed,  4 Nov 2026 16:08:41 -0500
Message-ID: <20261104211105.414914105@linuxfoundation.org>
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

commit 7f5e8bf335e5e257fb82cf5b3521980ded60e863 upstream.

LOLLM observes a couple of problems with this callsite -- an ENOMEM
return is completely ignored and a subsequent run through the loop body
obliterates the return value completely.  Also, an error value
indicating that the list is corrupt can get passed up (thus terminating
the repair) even though we can handle corrupt lists.  Fix the callsite
not to have these problems.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1331,8 +1331,12 @@ xrep_iunlink_mark_ondisk_rec(
 		 */
 		error = xchk_iget(ragi->sc, xfs_agino_to_ino(sc->sa.pag, agino),
 				&ip);
-		if (error)
+		if (error == -ENOMEM)
+			return error;
+		if (error) {
+			error = 0;
 			continue;
+		}
 
 		trace_xrep_iunlink_reload_ondisk(ip);
 


