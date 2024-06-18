Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AA81741EA;
	Tue, 18 Jun 2024 12:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715440; cv=none; b=MnNhOUTteWihOrDx1Q23G3X12YXTSFkh382Iqxq9cw+2OH55Xqw4CQ9whtzP6NdA3vpkfcd4yo+ZgpGLd7Cv30vZ9ClguMfRI0cLe4LuYB6xisCU0MWUCqGYqjuWTAqqXgjNSb5bsO7u5uOzrM96nXWF40+iuJrMsUZcGnXytig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715440; c=relaxed/simple;
	bh=JN6CL/JdJWMr0gWirt+HcG+QlFZD6nJYHLegaWow9Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qscDY8E5O0HsEn8jNL+1lgZ9/7D8cdXGrYnoUuk3dfuEzz9mEgGgQSrEH+JZBT5GCcdJAygxZEBTi5gCUsuR+eaq5lej+b2TuyFccyWz2AeKUjFtEK14BvnYaca45C5o0ve/JAna+ean9tbo0Qo72hhaia/FoCyl45h0Ruxm3RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gD6kKjS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gD6kKjS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C877C3277B;
	Tue, 18 Jun 2024 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715440;
	bh=JN6CL/JdJWMr0gWirt+HcG+QlFZD6nJYHLegaWow9Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gD6kKjS4ycuYTURoPerNRp6/7yQBbkNlfGXf64kC1ilPIrnJJu8OfTnedOuWCAQcg
	 TiNCjRuIdIy8aUUakrA+G6vESEIOSS49+oWzrokFu4L3yWTTpF05acG9HqsXuTinx0
	 t56+uq/X3zLJ9eK/4c9IZ4s6Lw2gIi55hH7AjjP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/770] NFSD: Constify @fh argument of knfsd_fh_hash()
Date: Tue, 18 Jun 2024 14:32:11 +0200
Message-ID: <20240618123417.997180968@linuxfoundation.org>
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

[ Upstream commit 1736aec82a15cb5d4b3bbe0b2fbae0ede66b1a1a ]

Enable knfsd_fh_hash() to be invoked in functions where the
filehandle pointer is a const.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsfh.h | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index aff2cda5c6c33..6106697adc04b 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -225,15 +225,12 @@ static inline bool fh_fsid_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
  * returns a crc32 hash for the filehandle that is compatible with
  * the one displayed by "wireshark".
  */
-
-static inline u32
-knfsd_fh_hash(struct knfsd_fh *fh)
+static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
 {
 	return ~crc32_le(0xFFFFFFFF, (unsigned char *)&fh->fh_base, fh->fh_size);
 }
 #else
-static inline u32
-knfsd_fh_hash(struct knfsd_fh *fh)
+static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
 {
 	return 0;
 }
-- 
2.43.0



