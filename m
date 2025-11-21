Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2E25F7BF;
	Fri, 21 Nov 2025 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731875; cv=none; b=QBNfG1IZ5srU+F2m2SZNfdyLiLy6XgvDgu/n0c6pKmgR8mNczeh02N3jz2moEV74kmQUExOO5OU7yLftbDNrX91U3EOUu65VIVVd7o3aosDQ0FBYrYTOEMOOyaaeCmMQkWNSB8o/k1H/YFDQg2aJhohYejUzKvVjv7pMQmyJ7h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731875; c=relaxed/simple;
	bh=uYqKYx+OW8wzBkvrHlNxn5CipID/3HNIgRgLDgG4tpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWq1BKCWssv/clGVrG80bx3IQf9NO3tUa0hPBDStoacjvpBbahXu12kPSMJiBrEwVFn2UkrogoS84xRnQabWExFujZVSjb5TYlqzdfORs5Oc0oJQdOwKElGc5hM3QoGa6LhBh2ktl3LWSJD1hfvYs1wlevbFw8XzamcVJSj2Zdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baS5vYaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baS5vYaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801EBC4CEF1;
	Fri, 21 Nov 2025 13:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731874;
	bh=uYqKYx+OW8wzBkvrHlNxn5CipID/3HNIgRgLDgG4tpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baS5vYaBKFPuX+rrW8vmWtbKw2WdY6adC9tfCbFzXHDRrD6GBceCS4KV4Pk43cxRt
	 oj2Q3Nc1b59b0wmcI3QsCcHQt3dAhJ6ox49iBYDb1z3ZX3cV6xYd3S3MXlz5BIxVWc
	 Cx3zexieD6BQirZ06z+5gu+JEHSPzk8FsGFxl0bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 111/185] nfsd: add missing FATTR4_WORD2_CLONE_BLKSIZE from supported attributes
Date: Fri, 21 Nov 2025 14:12:18 +0100
Message-ID: <20251121130147.879751493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit 4d3dbc2386fe051e44efad663e0ec828b98ab53f upstream.

RFC 7862 Section 4.1.2 says that if the server supports CLONE it MUST
support clone_blksize attribute.

Fixes: d6ca7d2643ee ("NFSD: Implement FATTR4_CLONE_BLKSIZE attribute")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsd.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -458,6 +458,7 @@ enum {
 #define NFSD4_2_SUPPORTED_ATTRS_WORD2 \
 	(NFSD4_1_SUPPORTED_ATTRS_WORD2 | \
 	FATTR4_WORD2_MODE_UMASK | \
+	FATTR4_WORD2_CLONE_BLKSIZE | \
 	NFSD4_2_SECURITY_ATTRS | \
 	FATTR4_WORD2_XATTR_SUPPORT)
 


