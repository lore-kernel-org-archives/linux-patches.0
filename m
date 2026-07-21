Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB5A3DD870;
	Tue, 21 Jul 2026 18:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658396; cv=none; b=NiVYwephbwyO/k2IHnHAHm7Q7QwpjT62BrzmzrDHtak+ghvtXYS5233BSMSZfB395PN7OdVWIrEW/0ifclqJP1/W4RLUbZC90E7CqXd3x8YFqSkzvPMdYtjIj3L7s2p8fwcsVivnc5DkGta041KOUsI2gG0c+3l6ADWYXHB47tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658396; c=relaxed/simple;
	bh=cqCARHdMLw8SIorRoZ5+8/9zE2BdbAirzQUdms0QRs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODYMGma4fYSKUtaAqGtMB+w7bI5KVee2OFyAbkoJwHCnLjFJxawKl98xPW8irIcRKZnbYTSYvixG2Hmcrt/tzpCigS1VVmUjSYAs4rRw4+rrh1Yedq3Z9692a5br+K5FmJ2qSFmSOMcaFGvAHjJMxKdULbQOBjxaoDVflbp0sK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14jP5b1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14jP5b1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B191F00A3A;
	Tue, 21 Jul 2026 18:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658394;
	bh=seESMGKqm/P5rySNhqGWug5eLAGFz/F7nHLH501lDwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=14jP5b1vicXAatCnMl7aAWorwygBDLQs9IsO/m9jqCAaru1cFH8/38lZoj/DlL1gD
	 eF2UPcMAdi/cCOA/hvILj54whBd/ZXjjFwueO79/MKbgZb4HY1nGTLcbv9Wixe5Ph7
	 qipTiNGNoCSzoJKFk+SPFu/6/q2lCygR1D6eo6Vw=
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
Subject: [PATCH 6.18 1128/1611] powerpc/pseries/Kconfig: Enable CONFIG_VPA_PMU to be used with KVM
Date: Tue, 21 Jul 2026 17:20:44 +0200
Message-ID: <20260721152540.793812808@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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


