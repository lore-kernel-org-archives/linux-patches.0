Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590218;
	b=MsiWQbvkon8DRw/YaTx7hbo0XeULgaodIBFZ2RJFhrmULYr87zh2817wreUoyBJeGpzi
	 ysIf48reDlDS0BeiInoekTWKFfLPelR19H57zCzKEsU610rKuk0dpImlZY0iog/nJXjl0
	 qeYJFnywFq/Xq+A7JF+pMVgB5nYBLPlwQoEneNndiBtsdW2UVBSsmflJCuFALhyVkUU03
	 0b6GBQbEe9PVOH6f3fFBNJBP217sXlkcKLfCA0ONs3BqeKxUXEPSkwiY0OGAjEsb+B6eW
	 cTXWwcyk7FJB8dQvmMr4k34r6v0BcdnMHWU+y+MIck+b/7Wae7JDwMjk+1V5ZpFnupw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JcVmPu8ZUL1jcIxTu3vw19U4xdkRNRkmFB4SfdfbCso=;
	b=FHLJa6DnC/eiKkTWPmHAoPhzxKDDW/X+bBFrtSdRP57Wj6jJSOb+oFFNf1HEo196G80v
	 5o/5ClIS1tSz/JfR4fa8kR2qfSoZX5U5v3daInW5tqXAEiA69hMRs3xPNLWMJE+sHtsKd
	 6XPK7P6pd6iFmu/XSQhxP+6FdDbhAhyxBAVwMUmBy6YYdBGACxXTABSzLeHpTSRLT+RXx
	 fM0/5a1sGf8rQvDgQ/OL55OZXcnsSn54jCXu+g6iGwrMnqIm5oUtr3zlwd/fFdG/XtJ0R
	 JGWDxsWxs3n9JEI17I12EPtlChMGqoUsWfMOjqLrXP+cOATSZBGGpAplTyQIPcnOF1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypfUuyOb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEFC606BD2A;
	Fri, 13 Nov 2026 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ypfUuyOb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0873F1F000C4;
	Fri, 13 Nov 2026 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590218;
	bh=JcVmPu8ZUL1jcIxTu3vw19U4xdkRNRkmFB4SfdfbCso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ypfUuyObFjdwgVdSuiMv3FsOO6/YqjA3erXLHnNDRlsNDpCz/RmnVStr25NNGsxHV
	 S5Ivxitow4VMpm+mJJs/UJAWi6TPcLK9VwhbCzF/e6yWLsBBb6STXcyj1/EWAM0tlg
	 oRpAM9cBwNOa7hi0h/zSlZBbpNhq7ofhN3R9z8rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/686] drm/vc4: hdmi: enable scrambling before the TMDS clock starts
Date: Fri, 13 Nov 2026 10:45:52 -0500
Message-ID: <20261113153828.452310524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Tanure <lucas.tanure@neat.no>

[ Upstream commit 81383bd290a18f06ccf9b0bfb29e1a3ef73d9357 ]

HDMI 2.0 requires a source to suspend the TMDS clock, write the
TMDS_Bit_Clock_Ratio bit in the sink's SCDC registers, wait at least
1 ms and only then resume the clock. vc4 does the opposite: the PHY
starts at the new rate first, and the SCDC bits are written tens of
milliseconds later, at the very end of the enable sequence, together
with the source side scrambler. On disable the bits are cleared while
the clock is still running.

Some sinks sample the bit only when the clock appears. One HDMI 2.0
sink we tested then sets up its receiver for a 1/10 clock and never
recovers: a Raspberry Pi 5 at 3840x2160@60 shows no picture, while
1080p60 and 4K30 work and other sources work at 4K60 on the same sink.
Writing the bit by hand before enabling the output makes the same mode
lock every time.

Enable scrambling, on the sink and in the controller, before the PHY is
started, and disable it only after the PHY has been stopped. The SCDC
helper already waits the required time after writing the ratio bit.

Cc: stable@vger.kernel.org
Fixes: c85695a2016e ("drm/vc4: hdmi: Enable the scrambler")
Link: https://github.com/raspberrypi/linux/issues/7693
Assisted-by: LLM
Signed-off-by: Lucas Tanure <lucas.tanure@neat.no>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patch.msgid.link/20261026164028.78792-4-lucas.tanure@neat.no
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 7a84d8414436f..8f5d43946583a 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -839,8 +839,6 @@ static void vc4_hdmi_encoder_post_crtc_disable(struct drm_encoder *encoder,
 		spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 	}
 
-	vc4_hdmi_disable_scrambling(encoder);
-
 	drm_dev_exit(idx);
 
 out:
@@ -869,6 +867,8 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 	if (vc4_hdmi->variant->phy_disable)
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
+	vc4_hdmi_disable_scrambling(encoder);
+
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
@@ -1478,6 +1478,8 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		goto err_disable_pixel_clock;
 	}
 
+	vc4_hdmi_enable_scrambling(encoder);
+
 	if (vc4_hdmi->variant->phy_init)
 		vc4_hdmi->variant->phy_init(vc4_hdmi, conn_state);
 
@@ -1612,7 +1614,6 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 	}
 
 	vc4_hdmi_recenter_fifo(vc4_hdmi);
-	vc4_hdmi_enable_scrambling(encoder);
 
 	drm_dev_exit(idx);
 
-- 
2.53.0



