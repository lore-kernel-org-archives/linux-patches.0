Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E822A21579F;
	Fri, 10 Oct 2025 13:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102431; cv=none; b=ui+wFfj/JUyw7zgFyQVyoTbnPa4qk48wHC5OWe83UH8boOLHdN8vBzMylxFZL6BBDI0jzCyYreMLoLRfRcZZLxl84cczE71dK5I7GrdrSPJKGjBH4tCPaiUNljfDvrJZMt/7/+WhuHPmVip6psLxcTOFDYhex6kDvmi0wBqQI8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102431; c=relaxed/simple;
	bh=4L8qjw/4jslETTYyb78sq94BeD6cD5GClrNgaqM272I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RiLei/J0OHSzv+O899T6NzDFA5gLz2jHdOjlEmzByH4mNathfqM5S9DQzngmYeeXIOHoeoTCNvjFg9rBtHZiqXCOgZ9d7sFWl+5pTWlxmZJ/e5e4Fu8e4azZv76hypdsqQ4y7FpXXUW7VJQJyS220gtYjzjrciAS30YSqptvmEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UK4JkGoe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UK4JkGoe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D812C4CEF1;
	Fri, 10 Oct 2025 13:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102430;
	bh=4L8qjw/4jslETTYyb78sq94BeD6cD5GClrNgaqM272I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UK4JkGoe7Z5g4RLtPNdtUDFT52/DdVW1jQtpHP7AlEckyVhZ55p347Z0AezmrD1nV
	 IPDKV3cI6wnEjPfkCarZgUpYXKBJ3KHbhbFwIdZdUX8ub0ZgnodOHecGccpz3+Fwsn
	 1NiE03RxTHJEbCMnPkv3F0sEtiHfsFATPAiekc2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 12/35] platform/x86/amd/pmf: Support new ACPI ID AMDI0108
Date: Fri, 10 Oct 2025 15:16:14 +0200
Message-ID: <20251010131332.235936334@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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
index 719caa2a00f05..8a1e2268d301a 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -406,6 +406,7 @@ static const struct acpi_device_id amd_pmf_acpi_ids[] = {
 	{"AMDI0103", 0},
 	{"AMDI0105", 0},
 	{"AMDI0107", 0},
+	{"AMDI0108", 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, amd_pmf_acpi_ids);
-- 
2.51.0



