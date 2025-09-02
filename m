Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22EDC30BF79;
	Tue,  2 Sep 2025 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820098; cv=none; b=ZTsshETTb3iAcn//dZUc4ZA/Agfe8N8c0ibKsjlQXZ5+SepFHoKmBjdDRsFjyoI4jWSKwJg5yvmgasPy23eBE74B+rY0Uu03U7iJfuV/ukAhDiZVhP1gqQpTOXcWRngjpG603SHQ/RxxshX7NZSIiHUAbDhUREu0BL7kReK2H84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820098; c=relaxed/simple;
	bh=jFCjxaDFyg3REYO0z0eTlaaGYHlxBa1hXMGTHWWTsBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HNiiG7ANlEa23SP4sy5LlGnXYVPJcCro2qkElD720GU04lc/+tH0QLVCBL3URWB7g2knpc6NQSEefxOtsYG3DG9syTN5z2dYpAb0G/9d4o+VpMtCHK8mOx+v48ItYZNrkxKJjhp+/030FRxPOgiNXDpr0Z6rY0VllWRw2y7zhus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z86vJx9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z86vJx9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979BDC4CEED;
	Tue,  2 Sep 2025 13:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820098;
	bh=jFCjxaDFyg3REYO0z0eTlaaGYHlxBa1hXMGTHWWTsBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z86vJx9n23PlohzNBPP3/rfsMeUx1b8lUi63k8XNoOUx8xdTOfx60SXsw7IBncvl7
	 nkyfzxdVJPS59bfpAml0Z7ktDXdyWUcGF8lS3c59bZp/FZzBCtoN4vTzREeFANLR3Y
	 XYZX7XQ4BIadH0F11F9cuXBiXOPCKjg3mqQ21It8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.12 92/95] Revert "drm/dp: Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS"
Date: Tue,  2 Sep 2025 15:21:08 +0200
Message-ID: <20250902131943.130857399@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

This reverts commit 3c778a98bee16b4c7ba364a0101ee3c399a95b85 which is
commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f upstream.

The upstream commit a40c5d727b8111b5db424a1e43e14a1dcce1e77f ("drm/dp:
Change AUX DPCD probe address from DPCD_REV to LANE0_1_STATUS") the
reverted commit backported causes a regression, on one eDP panel at
least resulting in display flickering, described in detail at the Link:
below. The issue fixed by the upstream commit will need a different
solution, revert the backport for now.

Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: Sasha Levin <sashal@kernel.org>
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14558
Signed-off-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -664,7 +664,7 @@ ssize_t drm_dp_dpcd_read(struct drm_dp_a
 	 * monitor doesn't power down exactly after the throw away read.
 	 */
 	if (!aux->is_remote) {
-		ret = drm_dp_dpcd_probe(aux, DP_LANE0_1_STATUS);
+		ret = drm_dp_dpcd_probe(aux, DP_DPCD_REV);
 		if (ret < 0)
 			return ret;
 	}


