Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831656;
	b=X7aBXN1ZekuruA+RjcpKfqvQL416T4skCUqzkNaC1NcrCTsgibUKNeVxHk2Z1GjMBeWv
	 tYxO7Kx1G3Q1aLz+o0besk1bdas5M4Ao7zvQKujqXfJZZXBqh32+iyNgoqAezroYw62IM
	 CovkaKyeXG6I88P6orWfDgDvo2MaJxW71Hnz0vFKweBS1aHGg1RlS0EBLPYeSeXIL0Dow
	 G0a2w/dKK82RmlDEzbWdmheBKHSOnPCz/ZNUeqWVitm4f1Dr5PKCgaYxg9TY+CLhtCyzh
	 oq11UMXS3uTxw187DQ7Mb4gYlPlWRfurySS1F2WEr8RvT9APCd2WrFDXnMJ54wxWQrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tir5w9GxJ0jLfiOiQLqHGLnoh4TvPlETEaY2poWXgtc=;
	b=lzFkTa7eIy71G7+vlQn+EclOLK7/Y/LveliItSCJuQOuiB8DQwl1yNerNzg3xBeA7rNc
	 Yv3rC0uLGUjjZ15UHERAiOtYY5pN0cGJ170TGnWUKTiO2IRjA8Dg6z2/7CkBObWGU8pnq
	 vct+SlUSSk9RRrbDFzTorsZiMOLF36extWvTLT/gydHhJd7X6KIkVmvLWJF60EZreRAoS
	 nucmBlxo9GWkYROK794Fsd8SLaJ+TZUX9SDYdxul/Ft9xgfDDPpRIZDkmP00alBuEHk+p
	 gHaUF4IK8tNogFadvqZw73AuGXDyt1YjA1vP+XF7BxI79VR8zK+JapVyVfTNgJW92tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjyglH++;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DBE606B2E2;
	Wed,  4 Nov 2026 22:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TjyglH++
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF321F000C1;
	Wed,  4 Nov 2026 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831655;
	bh=Tir5w9GxJ0jLfiOiQLqHGLnoh4TvPlETEaY2poWXgtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjyglH+++secMVth9dezQ8iA3LlFo92dt0AbHojgIX4BiJR8p3dGbkGXDxAVsc4TC
	 6zWEzVqWEuFFYEB7YUZKphtmKRh2FFOTiF4poKj3STORI6BLWpYkLh/SK6VkdwWlyr
	 uE82FztiuC7JSppXjeXnBd/qGahj3V85EXpIw3Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0800/1005] xfs: fix revalidation of xchk_dquot_iter cached mappings
Date: Wed,  4 Nov 2026 16:08:53 -0500
Message-ID: <20261104211105.756404426@linuxfoundation.org>
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

commit 6c64d650460b455980a6023d43bc6c8859c1cfd2 upstream.

LOLLM noticed that the purpose of xchk_dquot_iter_revalidate_bmap is to
revalidate the quota file mapping after we've (presumably) done
something to the quota file contents.  However, the "yes this is valid"
code isn't quite strong enough -- the mapping must cover at least the
block at fileoff, not just end after fileoff.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: 21d7500929c8a0 ("xfs: improve dquot iteration for scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dqiterate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/scrub/dqiterate.c
+++ b/fs/xfs/scrub/dqiterate.c
@@ -58,6 +58,7 @@ xchk_dquot_iter_revalidate_bmap(
 	 * no need to reread the bmbt.
 	 */
 	if (cursor->bmap.br_startoff != NULLFILEOFF &&
+	    cursor->bmap.br_startoff <= fileoff &&
 	    cursor->if_seq == ifp->if_seq &&
 	    cursor->bmap.br_startoff + cursor->bmap.br_blockcount > fileoff)
 		return 0;


