Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305662F532C;
	Fri, 10 Oct 2025 13:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102356; cv=none; b=fbErqX6NCT68XfPC6SnRXoPzFWmQi8cCnA0MDO9dSAh8IJyZIPOeUBODvd8xTYxVfkezgF1Rivfi7GN/Fk4XUlhOlGJj5itr4/SwT2G4xVQ+nmPIUoTf9OKIEwitx5NyyrltNorzSvMp9zIaNzc+bUfjFlm1obONQTLy7LjFxgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102356; c=relaxed/simple;
	bh=fq/567LqvUeahVCNl3/yt9Jp98AvqXHacB8dghC5n1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q0Uq8aJJX44BLXTm5sS8Pip4dKTUQl9CFFf4xuCUom+tdhEscJ+grWjoQZNYj1eHO0YNWW/59ZUH5mHYrzThiCDvIfdfOL43MfB8xOlBEa8Z3QxgwPajnq/earSz+jS7Jw9oKDyhf+jYHwlNrMdn3OKbqDomA1sTLBNPYeTscKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vvb+7nSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vvb+7nSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD629C4CEF1;
	Fri, 10 Oct 2025 13:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102356;
	bh=fq/567LqvUeahVCNl3/yt9Jp98AvqXHacB8dghC5n1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vvb+7nSrGlwK191Sse1PdXyGsI6GXsqSavIbhVqHpQMoLJDLOEd/E2Rb0VpvXfQQV
	 DzhDfScuUuh6F6yapnmh6HMjVeX9M11dJCeqb4iOXpwyG4DJxKb+ZzXXsrwJ/pAK/v
	 r+54ACmLR7DmQsjOpKI/2AThrzPRTfrmunFavuzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 27/41] platform/x86/amd/pmc: Add Stellaris Slim Gen6 AMD to spurious 8042 quirks list
Date: Fri, 10 Oct 2025 15:16:15 +0200
Message-ID: <20251010131334.402356012@linuxfoundation.org>
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
index 4d0a38e06f083..d63aaad7ef599 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -256,6 +256,13 @@ static const struct dmi_system_id fwbug_list[] = {
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



