Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4012B4A99F;
	Mon,  8 Jan 2024 15:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKGHYcJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 893D9C433D9;
	Mon,  8 Jan 2024 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726854;
	bh=9hGLalQ8YV9AchaQDJIxWYd/69xQr72E+nxKDDG7gZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKGHYcJNWz6vTjsXHE8ARolapb/XRNhLw9DhX/kbGFIZO9nao6CUtyK9ySicAtrKd
	 e7mzMIJZwdvxVpzJCqTAJB9RYFkQagN9S2Ef9IgAgzjiSEwZ1R1vfZx8YFraOuozPx
	 PWPxYf6IVY8XBiuBcvC/Ei6qJeV0NJ6pWgY0Xx5Y=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 100/124] drm/amd/display: Increase frame warning limit with KASAN or KCSAN in dml
Date: Mon,  8 Jan 2024 16:08:46 +0100
Message-ID: <20240108150607.570246259@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 5b750b22530fe53bf7fd6a30baacd53ada26911b ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index 77cf5545c94cc..c206812dc6897 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -61,8 +61,12 @@ endif
 endif
 
 ifneq ($(CONFIG_FRAME_WARN),0)
+ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+frame_warn_flag := -Wframe-larger-than=3072
+else
 frame_warn_flag := -Wframe-larger-than=2048
 endif
+endif
 
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o := $(dml_ccflags)
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_vba.o := $(dml_ccflags)
-- 
2.43.0



