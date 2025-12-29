Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8966A33123C;
	Mon, 29 Dec 2025 16:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025279; cv=none; b=Xn2TrjGQh7JH8qQawpIlNz0aG6dxYzJjtvqrDySjUZb9A9x4L5XqUBeGQdRjAN3DIt3vXA8VHywJLYeBJkhpvjAUCTIkTti1q4qYCL+M/oWlXG8SuCX1okdl4IIydyJ/jYSdKG9KDul59EO/dOnjQP7VmrfFeffOsNFydSn/ldg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025279; c=relaxed/simple;
	bh=tN1AuMsXgfzznepoG2pFsWw93YPYT8RqjRjzB/dt6tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSzWAZisXsUSrFDfUl6iKikGUjZCeFA6C5Wk7KLPjIYwmpTf8bHfwkSVHin4rMffGpgfN8HYrr9ulus0Vc+nVwOR1utZVyOkvvQrAvibq4D3qJV7u9Oii7qmdGUhqUfrLFomXRagEAtMTpRikDe3MKuX+0z4bA6Sy0m+XlWr52Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QwXR2KKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QwXR2KKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C26C4CEF7;
	Mon, 29 Dec 2025 16:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025279;
	bh=tN1AuMsXgfzznepoG2pFsWw93YPYT8RqjRjzB/dt6tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QwXR2KKq7vyijMpGb2VGqYAVHLq5/Y6BiWuGgG0grJtEnTRzXXG3B++RxkDlyR/Le
	 J3rtknYJMaIx4cqX1diwPM7BJeWk3jCLROM0+X5oNKWR4wq0WSFp1H2H9wPUjQGuEV
	 mRoR4WzFG5TvFTBxpphs26gy1/ODAXBu8KeUfChk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 157/430] ACPI: PCC: Fix race condition by removing static qualifier
Date: Mon, 29 Dec 2025 17:09:19 +0100
Message-ID: <20251229160730.137487913@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
@@ -52,7 +52,7 @@ acpi_pcc_address_space_setup(acpi_handle
 	struct pcc_data *data;
 	struct acpi_pcc_info *ctx = handler_context;
 	struct pcc_mbox_chan *pcc_chan;
-	static acpi_status ret;
+	acpi_status ret;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)


