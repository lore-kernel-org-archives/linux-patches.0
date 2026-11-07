Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061650;
	b=YUd3CH6FrCWVzFOgQVT3djckCy8qjN7XXGubDRlOSHjtkHxgREWBnBYHva7R6nyLeExA
	 O1HSJwHU8AECGgoBsRxE9pb04q3iCB+MtuZinnGqOJv6UYmvAn6al1n99wU9cW+SqVW1E
	 thBlbADCXiIOk3t58u0IG09FiUKF2pk83XZ3qydm+31IZHiXGDxwoGqGdW9TNLUB4vtaa
	 cbTRBCHKIf02/6uDpW0/eFdH/WPcugZPSaVZUGK/RUBwgJM+DTJOqRzVTi08rtiVaJ6uC
	 0LYF3vxodurAgkSid+H6dWc25NRAsjduZxlTuqTghOIjcP/M3lHPsRPqnWZ0d6KX4KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QYJz2GlSByTiODk9Qn0VAoaRPdyEiHklQly+rx9T+bc=;
	b=klEBUBhP9y0uWezrg62hvhwYCkb6yEfyDGnBmF9xkOOG6nSVl0HajT2qojyCpBI6PrWi
	 e84y0ILKZ4LkaJCKpZJ2ui01DtwwyY5cu4fBAYok/r4tz5I7MDmFMLsScjDDkj7POCH2i
	 fDdb/6I3JOU8ixkaGcx3wb0TH6aD9NYkOdgqs8Que5HNWmrditWMpq0Lwr5k5+oDPBndo
	 5UqBkc/du1GEjYrMGumXnZ5mpa0m6Pz+VcWSCydPm0dsm2bXR2xTph38m9F/NYBteJBuX
	 RA5vVx6E9cl6qNWqoHCbvjyHr1aiCdBX03RbIL14gS7hOU4a6NLkThnnffVwy8ZmLrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=huf5ety6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE340606A33B;
	Sat,  7 Nov 2026 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=huf5ety6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2BD1F008A1;
	Sat,  7 Nov 2026 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061649;
	bh=QYJz2GlSByTiODk9Qn0VAoaRPdyEiHklQly+rx9T+bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=huf5ety6llhZLZ1S1+HQ5JOvPCYhRKSy/BM+lubUOvvKwCLrx627M5vK8Z6RC2U69
	 SaHV+MmvZthaq8VB9/eKZbh5vWyp3oBa1K3dGEjNfH2gFZPaTJ2TU4RNeRAg0Rwb4o
	 petzWluvxLdJZ48MekeIqVfUaaWJZZqohEWVcu6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0702/1536] xfs: fix skipped inode mask handling in iscan
Date: Sat,  7 Nov 2026 08:45:18 -0500
Message-ID: <20261107135017.210653742@linuxfoundation.org>
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

commit 63341d4af16fe850716b454fcd18990590d07d97 upstream.

xfs_highbit64() returns -1 if none of the bits in its argument are set.
In this particular callsite, a totally zeroed mask means that no inodes
were skipped, so executing the if-body is incorrect.  Fix that.

Cc: stable@vger.kernel.org # v6.9
Fixes: 82334a79c6eb1c ("xfs: iscan batching should handle unallocated inodes too")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/iscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -545,7 +545,7 @@ xchk_iscan_finish_batch(
 
 	mutex_lock(&iscan->lock);
 
-	if (iscan->__batch_ino != NULLFSINO) {
+	if (iscan->__batch_ino != NULLFSINO && iscan->__skipped_inomask) {
 		highest_skipped = iscan->__batch_ino +
 					xfs_highbit64(iscan->__skipped_inomask);
 		iscan->__visited_ino = max(iscan->__visited_ino,


