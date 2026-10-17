Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAB23B2FD8;
	Sat, 17 Oct 2026 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259308; cv=none; b=T4dPB83tf8tlsp5FVA53jj4B7aCInu8Vj7hlxnWTHwWLf9Du4Ai3hdV5clK4y49w9sTtpgbZE0BHA8cOZ1/kmgDRB7X2lYz4JPQrtsXqp+iO6dCjuY8Icax7jTKGwHusYsBELFh4MReXEU+XsVaOIW4RcLiRUrYM0lyGlhpl7cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259308; c=relaxed/simple;
	bh=qPDRbnIYGqXudiXbnHFRoTb+wrSge0ZhfwKvz6/DBmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PwsVtbIKqWfjW/2XxABLUR4kHwCNe1tjcySRrm/5Dw4OBnxQfXZPTxDmy0fiX8Id5KYnAS6sPykxEbLbw7ASIUNBtfvxt3H8JfoxjonAt5zr2jK7l6/VdR62KNAZ3pLvuGFiDzqaiOIuxnX+Z2NuWxlvUrShN9cIBN8qNnqwsJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CI7yZDWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CI7yZDWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F3D1F000C4;
	Sat, 17 Oct 2026 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259307;
	bh=NFr6S1FmTndq5XKArvLypALGYceUjatddq+miKtGVtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CI7yZDWglGBdxGaTpvOrl/4mq+K40N541CX/em4aEmvzcwp+9yvywl+D5ctC2aEja
	 swiqqJpxJHpvMvzJajJuty+kc3PYQ+eFCQiJ1nd9MslT3vnBvOU9r2PQkJ/6OYPqff
	 VXnvjn/btL4iaYsRmf41nYh3SZfeHfPZMWliv8TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianting Tian <xianting.tian@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1170/1674] vhost: correct misleading printing information
Date: Sat, 17 Oct 2026 17:57:22 +0200
Message-ID: <20261017160501.178173030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 76f408535aab39c33e0a1dcada9fba5631c65595 ]

Guest moved avail idx not used idx when we need to print log if
'(vq->avail_idx - last_avail_idx) > vq->num', so fix it.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Message-Id: <20240311082109.46773-1-xianting.tian@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 09861858a683 ("vhost: fix vhost_get_avail_idx for a non empty ring")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index fd8298490a31d..8bbf44ce373ce 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2591,7 +2591,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 		vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
 
 		if (unlikely((u16)(vq->avail_idx - last_avail_idx) > vq->num)) {
-			vq_err(vq, "Guest moved used index from %u to %u",
+			vq_err(vq, "Guest moved avail index from %u to %u",
 				last_avail_idx, vq->avail_idx);
 			return -EFAULT;
 		}
-- 
2.53.0



