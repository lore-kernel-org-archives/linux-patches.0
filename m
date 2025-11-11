Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5C326B0B7;
	Tue, 11 Nov 2025 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823756; cv=none; b=hQg6PFCj2cbFt9NP37D236Kn5dX1UCllr9f/weYVKVQHLSz7dU1DDBkzzKgAjV9glFBa9lJ8V73BIz8VdfpcO8x+2yrZKGdH+jEcVE2nVpgoc+UKs8OF/eR6gAMg97aJOaBEOM0Ur728PBOUV/X7rPZsAbBgW8UGVzpwvL1BKcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823756; c=relaxed/simple;
	bh=zhFJ6wo+/hiEnUa8aPse4rQED0PTb9RjRsQz4+wTrF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REk7+nkMHGK+F777ILRBbubj7xordHyFC0f7AOk0vDZOJXtCIjeZh7xMwiePnWJ2yuqv2fxzuzjY+GQ/qF//B7XawzAOOsiqn3FATdYdkWGlw/3vaxdvk1I0neNI1vJtSZwgzwkpZOAw6HJ5hlNnGwAKV+J2+GEOwAMkuNf+QPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tm0o7Ed5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tm0o7Ed5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8E1C4CEF5;
	Tue, 11 Nov 2025 01:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823756;
	bh=zhFJ6wo+/hiEnUa8aPse4rQED0PTb9RjRsQz4+wTrF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tm0o7Ed5RAWTaKp0TLNyJM+AZbqnh+GBnUvpEPcy2s2SHsAazsXWatqLEDU6b1NvY
	 yoBkXW1B3RquzR8+c0+ikLelzv2pRYgC/3kuLkR453vWhRjM9myXmd1drutzfmot1X
	 OcV+GAcXm452icCjzVI9fkIjvFZRtkRarzb+TFj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 363/849] drm/xe/wcl: Extend L3bank mask workaround
Date: Tue, 11 Nov 2025 09:38:53 +0900
Message-ID: <20251111004545.194705091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>

[ Upstream commit d738e1be2b2b4364403babc43ae7343d45e99d41 ]

The commit 9ab440a9d042 ("drm/xe/ptl: L3bank mask is not
available on the media GT") added a workaround to ignore
the fuse register that L3 bank availability as it did not
contain valid values. Same is true for WCL therefore extend
the workaround to cover it.

Signed-off-by: Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>
Reviewed-by: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Link: https://lore.kernel.org/r/20250822002512.1129144-1-chaitanya.kumar.borah@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa_oob.rules | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 48c7a42e2fcad..382719ac4a779 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -47,7 +47,7 @@
 16023588340	GRAPHICS_VERSION(2001), FUNC(xe_rtp_match_not_sriov_vf)
 14019789679	GRAPHICS_VERSION(1255)
 		GRAPHICS_VERSION_RANGE(1270, 2004)
-no_media_l3	MEDIA_VERSION(3000)
+no_media_l3	MEDIA_VERSION_RANGE(3000, 3002)
 14022866841	GRAPHICS_VERSION(3000), GRAPHICS_STEP(A0, B0)
 		MEDIA_VERSION(3000), MEDIA_STEP(A0, B0)
 16021333562	GRAPHICS_VERSION_RANGE(1200, 1274)
-- 
2.51.0



