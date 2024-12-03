Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0A31F757E;
	Tue,  3 Dec 2024 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239519; cv=none; b=BRtWwE0r0qdtr4H+ExN3HYepLurXRzGhhadr66eFqv9ADrsdXROfH77b1uQ0eJgjoEIIttqgvKdr/Q45ldPUqMGwhgwYiSpEh9+iiKXlxnRBg3ftoO/BCKyZABESXRsDvH6yfxcum93P+WqmapoFlOGWiOenkSlSXXn1QEn+OVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239519; c=relaxed/simple;
	bh=/o4M9X3REStnwPdw3qdSSCp73PHPipLB05JPu5aYbf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c66yqK9IPkKQUbRgarvNWD8pjzfNe8vU8lYkbdFcVZL1SCPtQLz0LIvK+oP7juiN5H+bdix/o4q5xSasboyAsaYikefJ81oRM+kAR9iCnzj4d2TCoOxTi8ho1KzqeSGR5tfW5SflKWBQUoXz48pbU8sy2gbwfoRlKWq9ls7DYAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqQcQ2Xb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqQcQ2Xb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A65AC4CECF;
	Tue,  3 Dec 2024 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239518;
	bh=/o4M9X3REStnwPdw3qdSSCp73PHPipLB05JPu5aYbf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqQcQ2XbbNEuycFuUa0susHiyGbtXrST0YeKKec9+GRoK5k9khrx2my1s7dVq5DoI
	 ck9h3OtvGttMHfEyC5S3x+jJuiR9RwcmhLQ6ssEQS7fEs/JKFrEovBiQHRwUwOEwch
	 WagIw65/+Xn5R1yZQmQpvRb358y+DUr0XRAM+w2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Zverev <ilya@zverev.info>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 640/817] ASoC: amd: yc: Add a quirk for microfone on Lenovo ThinkPad P14s Gen 5 21MES00B00
Date: Tue,  3 Dec 2024 15:43:32 +0100
Message-ID: <20241203144020.930860329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Zverev <ilya@zverev.info>

commit b682aa788e5f9f1ddacdfbb453e49fd3f4e83721 upstream.

New ThinkPads need new quirk entries. Ilya has tested this one.
Laptop product id is 21MES00B00, though the shorthand 21ME works.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219533
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Zverev <ilya@zverev.info>
Link: https://patch.msgid.link/20241127134420.14471-1-ilya@zverev.info
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -245,6 +245,13 @@ static const struct dmi_system_id yc_acp
 		.driver_data = &acp6x_card,
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21ME"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "82QF"),
 		}
 	},


