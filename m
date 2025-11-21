Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9E554763;
	Fri, 21 Nov 2025 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731390; cv=none; b=g0H7V7Dsd61MB4OmGEDNf1Xmg8wTixRCiRBk2twI/4ioecCUQXGOas8lhiqA1xUEwyAmZiVGKmfOexF1ZDXitq66soA2XZBmRlQOQn2oS1/LIRgAbEJclUsSoootKlFiesEOJrIqLf4kZcdQb1ShFD1Bavm8YL3zuZ0yAoxH7rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731390; c=relaxed/simple;
	bh=ET9WeM/Y5CoaEuegTx/s7Y1V+VoUucKv2Zpf7WMt+Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2t+no4phDrzfvL5evCXVO8fSIqM54MHDMNabV0iYwZz+S5hfqFTN+Rbbk0GLb8cefvftr4GO9XGzK1thGYjDLDnxMnnSbr4hHfT1ns9xJBD9A6AjWOmle3GnZQa7K8Z3nPuBxuEKWA9M2V/GzolzUkzZHeAROPfAJsZRC1d5B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gkp2sgjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gkp2sgjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBEBC4CEF1;
	Fri, 21 Nov 2025 13:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731390;
	bh=ET9WeM/Y5CoaEuegTx/s7Y1V+VoUucKv2Zpf7WMt+Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gkp2sgjoOaHQadU8/Dqbo+jIXEf5uR7IcnfnIy6ox5XDWacdFulScgKlzapAaugKY
	 wvoLeBQjTmDz2ZmHSX3fTC3hWoIhUCHOHnB5ZEr+raEfFafv7U458Ed62tcPnkpqcm
	 w/2L4IgPuY6c8FLOprOkcpc0e2Yx88+byqTdDVD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.17 159/247] nfsd: add missing FATTR4_WORD2_CLONE_BLKSIZE from supported attributes
Date: Fri, 21 Nov 2025 14:11:46 +0100
Message-ID: <20251121130200.428483872@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -455,6 +455,7 @@ enum {
 #define NFSD4_2_SUPPORTED_ATTRS_WORD2 \
 	(NFSD4_1_SUPPORTED_ATTRS_WORD2 | \
 	FATTR4_WORD2_MODE_UMASK | \
+	FATTR4_WORD2_CLONE_BLKSIZE | \
 	NFSD4_2_SECURITY_ATTRS | \
 	FATTR4_WORD2_XATTR_SUPPORT | \
 	FATTR4_WORD2_TIME_DELEG_ACCESS | \


