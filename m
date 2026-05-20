Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BB63A3833;
	Wed, 20 May 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295797; cv=none; b=ur9dy7ZAJ2jg6QA4CLRKBk63x/ORoWXvCk5ImVW+DIC2Bs4PCNTcBlMvRRELAlnP6SqN3qAEK4IOilV4iFKguUZKqArCRFl9jf3D3TIYe+kpaWObd7lUNzIQsrRzHo3vSaf0q3tSRTow0/q8uLc9vx9BAu1hM/yaJpiLPmWBaqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295797; c=relaxed/simple;
	bh=OhwNnaojFxoe3BHjBZUpv/6gRdgqqSpfvgeQiExuhiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqmjjvUVnqrq+QfQ7OYhxrqwE2X3289WJkTOL4E6S9aD760q0qfPvsgn2geCkkPiYpBqBr/tdGMddybawFPBTbLxOPbeDDGR5frwB8Q3kW5X3U+pSqpDBQTscpIE/DYQCvLyA/k++WwpD5YE88klJAgp/yscKdDcJphd1bJpPiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sZBIt102; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sZBIt102"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BBF1F00893;
	Wed, 20 May 2026 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295795;
	bh=LPz6Cj2KU+YNgaM62bqKl1nM5iZT5ClOGrV+S9FIyYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZBIt102vYe7hZ5pOqTOXpaTwtZcMW1fPAQOnrgRIEgzLOGgGN8REPsAAjVYZJlyH
	 IjFLne1Gsk32hS3JX+eGCH+FmnTVTvH9YIfklA1UJJ1YvZZSYyrljzQfL4QI6lSaWP
	 Rx/SHcKs/fi7onubWDLBD8A5hUPfaMsRhtDZ39sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0554/1146] soc/tegra: pmc: Correct function names in kerneldoc
Date: Wed, 20 May 2026 18:13:24 +0200
Message-ID: <20260520162200.717797859@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit ec0e4da5d679f9da1cc198927951f70fdf28f001 ]

Commit 70f752ebb08c ("soc/tegra: pmc: Add PMC contextual functions")
added the functions devm_tegra_pmc_get() and
tegra_pmc_io_pad_power_enable(), but the names of the functions in the
associated kerneldoc is incorrect. Update the kerneldoc for these
functions to correct their names.

Fixes: 70f752ebb08c ("soc/tegra: pmc: Add PMC contextual functions")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/pmc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/pmc.c b/drivers/soc/tegra/pmc.c
index 8268a41c471a9..b889c44f8fddf 100644
--- a/drivers/soc/tegra/pmc.c
+++ b/drivers/soc/tegra/pmc.c
@@ -1005,7 +1005,7 @@ static struct tegra_pmc *tegra_pmc_get(struct device *dev)
 }
 
 /**
- * tegra_pmc_get() - find the PMC for a given device
+ * devm_tegra_pmc_get() - find the PMC for a given device
  * @dev: device for which to find the PMC
  *
  * Returns a pointer to the PMC on success or an ERR_PTR()-encoded error code
@@ -1747,7 +1747,7 @@ static void tegra_io_pad_unprepare(struct tegra_pmc *pmc)
 }
 
 /**
- * tegra_io_pad_power_enable() - enable power to I/O pad
+ * tegra_pmc_io_pad_power_enable() - enable power to I/O pad
  * @pmc: power management controller
  * @id: Tegra I/O pad ID for which to enable power
  *
-- 
2.53.0



