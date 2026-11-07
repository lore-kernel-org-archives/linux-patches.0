Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064319;
	b=QrrQyY1ho1a1Sx25fIbW6jR/2C027K0teqhCfezMuw8HQAp0HNchJR1oY2N0/tSaetNs
	 yGyfE2s3Jrx7IQKbNU/04QDk2qCO/TEX9hYTxzAwT03EXoNHmV/6M9bKwO4R7CAK4HmFt
	 O3KBFSzereQIMjsAIfcof5gYsSMWurqWDPAKopIrlTCqyVrm9r1Ed0pVLQ/NFpby2vvBy
	 Ekq/q+fW8gN721utsrc2uNU//aUCVGjiF6+BQVEtFy8lCuFv7HWIYPCzXRESXl8RkoV/s
	 zaV+GMyM5EYgEkHPtYRPHIN3kqdX3yg17Lya/xPgfFWuTt6EJI8w7c4ZFXNlPGj0zEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJXkxRQHv4aEVJZNuFWd2ICaE/uuHKILSqKD7ffxy9c=;
	b=xhduFQb7L/4VEe6QU30t5Bzg4mG0inbH8e6+LA+XPatZfQtjlkSek6uDinr3nO2aw3kw
	 MvVZU0jsCHFAqfcno6XmNVNF59igZ7IHF56/WB2PF4U9wsoS51wh7cOQQ7kgb+oRYHcpz
	 S6+83xulJsKEWNK5pixMe7k95lWU/olgdBTGfRoixmL/k+adIP8zSb5I15aj7u4+RNkts
	 OR9zBuJ1UAOXMm61KFwamvKA/0d6utzPl8yj8BaUSKvVLHNoLN1EENIFCrS0AdJ15X4Q3
	 hwH+NAawkBiUCIySY9NCP+g+WeWlp0S0H+6CAkpj59/z4F/RsyT61Js9X3lrJEi1l4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZjFGjTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8F606C028;
	Sat,  7 Nov 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JZjFGjTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B551F0089F;
	Sat,  7 Nov 2026 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064319;
	bh=GJXkxRQHv4aEVJZNuFWd2ICaE/uuHKILSqKD7ffxy9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZjFGjTp+kOtwpZi71RFhe+r7EhfNhP+SaW8OqzlXTAxOUNsjbF/+NtZH2TGd6DzR
	 R5nwZTjgcuxUNbrDXu6gO6F/BUQL64SrSHZZK8DY54TREktA07JBQ3YOGJ+Cck/u3/
	 Sxia8B/53qPYJUfA7T1X6JGATN0BmHLZzE1vikHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0407/1257] media: mali-c55: Check the parameters buffer address before copying
Date: Sat,  7 Nov 2026 08:45:03 -0500
Message-ID: <20261107134950.763985440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: David Carlier <devnexen@gmail.com>

[ Upstream commit 901d72d26b6dc135a41e3901b4690de124665d18 ]

mali_c55_params_buf_prepare() copies the parameters buffer supplied by
userspace into the driver's scratch buffer, using the result of
vb2_plane_vaddr() as the source without checking it. The queue accepts
VB2_DMABUF, and vb2_dc_vaddr() returns NULL for an exporter that cannot
be vmapped, so the memcpy() dereferences NULL.

Reject the buffer at prepare time instead.

Fixes: d5f281f3dd29 ("media: mali-c55: Add Mali-C55 ISP driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/arm/mali-c55/mali-c55-params.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/arm/mali-c55/mali-c55-params.c b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
index 70106276b7e4e..16e895e3488ec 100644
--- a/drivers/media/platform/arm/mali-c55/mali-c55-params.c
+++ b/drivers/media/platform/arm/mali-c55/mali-c55-params.c
@@ -710,6 +710,9 @@ static int mali_c55_params_buf_prepare(struct vb2_buffer *vb)
 	struct mali_c55 *mali_c55 = params->mali_c55;
 	int ret;
 
+	if (!config)
+		return -EFAULT;
+
 	ret = v4l2_isp_params_validate_buffer_size(mali_c55->dev, vb,
 			v4l2_isp_buffer_size(MALI_C55_PARAMS_MAX_SIZE));
 	if (ret)
-- 
2.53.0



