Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EC014A82
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6906BC433C8;
	Tue, 25 Jul 2023 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282210;
	bh=d5u29PkFHU5M4AVwKAW5UzJ/SzyrOt0Mh00oKMvMpjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHLy3i9dqRyMMkjWz/xoMLIY+7+BCqH5cdmi8OvaBMhcFv1yKtNSWeiT5wPD2E5wY
	 wZv5NdOZoacC6wKWuM9HqjW+a82Mb9rdzk4npNv7nowx8GFPyTvl7Wgq/awAp8lPWe
	 N29EaWuQNorSfQVkp6v6c+3EpSw35UNwCYojW2Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Skeggs <bskeggs@redhat.com>,
	Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 6.4 048/227] drm/nouveau/kms/nv50-: init hpd_irq_lock for PIOR DP
Date: Tue, 25 Jul 2023 12:43:35 +0200
Message-ID: <20230725104516.790119455@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ben Skeggs <bskeggs@redhat.com>

commit ea293f823a8805735d9e00124df81a8f448ed1ae upstream.

Fixes OOPS on boards with ANX9805 DP encoders.

Cc: stable@vger.kernel.org # 6.4+
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230719044051.6975-3-skeggsb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/dispnv50/disp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -1873,6 +1873,8 @@ nv50_pior_destroy(struct drm_encoder *en
 	nvif_outp_dtor(&nv_encoder->outp);
 
 	drm_encoder_cleanup(encoder);
+
+	mutex_destroy(&nv_encoder->dp.hpd_irq_lock);
 	kfree(encoder);
 }
 
@@ -1917,6 +1919,8 @@ nv50_pior_create(struct drm_connector *c
 	nv_encoder->i2c = ddc;
 	nv_encoder->aux = aux;
 
+	mutex_init(&nv_encoder->dp.hpd_irq_lock);
+
 	encoder = to_drm_encoder(nv_encoder);
 	encoder->possible_crtcs = dcbe->heads;
 	encoder->possible_clones = 0;


