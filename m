Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797E56FE35;
	Mon,  8 Apr 2024 13:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583127; cv=none; b=TsXOl+gcR5QjjjElAN+mwyFYF3ZmfhVcUdrQVZHXmkrZ5rQ+aJ5RpGFxAYys0xe0DFL8AjbLgUnyin8WfTSV6pvZCQPNUPJA6sdmRzCVlIW3yC7o1h2w8q5bdlX85KjylTth5o5XaAu9ah/Oxd5A0QCr6rU33Xl0doNv3VdQ1Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583127; c=relaxed/simple;
	bh=1N0R7l5oWX039hIEeuj14zIdLKuIBaYcCgNoElrEEho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEVsMJIu+3OfeWKHoT40aiELrXWyaCK1KK2O/Z7sKAQ6qHfcqSU6we1Uu1k1r17IflPPb/j1k40QUmiPPER1XkYCNgPqw6yplrBU+mfRrCHsUw6QncIx9EzjbswjrWOoA76kELSC3XhhrA1MpYVy9F1dOlvMQ8L67nSjwtYDM28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfAcp7Fv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfAcp7Fv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019A4C433F1;
	Mon,  8 Apr 2024 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583127;
	bh=1N0R7l5oWX039hIEeuj14zIdLKuIBaYcCgNoElrEEho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfAcp7FvHQ/ptWHlSkkzX8fCRRjYHnR3uK659383ifIKKWA4TYxXyNATSdygCNRMw
	 cqg2Zs9mVm7kS6CRYjGCnFuPRcQJNS+jSunlhFHgFEOzcL3t705fFshKs0t7SMOneY
	 QCnWlt5M7cIJ0MSXnOQEsCDcikDneEAhlO4OlELg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	Changcheng Deng <deng.changcheng@zte.com.cn>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 210/690] NFSD:fix boolreturn.cocci warning
Date: Mon,  8 Apr 2024 14:51:16 +0200
Message-ID: <20240408125407.134281408@linuxfoundation.org>
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

From: Changcheng Deng <deng.changcheng@zte.com.cn>

[ Upstream commit 291cd656da04163f4bba67953c1f2f823e0d1231 ]

./fs/nfsd/nfssvc.c: 1072: 8-9: :WARNING return of 0/1 in function
'nfssvc_decode_voidarg' with return type bool

Return statements in functions returning bool should use true/false
instead of 1/0.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfssvc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 7df1505425edc..408cff8fe32d3 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -1069,7 +1069,7 @@ int nfsd_dispatch(struct svc_rqst *rqstp, __be32 *statp)
  */
 bool nfssvc_decode_voidarg(struct svc_rqst *rqstp, struct xdr_stream *xdr)
 {
-	return 1;
+	return true;
 }
 
 /**
-- 
2.43.0



