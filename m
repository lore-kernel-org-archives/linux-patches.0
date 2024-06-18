Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D4D18040;
	Tue, 18 Jun 2024 12:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715526; cv=none; b=lSYo43H3XMRJeOkMR9gY9iXgIkVPo8h5i2L3vl1o8M7B0wZ74g8qbIJqF64RGk0Vpsa/o+MdMQu8fiWU0QT6MV2w8VhSvpaBwFPv9uuX81+eWIgLpLHtijI0e1eYtz3UGPyPTuUR0LNrO95Mr8KGX+n3tM6ycXAhFCDc+EtdHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715526; c=relaxed/simple;
	bh=/sozxjPwWrQY9P9aSPuAjzlfSB946VC3l2hWe+klI60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYh6pi9+bYarp0MQerjRgbpFtRpqKVWRokENT8ebe9ukXfX3OSeTb2TMSkJnvlOSjv5KXonRTgY/TOph/q5n7UWf0zVduITmrdRp2hqG8Tf4WyAT13Ya4wR+vmE0D/WosoDKah1xFzY/QGWu7n/ByzwwXMkPmKnrwrzMuJQmuhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlrB8MpC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlrB8MpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FEDC3277B;
	Tue, 18 Jun 2024 12:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715526;
	bh=/sozxjPwWrQY9P9aSPuAjzlfSB946VC3l2hWe+klI60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlrB8MpCI0FxR2umfSm2aTMK0fJlXYiG37wVgS6YfEkBfE22Yd4+TsLpAW2vPiP5G
	 Qxd/KdwAt/BMvjvKI4KvYzihF16eDO+gMSRZXY/Wb0kROw5av4jcxb+PnSQYetoZPA
	 eRF8tGJuzMYdyk9A1WzEdHKaTbc7l+mTXi2TkckY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/770] lockd: Update the NLMv1 void results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:44 +0200
Message-ID: <20240618123419.263393987@linuxfoundation.org>
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

[ Upstream commit e26ec898b68b2ab64f379ba0fc0a615b2ad41f40 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 091c8c463ab40..840fa8ff84269 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -331,6 +331,17 @@ nlmsvc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+
+/*
+ * Encode Reply results
+ */
+
+int
+nlmsvc_encode_void(struct svc_rqst *rqstp, __be32 *p)
+{
+	return 1;
+}
+
 int
 nlmsvc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -363,9 +374,3 @@ nlmsvc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 	*p++ = resp->status;
 	return xdr_ressize_check(rqstp, p);
 }
-
-int
-nlmsvc_encode_void(struct svc_rqst *rqstp, __be32 *p)
-{
-	return xdr_ressize_check(rqstp, p);
-}
-- 
2.43.0



