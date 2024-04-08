Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78E96FE35;
	Mon,  8 Apr 2024 13:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584103; cv=none; b=UOLS8nQteo0NQ7uajZVrHslbl4yNOJA+ZNJG6NKE0wYhX1hIH7C6E46wWndoS4mPjIq2DYRGpbZo0ZL8jv7OzkIE1h6JoahW0VCHYOqoJyRDb89nppdVQ58K1a8lt6/eES3Mh/veYdhEFHbJUFOGwFhh71eIveOQjXUCfVfFI7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584103; c=relaxed/simple;
	bh=Nq6/2PKyGJLHd4ON2TaZZHLT2q8WIvxPC+zVpgRF8e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiWh/0WOY6povfSHOd3WfAoP0ptWkclKzRG4ohxfktYZu/rdDs2yHpUcA2cEQTwRwQc2qgoqKywcTTSeeCxbSeHF3UJnuBP3yWFTdu+atOKF3dSKOZuuY88d6tOGeeLR24vnYMLgdMwrAnTI7y5VETPiEBN28hdpNjNI824+R/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZyXukoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZyXukoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD48C433C7;
	Mon,  8 Apr 2024 13:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584103;
	bh=Nq6/2PKyGJLHd4ON2TaZZHLT2q8WIvxPC+zVpgRF8e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZyXukoh8ZlZvFsTbTRJajhrGqvYRInrOuhXzRpsWmfZnHqAKgESxuRC3y6jH4mx5
	 A1ocSqw8ImzrdHYkT1reEFZ2AJCMhqWNtxg2lVpPStGm5uMEdSjLoHS+kd7h/4H4ZB
	 hHLU4K/Rd1MTE4gzEBceQzH05EYlmPrsIuJ1R+BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Chris Wilson <chris.p.wilson@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Michal Mrozek <michal.mrozek@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 262/273] drm/i915/gt: Do not generate the command streamer for all the CCS
Date: Mon,  8 Apr 2024 14:58:57 +0200
Message-ID: <20240408125317.627903821@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi.shyti@linux.intel.com>

commit ea315f98e5d6d3191b74beb0c3e5fc16081d517c upstream.

We want a fixed load CCS balancing consisting in all slices
sharing one single user engine. For this reason do not create the
intel_engine_cs structure with its dedicated command streamer for
CCS slices beyond the first.

Fixes: d2eae8e98d59 ("drm/i915/dg2: Drop force_probe requirement")
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: <stable@vger.kernel.org> # v6.2+
Acked-by: Michal Mrozek <michal.mrozek@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240328073409.674098-3-andi.shyti@linux.intel.com
(cherry picked from commit c7a5aa4e57f88470313a8277eb299b221b86e3b1)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_engine_cs.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_engine_cs.c
+++ b/drivers/gpu/drm/i915/gt/intel_engine_cs.c
@@ -908,6 +908,23 @@ static intel_engine_mask_t init_engine_m
 		info->engine_mask &= ~BIT(GSC0);
 	}
 
+	/*
+	 * Do not create the command streamer for CCS slices beyond the first.
+	 * All the workload submitted to the first engine will be shared among
+	 * all the slices.
+	 *
+	 * Once the user will be allowed to customize the CCS mode, then this
+	 * check needs to be removed.
+	 */
+	if (IS_DG2(gt->i915)) {
+		u8 first_ccs = __ffs(CCS_MASK(gt));
+
+		/* Mask off all the CCS engine */
+		info->engine_mask &= ~GENMASK(CCS3, CCS0);
+		/* Put back in the first CCS engine */
+		info->engine_mask |= BIT(_CCS(first_ccs));
+	}
+
 	return info->engine_mask;
 }
 


