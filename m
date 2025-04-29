Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D311A5BBB;
	Tue, 29 Apr 2025 18:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950102; cv=none; b=TG/HJao4vJjfpPPwWgubGgIR59qkV6RFnHFJCURKs3lAkH9jKyfWdKObHolm/05fmfbl1ukpuxibL0w0AsPkJ4Fnafz7xcrF00S2Xmyt1RSVPW9vYVRAngMUQXCHsgxsiXqACLQ62XYGPjx8JnjOPrftxDuOTJaaWwPj9x2rvAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950102; c=relaxed/simple;
	bh=kGr4vMUtTCiZYoLCGzjbcrQoOVyp2VaQj24HufiliQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZaS+50rMNVUl+SJH8o/3qHFSEx3kP3R3Keju2BoxkLJWg8s+tjW+gTC9d4Y2ou2IdFb/56eaZNQb0TdiKZsyXpYoAXjuShaX1kV5UBb4m19lSpubs+y1BmPb2f6nYSa2WqxVcPdFbumEglCeVIkCOAjWIasvG1CnX+hk4V4iow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fe2AwO3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fe2AwO3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980ABC4CEE3;
	Tue, 29 Apr 2025 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950102;
	bh=kGr4vMUtTCiZYoLCGzjbcrQoOVyp2VaQj24HufiliQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fe2AwO3xaJo/ImwerXdTOruCJIEgF+yzGC5ANwpGQdLHenajYDbsIt1gY8EqGgys4
	 Fyi3JAldwFV364Gm1e96ewFuG6DpU1Cn3wCyo8MXs49wrRAdEae1Loyze7/OhlXs5Q
	 H1dMG4hsZrLaKRbGKJTFBdsc4UULyBSOs6CY2y20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/167] xen: Change xen-acpi-processor dom0 dependency
Date: Tue, 29 Apr 2025 18:43:55 +0200
Message-ID: <20250429161056.879861187@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

[ Upstream commit 0f2946bb172632e122d4033e0b03f85230a29510 ]

xen-acpi-processor functions under a PVH dom0 with only a
xen_initial_domain() runtime check.  Change the Kconfig dependency from
PV dom0 to generic dom0 to reflect that.

Suggested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Tested-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <20250331172913.51240-1-jason.andryuk@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index d5d7c402b6511..ab135c3e43410 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -271,7 +271,7 @@ config XEN_PRIVCMD
 
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
-	depends on XEN && XEN_PV_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
+	depends on XEN && XEN_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
 	default m
 	help
 	  This ACPI processor uploads Power Management information to the Xen
-- 
2.39.5



