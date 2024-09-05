Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F651922CC;
	Thu,  5 Sep 2024 09:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529818; cv=none; b=iVSqV9NzfcBTNx1P6+5t7VnWjjwC2u2B4C54loEL2yLanJ1ma+4n0a7wMv+wycYsmjlKsp00JaXiWMFsL5yBykEDFjWG7zreBhHL56zBMNEEQiQI7kIcBzP3YsioZ8AdcHarh2Px4WrROfXmv7q63v0javTX2IF0J7Ei5wBuGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529818; c=relaxed/simple;
	bh=8WXIPWFF5ulscHN7+kLfuSj6HWbsykgdBwCuIWDqCng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gN1a6M8VCFlEBZd/fW9NLDoHR3lP1qHVMfUEnGwWK4AOBjwYSlB5l3xj1CrY7Ha5VdwXg9mBONthsUANt7WZowkdYl/jv0aeAG9n0KeDypvn4qomNf3LJTm/5rMx7BgstalpGolH528kAVbBCF9MklM0wv8hH4qwDsUvDS/K8R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0Xzhuv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0Xzhuv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C805C4CEC4;
	Thu,  5 Sep 2024 09:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529817;
	bh=8WXIPWFF5ulscHN7+kLfuSj6HWbsykgdBwCuIWDqCng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0Xzhuv28HpSN5HUSEPA+G+XYo0ZF3Vg74tx1FuOqpC3ltOG/ZTchI66VSNRVcjJu
	 +sRRpQM/4PodLin6BF5Za3eQGmbg2bno1ge5iHZDb59BvBvDqEOMeaRFenCMXaWG3X
	 R4FQ77SoqIN91IOe4ElFoyY/90N460Z/rMXOxa10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Badal Nilawar <badal.nilawar@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 151/184] drm/xe: Ensure caller uses sole domain for xe_force_wake_assert_held
Date: Thu,  5 Sep 2024 11:41:04 +0200
Message-ID: <20240905093738.234353950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 3541e19d0d3b30ad099c0c26ba87561aedfbd652 ]

xe_force_wake_assert_held() is designed to confirm a particular
forcewake domain's wakefulness; it doesn't verify the wakefulness of
multiple domains. Make sure the caller doesn't input multiple
domains(XE_FORCEWAKE_ALL) as a parameter.

v2
- use domain != XE_FORCEWAKE_ALL (Michal)

v3
- Add kernel-doc

Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Badal Nilawar <badal.nilawar@intel.com>
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240607125741.1407331-1-himal.prasad.ghimiray@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_force_wake.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_force_wake.h b/drivers/gpu/drm/xe/xe_force_wake.h
index 83cb157da7cc..8cbb04fe0ed9 100644
--- a/drivers/gpu/drm/xe/xe_force_wake.h
+++ b/drivers/gpu/drm/xe/xe_force_wake.h
@@ -28,10 +28,21 @@ xe_force_wake_ref(struct xe_force_wake *fw,
 	return fw->domains[ffs(domain) - 1].ref;
 }
 
+/**
+ * xe_force_wake_assert_held - asserts domain is awake
+ * @fw : xe_force_wake structure
+ * @domain: xe_force_wake_domains apart from XE_FORCEWAKE_ALL
+ *
+ * xe_force_wake_assert_held() is designed to confirm a particular
+ * forcewake domain's wakefulness; it doesn't verify the wakefulness of
+ * multiple domains. Make sure the caller doesn't input multiple
+ * domains(XE_FORCEWAKE_ALL) as a parameter.
+ */
 static inline void
 xe_force_wake_assert_held(struct xe_force_wake *fw,
 			  enum xe_force_wake_domains domain)
 {
+	xe_gt_assert(fw->gt, domain != XE_FORCEWAKE_ALL);
 	xe_gt_assert(fw->gt, fw->awake_domains & domain);
 }
 
-- 
2.43.0



