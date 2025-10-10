Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458EA2F25FD;
	Fri, 10 Oct 2025 13:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102336; cv=none; b=NEkGf1/A0FxWczmirjwug+e9ULFeWnajiWCf4KYF5SzfiVlT3aWM4OvA8kNfTKGdfpy4ApPCD0WTyvmYCqo3DJqYwgZNk9Nl+Z/7wIiuKvUtzIpQIP0xU0z9Kckj+kFPQ1HPXe0SNEUTrsXwdQNTFtGzhYu0Q5TUUzd8Lk6nhBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102336; c=relaxed/simple;
	bh=FeAlHTss76h8QCdm4tVvFLu41PSgLcu1qhOWf2CQj3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N7YFNfbStHgctaMueocJ08SKiVT/fhTAsptS2G5N6JWjsBSTwUox3IT5zbz9i1NCoaKRexvzeuFc2J/PuOO5I8E9nVe20q7G7H+poOVB2NHbp0/e1d1z0Xu0qHa87P2PjBSWqCjyxrto0jtiqs1VmLKz4raDthGveac6hdmnauc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKUcudRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKUcudRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3492C4CEF1;
	Fri, 10 Oct 2025 13:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102336;
	bh=FeAlHTss76h8QCdm4tVvFLu41PSgLcu1qhOWf2CQj3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKUcudRCDrZwqWUWs1dIPAEUuX959E9K8zjxjfwdv2QNpI8gVK765BVmGhLYYxOIy
	 Eyjzi3aiiO7/UN2KgKxdPxFF+JR/nqAHESbDPj6GGs+IBSQM74BlUKgnSWWMPYtdvl
	 V26iMLR87YI3gk2D+aRA7uQR3+8OAaGTlAe5Wxds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 20/41] platform/x86/amd/pmf: Support new ACPI ID AMDI0108
Date: Fri, 10 Oct 2025 15:16:08 +0200
Message-ID: <20251010131334.153016626@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 1b09d08866277677d11726116f5e786d5ba00173 ]

Include the ACPI ID AMDI0108, which is used on upcoming AMD platforms, in
the PMF driver's list of supported devices.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20250915090546.2759130-1-Shyam-sundar.S-k@amd.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index ef988605c4da6..bc544a4a5266e 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -403,6 +403,7 @@ static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0103", 0},
 	{"AMDI0105", 0},
 	{"AMDI0107", 0},
+	{"AMDI0108", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.51.0



