Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831660;
	b=PpL6osNJ62G61EdSaUQaq2rxPIO+0H5FaxGIehgGZA3iXcmRK0g9jxs3frtk1QHu4rsg
	 PhsInJHV4yCFxB8ptcL3W6LCD/qu7t8ZuofCXGt3QXrT3jb/HDLtoDiGHNU4AFT0ZnTRu
	 rIRWK1YRiz2CTPzaAnAWaL1/j0alZRrX89xza8PkAGZ4uw1Ex62PaUXe41kWm+5Nx2lUu
	 AOSDbV5qm+ialgDRJaK8i/mC+kRM9X9UYNXOjVP+uf8FiZEN+gN99GXDxnHEw7IkOPSL8
	 yp/ZO8BIa+kp1H0XjkyEMU34Wevtgoz10ccnqlfl6qt1VRNh5f62wwQ8Qz6IAk+bZvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831660;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xXAoqiWcYCL3OsYV1psJe++7WKAjMcgtAUf1lwqX5gM=;
	b=IyG+gYn9LeN6n4IrNs/F3zKO+CMOLSB7WBVPUBr+A1rPyBUamvvgmepZqW2Pxtt/jkoF
	 OFPDPElvEtsIRwIbWwB7xkQ7P3eNr6xZHe9LwF4AmP+tD0ZFmsEQ9jfsF5v8vXsppRzLH
	 0KhaTsSCd8q6AetRVxE8qqE56TOgole7Fb7eREw8bDTX8CMULuaHQJrEropBomClpD/Md
	 tDaeoWecPtlQCTN08pamZTg9T4fjsgUlVO/60Hrt69fH6V0NUpDJzPN34SY6EIOKKG9Wy
	 eDTY8hNC5ZmCCRU9fUNNfrfppWSclplb9cydAk0ZFmITOHTOK/HsFAClicgexgFB1cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jdQRa8vr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3BA606B2D7;
	Wed,  4 Nov 2026 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jdQRa8vr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5811F000C1;
	Wed,  4 Nov 2026 22:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831660;
	bh=xXAoqiWcYCL3OsYV1psJe++7WKAjMcgtAUf1lwqX5gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jdQRa8vr7H9fhyKTMBZ7Kb/ZVP7QPZ3jpM64D1YU4pAxkkJtwBb8ACWncEUJbsnyB
	 rvm8GheyeZlEMDA4GgsXKXy5zFJURMf5Q9FNsE/rNAa8hOgnEbhRvJk/8NZlcav4IN
	 3q+1EOGIam0ebCJ4eMQ5ic5GR+BAfZjeFMrJt0mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0801/1005] xfs: abort dirtree repair if the live update hook dies
Date: Wed,  4 Nov 2026 16:08:54 -0500
Message-ID: <20261104211105.785475794@linuxfoundation.org>
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

commit 07732dea4f5d0410e1566b81a58a1154bf9dcb29 upstream.

LOLLM notices that if the live update hook for the directory tree repair
code hits an error, it will set dl->aborted and stops working.  If the
repair code ever sees that condition, it ought to bail out immediately
instead of continuing with obsolete data.

Cc: stable@vger.kernel.org # v6.10
Fixes: 3f31406aef493b ("xfs: fix corruptions in the directory tree")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree_repair.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -831,6 +831,11 @@ xrep_dirtree(
 	 */
 	mutex_lock(&dl->lock);
 	do {
+		if (dl->aborted) {
+			error = -EIO;
+			break;
+		}
+
 		/*
 		 * Decide what we're going to do, then do it.  An -ESTALE
 		 * return here means the scan results are invalid and we have


