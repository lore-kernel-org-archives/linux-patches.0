Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68DD2512EB;
	Wed,  5 Mar 2025 17:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197288; cv=none; b=BPiKoHJPWyX0ZInpR8HG8ofGfVN/aAHdHytKYSmhk/C8BKnztlfweUwIgsD4y3DpwCm8JhT56jk+CbXbX4UkpMRH+IXmUF9KHG4CP4TFrmkVZVubZ57MleH6Ox22C+1u8SW5pkewcw25208fiRJ4j8d4l8qlyRfLM6LsonlFfo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197288; c=relaxed/simple;
	bh=Ek6xFVjgEXa/E2CQp3Zc07kvGUK5ieRyfbKc0HSOxjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvBmSnKto4EEiIENzXrOZ94GDdfDWIf+lCR2mYO/pOWaAHZtxvznp0hgVLY3o1nF6aLtlGomuHNDQfwKBCZvvoVbzqxAAMLwJ3NY6TFp/Z9YDYglmdi7UbEc+Py91vXZMlz4EtCUTfumA7ru1Z8hcH4dG/5VILP2/iimw+b68uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQ/ovTAH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQ/ovTAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A29C4CEE2;
	Wed,  5 Mar 2025 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197288;
	bh=Ek6xFVjgEXa/E2CQp3Zc07kvGUK5ieRyfbKc0HSOxjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQ/ovTAHoVP+bdDwmcXMEfJqoEjQnJTE6BZgeOBHm7vTqG7Hns7ld8VjuABELbq9T
	 4JwO0uA8pOgUjrMZuQaFPE47LBCCT9w7OcFNDRK29OwsFi1GYjE+du+RrVh2fkI1xG
	 KCt1pSo1f9sMjiq0OjzK7Tzwb1gLGGAd2OwKPljY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.1 072/176] drm/msm/dpu: Disable dither in phys encoder cleanup
Date: Wed,  5 Mar 2025 18:47:21 +0100
Message-ID: <20250305174508.352417215@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jessica Zhang <quic_jesszhan@quicinc.com>

commit f063ac6b55df03ed25996bdc84d9e1c50147cfa1 upstream.

Disable pingpong dither in dpu_encoder_helper_phys_cleanup().

This avoids the issue where an encoder unknowingly uses dither after
reserving a pingpong block that was previously bound to an encoder that
had enabled dither.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Closes: https://lore.kernel.org/all/jr7zbj5w7iq4apg3gofuvcwf4r2swzqjk7sshwcdjll4mn6ctt@l2n3qfpujg3q/
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Fixes: 3c128638a07d ("drm/msm/dpu: add support for dither block in display")
Patchwork: https://patchwork.freedesktop.org/patch/636517/
Link: https://lore.kernel.org/r/20250211-dither-disable-v1-1-ac2cb455f6b9@quicinc.com
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2059,6 +2059,9 @@ void dpu_encoder_helper_phys_cleanup(str
 		}
 	}
 
+	if (phys_enc->hw_pp && phys_enc->hw_pp->ops.setup_dither)
+		phys_enc->hw_pp->ops.setup_dither(phys_enc->hw_pp, NULL);
+
 	/* reset the merge 3D HW block */
 	if (phys_enc->hw_pp && phys_enc->hw_pp->merge_3d) {
 		phys_enc->hw_pp->merge_3d->ops.setup_3d_mode(phys_enc->hw_pp->merge_3d,


