Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B36E13B79B;
	Tue, 18 Jun 2024 12:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715319; cv=none; b=RIc2tRSWJPJOmLVDlTEB3ojS+y+7baeQf27tot0iCP9HUJJ6+k1Mre7edInLCm9Zn+eC/SMsjErFT3WI3QQTBMGc5wL9sbVj+69+VbaYSZtChVEusvRNWVhyITQkyYCOHoTjQ5Jq8mZGkEtQ2OUHBqJFgc1oKhh84Ny2c9+34xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715319; c=relaxed/simple;
	bh=PPdgHVi3Vs4T8f3IiDvE/1b9hyvCm8UWa1RmP7Y1ZkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRWDjLzXVitlH953pnp3E2Rt70LL/Ol2Ds/iOsgWwjeIB99SKGGMEBtSpgUhmrWZRo4smG4O47CMVT4hiAdj6Ai50xg+S1oVtWfgL8OKt4BgKkBD9PUqaCeAS4i74yLZZ9hYPfHmih1Shp+2BMcrmsvTgKGk14V6m2sh35aaryI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBzCVKHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBzCVKHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DD9C3277B;
	Tue, 18 Jun 2024 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715319;
	bh=PPdgHVi3Vs4T8f3IiDvE/1b9hyvCm8UWa1RmP7Y1ZkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBzCVKHSR0mVwD/dhwhkaYVJtPLFr6/L/Wdf6V4wjgDr19gV+pBSma+QmY6VoDzGs
	 57td58i1c7Jc6j4Gdw8cy65aOBlTgPw/TVJD5qBBkAWbhHgKMk9SJJkvX52A03byJG
	 xiFTfnADkO/YrKm6/cXSy4x8jThqs0xGllrDXLH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/770] NFSD: Add an RPC authflavor tracepoint display helper
Date: Tue, 18 Jun 2024 14:32:01 +0200
Message-ID: <20240618123417.617732157@linuxfoundation.org>
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

[ Upstream commit 87b2394d60c32c158ebb96ace4abee883baf1239 ]

To be used in subsequent patches.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index d20ab767ba26a..3ec6d38fa5318 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -841,6 +841,22 @@ DEFINE_NFSD_CB_EVENT(setup);
 DEFINE_NFSD_CB_EVENT(state);
 DEFINE_NFSD_CB_EVENT(shutdown);
 
+TRACE_DEFINE_ENUM(RPC_AUTH_NULL);
+TRACE_DEFINE_ENUM(RPC_AUTH_UNIX);
+TRACE_DEFINE_ENUM(RPC_AUTH_GSS);
+TRACE_DEFINE_ENUM(RPC_AUTH_GSS_KRB5);
+TRACE_DEFINE_ENUM(RPC_AUTH_GSS_KRB5I);
+TRACE_DEFINE_ENUM(RPC_AUTH_GSS_KRB5P);
+
+#define show_nfsd_authflavor(val)					\
+	__print_symbolic(val,						\
+		{ RPC_AUTH_NULL,		"none" },		\
+		{ RPC_AUTH_UNIX,		"sys" },		\
+		{ RPC_AUTH_GSS,			"gss" },		\
+		{ RPC_AUTH_GSS_KRB5,		"krb5" },		\
+		{ RPC_AUTH_GSS_KRB5I,		"krb5i" },		\
+		{ RPC_AUTH_GSS_KRB5P,		"krb5p" })
+
 TRACE_EVENT(nfsd_cb_setup_err,
 	TP_PROTO(
 		const struct nfs4_client *clp,
-- 
2.43.0



