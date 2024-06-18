Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC5C1AB535;
	Tue, 18 Jun 2024 13:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716590; cv=none; b=Ho3K+xDQT446dhSnbzwEJdPasHlSiG3A7QPaqlaZlNEZzYGen0WM9ril1ZUP0g71D1oPQW76G39IP/FgtXw5gIvkBDcXHIm+CajE1vjeaRvfg2KR8e9eI+Sp5zD+tVrhYSlLS2L4PCxH2jFjeM0gXl3w6/AXjRBpg2wtBp9L3IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716590; c=relaxed/simple;
	bh=R6R1UAf9MRt36oGK0K6bzs5QrrBD04d8A4fCLN1MEJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ng7vGzzYZm7+DnKt/Q+ZItXYh4VijckonM2ouPzMkftGjDZ9xu9pSJFKZZyih2C+8kSm5jNIw51OZYbraJ7f5PyHFf+Da4KOEF8FiO3KsRD6CFXGsQ5rGHgUyMv7A1GeCpnLjzmRQ/k6xGl54Fdm9rHnP24nkqJvuuw99qRYAdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF8stOzr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF8stOzr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14900C3277B;
	Tue, 18 Jun 2024 13:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716590;
	bh=R6R1UAf9MRt36oGK0K6bzs5QrrBD04d8A4fCLN1MEJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF8stOzrZf2NDYD07eePPf7Fr8HwU5DXANvzS3+P7JKeTIiwCr2JX0MUu7LoPMEtc
	 0UrllreyCjfZWTl3HzqH4Fr4tkOsf3n84ESY0/yHlmFRHyuMkLx0GYaiQ4OfjBwXWb
	 jO3UpcPKP4mzf8dMyT5OlodLutdD2eXFQmjUVv54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 697/770] NFSD: Use const pointers as parameters to fh_ helpers
Date: Tue, 18 Jun 2024 14:39:10 +0200
Message-ID: <20240618123434.181183717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b48f8056c034f28dd54668399f1d22be421b0bef ]

Enable callers to use const pointers where they are able to.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsfh.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index c3ae6414fc5cf..513e028b0bbee 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -220,7 +220,7 @@ __be32	fh_update(struct svc_fh *);
 void	fh_put(struct svc_fh *);
 
 static __inline__ struct svc_fh *
-fh_copy(struct svc_fh *dst, struct svc_fh *src)
+fh_copy(struct svc_fh *dst, const struct svc_fh *src)
 {
 	WARN_ON(src->fh_dentry);
 
@@ -229,7 +229,7 @@ fh_copy(struct svc_fh *dst, struct svc_fh *src)
 }
 
 static inline void
-fh_copy_shallow(struct knfsd_fh *dst, struct knfsd_fh *src)
+fh_copy_shallow(struct knfsd_fh *dst, const struct knfsd_fh *src)
 {
 	dst->fh_size = src->fh_size;
 	memcpy(&dst->fh_raw, &src->fh_raw, src->fh_size);
@@ -243,7 +243,8 @@ fh_init(struct svc_fh *fhp, int maxsize)
 	return fhp;
 }
 
-static inline bool fh_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
+static inline bool fh_match(const struct knfsd_fh *fh1,
+			    const struct knfsd_fh *fh2)
 {
 	if (fh1->fh_size != fh2->fh_size)
 		return false;
@@ -252,7 +253,8 @@ static inline bool fh_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
 	return true;
 }
 
-static inline bool fh_fsid_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
+static inline bool fh_fsid_match(const struct knfsd_fh *fh1,
+				 const struct knfsd_fh *fh2)
 {
 	if (fh1->fh_fsid_type != fh2->fh_fsid_type)
 		return false;
-- 
2.43.0



