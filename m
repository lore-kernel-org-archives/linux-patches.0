Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061696;
	b=q2BVq1oVZT4KXXOfan4CmjNYiBWgKAHoYmkup7h9Q8TeAFMp9MiLYkmpuXbc7f7lQ6/G
	 h1nNSFznrOtunEl+VMhC+ZLQ0FPSRusMbK4u4ie40398zoUpz/7LEDfIb8LoRyTn2gTXt
	 32dBrvlNiE2heDSbJBAyIGh8loYjuKN77IjYP3YnZK0kA2EJXw2dHRer88ByexqlXIcOC
	 IVAD5b1duGx32JMnr5XXToZHb2BlUrweaPMFdTRDWFWl0fGBfBVHubhwlKogrn+z8OifS
	 g4NXlR0VqAoQj0Z31bg80sMfpAFguPW9H9qTNiC5wHmNUD2ifHYKTruVN9IhP2euv5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1AXEBxqW8/QFNpUgK2VdwZ5oDFh5kJbhBXRS7m0Uzpg=;
	b=Hp/+Ti4VLDk7HpjVBkbZylPnt7/TrASSZj0TNw+9xUrlf8ea6GL9BRv0Olp9rh5z5zcR
	 qTrmZoVxKoAKdPUPjddRCWtP6AXAFP5bSR8VEyO9+tORxdUUnUcSu88v5K+Oy0xYWCkEY
	 3pRUei6hix9UGOgArvZrsaizlYW1cf7mHWEtFZVwLouXiPtRXvxUvlfdVNr3mwpfR0/X+
	 CFw1xi3O+ZdZnK2LMH4adLKHgm5e90Lna97bqr4fF7oeRXAONKMRPRyHgR8vOIkjw/y97
	 hHUHQrYp0pikQ/6/e3JOr2EjD6xiKaUQ7nv0OGaIjlpJm6KxMMSicW75htaVin067+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08iWZgVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AACF606A326;
	Sat,  7 Nov 2026 14:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08iWZgVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DFF1F0089F;
	Sat,  7 Nov 2026 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061696;
	bh=1AXEBxqW8/QFNpUgK2VdwZ5oDFh5kJbhBXRS7m0Uzpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08iWZgVBnLtOyihgzYm0x5AtW8bXQkZXtDOz33CBcdCIO7xqdfSj+fOcOiDmB3pFs
	 XirtrSG//dSiogGXkrkUzUrNEzjLSHRELbYArn56L0uK66E8aaLJ7buWR5C1OpP0Go
	 uXIKQDB52+K2i+/0lm8ueOnDAqydf3tWwgpxwJf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0708/1536] xfs: fix revalidation of xchk_dquot_iter cached mappings
Date: Sat,  7 Nov 2026 08:45:24 -0500
Message-ID: <20261107135017.384597143@linuxfoundation.org>
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


