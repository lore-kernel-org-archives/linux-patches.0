Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802CE2D8782;
	Tue, 16 Dec 2025 12:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888197; cv=none; b=Ha0BxARylNvYYy3SA/4Ubbmy7GnnFNhhqtEGC3i+zT3bMagRG/cmTGw1flYPBRJhnybWDOb8Ue0K30tIhPWB1PgX0M2gS2hsVoCeTCGmZWYtltA9qrbDD/s1t1ptooE4iz4/Z9ZsXkP1fFt+JEyUZ7Pa2zUp8DGb06r1l+cYSww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888197; c=relaxed/simple;
	bh=H2NUDktfKzHcEGnGedtQZtHBCIQM+eU4PdItUUPsBNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL1+DqqcdxyycUiC6s6eVuA2By7bZUZAo2MTbDc1iMVAamcDRVJfDu5Cf09G7xzG02N8Ik3a2tj+x+weJbCm096d92YqG8HYmIuYOfL92e06vHttxJPkEVeMyAw6yLQ0WoSGlr9pN8HhHAsqQvtZpC85Mr83RdaSc2/KyZZZ8ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uH23GF7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uH23GF7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4451C4CEF1;
	Tue, 16 Dec 2025 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888197;
	bh=H2NUDktfKzHcEGnGedtQZtHBCIQM+eU4PdItUUPsBNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uH23GF7TGAGjPp14YGWV9CTPpVk0drcaWX+IhL5eQSFW0t50FEUkE+GM8k9k34o68
	 KBOLRilcn3qi6TKP+aNej3mfd7ShA2S7LHt4OpCXaZN6f1PH6Fs4KdTz3dLiEQB4lo
	 F76QO0833xAa38pOPb9yR2PZyHaNEPRbTKw62lVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 462/614] virtio: fix grammar in virtio_queue_info docs
Date: Tue, 16 Dec 2025 12:13:49 +0100
Message-ID: <20251216111418.107632677@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 63598fba55ab9d384818fed48dc04006cecf7be4 ]

Fix grammar in the description of @ctx

Fixes: c502eb85c34e ("virtio: introduce virtio_queue_info struct and find_vqs_info() config op")
Message-Id: <a5cf2b92573200bdb1c1927e559d3930d61a4af2.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index dbc7eff1f101f..78cf4119f5674 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -24,7 +24,7 @@ typedef void vq_callback_t(struct virtqueue *);
  *        a virtqueue unused by the driver.
  * @callback: A callback to invoke on a used buffer notification.
  *            NULL for a virtqueue that does not need a callback.
- * @ctx: A flag to indicate to maintain an extra context per virtqueue.
+ * @ctx: whether to maintain an extra context per virtqueue.
  */
 struct virtqueue_info {
 	const char *name;
-- 
2.51.0



