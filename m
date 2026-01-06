Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B2B34EF0A;
	Tue,  6 Jan 2026 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720091; cv=none; b=FV1dB/XQD4VJ/p259jl2P4M7XyEDeRuW57x/Vx4aUGQfbERYIs6sGoWIWayKUAu7iD7M+n5POg3a03xCZbvVI8YevkyCtJDNqhmG4EX9LKfgp7xTIBzSWU9M0p2c183dxd5kug684HfFrb3cRgDIRJqzqPsgwqN9joMKR4SVvZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720091; c=relaxed/simple;
	bh=H/AK4q6H7s2pFIwbnoanw8gnvQ6wgOcs+QgFxnxdLUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=poL3sSWk+tC1NPZrE4bmRPlF5DT9S6TZy+JuLQ3or/iWoTawDj9bd1Sd4e6U/IXRI9RjC3STGkE3w+zL8zCflElDJP3o2jpkwE1eAQ+NaTeT4CoCAHi9rnZKJLKSrEO4ZLsUt9/DCL/kFK6SZXAjLscoKfr7PLMCJ6ZYPDanchY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oWzoUWmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oWzoUWmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A8CC16AAE;
	Tue,  6 Jan 2026 17:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720091;
	bh=H/AK4q6H7s2pFIwbnoanw8gnvQ6wgOcs+QgFxnxdLUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oWzoUWmBg4AcNt5Ebq9TnIjMksxYdmIcoMXi4LBTxqlJZk1y7jL9hyFYKELXRJAYE
	 b/X/wfjvTsSgrZB2aluKaVb4QbRfDZVqEitTTGJHAZ+jxi2l6a4WDd/FbtgcwwGmiM
	 IZ12EOzec8bCJJRpcSD4X4zDs1QN9AMqCjRxtwxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.12 104/567] ACPI: PCC: Fix race condition by removing static qualifier
Date: Tue,  6 Jan 2026 17:58:06 +0100
Message-ID: <20260106170455.175392367@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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


