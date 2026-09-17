Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820154078D3;
	Thu, 17 Sep 2026 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671448; cv=none; b=UGoqEMitt1leMgZ3S0g9ggjbLdY4FAKVRO3QjWZGyVx6ZRTZZtrx2mx9C9x9zudWiF0KZm6hADELsFdmpWSkQiLk1JIyOlDPQi5RkPgQqJfqMAj/jfFyHpA2SventjEIUcDVd1yl2qGdmILQDxoMHpK7DYLAMvEOxRLp1o5tJQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671448; c=relaxed/simple;
	bh=XwoDaQxN6kVJFWhnOuiZOfcOdHdI4j4HDcj3yfyAPsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgz9e/um+ZzBdBlbY1K1GV6V5YTvxZBdMTn3X+9w6LOLMfD9T6VSpfXEacZ8YhfvEr2zeangGAZrBT6GglBCoAOYLa/OuaisWohIpY8glvYgbtSmLoH+NpkkMk6nmJ3lyDf9xnvcsxwb8uT1ldeMNN38Z+IJPKJN2XvNTil8DAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikU4j2Iu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikU4j2Iu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97811F000FF;
	Thu, 17 Sep 2026 18:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671447;
	bh=mM7cfNedxxSnSfCSY1vRc78s7hHEwMVY6O3ferJqf3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ikU4j2IuWCAdyM8qub++NcOyokrPKQjWsiiiU6zFJQlO909tif3tH0MXy+p+yNSma
	 WRf6JiLJ/M4YMZLlsSgb8CgjzymHHfxzHrwD9Tmco/VRVnNDHvzn7TApWVj5IS97/V
	 V0/apakglJZn8hYuNMZ8vcjRODbQJFLpE39uS2PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Pavan Kumar Paluri <papaluri@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0980/1102] KVM: SEV: Disable SEV-SNP support on initialization failure
Date: Thu, 17 Sep 2026 16:15:23 +0100
Message-ID: <20260917151605.300973130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 179a8427fcbffe36ccfed5e138d7c9b6180caff9 ]

During platform init, SNP initialization may fail for several reasons,
such as firmware command failures and incompatible versions. However,
the KVM capability may continue to advertise support for it.

The platform may have SNP enabled but if SNP_INIT fails then SNP is
not supported by KVM.

During KVM module initialization query the SNP platform status to obtain
the SNP initialization state and use it as an additional condition to
determine support for SEV-SNP.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Pratik R. Sampat <prsampat@amd.com>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Pavan Kumar Paluri <papaluri@amd.com>
Message-ID: <20250512221634.12045-1-Ashish.Kalra@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 42a39ad5d592 ("KVM: SEV: Track the GPA of the guest-controlled VMSA used for SNP guests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/sev.c |   44 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 35 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2984,6 +2984,33 @@ void __init sev_set_cpu_caps(void)
 	}
 }
 
+static bool is_sev_snp_initialized(void)
+{
+	struct sev_user_data_snp_status *status;
+	struct sev_data_snp_addr buf;
+	bool initialized = false;
+	int ret, error = 0;
+
+	status = snp_alloc_firmware_page(GFP_KERNEL | __GFP_ZERO);
+	if (!status)
+		return false;
+
+	buf.address = __psp_pa(status);
+	ret = sev_do_cmd(SEV_CMD_SNP_PLATFORM_STATUS, &buf, &error);
+	if (ret) {
+		pr_err("SEV: SNP_PLATFORM_STATUS failed ret=%d, fw_error=%d (%#x)\n",
+		       ret, error, error);
+		goto out;
+	}
+
+	initialized = !!status->state;
+
+out:
+	snp_free_firmware_page(status);
+
+	return initialized;
+}
+
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
@@ -3088,6 +3115,14 @@ void __init sev_hardware_setup(void)
 	sev_snp_supported = sev_snp_enabled && cc_platform_has(CC_ATTR_HOST_SEV_SNP);
 
 out:
+	if (sev_enabled) {
+		init_args.probe = true;
+		if (sev_platform_init(&init_args))
+			sev_supported = sev_es_supported = sev_snp_supported = false;
+		else if (sev_snp_supported)
+			sev_snp_supported = is_sev_snp_initialized();
+	}
+
 	if (boot_cpu_has(X86_FEATURE_SEV))
 		pr_info("SEV %s (ASIDs %u - %u)\n",
 			sev_supported ? min_sev_asid <= max_sev_asid ? "enabled" :
@@ -3114,15 +3149,6 @@ out:
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
-
-	if (!sev_enabled)
-		return;
-
-	/*
-	 * Do both SNP and SEV initialization at KVM module load.
-	 */
-	init_args.probe = true;
-	sev_platform_init(&init_args);
 }
 
 void sev_hardware_unsetup(void)


