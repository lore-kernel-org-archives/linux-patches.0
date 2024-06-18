Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3EB145353;
	Tue, 18 Jun 2024 13:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715713; cv=none; b=pgpdkMDaKaBRY/MAi/LXjIq5YQI2YOpnYz9Vu7cafbmCtfP3J2x+D1k+oj+sUvNQJlBg577AhN5FKrvh+9ZhM5CW1IJSID45jwPFELwNVfNfJlnuEs326zMFFdyliGQxt6zkHWY1hz4Xnrio/rycXnez8SJGmABi1Q3FOJAdo4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715713; c=relaxed/simple;
	bh=TUxjVxIsTJQOrQ07xPAapz9f7DdJhuwpixJ3DUi85A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLAghrNVmPzqnXCfvNmnCFKhx35IEQ2Fix96y372adHfYIEOEYNt7Fv4ed6CYYtcgEFWPfMtu2bFvLJHjipJ3QHsaHXZzFEdSZarO9FhhjoAt3pfBtrrZwXPakKjnyq1ZONxLP0qhXbxr8ZiPOHIihifK/uNdyUxqmrCOpic2Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cbDvRreO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cbDvRreO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C7EC3277B;
	Tue, 18 Jun 2024 13:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715713;
	bh=TUxjVxIsTJQOrQ07xPAapz9f7DdJhuwpixJ3DUi85A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbDvRreO98w81hUc2SnNnAaYUkLQhSzcQn5oH+KY0Cjh1RsUYssysISBDFMhHOruW
	 Gc+m5sC5mOVaNLNvkPXtY00zlTcx5UZQ561X2f7BptiqPXdIsntpl85FiSHTdmLx/L
	 mM8UC+jDTTLjLruE21jItt+iAux9iZiVB1OD6XP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	Changcheng Deng <deng.changcheng@zte.com.cn>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/770] NFSD:fix boolreturn.cocci warning
Date: Tue, 18 Jun 2024 14:34:14 +0200
Message-ID: <20240618123422.762177795@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



