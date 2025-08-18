Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A8927B355;
	Mon, 18 Aug 2025 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521744; cv=none; b=n2dDHD0xa3y3y8W2d+4qGjN+72Q6Xl8wm1C+4+5S+YTlDtoUvSmNkYuri5/vEIM5qmm8a6unavvaIuF/nYIUOKRNFcn9yTf8+XLM3vK44i13cDbMwsNAQxCzyNl8giswsUNbp5z585m9HyGN05dP8Q9abhGEhmWV9MaN8hq1VQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521744; c=relaxed/simple;
	bh=EoTO161H4hhZfQvVeXfugZzhRf606jeNXySFHY3/Ses=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s20wA0aKNqDHdA/IFBZL+mHw5y9yMFXrSu1xfB7hOq7zCCxXnWFQPYf6Ih8BzGaTMsroeQjCvUe/jxi+ZD/6J1rW6vn6cGCVWXg0akS6VZRtt4urW+w5jedvp2w9UQhwT9ZAoRHPqgE2W0TK7R9TUmTBdZzA9Gku+o0+O5zYfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+dvOW8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+dvOW8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059E3C4CEEB;
	Mon, 18 Aug 2025 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521743;
	bh=EoTO161H4hhZfQvVeXfugZzhRf606jeNXySFHY3/Ses=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+dvOW8OfYh9EghK7m05DGNfPGf6CXMFMC2VF1UMSnzoZJWVSU1zKPNihJiLqBEYu
	 ouXHiJkJqPsF7OwAw/+YAYKmSVUUg/QAm6qVdtjuIjGklGpNHzScovx1c8GDrRwrir
	 UF0FDVh6anG2CbQK86bWkykLGz8GKVdh/f0jiCgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume La Roque <glaroque@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/444] pmdomain: ti: Select PM_GENERIC_DOMAINS
Date: Mon, 18 Aug 2025 14:42:14 +0200
Message-ID: <20250818124452.988428960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume La Roque <glaroque@baylibre.com>

[ Upstream commit fcddcb7e8f38a40db99f87a962c5d0a153a76566 ]

Select PM_GENERIC_DOMAINS instead of depending on it to ensure
it is always enabled when TI_SCI_PM_DOMAINS is selected.
Since PM_GENERIC_DOMAINS is an implicit symbol, it can only be enabled
through 'select' and cannot be explicitly enabled in configuration.
This simplifies the dependency chain and prevents build issues

Signed-off-by: Guillaume La Roque <glaroque@baylibre.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20250715-depspmdomain-v2-1-6f0eda3ce824@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/ti/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/ti/Kconfig b/drivers/pmdomain/ti/Kconfig
index 67c608bf7ed0..5386b362a7ab 100644
--- a/drivers/pmdomain/ti/Kconfig
+++ b/drivers/pmdomain/ti/Kconfig
@@ -10,7 +10,7 @@ if SOC_TI
 config TI_SCI_PM_DOMAINS
 	tristate "TI SCI PM Domains Driver"
 	depends on TI_SCI_PROTOCOL
-	depends on PM_GENERIC_DOMAINS
+	select PM_GENERIC_DOMAINS if PM
 	help
 	  Generic power domain implementation for TI device implementing
 	  the TI SCI protocol.
-- 
2.39.5



