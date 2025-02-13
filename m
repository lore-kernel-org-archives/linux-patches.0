Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB97626B086;
	Thu, 13 Feb 2025 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458926; cv=none; b=GXT7KVs84Ktq9WibRNS0PAWgH8TYqw9FFDeP9qfXMA57MGnMsBxmn0Z2KcRF00nbOL5JxkCZHrAZtSlJU8t3YfTTuRPNvyJS3hCWwnHAtxXBlVhNHXZIAYx9z+66ebwuOhrB/X+jg7J2h1uquRIlkTjR/sHnZthuC7i+iiS21CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458926; c=relaxed/simple;
	bh=dM5hQmqJ9PUnZzQ0cKob5aD35SVIEHiToLAUXXLzm3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjm1xWAkUhYOirRY2fCHifg79pL8+/VXa1QzccpYsI/bZWDV6iSIdGeZOKQ53oy7mZEZx8Bsdl5B6lrmVH1Zy/zW5xLd0cFvts55Nm4vNMmS1N+cGxXqLIXgtwMnchebYodCV4Pdae8jsQuuNw4krshOgtl2VIbWGKhmCHy0Gng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqEeAZ3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqEeAZ3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372E9C4CED1;
	Thu, 13 Feb 2025 15:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458926;
	bh=dM5hQmqJ9PUnZzQ0cKob5aD35SVIEHiToLAUXXLzm3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqEeAZ3XCjpHVsra08Y+CwRxkUxO2OHC7b+f20iQudHlYGBTO1NUMaa7I3D+h+W7u
	 d+UxLGLoHb4pRXWYjcaB+Pakx+Q4BEaLfjzzPNXunb2DAUgtfWYjK0CSdqR9HHbKDW
	 F1tFqIoWThIaBxJ96dfx8SzpXKLbLTRj5hvyI4FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hridesh MG <hridesh699@gmail.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 100/443] platform/x86: acer-wmi: add support for Acer Nitro AN515-58
Date: Thu, 13 Feb 2025 15:24:25 +0100
Message-ID: <20250213142444.470429152@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hridesh MG <hridesh699@gmail.com>

[ Upstream commit 549fcf58cf5837d401d0de906093169b05365609 ]

Add predator_v4 quirk for the Acer Nitro AN515-58 to enable fan speed
monitoring and platform_profile handling.

Signed-off-by: Hridesh MG <hridesh699@gmail.com>
Reviewed-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250113-platform_profile-v4-5-23be0dff19f1@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 3c211eee95f42..1b966b75cb979 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -578,6 +578,15 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "Acer Nitro AN515-58",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Nitro AN515-58"),
+		},
+		.driver_data = &quirk_acer_predator_v4,
+	},
 	{
 		.callback = dmi_matched,
 		.ident = "Acer Predator PH315-53",
-- 
2.39.5



