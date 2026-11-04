Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831657;
	b=gg/EK/wZZaitjc8Y6qcJbSkLb8lZjB++HnhpocxozRnn3M1IOaoxt0DO7y9gPw8sCD8r
	 prPis2Rj8TG/8er5MWOeWVkAfP/9FK9ALBT+v7i38DbIAAMjNr6T27OYG3pOSK8zmtFqA
	 cxxICHDWYTb+KJgwW8h/n4fsk3FIJA8iS/VilZcUpWQDuS+An6iyHigWmOnH4WV04lpEY
	 gxXxy+feASqTLgEFQhTsmJqi7AYmg4vg9Mtaof71Stj7Jx8WqWcqofXCx2RmNiiGGTywB
	 wPhG8Q8KAefPF0bWSCpdDoQsH3nnsW2Zm5JlFffeWC0HH1aEDSiMHMcvatQ59HX5FtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NPRMwwkXhralL+MCYjvVtPLLA+12PgcGhxKbOZ5f9Mw=;
	b=ntZ5/sNm2Q/pTKk4viBT6PxNqSp7lBYIcWmt9jn5MlRj92feR1DZyQSQTNDPJlDU6GOj
	 K01PMXXvXwHMbKX/r3tT/MkHNKGduyBdD95sgUZlEnerJdkn9/sgVDVBKGBkxQdhlDimO
	 t/qO3YwpFmt8OsDosdGi5G/QutG5zKuGYLVselOCeY3z+EgSkFZ1z529zVAPZlguvMCqx
	 2MrhW5AM9dHEzuuuYkwdyXtr7jwvvTu5FiMbCdqGvlljyzSEJW+rYZIl4b7auURrMeL5i
	 hTlZB3sUdTQfKE6dote49e8ctfWqQ+VdPqd6CgOuhRv3LfoFe2wGyjF+XzFNSpml5iQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jGIpTfuG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCA6606B2F9;
	Wed,  4 Nov 2026 22:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jGIpTfuG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3011F000C1;
	Wed,  4 Nov 2026 22:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831657;
	bh=NPRMwwkXhralL+MCYjvVtPLLA+12PgcGhxKbOZ5f9Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGIpTfuGI7uaMmGqB56XakcZNT3o64Q7ramS7U8AdjXB6qQoquoTrl6JtcEW/HgVb
	 rtUErvr39g+qvTDdu5qo+dBIplK6kNOUjV7sVp0bo+gwgzm3DwN3ioBQNzvpk43VNP
	 VSWsAqHekUfvrkdHgFxp+Xdd3j1ER5G2O1haVPqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0836/1005] xfs: always report inode repair setup failures
Date: Wed,  4 Nov 2026 16:09:29 -0500
Message-ID: <20261104211106.742665202@linuxfoundation.org>
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

commit ce9098338a7e1a77246684242d10779fc4d4a539 upstream.

LOLLM noticed that xchk_setup_inode silently discards errors being
returned by xrep_setup_inode.  Fix that, and fix the stub macro so that
it actually "returns" a value.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode.c  |    2 +-
 fs/xfs/scrub/repair.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -212,7 +212,7 @@ xchk_setup_inode(
 	 * make repairs to the ondisk inode buffer.
 	 */
 	if (xchk_could_repair(sc))
-		xrep_setup_inode(sc, &imap);
+		return xrep_setup_inode(sc, &imap);
 	return 0;
 
 out_cancel:
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -239,7 +239,7 @@ xrep_setup_nothing(
 #define xrep_setup_rtrmapbt		xrep_setup_nothing
 #define xrep_setup_rtrefcountbt		xrep_setup_nothing
 
-#define xrep_setup_inode(sc, imap)	((void)0)
+#define xrep_setup_inode(sc, imap)	(0)
 
 static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 {


