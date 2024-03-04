Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2A31EB5A;
	Mon,  4 Mar 2024 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589039; cv=none; b=c0dDPXheXM6Y5edd245pwlYj7ruiz+1brN4naXS+5VsBwqWqEhUm+JUY5dTdjzMEx4aComchfykqyuTXUPbtjmluZ0W16u1GUAyfgw7/nhZgWoYiLfiA2L30NeS+8OhfVXHoC8xnN5sGQi1s4YahWyApP4u7NpW+UTQ4gyaaiJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589039; c=relaxed/simple;
	bh=4Gx/BfkJADYmXqlxq2RgaCdTxZU3uNI4ySTqPmYAtmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=autmIrH+/KU1KDIm1M1PN40Tqjb2A5SuL9ZN/IkQ50OBhEtwGDR1g1ziPbpgf8elDw7tTNZnsTkqOnBp9srOQ1FC19bXuf599+nPg9hCTXTdJEuszFMYI9JKwXIcTXMSaWKEzq4IQZSEpcQEpQyFxPuhFb4sGouLGJpQBgqbanM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWmFzwX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWmFzwX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1F3C433C7;
	Mon,  4 Mar 2024 21:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589039;
	bh=4Gx/BfkJADYmXqlxq2RgaCdTxZU3uNI4ySTqPmYAtmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWmFzwX6YHq6UyY5FPTtA7YZ19u1vxsjufX4DSOMX0KXo6dPzydbzFLqZB1tL8O26
	 LU0YkH4sOu9ZV5PT0EvExjkp9QC35eOEgdbtBphpNmnZzhra6CmEnIPd4OVQeWCjJq
	 aX0auvhc4pq8AdtD8XSZP3KZfh+5ZJlybSgK/Dtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 6.1 153/215] NFSD: Use const pointers as parameters to fh_ helpers
Date: Mon,  4 Mar 2024 21:23:36 +0000
Message-ID: <20240304211601.872485443@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b48f8056c034f28dd54668399f1d22be421b0bef ]

Enable callers to use const pointers where they are able to.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -220,7 +220,7 @@ __be32	fh_update(struct svc_fh *);
 void	fh_put(struct svc_fh *);
 
 static __inline__ struct svc_fh *
-fh_copy(struct svc_fh *dst, struct svc_fh *src)
+fh_copy(struct svc_fh *dst, const struct svc_fh *src)
 {
 	WARN_ON(src->fh_dentry);
 
@@ -229,7 +229,7 @@ fh_copy(struct svc_fh *dst, struct svc_f
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
@@ -252,7 +253,8 @@ static inline bool fh_match(struct knfsd
 	return true;
 }
 
-static inline bool fh_fsid_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
+static inline bool fh_fsid_match(const struct knfsd_fh *fh1,
+				 const struct knfsd_fh *fh2)
 {
 	if (fh1->fh_fsid_type != fh2->fh_fsid_type)
 		return false;


