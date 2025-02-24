Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DBC38DD8;
	Mon, 24 Feb 2025 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408126; cv=none; b=IzIuBCC1y/n0eyZvMUmuVGZprI4Qj9zvqqMeX3WMUPh7ufq9GA+xujnha77lEGOUUQ9mH6Z/KMnFaiwIHo7f+eakTc6h0Kir5ZfCrEwNFtT9vb+dg5W0OsMqmrcFCWupktDHpv79n338599NYhwEr4WSfJoRou7ROirlP52GRp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408126; c=relaxed/simple;
	bh=7nuh+g4GrFP2F70G4YM+W8SXfpJHTV+0VX/n3b5p2VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfdtWd2SZL4BJs6M/kBvM0C6sd+5x3ac+0hQCGae056wY+II+U2sOBNwf0EloNVTABPTI6gUeimmtzll3cx2tRqPMqKePLeDvKtZBr4flQVAhco886hr9jeFd4JEeg3jCIclWbsB2QOv3KB+K7SASlzr5ERlkzAG9gyvm2Dfvyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsWmbfbO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsWmbfbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C27C4CED6;
	Mon, 24 Feb 2025 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408126;
	bh=7nuh+g4GrFP2F70G4YM+W8SXfpJHTV+0VX/n3b5p2VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsWmbfbOYSjXtNrhyaak+oxv2g5VZW4HUYJJC0x7Wc/4jInfda8BYqugnnmn/UciW
	 qstMj5fujncrzFMfZDObBzB0szOKwde79agbLGp4rgUVVZkteNiv5BbXaMAoxtILkH
	 9jHBS3jqH07ETSNTU6RQq5iwMwAhsqK7ERq6fD5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.6 108/140] drm/msm/dpu: Disable dither in phys encoder cleanup
Date: Mon, 24 Feb 2025 15:35:07 +0100
Message-ID: <20250224142607.257530515@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2075,6 +2075,9 @@ void dpu_encoder_helper_phys_cleanup(str
 		}
 	}
 
+	if (phys_enc->hw_pp && phys_enc->hw_pp->ops.setup_dither)
+		phys_enc->hw_pp->ops.setup_dither(phys_enc->hw_pp, NULL);
+
 	/* reset the merge 3D HW block */
 	if (phys_enc->hw_pp && phys_enc->hw_pp->merge_3d) {
 		phys_enc->hw_pp->merge_3d->ops.setup_3d_mode(phys_enc->hw_pp->merge_3d,


