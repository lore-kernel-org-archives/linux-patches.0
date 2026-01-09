Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94002DEA6F;
	Fri,  9 Jan 2026 11:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959933; cv=none; b=Hg71Z8PeXirY4z8QABq37Htu+lef0CCA1u3nzViUtMK2qg3Y+pX4SHU4oooO/I5IbWA4yqtHJA6R9NAwlqXs151GNsYeduCmaAuaZnmoDF2s9Bfxrl0uTodWf2phPguwcfgBABsJiS99wt3rWcJCi6XJGd2g9+Ij1qtwOH7TfyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959933; c=relaxed/simple;
	bh=mvaeSg5r0fD2mVTNHHltLlVnPsL7+vOPnl0+chKkCVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5Pgt389pJXvKev7TwOK2Iqzg73UjIC3FbN1aa+72SSaN14y4ocmpzfKgTmgoKqBKkgnKJ6Nx9U0EmRkW5ZhKPDjsH6ZOd5tET6Ob4tTtcHL6Zvs0Ff4/sI+9z8+f9Sdnag/m+AqqeShAeEba9nLiRdpj6AiVLeVnCG+mkDpye0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7QyZYIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7QyZYIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1BEC4CEF1;
	Fri,  9 Jan 2026 11:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959933;
	bh=mvaeSg5r0fD2mVTNHHltLlVnPsL7+vOPnl0+chKkCVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7QyZYIGCn7ecePSIU+jeiAG42RTd16rHrZa+Ac9aAZmxLQA/7ERlzWTFpl8s91My
	 5rTutwUjZUv8CvuY2BpvB1ZBBRO2m2krzRROaX+S/KgyxBAAj73c2tPp1LHUK9nJkA
	 QEtEb/PNwO5I3o113IQbJwYPeEURpuhh/cdOT6LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/737] virtio: fix whitespace in virtio_config_ops
Date: Fri,  9 Jan 2026 12:36:06 +0100
Message-ID: <20260109112142.539881349@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 7831791e77a1cd29528d4dc336ce14466aef5ba6 ]

The finalize_features documentation uses a tab between words.
Use space instead.

Fixes: d16c0cd27331 ("docs: driver-api: virtio: virtio on Linux")
Message-Id: <39d7685c82848dc6a876d175e33a1407f6ab3fc1.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 84a9fd21df3e8..f106d3177476b 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -71,7 +71,7 @@ typedef void vq_callback_t(struct virtqueue *);
  *	vdev: the virtio_device
  *	This sends the driver feature bits to the device: it can change
  *	the dev->feature bits if it wants.
- *	Note that despite the name this	can be called any number of
+ *	Note that despite the name this can be called any number of
  *	times.
  *	Returns 0 on success or error status
  * @bus_name: return the bus name associated with the device (optional)
-- 
2.51.0



