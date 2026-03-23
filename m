Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5F62D9ECB;
	Mon, 23 Mar 2026 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276855; cv=none; b=LJl1gnrFqAZ5F3/DaBEdcNTYlKkDxVKqNDkFcSH0xO7VhfM4U8z3h3HD6hIbpa2zKp/Fqymh7AQ/k49ioomZVHy4jqfc+9pGfjt9ZWooOtdfe97cpWEsuXmc47mxUhl9yol8I2wQdlrCA6ECvnbjEYYCOTkQH3Ji3VapwgIXcvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276855; c=relaxed/simple;
	bh=k9rPnA0nMOhzCH1J7qb/2Y7s9D95bBIRXwGU+evDVJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uUX0u5VE0O8TKUCDmSTOxM6AmnewK5BWUsIBnPkmSP4c0Q8hNlgibRpMk1nfx/4Ntx7wAyl9ZyPrBbzElwZi9YLfffzck5ExpUG5Mt3qFmbKfyNqrx4ejtKQBj9DLfxWtvLEWHoe5HmgV0IG7bIzHKl61vIenMw2LFT7iF2eRwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfYijSGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfYijSGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B89DC2BC9E;
	Mon, 23 Mar 2026 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276854;
	bh=k9rPnA0nMOhzCH1J7qb/2Y7s9D95bBIRXwGU+evDVJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfYijSGNueQs0iHKyYgwsjRslnA1gspvjeqU9OmmTcDKLnbFsY4mgW2PLjUtajICu
	 HoxfhptGfNcna6EG+Jgb2WRz6/DBP1EsUrOvCDlVO3giMTwrH5SKNmgcKFrxKV9u01
	 uBRiRa1CzfYxos2zpDMakQbfxECr9BRKMsPIIYmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kerry <p.kerry@sheffield.ac.uk>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/460] platform/x86: hp-bioscfg: Support allocations of larger data
Date: Mon, 23 Mar 2026 14:43:44 +0100
Message-ID: <20260323134532.098212780@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 916727cfdb72cd01fef3fa6746e648f8cb70e713 ]

Some systems have much larger amounts of enumeration attributes
than have been previously encountered. This can lead to page allocation
failures when using kcalloc().  Switch over to using kvcalloc() to
allow larger allocations.

Fixes: 6b2770bfd6f92 ("platform/x86: hp-bioscfg: enum-attributes")
Cc: stable@vger.kernel.org
Reported-by: Paul Kerry <p.kerry@sheffield.ac.uk>
Tested-by: Paul Kerry <p.kerry@sheffield.ac.uk>
Closes: https://bugs.debian.org/1127612
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260225210646.59381-1-mario.limonciello@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[ kcalloc() => kvcalloc() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
+++ b/drivers/platform/x86/hp/hp-bioscfg/enum-attributes.c
@@ -94,8 +94,11 @@ int hp_alloc_enumeration_data(void)
 	bioscfg_drv.enumeration_instances_count =
 		hp_get_instance_count(HP_WMI_BIOS_ENUMERATION_GUID);
 
-	bioscfg_drv.enumeration_data = kcalloc(bioscfg_drv.enumeration_instances_count,
-					       sizeof(*bioscfg_drv.enumeration_data), GFP_KERNEL);
+	if (!bioscfg_drv.enumeration_instances_count)
+		return -EINVAL;
+	bioscfg_drv.enumeration_data = kvcalloc(bioscfg_drv.enumeration_instances_count,
+						sizeof(*bioscfg_drv.enumeration_data), GFP_KERNEL);
+
 	if (!bioscfg_drv.enumeration_data) {
 		bioscfg_drv.enumeration_instances_count = 0;
 		return -ENOMEM;
@@ -444,6 +447,6 @@ void hp_exit_enumeration_attributes(void
 	}
 	bioscfg_drv.enumeration_instances_count = 0;
 
-	kfree(bioscfg_drv.enumeration_data);
+	kvfree(bioscfg_drv.enumeration_data);
 	bioscfg_drv.enumeration_data = NULL;
 }


