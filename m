Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB446774B;
	Tue, 23 Jan 2024 01:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972011; cv=none; b=tr8jCYBD/Os6J+hq2B2Y8b7sE9DqS4WGY0CSO9s0lE+bnhbH9mE5QG14vazW9Ib2trioAsdHqMiX93r/1OT7hilDiZZRc7Z5ZSFIMgA+63bOJ8cTNyjzrTZkIZ0lkBIV8fiKirFjIh+Vop4ocn2cIvn5OlXg5bQZU84A0CziLW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972011; c=relaxed/simple;
	bh=sYFJ2ZIVR9xUd3EGIHvslFwflmTwIO/Dep16ey9Mf2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAw0meDwbquAUbpTXVDgAZ4AjUVJxgp0QIhwL3rUCQkHg1fPobVSSZSJANYAw4l9jqK7qMJg5wI84CqmBvzaTyAq2voMEISG12lZ+t5a4UEsDKuoBzPISk7K7/vRacbBV7XfqsxSwYLIbPBmTXU6Uzd3/6GQPqN8syPxTLTVYXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7XSVXkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7XSVXkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FBFC43394;
	Tue, 23 Jan 2024 01:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972011;
	bh=sYFJ2ZIVR9xUd3EGIHvslFwflmTwIO/Dep16ey9Mf2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7XSVXkvxZqbPNvsrbFsZ4dLcjyzSHE2hlZ54QcAaYhEmTTXz+imJ2yzSL+8X/y/6
	 W1f+kj+7Qqz9zynK8fxvqag2wM2+Qn1O7q4t5p/Q+p7ULGOhsCR4x0omhc/Lz9BYsA
	 iwN2B/FZqMM5evUq48e4bhJbdm0xNYWts/4Ko5qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 363/417] vdpa: Fix an error handling path in eni_vdpa_probe()
Date: Mon, 22 Jan 2024 15:58:51 -0800
Message-ID: <20240122235804.398274649@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c1b9f2c66eed3261db76cccd8a22a9affae8dcbf ]

After a successful vp_legacy_probe() call, vp_legacy_remove() should be
called in the error handling path, as already done in the remove function.

Add the missing call.

Fixes: e85087beedca ("eni_vdpa: add vDPA driver for Alibaba ENI")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <a7b0ef1eabd081f1c7c894e9b11de01678e85dee.1666293559.git.christophe.jaillet@wanadoo.fr>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/alibaba/eni_vdpa.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/vdpa/alibaba/eni_vdpa.c b/drivers/vdpa/alibaba/eni_vdpa.c
index 5a09a09cca70..cce3d1837104 100644
--- a/drivers/vdpa/alibaba/eni_vdpa.c
+++ b/drivers/vdpa/alibaba/eni_vdpa.c
@@ -497,7 +497,7 @@ static int eni_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!eni_vdpa->vring) {
 		ret = -ENOMEM;
 		ENI_ERR(pdev, "failed to allocate virtqueues\n");
-		goto err;
+		goto err_remove_vp_legacy;
 	}
 
 	for (i = 0; i < eni_vdpa->queues; i++) {
@@ -509,11 +509,13 @@ static int eni_vdpa_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = vdpa_register_device(&eni_vdpa->vdpa, eni_vdpa->queues);
 	if (ret) {
 		ENI_ERR(pdev, "failed to register to vdpa bus\n");
-		goto err;
+		goto err_remove_vp_legacy;
 	}
 
 	return 0;
 
+err_remove_vp_legacy:
+	vp_legacy_remove(&eni_vdpa->ldev);
 err:
 	put_device(&eni_vdpa->vdpa.dev);
 	return ret;
-- 
2.43.0



