Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618281;
	b=EM1H/fEPPuWYbl1uHgXus6mfnT9ukZEpduQJaFgBAcSMJJAyGeZv7LrTdP5hb79yjgxR
	 SgfaeqSa312PrXUkOI6abx5DAb1i57TIDN2rNwk7f1yptE80bKEaJ13wM0u0X6bYAT9XL
	 VlPPfr+ZU8uaM8zFaO8eGmMuIJmAY3p3WCKAAdpditg1dhkFDEOPqHeXIixHyU8MHc/C4
	 hAjDNUfauOTGUWaIuQPIdRuMahHB/N/kJyshuC30829bAB7NyI9nOkzmxYukPkldqZh9K
	 7xdMcu8LfLrYjCvG2OfN10LRxHjbO3YFtKCrfdZTwM3IMvXxNpj5FQu6N+QTASCHkgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=papwZLwl5w/BytwQ+RjRuSW83GcZFfdbsoiy6M6tWpQ=;
	b=NJKQaupilUTxTQ7GM5GehMHcZtFMxoWFPYyujOI7W95yLFudqY6gh69hqHt9O3hKN68V
	 IPQj0IYj+NCKYFgFoH0IcCwMfIu5S1AdS3g0tTQf7MT7ESV7IivZvTN+yIfvsF8E69OmJ
	 cvW0tqVLtJ0xTCPcwrozUTDqNg2JDmsq+Ha7bgWFgdpSD6ZybZZer6heI1JuH50G2oqsW
	 I1xpKEYiDre+mE82U+crXUcjGwjMiTFagdgXl4pH/zB4iZKvOXaG1KAnPVUECZMK0ZuDB
	 qCnPPvDd6k45n064nPHce7RAJb8+Cn+K124S2GmG/1xyn6lXlO/hkWAIqSyWIc8d4VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t/ejP/6T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD2D606A31E;
	Wed, 25 Nov 2026 14:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t/ejP/6T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F3B1F000CA;
	Wed, 25 Nov 2026 14:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618280;
	bh=papwZLwl5w/BytwQ+RjRuSW83GcZFfdbsoiy6M6tWpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/ejP/6TnsVCbWLSBy0aOt7IICRZd9nKk4y8h+mA9pyP8ec6+Qp3ZFD3DDzQE6bWF
	 hWqye99yn5C29AaE2H0wEEweox2mJwvK/wBg4vnmSFjQAKvp/veaqj3y95VhLR3dxL
	 A1MmTGGmhDTRDb5gEBuymtTX/bZlTgMkvc+F+FrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0231/1005] vhost-scsi: reject delayed virtqueue setup
Date: Wed, 25 Nov 2026 15:26:09 +0100
Message-ID: <20261125143827.151695141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit a543346b96a174fcee6812ac2764acc8dc993358 ]

vhost_scsi_set_endpoint() allocates command pools only for I/O
virtqueues that are already set up, but publishes the backend for every
virtqueue. Userspace can complete a skipped queue after attaching the
endpoint, then kick it with scsi_tags uninitialized and trigger the
alloc_hint warning in sbitmap_get().

Delayed virtqueue setup is not supported. Leave skipped I/O virtqueues
inactive and reject changes to the vring size or addresses while an
endpoint is attached. Userspace must clear the endpoint before changing
the vring configuration.

I found this bug myself, though the patch was written with AI assistance.

Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
Assisted-by: OpenAI-Codex:GPT-5.6
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261010-fix-warning-in-sbitmap_get-v3-1-33de562d1359@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8a32687f7424b..1274e7734747e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2135,6 +2135,9 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 
 		for (i = 0; i < vs->dev.nvqs; i++) {
 			vq = &vs->vqs[i].vq;
+			if (i >= VHOST_SCSI_VQ_IO && !vs->vqs[i].scsi_cmds)
+				continue;
+
 			mutex_lock(&vq->mutex);
 			vhost_vq_set_backend(vq, vs_tpg);
 			vhost_vq_init_access(vq);
@@ -2496,10 +2499,16 @@ vhost_scsi_ioctl(struct file *f,
 	default:
 		mutex_lock(&vs->dev.mutex);
 		r = vhost_dev_ioctl(&vs->dev, ioctl, argp);
-		if (r == -ENOIOCTLCMD)
-			r = vhost_vring_ioctl(&vs->dev, ioctl, argp);
-		else
+		if (r == -ENOIOCTLCMD) {
+			if (vs->vs_tpg &&
+			    (ioctl == VHOST_SET_VRING_NUM ||
+			     ioctl == VHOST_SET_VRING_ADDR))
+				r = -EBUSY;
+			else
+				r = vhost_vring_ioctl(&vs->dev, ioctl, argp);
+		} else {
 			vhost_scsi_flush(vs);
+		}
 		mutex_unlock(&vs->dev.mutex);
 		return r;
 	}
-- 
2.53.0



