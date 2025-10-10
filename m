Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCF71F63FF;
	Fri, 10 Oct 2025 13:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102541; cv=none; b=JNOAGvCXNtKkUuGQSdOkRLUPrykGQfnBFuR662afRi0iOt2WSf+L58YLe/4HXkuxzo5mzy9xQEwSFcy5NPF+F0KKRkTY57S/Pz+sVdaGYeFNKRC/GrI8gpF8HTx45qVw9uBoeTHUPg1QuYibd72yvOBJJLlfrhmsf12NouyexlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102541; c=relaxed/simple;
	bh=sfM890oGsmg+JyxtdJ5WKRVz3gcCa6m/Z/htBJXZQEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fuk7eojDp0fikdpaPpfwpegHXxigVfAWpTQhlFxUpxTmYkmjWd87jqSnyBgO5P3f9uxn4zS+wKV3syLTy0ROuQ9APV//4uuBOaz7UGtKcMrpvEAkOwvdiTmY1VjRz8B6D+PwrPst3/pdVeujDQA9I3Q0XmCLIubLBrpgVspEABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOrm1E7y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOrm1E7y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AD2C4CEF1;
	Fri, 10 Oct 2025 13:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102541;
	bh=sfM890oGsmg+JyxtdJ5WKRVz3gcCa6m/Z/htBJXZQEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOrm1E7y9FeoSQsaZtrE1lAI8g1Zi5oamSRjtcpgXThKrwNpMCk9pmXgh9hGUlT+q
	 hhgoJG0gUugZJMldpDZ7FFKj9BAH6VHWEluka4cqfb8RKBCgLefRsZQ5K4kh/NnQtA
	 DnniWRUfDL6eocZaIxJDcQdJMuqDz5GPD/f5b9FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/28] platform/x86/amd/pmc: Add Stellaris Slim Gen6 AMD to spurious 8042 quirks list
Date: Fri, 10 Oct 2025 15:16:33 +0200
Message-ID: <20251010131330.918895639@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



