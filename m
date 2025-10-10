Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDA52F28E0;
	Fri, 10 Oct 2025 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102588; cv=none; b=p9YO3P/BMYwR/IHhBrQCjWJDndVG6JiAmEKs3E0rAFK32OiumyeIt1JKZ+zJJi5Yj4Z/y+a6z6ANa8pFu40CRONjrxawskHXWrCXFBZnpjmuB42brb/nXpJbWxp0Bk7E1N7ZH4TC/tcMELKaOOyxyr2l8itiSYf8PF/lkdvJOS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102588; c=relaxed/simple;
	bh=7cWxGMtnlxFB3yZsUk2uCAEzX6xtVZx2xE102xs+qJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aX84oFE6JYy5c9446vYsJ2mIZpfTRJxCSBc3yNIKX1T9f7fHSrpvCAR46T0IMz/06/4aGbYdJd4SmfNYbuBk+9a1pXBxMsnIRkhgSpjGlh625Eh303yM7XHi5oAu/PBQxxJN4ASd5llrGHbEiGJo2pRXjbI/IVTBZ0rkrJah3B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyzxP91b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyzxP91b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623E1C4CEF1;
	Fri, 10 Oct 2025 13:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102587;
	bh=7cWxGMtnlxFB3yZsUk2uCAEzX6xtVZx2xE102xs+qJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyzxP91bgKUrGSg4ZKar/C3H281oav/trlyMjnE3vY71KjlwkB8dbH3x6rUM0TCCc
	 ZGUDxFMj1pQc9kvzoUatGP+Ew0BNiGiC62AIl07ibGG7fY+69C7N04ZI0xa6erbxi4
	 idD3ZxQnAEyjlPCMov2ue4LXO0VOvAXe+hiEuhjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	April Grimoire <aprilgrimoire@proton.me>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/28] platform/x86/amd/pmc: Add MECHREVO Yilong15Pro to spurious_8042 list
Date: Fri, 10 Oct 2025 15:16:27 +0200
Message-ID: <20251010131330.702651341@linuxfoundation.org>
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

From: aprilgrimoire <aprilgrimoire@proton.me>

[ Upstream commit 8822e8be86d40410ddd2ac8ff44f3050c9ecf9c6 ]

The firmware of Mechrevo Yilong15Pro emits a spurious keyboard interrupt on
events including closing the lid. When a user closes the lid on an already
suspended system this causes the system to wake up.
Add Mechrevo Yilong15Pro Series (GM5HG7A) to the list of quirk
spurious_8042 to work around this issue.

Link: https://lore.kernel.org/linux-pm/6ww4uu6Gl4F5n6VY5dl1ufASfKzs4DhMxAN8BuqUpCoqU3PQukVSVSBCl_lKIzkQ-S8kt1acPd58eyolhkWN32lMLFj4ViI0Tdu2jwhnYZ8=@proton.me/
Signed-off-by: April Grimoire <aprilgrimoire@proton.me>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/IvSc_IN5Pa0wRXElTk_fEl-cTpMZxg6TCQk_7aRUkTd9vJUp_ZeC0NdXZ0z6Tn7B-XiqqqQvCH65lq6FqhuECBMEYWcHQmWm1Jo7Br8kpeg=@proton.me
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 6f5437d210a61..b872baf35808f 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -233,6 +233,14 @@ static const struct dmi_system_id fwbug_list[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "WUJIE14-GX4HRXL"),
 		}
 	},
+	{
+		.ident = "MECHREVO Yilong15Pro Series GM5HG7A",
+		.driver_data = &quirk_spurious_8042,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MECHREVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Yilong15Pro Series GM5HG7A"),
+		}
+	},
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=220116 */
 	{
 		.ident = "PCSpecialist Lafite Pro V 14M",
-- 
2.51.0



