Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831672;
	b=rdu6PoWiFThsSY4kvSp/xCwJZ2TV+QYTVZ6SAwFYf76VLN4JlmpimU3VTaYBF0uW2GLC
	 xuoscOy/W3MRsnPF7Yhpn/BxHqGm/goj8qIRlixkoD19YK0etRXWZfc/LAIVVOqc5wkZx
	 8V24tiyhqjcDmI1Wt5nQ2GAMkExmOjM+N5CCI8LEkfCvDqB+nwpKlaEllePRy9SyDvUFt
	 O/dpIUzriKqf6at8e4+dQP5sufJ023VF/zd+FAchlnkEl5W/igWT/38VSTWEqHpSCtKgA
	 MFVNfdoj1TG4s2hsfoCRctd+AehDEceuXZAM/Jkk2dDqvRba8k8on3hx4xHpqERM3ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831672;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4SwWFZ8GmghCa8jwbNdXr/Ro99DzcPL1bcM/yK3bF2Q=;
	b=5nQI+L07squWrCt2Z/nA5pzN/U6raeBRTgbCLd4Apw5vYpQpZeBPMCqfglDaAKmYeWpD
	 Zo/51DhCDjpkZFR3ALBnt36NELMRltd4VoN7O6MM79p3MeZU9hOeAmLSYwZNizyOi+ehv
	 MzSTJcEge9cSWst0OGb6sqh0WZtBvmFrBCGDYotNAwJdvWjozpysbV3YT1PDWpSvHCJjF
	 4mfO7BTo9xISF/yZWqA5pFH1Q/mNzT82tzY1md4qPtpgowv+ZXll+CUHann8y1xkyNqDu
	 M+2hgra5vuw1TdiWLdv4afP1Z75EwuC7jzVByu54Ib8jDnsnAbllpS4h05ok7I0RIog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLDxi4NF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B71E606A33A;
	Wed,  4 Nov 2026 22:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLDxi4NF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722DE1F000C1;
	Wed,  4 Nov 2026 22:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831672;
	bh=4SwWFZ8GmghCa8jwbNdXr/Ro99DzcPL1bcM/yK3bF2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLDxi4NFEn1gqw9xOAO8NTojSVPM9sNcDB4cNEBFJC+3q4QM0FRyz1Q4MhHi5+fiM
	 tGa2jtq9xYVwySi3Jv0FThH/vso3jypgsIKSGY0ntxEaurMz2Pl7Nb6u5veMFJyJ1P
	 DlhN7eYkX0jDHIBhox/wUI85F3Pgl5OWu1Wwq3g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0796/1005] xfs: fix lost errno returned from xfarray_foliosort
Date: Wed,  4 Nov 2026 16:08:49 -0500
Message-ID: <20261104211105.640781475@linuxfoundation.org>
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

commit 8c4f172c246717b1420f138a159ed15c315a58bd upstream.

LOLLM noticed that we stop the sort early but don't actually pass along
the error code, which could enable repair code to continue running with
an unsorted array.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: ee13fc67205b98 ("xfs: convert xfarray_pagesort to deal with large folios")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/xfarray.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -943,8 +943,10 @@ xfarray_sort(
 		 * problems, we're done.
 		 */
 		ret = xfarray_foliosort(si, lo, hi);
-		if (ret < 0)
+		if (ret < 0) {
+			error = ret;
 			goto out_free;
+		}
 		if (ret == 1) {
 			si->stack_depth--;
 			continue;


