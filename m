Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3D122A81D;
	Tue, 29 Apr 2025 17:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946374; cv=none; b=lM1FsT+ej8QKe4KdAdmnRYhtEmI03Tqrl5P5WSbKF5p5f2HLW0CurY05WYsE0OGabMd82Ob8oL9BfNuT+hZ+b+gbwv6111QjG8qa0n2WmQDLcaFyhB8HF4aAkUXOBMt8pVVj4Y4Fb4Ljt/7jyq1GcywwPyl65NSYVwgkMWZqC+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946374; c=relaxed/simple;
	bh=3V0TpQYY25r0KEpfQ+qOVAXtF57FUdp4WFYMdQkEJQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz7PWxWil3sVdvXGVEvPeOH7Jnk/unU3QJAC9cJ1/39IlBDFbx+bycyRXg+WpZMI1dS6Fpg9Z2Rq/0bat7DmMhDANslGkVn9RWGCE1dE99TtrUgP8ZE+dIxUQD4+MGUGLcsaOZ6bI65oeela95Gh0CyKcIkrqtDywJ12PhP03ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5iwNNyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5iwNNyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4467C4CEE3;
	Tue, 29 Apr 2025 17:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946374;
	bh=3V0TpQYY25r0KEpfQ+qOVAXtF57FUdp4WFYMdQkEJQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5iwNNyuSnGGJ1zFJWasWBWj15xkq9ryd4GO7hP+tCLydqIyddV26QeROAoiOcXrf
	 0Y8VovP3ay/zQhEUbzHbfcWU7NdZWILwRMDGtLHU8flRQ66lX1fMlCErPSoAmxQDK5
	 Wqcl7A8SP2nyRhL6FRha6by0xptWnpWMIBRhSKHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 244/311] xen: Change xen-acpi-processor dom0 dependency
Date: Tue, 29 Apr 2025 18:41:21 +0200
Message-ID: <20250429161131.025431542@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index f7d6f47971fdf..24f485827e039 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -278,7 +278,7 @@ config XEN_PRIVCMD_EVENTFD
 
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
-	depends on XEN && XEN_PV_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
+	depends on XEN && XEN_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
 	default m
 	help
 	  This ACPI processor uploads Power Management information to the Xen
-- 
2.39.5



