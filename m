Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E6F359FBA;
	Fri,  9 Jan 2026 12:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960360; cv=none; b=kpV2cM0Z4pxlAwKg7Sj0T54Lhy65HC4BfCAvyaHvt/uRILHV8WIdq0uM6mN1bPNEzqz9/0BBFYLpZzu2zhPHUHyiXc3tpOmgQAGXKvCohJE9pfydufWkkuJWMQL2KQ+xDXAUArylHO86FgOwVyXqQ0SmyjwzQ5X8m5t4tb7nzUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960360; c=relaxed/simple;
	bh=PUrCsLkGrQ1XRdXY6Wv9V5C6nUpbkz1KmkaVx/jKSbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wt51RWZrTUoltvG06HKbTXaRf8y8wGLSLu/EphPWKND2Q4Xg6EIcqBaC6aR6alESmhLFjvHREGwpxL0rJOhOjABFx2e238pLFNRCZRWLLa45SSgQO87ZNRMN+x6w4X5G/p6zsSznnWTRsuKsZQSnVaSp98hJatSj6Iki5P9rsb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLWRxMPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLWRxMPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8987C4CEF1;
	Fri,  9 Jan 2026 12:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960360;
	bh=PUrCsLkGrQ1XRdXY6Wv9V5C6nUpbkz1KmkaVx/jKSbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLWRxMPGdHQJmFWR6LVNTBcwAoalHdZ3ai7IKgf3zMecvqj4aX9jrjGoAj95rpW/+
	 5IPQc0lskwAM2s/IlostOwyifGNpjodJBJfSstsK2L0LoO44h6DC6fdMWyBraaASAO
	 d63CCaFab2dnLYY694iaGc912KSm7YTbNwZjWsZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 376/737] ACPI: PCC: Fix race condition by removing static qualifier
Date: Fri,  9 Jan 2026 12:38:35 +0100
Message-ID: <20260109112148.138922246@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengjie Zhang <zhangpengjie2@huawei.com>

commit f103fa127c93016bcd89b05d8e11dc1a84f6990d upstream.

Local variable 'ret' in acpi_pcc_address_space_setup() is currently
declared as 'static'. This can lead to race conditions in a
multithreaded environment.

Remove the 'static' qualifier to ensure that 'ret' will be allocated
directly on the stack as a local variable.

Fixes: a10b1c99e2dc ("ACPI: PCC: Setup PCC Opregion handler only if platform interrupt is available")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: lihuisong@huawei.com
Cc: 6.2+ <stable@vger.kernel.org> # 6.2+
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20251210132634.2050033-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_pcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -53,7 +53,7 @@ acpi_pcc_address_space_setup(acpi_handle
 	struct pcc_data *data;
 	struct acpi_pcc_info *ctx = handler_context;
 	struct pcc_mbox_chan *pcc_chan;
-	static acpi_status ret;
+	acpi_status ret;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)


