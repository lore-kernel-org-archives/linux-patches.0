Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828905;
	b=togN3JBh2hj4vhxMT6c+ZoPzM4OcTPSKt0n1ScDZGP3EJAv6yCu9BfyM7uuyYNxxyJOl
	 G4jyrk+Nw1xD6b+rxLMkkd8XPYzxiHqW7EIs953UeVrc0qcVqa9oOkCwJCkDeyAuZnPFc
	 Ko1hpastlThAYQMBnk1HFO0IBGiVmfTYu75Zkn88vUot5ZaBCAOQx5wZRXW84VNwR3/OV
	 10RTngVnMZRKbDqO+PelruyMTDDsz18U+pZJ1ycppD6LSwYqlfas7Tw7fDdfPl3YdL176
	 UmCx+podFgylLok4cftfc9Xg2bHs+whiwzT7QTsGV88aoZ2tOVeYFequ3yzvnK/BEUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yj+xQqx+96kgplweeN79uSaPm6pl2hXRqHVosAWyo5g=;
	b=ioNGqcQhzdoZOeuG+2WSMNzyH29CJ9gCqwl/Dy6/BEcxJc+atp2l8Omb32mwxOAIPwML
	 Sm6FLkkwxeigV2wbtpHMNeMoD5JT+02yOuT06LCrYQgIWZ8YRzhtB2sLVrevbSYINIrPL
	 gHHMR44E/nMSrTTT0mC3fh9zNB7j/I5w1IHHuNXkNgIaO/56bRZH1R0rWJZn3a1mpNWLJ
	 6+qMDy1EsCzwANySV+D5JXMheEXKpqJsDuWDQ4PcdoSqsg+Vp92JGN8jnr7mlv/m/WZus
	 rNR58iHq63nnGU029KpRPtQ4CO3wOJDeiuyDAD0+n1InTgP5VARQHhzR7634ZcXLbLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqyivGyA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADBB6071AFC;
	Wed,  4 Nov 2026 21:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UqyivGyA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1581F000C1;
	Wed,  4 Nov 2026 21:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828904;
	bh=yj+xQqx+96kgplweeN79uSaPm6pl2hXRqHVosAWyo5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UqyivGyAGYuC9L3EH+tX1s/qHQ4QDSRZf/wNl36oMFxGhnYRG6dep0AODyrJQbjV9
	 5GDiBOCH6rta+cFt4G0ZyjEj7G423+D6KAeSBwCbD7OPeoGmceJbwT3qO6MO+maSdi
	 mHd2hIGV76JTH/swILgyM+/mwUHcGQ/QZdiFprSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Sandeen <sandeen@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 317/547] xfs: validate rc_domain in xchk_rtrefcount_mergeable
Date: Wed,  4 Nov 2026 16:08:21 -0500
Message-ID: <20261104211047.225374723@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

commit f04361fb8694bff98ec61e2e2030a1993426fdca upstream.

xchk_refcount_mergeable validates that the domains match, but this
was omitted from the realtime version of the check; fix it.

Fixes: c27929670de144 ("xfs: scrub the realtime refcount btree")
Cc: stable@vger.kernel.org # v6.14
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/rtrefcount.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -379,6 +379,8 @@ xchk_rtrefcount_mergeable(
 	if (r1->rc_blockcount == 0)
 		return false;
 
+	if (r1->rc_domain != r2->rc_domain)
+		return false;
 	if (r1->rc_startblock + r1->rc_blockcount != r2->rc_startblock)
 		return false;
 	if (r1->rc_refcount != r2->rc_refcount)


