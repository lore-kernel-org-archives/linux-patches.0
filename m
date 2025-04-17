Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25202255E23;
	Thu, 17 Apr 2025 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912855; cv=none; b=gzGErJoxKFODEakFRibMtyZZvrFH1EzTPr4DIBJpBCTgNppJEFkNK27D2R+A9xaIoBsccOc4BvhWcRCQTizxUcHNH+x+sq3tSF9E5tWUgjIUykgOkx9tegmzNVLVNIRdEhZSzNg0lu72FIH/QFQGWdZ4PkzP3G0JIsHliI7kW14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912855; c=relaxed/simple;
	bh=Kmn9xpz13XxnysOaYBVKvlZ0ROTfxlaHwZat5oyQmac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4dZUC7acBy2chXlQr/YDPVJi7gi2ZVOCLxt8JuuYfa1lrXk4nN3e19mpfo4WkNDFuVLPX7i4ugEKgH5peycm4Nj1INf0GbppdxzilbtmCW+ekIWh8CwablerJUHsvcIrg6e1CxyKYQIisy0gJxdXVmSpWl7po8wRMvDsC/78Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o1E2wV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o1E2wV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A62AC4CEE4;
	Thu, 17 Apr 2025 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912855;
	bh=Kmn9xpz13XxnysOaYBVKvlZ0ROTfxlaHwZat5oyQmac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o1E2wV3CFPgqmdMgffFUsoiUHRuk8mkxNt5vf9eh/NWGOIGRXWlmJmnKcyl6K6Vw
	 DSftj1bp9LU40EUgUryQVgneLTIs8frmAQ6BEm5NHgIMHo00Ak/donOgSw0f0kCzg4
	 1v9hy3c2V5VGSRCinVW16v42bxG704dq4v2XhSPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Clint Taylor <Clinton.A.Taylor@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 147/449] drm/xe/bmg: Add new PCI IDs
Date: Thu, 17 Apr 2025 19:47:15 +0200
Message-ID: <20250417175123.890583316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shekhar Chauhan <shekhar.chauhan@intel.com>

[ Upstream commit fa8ffaae1b15236b8afb0fbbc04117ff7c900a83 ]

Add 3 new PCI IDs for BMG.

v2: Fix typo -> Replace '.' with ','

Signed-off-by: Shekhar Chauhan <shekhar.chauhan@intel.com>
Reviewed-by: Clint Taylor <Clinton.A.Taylor@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250128162015.3288675-1-shekhar.chauhan@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/intel/pciids.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/drm/intel/pciids.h b/include/drm/intel/pciids.h
index 77c826589ec11..4035e215c962a 100644
--- a/include/drm/intel/pciids.h
+++ b/include/drm/intel/pciids.h
@@ -846,7 +846,10 @@
 	MACRO__(0xE20B, ## __VA_ARGS__), \
 	MACRO__(0xE20C, ## __VA_ARGS__), \
 	MACRO__(0xE20D, ## __VA_ARGS__), \
-	MACRO__(0xE212, ## __VA_ARGS__)
+	MACRO__(0xE210, ## __VA_ARGS__), \
+	MACRO__(0xE212, ## __VA_ARGS__), \
+	MACRO__(0xE215, ## __VA_ARGS__), \
+	MACRO__(0xE216, ## __VA_ARGS__)
 
 /* PTL */
 #define INTEL_PTL_IDS(MACRO__, ...) \
-- 
2.39.5



