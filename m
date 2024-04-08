Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9118129A6F;
	Mon,  8 Apr 2024 13:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583433; cv=none; b=Kmw4Xn7ztJcrUKC969TV4CmftNdWrm/zDh1VHlSAvA3iOgMxA03dkM2E5cqfsgk+s4CdrSG2ZbJW8Mt/KEgbxCXGKsgJhX/1dBYFYoZFXE1Lm2Rg/q6weJZXPwL4FmJ7rloA3JM+aCfn5/EQxQMoIz8JFd7LwqiS/G9rSi8lA2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583433; c=relaxed/simple;
	bh=sYwnlPmHgR5GK1Mg/8HlJNpVPPqOM0b9NFEDQVafzoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRp5vFX0nuAOtFYfj5bM8wo3B2DKUXyPuAA33P/iIphaC8T9ATNDAX67fgzdqEpCph8jDrJSy9Ghvsh2kYhJM9M5cF/hWVF5i8Va4dRpe86ypsnKW/2ISjv5JXOWMnyWDNR8DB8oS0rdEbOaFDz76v3KXlAlVBs16aouM1ImPx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E8WzyEvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E8WzyEvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C467C433C7;
	Mon,  8 Apr 2024 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583433;
	bh=sYwnlPmHgR5GK1Mg/8HlJNpVPPqOM0b9NFEDQVafzoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8WzyEvlpg2iqJUPh2G+dSno9fD8LqXtr+j71jh+ffEnJD23KrFp6UAORSohHSrCY
	 xLCAZgOASAHZcIFdHwU9cZ42EBOEOJjDEUPL4OCbw22yKh+AK7FuP/y6jXn11KOqUP
	 oUXVY2GMR4lrnwV9hb5hCaw1KzzxiQkV4lPeXWfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 247/690] NFSD: Fix inconsistent indenting
Date: Mon,  8 Apr 2024 14:51:53 +0200
Message-ID: <20240408125408.572314874@linuxfoundation.org>
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

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit 1e37d0e5bda45881eea1bec4b812def72c7d4aea ]

Eliminate the follow smatch warning:

fs/nfsd/nfs4xdr.c:4766 nfsd4_encode_read_plus_hole() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1483cd1b5eed7..506ecfca2338b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4807,8 +4807,8 @@ nfsd4_encode_read_plus_hole(struct nfsd4_compoundres *resp,
 		return nfserr_resource;
 
 	*p++ = htonl(NFS4_CONTENT_HOLE);
-	 p   = xdr_encode_hyper(p, read->rd_offset);
-	 p   = xdr_encode_hyper(p, count);
+	p = xdr_encode_hyper(p, read->rd_offset);
+	p = xdr_encode_hyper(p, count);
 
 	*eof = (read->rd_offset + count) >= f_size;
 	*maxcount = min_t(unsigned long, count, *maxcount);
-- 
2.43.0



