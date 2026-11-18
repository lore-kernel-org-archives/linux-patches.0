Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019588;
	b=Xym7mhZn8Ry3Eyv9hLkUwKOHOfQj0yU11eeGeG6YIgYsO7xc5+faJ13oy/BiEBG/oJgt
	 NMmZz4dS1QQ3xBEhzMc+0ZP913CYogtbiAB1rio/jI0NmL6P+lOaEiSSG2uuqxcXldHnN
	 Z7Gz6RcnAJQy//VVBMK8WPDnkiCA/1qx9JCSpacdpXwvak8jXgxz0dQQWfzcrkuMFL4dw
	 X0NoApe3t++bAHR/SIjsujGgA14+oAIchyb4XkEj9Q/55hKpsW/02691TWjDHj7/nNZxQ
	 W8sTFUSuYsVjbJ6OVVxiMhlstTcL4RTm1l5LhSAjs2Be074EaNe1FILUMQ0CsEA4QUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qHnQVLzGH1TZ57kFLd0UZPb66ikDmW/s7KqHI9O1/iU=;
	b=R3X6XTbv1PFQLik3ectpoyTiCnMaSZDD0VWW13l9NUVWR5p0445ILsNjQTrgkkWkvlzU
	 M0/ccXDS3vBLl3wBM7xHM4Easw3CLeXR63/+qSNAjwBiNUoGnEdtYXOU8phGJQ8rQupcA
	 t2w3dAaFvMgo9a1+hQLbnCputnG6LFDPBF7ddpNzKSImI1EUr/jk2XRtDUb7Nz6IB8VP0
	 XZEk89qWENhYVObxFY5EVhpU3LgmfzSV6A7MVxt2oW2KWHDBnZeuuox5MftSpmSy/NgmM
	 3d6AFfCf92XTV825hbdP29zw/uyDGPvcTKwZfsk0tSJWiGacNzES1pKRedpgobmItFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZQxk9ES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA0C606A7DF;
	Wed, 18 Nov 2026 16:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jZQxk9ES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F54F1F000CC;
	Wed, 18 Nov 2026 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019588;
	bh=qHnQVLzGH1TZ57kFLd0UZPb66ikDmW/s7KqHI9O1/iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZQxk9ESMjwIjCaOv2yEvkzdR393oDKlr/eOqbUDvzVQaXIDN6//uVZAmz2+lFyi/
	 2b0zrvghxWd5arD+8TXJiLfT1Iyxng9F9d8EhDh2pBvoY2oJGW+QGajTVKKQWFwUzv
	 BeBu9xEt4AhjeF/pOGz6HWdMtqPFRFCTTP+TFAhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Zhang <yidong.zhang@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1648/2651] accel/amdxdna: Reject device heap BO when dev_mem_size is not set
Date: Wed, 18 Nov 2026 15:48:08 +0100
Message-ID: <20261118150347.121040995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: David Zhang <yidong.zhang@amd.com>

[ Upstream commit 3e32932d3626d0279f9b3531bd648f8c0a16cb08 ]

NPU3 devices do not set dev_mem_size, since they do not use a device
heap. Creating an AMDXDNA_BO_DEV_HEAP BO on such a device hits the
WARN_ON(!is_power_of_2(dev_mem_size)) check, which any user with
access to the device node can trigger.

Return -EOPNOTSUPP when dev_mem_size is 0.

Fixes: d76856beb4a4 ("accel/amdxdna: Refactor GEM BO handling and add helper APIs for address retrieval")
Signed-off-by: David Zhang <yidong.zhang@amd.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20261008232416.2646054-1-yidong.zhang@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index f4832337ec31d..f14484bc31ec0 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -1140,6 +1140,11 @@ amdxdna_drm_create_dev_heap_bo(struct drm_device *dev,
 	struct amdxdna_gem_obj *abo;
 	int ret;
 
+	if (!xdna->dev_info->dev_mem_size) {
+		XDNA_DBG(xdna, "Device heap is not supported");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	WARN_ON(!is_power_of_2(xdna->dev_info->dev_mem_size));
 	XDNA_DBG(xdna, "Requested dev heap size 0x%llx", args->size);
 	if (!args->size || !IS_ALIGNED(args->size, xdna->dev_info->dev_mem_size)) {
-- 
2.53.0



