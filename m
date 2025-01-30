Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECA51E493C;
	Thu, 30 Jan 2025 14:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246729; cv=none; b=jGHudeSpgiFjSOwAM5jqQPMn4csXAJKAqFwJ13xBZGUipS6L/PpnfxfHfk/SzB0hVx/fvb+MaH5E8+Ojf56TYj6Ih1+qLFJhwLxXNQ9GvPw3BfU4YPOk/vGe5ndr0HvOXlxP7esKeGHbSpt5yMXNkHi3iNAgTCXJktWgKk7Tio8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246729; c=relaxed/simple;
	bh=BGl04HCkT/vzgTiSXp30AVo/nmSlBGp6riJZij8tVL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lc437M3w/s7phZhL/R3Qo0L7KC+iPcfdkHdtapz7d+MYXiZGpvqNg4m8dXKtSTHbKNnTR/BSdZmMJ1HMEEHdm+Co5xtohTWe4bvr7tpOjX0nfN91+V6OTOxY387OGZM/DtmLppgzc1cfEheegSsblWhDzJpOEYKGYnh8Bw2Jzyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqtMkC6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqtMkC6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECBAC4CED2;
	Thu, 30 Jan 2025 14:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246729;
	bh=BGl04HCkT/vzgTiSXp30AVo/nmSlBGp6riJZij8tVL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqtMkC6uBCkfKQabKR5SmnJWDANeSerirpws4h6qQSDueOO7CeUgcXkrmhcFxCqgD
	 M7Vhpt4+ByhHJjgOybpc90CGfcSBWsAw5bsco51mY5s0MveA4bzTlzr9k5WhH3lkOQ
	 C/mDseZHynw+izgaFjnJZ+jmnAwkET/0SYh5tUKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 17/91] drm/amd/display: increase MAX_SURFACES to the value supported by hw
Date: Thu, 30 Jan 2025 15:00:36 +0100
Message-ID: <20250130140134.351774623@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

commit 21541bc6b44241e3f791f9e552352d8440b2b29e upstream.

As the hw supports up to 4 surfaces, increase the maximum number of
surfaces to prevent the DC error when trying to use more than three
planes.

[drm:dc_state_add_plane [amdgpu]] *ERROR* Surface: can not attach plane_state 000000003e2cb82c! Maximum is: 3

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3693
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b8d6daffc871a42026c3c20bff7b8fa0302298c1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -41,7 +41,7 @@
 
 #define DC_VER "3.2.48"
 
-#define MAX_SURFACES 3
+#define MAX_SURFACES 4
 #define MAX_PLANES 6
 #define MAX_STREAMS 6
 #define MAX_SINKS_PER_LINK 4


