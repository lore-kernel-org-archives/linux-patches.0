Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F831F3D56;
	Tue, 21 Jul 2026 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654053; cv=none; b=XIEy+o4djQHEyTOm4EI12eGj6kpnPPw1E42Dcj6EODLVsEZvR3qcFIXQF0N36dRsZUN4fU+E/P+oSBfk9z16oxayHGwILSXsymU7yfRxtS5gWaYGlHMS1f9mgTxBjgoECuUEd7kCkFfKyfq43Zz577lGs+zINcDJyBEVOFLZbiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654053; c=relaxed/simple;
	bh=FRSgZVAL/xQDfWQwASGRoXkg5a3CP+eJTYFmYpYb43o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDeULiesIOoihVPdZ748rq/P6Vw708Y/jlquqrKviwFtK1z1f/jqZKVm6kUQmxtcuVUoV19L8QulZjHN1poevlo3KYTQXbxYfWb+nWJ7PybthBYPGGgfEgP0eJbn1n7bqY1jeYP5j2kFM81+FY5bGeCMl3NCKyzPCyveaktDHmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYerNHcy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYerNHcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C9A1F000E9;
	Tue, 21 Jul 2026 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654052;
	bh=KMpVbFad3zMoviteLegjA3z+W1t4ZelN1FlMJsHKJtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYerNHcyG2S6uH41jzFV0ZSYL6JJ6AXw2ISXbs4I3E5DewA0VBZia1T4vlbRvfZHi
	 Bgmdw04KDKccyreqp+3hhkXIHOw2XpnQzRnZ4czL7kvkC7QVVq7Df5JFQsrh50RbNk
	 Ymb+UOi4jNbmGyW+a3TMCPHOarHR1mkZrfUcjdrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Gautam Menghani <gautam@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 7.1 1558/2077] powerpc/pseries/Kconfig: Enable CONFIG_VPA_PMU to be used with KVM
Date: Tue, 21 Jul 2026 17:20:31 +0200
Message-ID: <20260721152629.529543049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautam Menghani <gautam@linux.ibm.com>

commit fe179677b6dcb4b658586038a811f87265e97777 upstream.

Currently, CONFIG_VPA_PMU is not enabled by default, and consequently
cannot be used for KVM guests at all, unless explicitly enabled on
host kernel.

Mark CONFIG_VPA_PMU as "default m" to ensure it is available when KVM is
being used.

Cc: stable@vger.kernel.org # v6.13+
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
[Maddy: Changed tag order]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260615091120.84169-1-gautam@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -154,6 +154,7 @@ config HV_PERF_CTRS
 config VPA_PMU
 	tristate "VPA PMU events"
 	depends on KVM_BOOK3S_64_HV && HV_PERF_CTRS
+	default m
 	help
 	  Enable access to the VPA PMU counters via perf. This enables
 	  code that support measurement for KVM on PowerVM(KoP) feature.


