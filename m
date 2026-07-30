Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDA83B71C9;
	Thu, 30 Jul 2026 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422398; cv=none; b=FqnZTuCNep/oYv5GaBnYZNvI+/ZS9a7jefGqMRirOvWzs4qjv76M9+kdvbD68Opg84YUDMpYoG5wleMLzA4C5tLzWwI58fzhvsWYjSeDPN7SHn2bh8olOJbAnLMUs+r+U9xjb5WjiJqKoyg5u3IRTrfSQNJrwBW5u5fEuTrQyyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422398; c=relaxed/simple;
	bh=wlXAIYCmD1kz50tqzV4VDmNjzHo0Yk1Ppjg0YAhz/Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTrdj+iDPkcKfT1wtsG8G2U6MGn1e5R5sDAQY2TgTx9kmOLboDBfHCh5hDGEoPxLhcMsj+DdD6A6UV9mRimZEWjexodq/KHaCteUlmbW/yxnpLOA5cvTDAkkVtCN89b3mECiis9ofQhKhOE1FquM1Awt71c2nkMsULOMiyPpKJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shXaWJMW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shXaWJMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE1F1F000E9;
	Thu, 30 Jul 2026 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422397;
	bh=9pZxImxl4Ibx8AAZ6+6Bo2Z90nvzmDko9BXViiSG7xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shXaWJMWCThi9xyqMAFuWlkOMYk4OnUkiUtlapmfv9n+FB/XbCjEP9oZ2RvcNkTTV
	 SPv3r66svxT7bFByQaMHd19oUr/RIwIC3XqzGDgt1wE25rNNaMoFfXSCJjQKEZ6Vyh
	 W4agy9G95EN95ARB8jP1JImtXkeiCNP8cIwYUxWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hodo <martin.hodo@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 7.1 425/744] drm/i915/hdcp: require monotonically increasing seq_num_v
Date: Thu, 30 Jul 2026 16:11:38 +0200
Message-ID: <20260730141453.329467799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit db9e64c983dcb07ff256bd455f258c44aa530ff8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_hdcp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_hdcp.c
+++ b/drivers/gpu/drm/i915/display/intel_hdcp.c
@@ -1785,9 +1785,10 @@ int hdcp2_authenticate_repeater_topology
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
 


