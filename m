Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828982;
	b=ccfArWowiKd+5akFPFG4NLk4YlJp+o5egJZe8L1qwKQFQY/tkPbVNzQiuAWm64FS1dMz
	 PYn6nQM/QbotsEsO6FeKNTWZ0NbVrNNlB3BPA+uvOfT6YBdIJSxL7RWrb/MLXbQnrMvXO
	 ayC3tg5qqt2aB3vSrKqbNKtBmOTV3YiV1sP6kY+ZA1X82AKllFCl7yWUeVttZFWl2S/Pu
	 Q9DQeRPkQVRdiTzQ+oJpcRGvWBcvj4vf2VwL1brWTaG02eRaeCYLP72tionvr+OiwXGhz
	 Z/C/L0vGBQTMnB99j5VbwDtaZ+10CH8Gj4vdJkQygI+dE6oIumCcfkM+ejuYGydaXuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KvhpsYXJPyh3uKkM2TSR9pjEM9RkRCe0Y1rQ4HhoGVw=;
	b=ZopTdzQKZkba7VuVfoyGN0qAECDkQBS9OKetzXgOjXqMG4n7k6xqg4w+cvwHlJpiFf7n
	 +AF6jjxdyK43HR7DmgccUxC05sWDjgERreKMCNY/gUZQFRBJOpwHS/q8uL6VkEHKBT+2Y
	 fqR/SyvUo52PSW7WU59Ab3Iu2hWJpI+XTU4mFCofguZ9+k7A8lrJiHRlvv7lu5CoW+9AW
	 Tn+uAPZq+WTc7NxuZ1W8cW1nIQBdYFC705XL2Sn66Gwyz8ukKiHEbB1rriFvtdAxeab4L
	 LWYHb1qMdxD2lkAhhDTx/CjQtGj6nMMPFgZAv8LFiqEPbLYbDRwhOSwPt4Iz6YaE+Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xS+icQnE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BBD6070742;
	Wed,  4 Nov 2026 21:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xS+icQnE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAF71F000C1;
	Wed,  4 Nov 2026 21:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828982;
	bh=KvhpsYXJPyh3uKkM2TSR9pjEM9RkRCe0Y1rQ4HhoGVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xS+icQnEb+Bnx2dY+EGIEx9lmJv8JJPwxMy43ebusqgRhJo1w0rFvIf7ELAmjcXvc
	 hDPswSRp+1llmvLk1D7HLN+M/cah5Fg8skEGPxaOiBEBM+k/5uEelEHm9lzG0h1Io7
	 UV2zFBP54WdpQueUk3NBLPqWxgIO88Gl4ILqr9tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 368/547] xfs: never reset the default quota timer
Date: Wed,  4 Nov 2026 16:09:12 -0500
Message-ID: <20261104211048.749433106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit ddf4fe30c3fd7d37cf9bad3887ddb69984954cf4 upstream.

LOLLM notices that xrep_quota_fix_timer doesn't check the dquot id,
which means that it can inadvertently reset the default quota timer when
we really meant to ensure that a (non-root) quota overage timeout has a
sane timestamp.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -272,6 +272,9 @@ xrep_quota_fix_timer(
 	time64_t		new_timer;
 	uint32_t		t;
 
+	/* never reset the default quota timer */
+	if (ddq->d_id == 0)
+		return;
 	if (!soft || count <= soft || *timer != 0)
 		return;
 


