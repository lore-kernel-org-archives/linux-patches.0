Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA06926ED5D;
	Sun,  7 Jun 2026 10:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828212; cv=none; b=XkHRo2z+3XFno/+5mPvwARlal/i3zd8RZ3iyA/lkNw/mA6WcDAcl4pkUNKx3ejRfoEeoByE90oLG2ETRN4aTT2uD25rHlgYLnbDgxJd2ypg+I/Nr6B/l7GCrVoH92THhNrqeGokj8hqOU3Cya6Jl2oxjPF2NxjNr7J4wAUsTrSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828212; c=relaxed/simple;
	bh=PEEzThoPBMicd9j13NrRgahxKXAWVWCil2d1zFFstA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+ulj1TZrMOrueMQO8mxGSDzqm3F1WeedhgchzApUOdMI8leMpK7WUTTbMohpHby8WjiCwyFjXzjKYF01tXCm7L81PXDKYo9w/oWA+0wANPbq75czSFjSO5DYcautskmjIpVX3yFZASrvHkOdjQUKzhusK2vRiusUfUNjmMcjK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbNiwRWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbNiwRWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CBA1F00898;
	Sun,  7 Jun 2026 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828210;
	bh=beG16EsAL2d492y3LKjLmLQ0n3YYf84lZCkwp+VbBFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbNiwRWF1LQY2oJSjypLINDISpaXf4c0508RXNVPB11UGeyDks9RlMhOcJwaTefhv
	 5jWaxlv+Qmzs9+PREfaRmoHFPz3eKvDdMi9/UYP9XjN0zmu2Mnp8YsN40YzG5BC58X
	 dSw3LqhicJvTsW8TkWLFEqjSAWUapNt27Ro7Wsc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Ben Kao <ben.kao@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/307] drm/dp: Add eDP 1.5 bit definition
Date: Sun,  7 Jun 2026 11:58:37 +0200
Message-ID: <20260607095732.170506695@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

commit 5dfc37a6b77bf6beedbd30d70184b54e1a08ccac upstream.

Add the eDP revision bit value for 1.5.

Spec: eDPv1.5 Table 16-5
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Arun R Murthy <arun.r.murthy@intel.com>
Tested-by: Ben Kao <ben.kao@intel.com>
Acked-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250206063253.2827017-2-suraj.kandpal@intel.com
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/display/drm_dp.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/display/drm_dp.h b/include/drm/display/drm_dp.h
index 3bd9f482f0c3e6..dd218400a613e3 100644
--- a/include/drm/display/drm_dp.h
+++ b/include/drm/display/drm_dp.h
@@ -997,6 +997,7 @@
 # define DP_EDP_14			    0x03
 # define DP_EDP_14a                         0x04    /* eDP 1.4a */
 # define DP_EDP_14b                         0x05    /* eDP 1.4b */
+# define DP_EDP_15			    0x06    /* eDP 1.5 */
 
 #define DP_EDP_GENERAL_CAP_1		    0x701
 # define DP_EDP_TCON_BACKLIGHT_ADJUSTMENT_CAP		(1 << 0)
-- 
2.53.0



