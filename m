Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B5B1D04AE;
	Tue, 27 Aug 2024 15:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772526; cv=none; b=gGzPFx9+IRPKe/W4T4UcEZRYtQJmRLVZhRn08wL+ifBJ2VmEzm0SmEWf5nnMvjglDQ8YI0eIcQsioF0HtOojxdkbQsbd1iKG/vRQas60O+hj1B0fcvsfPD3VUlgpZIN5zGFdiNaRvyTfTZAfgcGmgrDuRh5tHInkYtopaKPMn2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772526; c=relaxed/simple;
	bh=E+GV7bs9PTfa8BuuWM0UILBVBVNCM2U1tXo96F7SEH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJ5QcA8w7Z8SyvTQZC5On4Lm71lAKqgOGIfQULuAtABMNv2JC3FaVAIqsqsq/SPytmxaiR0jIHRmfBFCKvLQt2BvBPsP1z9x0xAmWcNFPFSRtYN1XB2kyu7405kN5Fo0PrTKUdpNWEeIQuLwl5j14UmMq+rd9sBIfaCJ5y8Bipg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkKCxOKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkKCxOKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4719C6107E;
	Tue, 27 Aug 2024 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772526;
	bh=E+GV7bs9PTfa8BuuWM0UILBVBVNCM2U1tXo96F7SEH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GkKCxOKErOecPT/OEBZyI26ftEgoxPacHu8iYVjLXGlYKyjeU3HXGu8WXWEzcW+RE
	 uE9/hV9EFcpy0nNl38ptkR0yvY8P4HsKjqDncfKLaBizpNDnBvFPLO0WQF+9kszv7M
	 GpCySYr8/l+3I4Bg8JFrQ22ARUZSCWMmTItWWNUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/321] platform/x86: lg-laptop: fix %s null argument warning
Date: Tue, 27 Aug 2024 16:38:28 +0200
Message-ID: <20240827143845.845776252@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit e71c8481692582c70cdfd0996c20cdcc71e425d3 ]

W=1 warns about null argument to kprintf:
warning: ‘%s’ directive argument is null [-Wformat-overflow=]
pr_info("product: %s  year: %d\n", product, year);

Use "unknown" instead of NULL.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/33d40e976f08f82b9227d0ecae38c787fcc0c0b2.1712154684.git.soyer@irl.hu
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 2e1dc91bfc764..5704981d18487 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -715,7 +715,7 @@ static int acpi_add(struct acpi_device *device)
 		default:
 			year = 2019;
 		}
-	pr_info("product: %s  year: %d\n", product, year);
+	pr_info("product: %s  year: %d\n", product ?: "unknown", year);
 
 	if (year >= 2019)
 		battery_limit_use_wmbb = 1;
-- 
2.43.0



