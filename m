Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66858522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD4DC433C8;
	Sun,  9 Jul 2023 11:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902450;
	bh=3mHwm5A/3Fa8cJOt/mS8kVyUwqZMIjyUP6tuVguET4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPIi7pv+K8IhG4WgQNbY/W2CE+WHS/k9dD34vOjY1SVsfzdgXyVnoKOgWNXSvh7Is
	 3bFRwoncubp+09G9ZBk2OeXW1lyr1tkbWUc1Xpon+X/9XZhSr7nMwXW4EsC5fxa9Kc
	 cSXoar9MStCFLx/hXcgQQar5RhxyLUyeXJ1NI9N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Pardee <xi.pardee@intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 363/431] platform/x86:intel/pmc: Remove Meteor Lake S platform support
Date: Sun,  9 Jul 2023 13:15:11 +0200
Message-ID: <20230709111459.680040768@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xi Pardee <xi.pardee@intel.com>

[ Upstream commit 416a87c972b978d71ab828442d1d48e3bd194855 ]

commit c5ad454a12c6 ("platform/x86: intel/pmc/core: Add Meteor Lake
support to pmc core driver") was supposed to add support for Meter
Lake P/M and mistakenly added support for Meteor Lake S instead. Meteor
Lake P/M support was added later and MTL-S support needs to be removed
since its currently assigned to the wrong register maps.

Fixes: c5ad454a12c6 ("platform/x86: intel/pmc/core: Add Meteor Lake support to pmc core driver")
Signed-off-by: Xi Pardee <xi.pardee@intel.com>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20230601004706.871528-1-xi.pardee@intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/pmc/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/intel/pmc/core.c b/drivers/platform/x86/intel/pmc/core.c
index b9591969e0fa1..bed083525fbe7 100644
--- a/drivers/platform/x86/intel/pmc/core.c
+++ b/drivers/platform/x86/intel/pmc/core.c
@@ -1039,7 +1039,6 @@ static const struct x86_cpu_id intel_pmc_core_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P,        tgl_core_init),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE,		adl_core_init),
 	X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_S,	adl_core_init),
-	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE,          mtl_core_init),
 	X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L,	mtl_core_init),
 	{}
 };
-- 
2.39.2



