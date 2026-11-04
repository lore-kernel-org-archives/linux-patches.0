Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829021;
	b=HOOLJeopxlFN/IelkJ7EBtGlkqKnqDQC/ROAvvJBXDuLFr6+ReRP50Ow78V7za5OdMEM
	 XAG7gGG3Vfr7uGCkY/GSOvVciVEhOp1HpFApvjlJ17LrMOSuVbbvS2nrkeBfX2kNDGLMh
	 BADgClicOSi3vbWra0Dv4T9dXG0Q1wkz7P5wnKOlnM9o11loawBC7WP3WEdsMvufJrZgq
	 P7zzNjVV9Pc0MzjsfiBXEROKlphF5v8QmSejTebKCSgsIdo23yi5p9WCwz3n9vGIp1sKU
	 +q91b+Ca1CER1r2y6ulSUNz2LSjszErCaOXJEKBuDmdbSAI5GE3DcHuOLbsuKuQLDjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w7jeVVkSmMHLew86Tkd+sYI69/+qvRYUeLDEDmCKk7Q=;
	b=Cq62gmVVg4bAl/YXloBlj38BFK1PjKc8Z5SseKVTs8J/kfuHUekYUvMH33owRsMBW+tP
	 OGz83Egej4RgPEfvE3o8eOmAvGihnV8pnXld09wEj5zZrgHAduFlGpNQ3H2ai/8Heajxf
	 reBcPness1+9moa2+RWvcQ+8NW7KK+DdIkbjgdcQZ4aiOj2MHozzAmv9NsJcmkPoW0Eo+
	 eemd08k0wUECRSxjSWjKf4wgSbcB/eLTdPfKUksIfjeDPHphjSKyrQCmSsaVmTy/t+/yY
	 xSGZZc7q4MoLr0tQ1fHX6GffOZOUImSOG6t2xdSLRb6FeZMUAZWK8Hpavht02r4ptUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8aeTgIp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E52A6070759;
	Wed,  4 Nov 2026 21:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8aeTgIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E151F000C1;
	Wed,  4 Nov 2026 21:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829021;
	bh=w7jeVVkSmMHLew86Tkd+sYI69/+qvRYUeLDEDmCKk7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8aeTgIpMEhvw3CZz6XPClZnRR9tM2Gh4XPV7lHQE2u2ziZlp5/Jb8Unu/T9YELm6
	 zHaMRxtFg06sJd4jcOgeItuArR6HIS+TrEjGOVXe5bI9snlHQghdabm2eDL4QfKhZZ
	 pyq8sV1hI/J+7AcNGdVIHQlrnZ1a+UsMBt0J2Fa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 354/547] xfs: complain loudly when dirtree checker finds broken links
Date: Wed,  4 Nov 2026 16:08:58 -0500
Message-ID: <20261104211048.333678114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


