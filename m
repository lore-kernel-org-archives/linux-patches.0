Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E513D1EB5A;
	Mon,  4 Mar 2024 21:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588945; cv=none; b=uAptDMd9qm4Pj4eLMOYt//u7STzEiJFYKFubrMfn3HVz/BBMN2oAjSLvJxjWXQHwWFm2JD4jIqyKF1iG2tHWq/SYhMUUag3OQDr02yCfaPpMldXxras9nbjDOvZk7RS+Wm3dkfO7wv5bak250qXkedLxLUrwsFo2f+EDRMxBdRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588945; c=relaxed/simple;
	bh=oa6t1T8qzUEYK0X6vmgV2OhqGUVuoZtKmfaDVYrHXaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vzo1hJclxj/HEVh8c4v8GL3GWWVaFq0vcOQK0C2g61obN0LNspb2812Tr2Ab4ejR4GUOlhIIBXQ898b3/0s92xxGefFPTLjZoMQjsD9HNYWCymmxNTTxi1MnPvboOsAIh7ztK9HqKXf1ocOmX4vQB1h46OMvR2IuUzQEDc+lqF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwXGRePm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwXGRePm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9668C43390;
	Mon,  4 Mar 2024 21:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588944;
	bh=oa6t1T8qzUEYK0X6vmgV2OhqGUVuoZtKmfaDVYrHXaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwXGRePm94R5atnbjFrXNdse3UZXV6FtIkIJZ4Z9Ix9gHeXex+4VJIbOL8DFdgVm5
	 MPprYpFZa7eH/ijkGDC9YCM3zEebelvV+G8eGo9nl5OoeCeJtbwjXhBsFk8Ne+OY0G
	 t0jVAVc//k7el8bmLhApUY1xbMReKi0st0/7IDag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	kernel test robot <lkp@intel.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Samson Tam <samson.tam@amd.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 141/215] drm/amd/display: Increase frame warning limit with KASAN or KCSAN in dml
Date: Mon,  4 Mar 2024 21:23:24 +0000
Message-ID: <20240304211601.528915648@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5b750b22530fe53bf7fd6a30baacd53ada26911b upstream.

Does the same thing as:
commit 6740ec97bcdb ("drm/amd/display: Increase frame warning limit with KASAN or KCSAN in dml2")

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311302107.hUDXVyWT-lkp@intel.com/
Fixes: 67e38874b85b ("drm/amd/display: Increase num voltage states to 40")
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Alvin Lee <alvin.lee2@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Samson Tam <samson.tam@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -51,8 +51,12 @@ endif
 endif
 
 ifneq ($(CONFIG_FRAME_WARN),0)
+ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+frame_warn_flag := -Wframe-larger-than=3072
+else
 frame_warn_flag := -Wframe-larger-than=2048
 endif
+endif
 
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o := $(dml_ccflags)
 


