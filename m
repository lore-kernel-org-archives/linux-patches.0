Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4B521579F;
	Fri, 10 Oct 2025 13:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102448; cv=none; b=G6EjSIAj7SXQsAT5O3eyxMmPo2jaAIr/JZ2azsv6qS8VGt8SoKhyF8cvCVR9ly91Px3T9eE9EDV4AgFA8iIPL7LzIogFW0nz01DH1bF9CMe6Twqjno7MIrk3qb4lFOwHeNlw+8rsd6P5DDI1mrHTooFM6wS7Iol5v8uK9pB5yVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102448; c=relaxed/simple;
	bh=Aj7XiayTr8D/QIg/rOL1D3REb47yOyapl40IdFN93qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nf7ESZD71VKO+qRy8Y/9mz2Bo8YziXaiKx9siBOGLBKWT67MrmH9eNYOfq0SaX7EWzkzzZzrIoGx9o0j3vUz/95/cMrw20XdaLUyhqomE8LLR0vzmr6aZmoPcp2k2P/i5IRkQRyI8OSWDnxLILe+98IH/tqi/+vEDUKwE6rFEcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAuXbdY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAuXbdY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2D2C4CEFE;
	Fri, 10 Oct 2025 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102447;
	bh=Aj7XiayTr8D/QIg/rOL1D3REb47yOyapl40IdFN93qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAuXbdY4EF1KNouOTP/oUlDzhqb6k5YpfXYH94GbZMWysuY8WlKYn+rfOU/Q9eEdf
	 If2noREOB6J0jz7yiuCiFXlaD4/QZ6n+XgdNpSr9aX1IbMnXeIDTOjIj6MrYxN6fjJ
	 oyA39xqjAO6kdcfOOCPOwN3iZLOPtX7OP3Qw2ESQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 18/35] platform/x86/amd/pmc: Add Stellaris Slim Gen6 AMD to spurious 8042 quirks list
Date: Fri, 10 Oct 2025 15:16:20 +0200
Message-ID: <20251010131332.452470589@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

[ Upstream commit 12a3dd4d2cd9232d4e4df3b9a5b3d745db559941 ]

Prevents instant wakeup ~1s after suspend

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20250916164700.32896-1-wse@tuxedocomputers.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index b872baf35808f..9fd2829ee2ab4 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -250,6 +250,13 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Lafite Pro V 14M"),
 		}
 	},
+	{
+		.ident = "TUXEDO Stellaris Slim 15 AMD Gen6",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		}
+	},
 	{
 		.ident = "TUXEDO InfinityBook Pro 14/15 AMD Gen10",
 		.driver_data = &quirk_spurious_8042,
-- 
2.51.0



