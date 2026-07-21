Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FCC408615;
	Tue, 21 Jul 2026 18:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658984; cv=none; b=BMXydCP2N2w2ybG+I/o6Ii0ckvLImqny4143dhjwH630ydwBy8n19gQB1c9T5/aKs0IFbqvxKScAJHQXEUkylPo4/N3g0pejpo/rEktaXJ7sLPVpwqlIR1zm8mzVJU0BoFOLa0fn1dEi2rZIATZrhkvJEqp19GF1BnHwm7RuSHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658984; c=relaxed/simple;
	bh=lPGJvJ3RF6fQm+stLtUnDQaXAMnxIu5xy701nEVBZ2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iMV9GK3Kf4fG+DRWlM/oUQ/UvgRkt45DtqYFtqkA9LueK6Slzep6O4G5qnSUJGdBx+4mPwZuXdm4BFJKpADc6J/LXSQSPSiCzSVUNsUJ+BPyGZ1xW2ddMKPt5EjCz9u1C1jl6eh1MRjSKjVafjn13W0fCBbwp7TQ7+4RPfvsLXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glQaQXV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glQaQXV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5270A1F000E9;
	Tue, 21 Jul 2026 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658983;
	bh=s0HyFrrFPpNAnYQw/dVOuGA/W58mtd6wilMLBLqnSf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glQaQXV3zdgAj69Y/A2pQ2/QjNzJ4Fwg5PyAlP7iCRcT1G/Zc6nrckUHveBt+MmHH
	 PeB/owkOtiUjCrUf4Z6KTMQ4hOr2BsZav70UYRXmj/D9VKq1kZbotCoNmstW8cq5r4
	 nxrvdt7JpWdc+F7rsVhW/eRAesVePft4n44YyAQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Lai <yi1.lai@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 1297/1611] platform/x86: ISST: Restore SST-PP control to all domains
Date: Tue, 21 Jul 2026 17:23:33 +0200
Message-ID: <20260721152544.617422294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@intel.com>

commit 2565a28cdcdcb035e151d285efcba26bccb3726e upstream.

The SST-PP control offset is only restored to power domain 0 after
resume. During suspend, control values are read and stored for all
power domains.

Use pd_info->sst_base instead of power_domain_info->sst_base, which
only points to power domain 0 base address.

Fixes: dc7901b5a156 ("platform/x86: ISST: Store and restore all domains data")
Reported-by: Yi Lai <yi1.lai@intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260528204521.3531456-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1786,7 +1786,7 @@ void tpmi_sst_dev_resume(struct auxiliar
 		memcpy_toio(cp_base + SST_CLOS_ASSOC_0_OFFSET, pd_info->saved_clos_assocs,
 			    sizeof(pd_info->saved_clos_assocs));
 
-		writeq(pd_info->saved_pp_control, power_domain_info->sst_base +
+		writeq(pd_info->saved_pp_control, pd_info->sst_base +
 		       pd_info->sst_header.pp_offset + SST_PP_CONTROL_OFFSET);
 	}
 }


