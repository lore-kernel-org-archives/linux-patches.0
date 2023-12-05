Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC466DCE4;
	Tue,  5 Dec 2023 20:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="coBmld9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F7AC433C7;
	Tue,  5 Dec 2023 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701807224;
	bh=UvvCP2cr3Sol/CXMJFp/czhZ/k3NKffJrLgAuSfn1xA=;
	h=From:Subject:Date:To:Cc:From;
	b=coBmld9N/VoJIhT5CBN39p88BfHbQoOq2L0k1QKXGUWcqwUDmNx7FibgZ7EgkzVwR
	 8shoY0C4GN3n/bczW3LirTDjuIII/5Z3LjZZ1zfPJT9As3HYeFjfuIe88p3T/aYJ6f
	 gZKXyorwKOg8ashEsK/LuzcCAOo2yAYTP9tQekdPBf5TXR4uVB9asXi6ZQaufPVaxX
	 2zgVny5kWpxtaVU/cjbrh/3ML2Cj9/ZpUfbuPNjtu05uEvK4aM9FCVHITiv15QYAuk
	 EuahNLLCP3xvHfo+IHc3EjYjPLEq8CvAqVSr0cmHaugJBL/sGUOelzVPwSiXD10RB6
	 mgotKmv1YBcOg==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/3] A few fixes for transparent bridge support
Date: Tue, 05 Dec 2023 13:13:33 -0700
Message-Id: <20231205-drm_aux_bridge-fixes-v1-0-d242a0ae9df4@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG2Eb2UC/x3LSQqAMAxA0atI1hbaOlS8iohUGzULB1KUgnh3g
 8vP4z8QkQkjtNkDjDdFOnYJk2cwrX5fUFGQBqttYayuVOBt8FcaRqYgOlPCqExtXaMxOF16kPV
 k/EHOrn/fD7V4nZhmAAAA
To: dmitry.baryshkov@linaro.org
Cc: heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org, 
 linux@roeck-us.net, neil.armstrong@linaro.org, bryan.odonoghue@linaro.org, 
 linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>, 
 kernel test robot <lkp@intel.com>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=829; i=nathan@kernel.org;
 h=from:subject:message-id; bh=UvvCP2cr3Sol/CXMJFp/czhZ/k3NKffJrLgAuSfn1xA=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDKn5LWVcDm2P989pn/7u+ftPnCrlVz1uMsv63O4xmCtYY
 DX/xPHNHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi0Y8YGSb03zS/MHHtWk3L
 J/9FRTvV3CZW5i/bcyfwhZ2xsF5suwrDP7Uva/fu5FH+/mBJhUC/z/eJIb9/bdESK3rbwM999TD
 Pa1YA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series fixes two Kconfig issues that I noticed with the selection
of CONFIG_DRM_AUX{,_HPD}_BRIDGE along with a fix for a sparse report
that I noticed while seeing if these had already been resolved.

---
Nathan Chancellor (3):
      usb: typec: nb7vpq904m: Only select DRM_AUX_BRIDGE with OF
      usb: typec: qcom-pmic-typec: Only select DRM_AUX_HPD_BRIDGE with OF
      drm/bridge: Return NULL instead of plain 0 in drm_dp_hpd_bridge_register() stub

 drivers/usb/typec/mux/Kconfig   | 2 +-
 drivers/usb/typec/tcpm/Kconfig  | 2 +-
 include/drm/bridge/aux-bridge.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)
---
base-commit: 4900e0396e59be233cfa636369d4eec6b40dbeca
change-id: 20231205-drm_aux_bridge-fixes-162780ed704a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

