Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153993FFD;
	Tue, 29 Apr 2025 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949636; cv=none; b=UhIaQy9/mCM2NBrNCtgreXOqUjo8ZSSaSLABXJNa9WcVgj1wy/BNaXN47+c2j6Rdlhmvz8vSRcuHc29/Y4xhbRnUI2vR0Cc2kepeFFHhoW7Qf8PmQHFwQln/jOhPSyUOxFucHZTi90Jr3NvG67DOB81vUvT2XdxqwYMyuaaLxK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949636; c=relaxed/simple;
	bh=vym/0Cl2xvkOAO0etETEK1KXrvwT6IYj/Af58sPZFNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b14QiXWycIJrxA4V+CIMCj8XSJQ1B89g0FIgrNVcprQfKXdmx+5b885Xojj0ub1q10hSn/bim6xGYl1q9z11iFujmhnkD2CWujkanTgmj5Dcufeba5YXtTbihjaXZsapYWwusOUjyZ2n1jCukUWuWm81yvC5h+FJoK47JjrT7Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+P/CDYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+P/CDYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91425C4CEE3;
	Tue, 29 Apr 2025 18:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949636;
	bh=vym/0Cl2xvkOAO0etETEK1KXrvwT6IYj/Af58sPZFNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+P/CDYyUBrGV7oS0ZkJv3wS/XTDqqrgEU3fSXQjAGApF3gpVojgTilQQ59s7KSjN
	 bGWxS8/xoztOYitW+XydBrwI0uhnNF5tZqwP8ewizRFFmnIvA1Zhc13KMK0IFjNO++
	 ELLOyG7boKMlKwrRJV8blMgCOWCzPvznO0BXe2xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/373] xen: Change xen-acpi-processor dom0 dependency
Date: Tue, 29 Apr 2025 18:43:40 +0200
Message-ID: <20250429161137.245922415@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1b2c3aca6887c..474b0173323a6 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -241,7 +241,7 @@ config XEN_PRIVCMD
 
 config XEN_ACPI_PROCESSOR
 	tristate "Xen ACPI processor"
-	depends on XEN && XEN_PV_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
+	depends on XEN && XEN_DOM0 && X86 && ACPI_PROCESSOR && CPU_FREQ
 	default m
 	help
 	  This ACPI processor uploads Power Management information to the Xen
-- 
2.39.5



