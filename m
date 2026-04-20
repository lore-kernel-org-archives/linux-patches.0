Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7AC3B47FE;
	Mon, 20 Apr 2026 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691410; cv=none; b=JXaFRf1GfFrz/QkRuCyjY5X5gtIdpn5/iiH7aEBRH5UEXc66eaHhH1t4ShgDtz10xhaxvEc94tlzPi2RdAcJXwxcjY6px8J0GDVQ5H5p/3j+5m42hGhHtv9JAHcw37rp2AzkgNaHUG6ZP4vJja1SPB0Yez0Dxgwk8F3yMQCVFbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691410; c=relaxed/simple;
	bh=XuG43H8RaQ3gi+9k8AkuTRmGsdULa2PDN5UnCxJCgHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d5AwKvOvzqc06XHWU5jnAc19/qwClH6WV8BTDnXd1zW7Eq/2lLuuAbr1V0DHepwxAPEhABEPgOze3IFdvZFfZy3Bjnv2HcXcZYxHpBM2akeJzYM1FueHm1C4mtuymkA6JWDSK6bMnmtveUPT+qW90eWcTpUwvbkRz/iA23CrrKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUItzhQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUItzhQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEE0C2BCB4;
	Mon, 20 Apr 2026 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691409;
	bh=XuG43H8RaQ3gi+9k8AkuTRmGsdULa2PDN5UnCxJCgHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUItzhQZjEIA9YZ6GZqCZ956oKIUQcCwV3DDr3SNHwTDe9UAFpkORfKAXQKPBE/8Q
	 DRLzmZyBwIg6oOYNC+mz9/kJUcvrbTRTtYqk/psaE5/SoOgvsB4O7itzQVtU877hbH
	 YaSjuhZecz5/CDsioUX6azIOqMgtf9CYYhzBzS8bxVNHJevG7UrwtoJgD8/iw/PJhp
	 kjz/VuFErcHzEy0/KSp6xJ/nd2RwLs8ozGNKrfFBONPxYJtFISX4ieCOaz+sK8nw16
	 4BRIxAhxjiq1n2OmidJnGvrr5p35Tjvw7jvkRJ1phu2uC8DJqJI9f9c3z+bHx5WP23
	 7Hk4d6QXC9IKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	corentin.chary@gmail.com,
	luke@ljones.dev,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] platform/x86: asus-nb-wmi: add DMI quirk for ASUS ROG Flow Z13-KJP GZ302EAC
Date: Mon, 20 Apr 2026 09:16:43 -0400
Message-ID: <20260420132314.1023554-9-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit 0198d2743207d67f995cd6df89e267e1b9f5e1f1 ]

The ASUS ROG Flow Z13-KJP GZ302EAC model uses sys_vendor name ASUS
rather than ASUSTeK COMPUTER INC., but it needs the same folio quirk as
the other ROG Flow Z13. To keep things simple, just match on sys_vendor
ASUS since it covers both.

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Reviewed-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260312212246.1608080-1-matthew.schwartz@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/platform/x86/asus-nb-wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 6a62bc5b02fda..8dad7bdb8f612 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -548,7 +548,7 @@ static const struct dmi_system_id asus_quirks[] = {
 		.callback = dmi_matched,
 		.ident = "ASUS ROG Z13",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow Z13"),
 		},
 		.driver_data = &quirk_asus_z13,
-- 
2.53.0

