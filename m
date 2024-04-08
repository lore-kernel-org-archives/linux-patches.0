Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2462279955;
	Mon,  8 Apr 2024 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584571; cv=none; b=c7SWzDXV48UMmfF+mc3ceTR8i/UgbXjl02D6+2RV6oXG+2/UOoG7PjmzDYNZ6JijbjZwqFb5kjJvIdyuqdPAweT7OXLBnU5aSfvdcLZ8JXibi90Ay1k28l8G6lOSVnNG3wPWcBNMJ4a6HPYdd0XGrEI4pxYAOtQqQC5J2dvaFu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584571; c=relaxed/simple;
	bh=9LpyRCCcOPwv7VYY0u+Ev4KftUnqxyiEB+I1xg8KUjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bok0B29KbZbSp79IYPzx/XI2Kwx30S4QW0ny76xpHw30KPBSXZFso54w47fOFOWDQRP3UH181MxBS9EpLWae7CxID83i0k0Iy3zsXTeqQ6yQNpn4OQgJnEvegr0gLkyONMqiJq3aNBi1TfRiFFAgvIyey53GRaE5FTW4k+lRYXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxUdelJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxUdelJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F21EC43390;
	Mon,  8 Apr 2024 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584571;
	bh=9LpyRCCcOPwv7VYY0u+Ev4KftUnqxyiEB+I1xg8KUjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxUdelJukJtyfhLN/62grozn6l1vx4y6Rcr4zU781R57qhm1yySVPM7zmnSXkrZT3
	 UFSgp2NUDJdKU1dcAKryY7V+WiFFIJbcNDNWixz9F1i/qttRo79W8BxR2TsVpEU9My
	 BLKyI57t2bPIEhhb8dabUq+mEZLdArKDbYwwb93c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 453/690] nfsd: fix comments about spinlock handling with delegations
Date: Mon,  8 Apr 2024 14:55:19 +0200
Message-ID: <20240408125416.055119230@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 25fbe1fca14142beae6c882f7906510363d42bff ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1e9245303c0f2..e98306c69f424 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4870,14 +4870,14 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	 * We're assuming the state code never drops its reference
 	 * without first removing the lease.  Since we're in this lease
 	 * callback (and since the lease code is serialized by the
-	 * i_lock) we know the server hasn't removed the lease yet, and
+	 * flc_lock) we know the server hasn't removed the lease yet, and
 	 * we know it's safe to take a reference.
 	 */
 	refcount_inc(&dp->dl_stid.sc_count);
 	nfsd4_run_cb(&dp->dl_recall);
 }
 
-/* Called from break_lease() with i_lock held. */
+/* Called from break_lease() with flc_lock held. */
 static bool
 nfsd_break_deleg_cb(struct file_lock *fl)
 {
-- 
2.43.0



