Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23B73B6C03;
	Mon, 23 Mar 2026 15:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278793; cv=none; b=A9wFqkdoOMV0kxP8ZiOkuoTXm4fgp5gdXkhJmZSQrpCWatzEmifbF6sUARJbSPZ1ld4giOkTL0S3qaYaiy1aZa2LW4JPQIVUfvk7KAkNFQzNDRawkvMg/HFIzYkxF6qGT5TdSiNpLWFhhf6pSl3hjZNbLAkKPD1nIJwLnIkyeCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278793; c=relaxed/simple;
	bh=gCSuP0+F8sS7rAaUC/TnLaWZjLQITDs6EZSW80ZM24o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zl/4/lUsW72Jnm03CAi7b6BvcG3ooHjsJQGDd73NET8pJPJa0S06ZUtCxoHiTwpmGeWjb0mzM5TR8t3jyLet3/fwVn3ExEzqDInkmo02GnX2AL2jPg2I3BDvcTXz3Pv0j4k9+JC2z39G2Kcw6SWODnq6rikqxLFdU+6vIJA/4H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d0WOexqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d0WOexqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EAF2C2BC9E;
	Mon, 23 Mar 2026 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278793;
	bh=gCSuP0+F8sS7rAaUC/TnLaWZjLQITDs6EZSW80ZM24o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d0WOexqxThiArnVi9kYxGAsq67YdFfCBxlWlWQEgyU/HgUxLzY61D8zljdszCr9E8
	 saeR138wtkMtdTKI3MXLEbvA/WWRof8wk0IgevMNCbpi5vT60qbjBnrLE2S0GcQfEq
	 0FQlmfTMEBUqBgcLx0+iFjH1p7oUGXNeoxZn8ay8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kerry <p.kerry@sheffield.ac.uk>,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 369/567] platform/x86: hp-bioscfg: Support allocations of larger data
Date: Mon, 23 Mar 2026 14:44:49 +0100
Message-ID: <20260323134542.951248817@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -96,8 +96,11 @@ int hp_alloc_enumeration_data(void)
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
@@ -452,6 +455,6 @@ void hp_exit_enumeration_attributes(void
 	}
 	bioscfg_drv.enumeration_instances_count = 0;
 
-	kfree(bioscfg_drv.enumeration_data);
+	kvfree(bioscfg_drv.enumeration_data);
 	bioscfg_drv.enumeration_data = NULL;
 }


