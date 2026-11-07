Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061752;
	b=dCZQf6a6CSO2j1aFq7mbfhdcBt9ZvRbm80qdJAFhon4qdGCwUZtdLY28HFhf89UGI9lS
	 bDRtEKL+0qdTtT6qtqSaacHiwLXPpDGwfMUDrNNWaGtwiwVf8j+YzqdtVD/IHSx6iAo6O
	 qGqML/tNMZETX7+OWW9+Ec0NdcliAYiGpp5wm88BF2M9gN0OovCTLCfdG8bhi0sicvLlE
	 gLcwzql/ErBxzeZhgiA7ZhRBVJ52LJFXsXcdKTf3H8ITQVxgsA6S+NgAlxWQqZWB/HDEw
	 5QIyo1E2WZBREGk0ze0isldKY7fUo5i3NMP2eKuEuECf8d0zGLQ2XwS7fkrs1p0+7+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w++XAy6VixJZg3nZq3JZnnnzlqt5yRZgb/Cwq6OY7pI=;
	b=JHQSAagMxWQlkkG7UuUMVm1keR68nFVjl4y0XexSQ0FiOjL5tVc9yvMNIEEWNiZVUrs9
	 QKdREDwcn+z0NKd1YOR0GTY9WBL85DNfOrhCFWj6MqQTQQGWEOFI8OQKB7bQSFTESjkF6
	 Z2IIyn+d3QtobjSGktUr+08a4uLKfmcASfypOG04KmBKq/AJAk5fyYypnwlcShjWpr3CK
	 P9UQw1WdhSMSLc6oqmhGzxcb00OMWddzgNyiQANpjHhvxqVryPTOzoaxt+0c3cifKNKFq
	 UkaexwpjaycA7BMjtdZ3ktqo8tRRGa7Go6yjzxO5hkyAQdOgu7zb9cKQrHFzuPprKaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyc7eCVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA536606A326;
	Sat,  7 Nov 2026 14:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iyc7eCVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910F21F008A1;
	Sat,  7 Nov 2026 14:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061751;
	bh=w++XAy6VixJZg3nZq3JZnnnzlqt5yRZgb/Cwq6OY7pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iyc7eCVB7Hx/0R6+hOq8Cf/OdJ0tmlxqvbfZdDhFCmqjmvyYl3Zm8/V3t4L4RRR0M
	 IXLhSGi52abj5DK0KWWDymj6GxmDnJKNmmoLi8/Zh0fuxzHyUcaPjCGfKe9Rj1Cu2k
	 r85pTZUY8TnhXrfaLBEOKk5OqTP0uZwWrNCg/A5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0742/1536] xfs: never reset the default quota timer
Date: Sat,  7 Nov 2026 08:45:58 -0500
Message-ID: <20261107135018.365449530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -274,6 +274,9 @@ xrep_quota_fix_timer(
 	time64_t		new_timer;
 	uint32_t		t;
 
+	/* never reset the default quota timer */
+	if (ddq->d_id == 0)
+		return;
 	if (!soft || count <= soft || *timer != 0)
 		return;
 


