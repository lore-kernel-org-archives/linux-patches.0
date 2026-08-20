Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4654E46C82A;
	Thu, 20 Aug 2026 17:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248452; cv=none; b=qqCVOHbKCD5TvLniL7DtCtWmohWNoGj0jNZhbWdcdfHx3pSQLEqEs7wdzo//3ejcwd/YoJXrKF4MwKI6OGLf/j4D0fgySR7igcQfnGskdteVhV+zmmbcLmhoNR05F6IgTTXaB3Lj2kTXhed9AmVCe5eDKekI6sDstz8KfK5Mz78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248452; c=relaxed/simple;
	bh=5J8m1FK/79gzAJkQa9FFt9I8ppn7fGOtUlT6b9Ms2o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieCf71mypLeAdngvhD7L16AxbSdpzsap3cwIFj75jsg5YAL61rM68dRrN6Uq9EnVSnEgGJhAbIvhh+e5dFO/ANyrL3+8JhWGdh9j5j108nMq27si93WfXUfIJTW4Pj3GMhYv9RSZVqrQfb/sACS/XL5PxQkMdT9kuK7amZUGimY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6VGf0ee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6VGf0ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30601F000E9;
	Thu, 20 Aug 2026 17:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248451;
	bh=scyDFovWeiQVIxfLtcRbFZwTvMDqe41qH8uvm/UmKoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g6VGf0eeAf4ntu4RvoUguGia3ymeULAJEFSvogoc6Q4G5DfHgmyyabO5sdI4h7hp1
	 do/g/UXRbm/krIhlx5SObuTjpvtzKU1WsEsDwyOlqMfYw+m1Q0ExsnldsSLOWK8ERQ
	 vt1PZNgLngMiX0txh19hkKaYwbG4q/bJ7StJ37Js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/303] drm/i915/hdcp: require monotonically increasing seq_num_v
Date: Thu, 20 Aug 2026 16:55:29 +0200
Message-ID: <20260820145259.147040094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1677,9 +1677,10 @@ int hdcp2_authenticate_repeater_topology
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
 


