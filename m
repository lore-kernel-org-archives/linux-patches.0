Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051803;
	b=ak5bM88lQsC5v8kOqRfvGupD+MNiJunx5hTyxQ5Ktsh9GHd4O37Xpu1tYlGljsYE9nvI
	 42IQpqkZcOf5W8ocdPICLh3IUsp/AjmmBhxxHgHBtBCJ94hQy1sb6+0OpCrBRi5CtCiWo
	 9WeNgan7yalsKPD/yrlWR53B2EmuR9KxcjC8vZGx0P+FnTNc5ioZ407mT8ECkQiQ4tAij
	 RJiutz5JRiMPT3Q2xbxWUNfn2bV9B4BzOt464EhS3Y89SPVV20Ck4u0ZAEOYNo+CWHO5X
	 s0foXna/nfOS1DLk1iC8U9QZuzDNHnHhEFEC6JXag/hTph+k5LCJ1oS/kJnUFfdOIYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbTA+mc/eY9SNt5G09bGOH3FAnoA3/jkByXy+BPF1ig=;
	b=KUw8Vf40nceEH9npLRHx8tviEhKoVOpD0pmz0n0hFKxtmMJ9uOgnROZypCSzHykJaVIe
	 eAOtYqlzmNI4U58YB64FAH5+YqH4lI8GuGTFLP4xoTrLa2Snw49hYWAsGS4YOPID/KOdR
	 cKQcvFJg9anS1BxTnKMgzTzPgGTYfTX5uHRmT0gCDrqSmMGQgrnBEqM+h8JhqFwi7Okw7
	 JUCAjwQBQuh40pwipBLW4NqOCQ8vgurDcBZitE5sRof3tZzOV0bo1j6812Nflyp9/RBqk
	 5CzD71tmhTLG42MK+3b4dedlIKj/ErKv6OvxCn5xbjYaTn9vKLaSqS6BZN3igQZHYXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ge3FEcxW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2665E606A325;
	Thu, 19 Nov 2026 01:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ge3FEcxW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A661E1F000C4;
	Thu, 19 Nov 2026 01:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051803;
	bh=tbTA+mc/eY9SNt5G09bGOH3FAnoA3/jkByXy+BPF1ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ge3FEcxWPG7Cid1E3OkWS+KOPYTLockqTL8UtdcBkxEguyDLcGP0ObOTHV1M3m6zq
	 EZu9FWhP4ktaMkGwt1jg8VUl3cxUZ0ltH4sL9Zw5lHa8lWGzeKmltgRa8va5hAEYbY
	 i626N1cHFgISOO6eeUc36uFVduTFpmi/e4GSPNgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0338/2214] xfs: check for fragments when full-extent sharing matches
Date: Wed, 18 Nov 2026 15:33:34 +0100
Message-ID: <20261118150024.074039476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 95e213c1ddb40dfb0a8178ed35c9f29992a320e1 upstream.

LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
if there are enough rmap records that overlap the space referenced by a
refcountbt record to match the refcount in that refcountbt record.
Unfortunately, it never checks the fragment list in this case, so it
won't find the discrepancy between the rmap and refcount btrees.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -157,8 +157,11 @@ xchk_refcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)


