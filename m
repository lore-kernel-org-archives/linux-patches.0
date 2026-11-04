Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831750;
	b=M60+DN9w8ICWbLLeQWWbquTcUdy1GGr1y686Jnj45mkbz4b6edADekabZrf0LrNu8Y+j
	 LL48Z69Sr9dgKXFuuWnbT1fdK9HcDVVI/bubkJhXg9wqqWLwoFBXSrbL/DNSpmGVffH8b
	 zGfY46CvDepRtltPT0p+XCDs/qEaQIRHOjIwt04Yza8UMjmVy3KBbQsQnBz+6I0KS48mT
	 2WmBDEVYRtUpv956aKb+1i1CumQ+dzn1GqqXx0UhW8u+P8F9RaNtyWdgVaujQ7Z3ODzEj
	 ZCxGZ+HKZj8KM0Hzx3R/29pGNPTWgepCl/eN0N+lB2tTt7nMWtEHVDISfsmsMV1ZLIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=885e3uHrBclvmzn7an/RvTpD4Ow6ydBNRvYB0uO/ltQ=;
	b=RyFxCemzpwxi/ZcwkkKVOVeqwt9u4SDDp1p6WT0t7kGCzAdv3KZWRYfk4K4FugT0c03N
	 Ne/+YDvXL1ikYbvYMklk6TO6P/hWzO3A32It+sihHmcs6IrXYjAkGcU0tZeVvgHWnmRwx
	 ivmZBQ5iQjIM5C8eEg5qJ96IgadJJJ48XErCfxKayXYEATTtLDfaNNoMjE+T3CKejE2YV
	 LEPVUSr5cx3HHF6TCq8zl/J0ZhkDsPQAcct/nWEwZ9kajTMvABMW/2Y1Ur9SDhG4fmDz/
	 dkJw7RdSr3ETm37x6D/tbYUFZbjQLTyRHgF4dRxGBC3CK7gjNIQualo7vWpR126W8rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7AP4v8+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B99606A31B;
	Wed,  4 Nov 2026 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l7AP4v8+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D071B1F00A16;
	Wed,  4 Nov 2026 22:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831750;
	bh=885e3uHrBclvmzn7an/RvTpD4Ow6ydBNRvYB0uO/ltQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l7AP4v8+SQgHgS3xH+Q4wXPL7H5rqrC7WQqrFSRGeQXUm9XY2+FiBQdL2yOtuUbRe
	 mgkdvX+qqR6KreD7d5mpBFJ1+cGsyoYnTkGPc6kxtRoUUPLc1GBxucc78AFmxPz7X4
	 16EkMcAEP1KN7TRWpFZewU4iqjb8rDbokCG24lmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0845/1005] xfs: complain loudly when dirtree checker finds broken links
Date: Wed,  4 Nov 2026 16:09:38 -0500
Message-ID: <20261104211106.989052756@linuxfoundation.org>
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

commit e09438cab72c2c6a32665829d4186155346bfee8 upstream.

LOLLM observed that the directory tree walk code bails out if it finds
broken parent pointers along the way.  However, it flattens the return
code to zero, which means that we can end up in the repair code having
not completed the scan.  We should never proceed with a repair in this
state, so let's mark the scrub incomplete and exit.

Cc: stable@vger.kernel.org # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -860,7 +860,8 @@ xchk_dirtree_find_paths_to_root(
 				 * A parent pointer of @sc->ip is bad, don't
 				 * bother continuing.
 				 */
-				break;
+				xchk_set_incomplete(sc);
+				return error;
 			}
 			if (error == -ESTALE) {
 				/* This had better be an invalidation. */
@@ -981,6 +982,7 @@ xchk_dirtree(
 		 * parent pointers are corrupt; this scan cannot be completed
 		 * without full information.
 		 */
+		xchk_set_incomplete(sc);
 		xchk_ip_xref_set_corrupt(sc, sc->ip);
 		error = 0;
 		goto out_scanlock;


