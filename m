Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31FC279DC2;
	Wed, 25 Feb 2026 01:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983928; cv=none; b=Fcc8eeS9B4MOgfG0wYg6yUco/mI37TU9FDvDACUaTX7+QzZ4ryMxgbuLC8kGYF+rLwMi1TPZl5BvhLznIc/YwoqV5V6R/bu6o9x2m3iujYzx2cSBhNYOZTYZAn1At67VYGiZMfciPYxLR8Ky92yrEo2ILPlTdCqjjCB7G2fRYew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983928; c=relaxed/simple;
	bh=twqGR4/7Kl3BEQt74zzY1tePy6JTWXsBWLa9KUue+nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbRXx1GT4LKntuoUdGRlxo06ng4xBcMID1BuU5F3mrARPem6gAm+cvzTNaEzaCc3IjLUPClVfBvBhG4dJTMRwLKJKG1MSs+XOhjFZ80+sDh8sBOtkYvZvbsPFQtp6yILrBODyFwdfGOr3DpwFX8DqjsbM3Jv/xg93SY1+jez/Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzeYrzy0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzeYrzy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76126C116D0;
	Wed, 25 Feb 2026 01:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983928;
	bh=twqGR4/7Kl3BEQt74zzY1tePy6JTWXsBWLa9KUue+nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzeYrzy0prpKtrspsNzNjomTSRUouUqhhdpO3KJRZ77hE5GtR/jNVvnUUixgOOKqr
	 2aNok2j6kwe5a030RBBxdvQZpLOCdGTvJre3Kfym0Ohp6+Jf1uuVZFaZNGtvT9wly1
	 aS5X/d537OwZnXywolXayT2SDaxCXf5Ch+LZizTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/641] mei: late_bind: fix struct intel_lb_component_ops kernel-doc
Date: Tue, 24 Feb 2026 17:18:41 -0800
Message-ID: <20260225012353.715678513@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 936cae9254e55a39aeaa0c156a764d22f319338b ]

Fix kernel-doc warnings on struct intel_lb_component_ops:

Warning: include/drm/intel/intel_lb_mei_interface.h:55 Incorrect use of
  kernel-doc format: * push_payload - Sends a payload to the
  authentication firmware

And a bunch more. There isn't really support for documenting function
pointer struct members in kernel-doc, but at least reference the member
properly.

Fixes: 741eeabb7c78 ("mei: late_bind: add late binding component driver")
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
Reviewed-by: Nitin Gote <nitin.r.gote@intel.com>
Link: https://patch.msgid.link/20260107160226.2381388-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/intel/intel_lb_mei_interface.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/drm/intel/intel_lb_mei_interface.h b/include/drm/intel/intel_lb_mei_interface.h
index d65be2cba2ab9..0850738a30fc7 100644
--- a/include/drm/intel/intel_lb_mei_interface.h
+++ b/include/drm/intel/intel_lb_mei_interface.h
@@ -53,7 +53,8 @@ enum intel_lb_status {
  */
 struct intel_lb_component_ops {
 	/**
-	 * push_payload - Sends a payload to the authentication firmware
+	 * @push_payload: Sends a payload to the authentication firmware
+	 *
 	 * @dev: Device struct corresponding to the mei device
 	 * @type: Payload type (see &enum intel_lb_type)
 	 * @flags: Payload flags bitmap (e.g. %INTEL_LB_FLAGS_IS_PERSISTENT)
-- 
2.51.0



