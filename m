Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F7742AF95;
	Fri,  7 Aug 2026 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116535; cv=none; b=DUAbwUPZOovxPfnhDXTSKRXdt/YorKeOcz2GIGZtMuQOgI5K0OwWsL0/CTZcoD60g+nWWcOTdC38RnpQCsQEHdYN5OMaWOKDkTGMnI8Zf0/o14zF1f02RWLp3clp2N4VR9m/w3PtPRLv1IDo1skhbnkpl2xi/HoTAUKpGU+Un4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116535; c=relaxed/simple;
	bh=HXx4FwBV3drqMn/ujl2bF+z1eNOb3L80+0QLOcaJe4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHml3uVHdRWHMo/N5HIdKGQChHS65vJjpFN0IlqrFhnUfBV7PZ2x1hOayff2J5X0BqfJ62yH6FOuIiHIvhVMvyqrOnRPKVjYrRs1qcbxRbd7caMAcXLa49O+JLMyPo4V1P9ZkNUWgL12pJ+oVql9Myr1X/UKvcguBOg8EMiika8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mncRh3kL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mncRh3kL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3461F00A3A;
	Fri,  7 Aug 2026 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116533;
	bh=S3HTWrISLQ22VtOGyXZLTCNeSluKLU0zKqAf+I3exs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mncRh3kLJQJKOhDNY+SGu1kQCElzgh+xsr+ufNdMvdLRo5RNoLqJ0NwwflkHs4MFA
	 Non67vkWXkSkjfs51KLm9vnhOifLWjrKZw6et4xKcTjPKXobDQ8bXDrgr8kls7hUnI
	 WKQ2zSDwYpHB7KXP4g7nI1ygus5kMH0oXwy2/R0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/261] drm/i915/hdcp: require monotonically increasing seq_num_v
Date: Fri,  7 Aug 2026 16:40:14 +0200
Message-ID: <20260807143420.963481244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit db9e64c983dcb07ff256bd455f258c44aa530ff8 ]

The HDCP 2.2 specification requires the seq_num_v to be monotonically
increasing, and repeated seq_num_v needs to be treated as an integrity
failure. Make it so.

For the first message, seq_num_v must be zero, and is already
checked. We can only check for less-than-or-equal for the subsequent
messages, where hdcp2_encrypted is true.

Discovered using AI-assisted static analysis confirmed by Intel Product
Security.

Reported-by: Martin Hodo <martin.hodo@intel.com>
Fixes: d849178e2c9e ("drm/i915: Implement HDCP2.2 repeater authentication")
Cc: stable@vger.kernel.org # v5.2+
Cc: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patch.msgid.link/20260625104407.1025614-1-jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 58a224375c81179b52558c53d8857b93196d2687)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -1654,9 +1654,10 @@ int hdcp2_authenticate_repeater_topology
 		return -EINVAL;
 	}
 
-	if (seq_num_v < hdcp->seq_num_v) {
-		/* Roll over of the seq_num_v from repeater. Reauthenticate. */
-		drm_dbg_kms(display->drm, "Seq_num_v roll over.\n");
+	if (hdcp->hdcp2_encrypted && seq_num_v <= hdcp->seq_num_v) {
+		/* Reauthenticate on Seq_num_v repeat or rollover */
+		drm_dbg_kms(display->drm, "Seq_num_v %s\n",
+			    seq_num_v == hdcp->seq_num_v ? "repeat" : "rollover");
 		return -EINVAL;
 	}
 


