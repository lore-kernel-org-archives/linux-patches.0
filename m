Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD13F218592;
	Thu, 12 Dec 2024 16:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020047; cv=none; b=QmYff3Ik3hKM0DYQoRPHJLzuc7TkqsT0mYic1acITs8eNTV/pYq885vlCj2klR1PaQpDidVPIxkgzJ9vVay5VKZ+yStauqDgmtklj2qEc8EhBSXIlL2FXOs6i7GEmbYKIUWAYRpHTppMMrWznVx8ROKyApngf3580uoEO4VvNj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020047; c=relaxed/simple;
	bh=/m2vpw/tEeZb09PYNETO8si5FqeiqbuT5Vvzo6kfJBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfvPFBsYxIYcjPZffbi/AW8a9ILF/nwQ78mB7/+O8Gm4oaCiUuLoxiQc7zqNMzz6BFs0s0ETnkFdLf0MEyOuR2pxydWkE+kcSzvrNTqzmSRWghWXLbzgWW4pnwsW9j+qPXa10fSnvuBZfmDsc5aL9Dww5iGmWAYBiJ2bn9jhFbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hynOgzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hynOgzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146A8C4CECE;
	Thu, 12 Dec 2024 16:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020047;
	bh=/m2vpw/tEeZb09PYNETO8si5FqeiqbuT5Vvzo6kfJBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hynOgzsUIZNWAH4jYcxhHcN8N2YcWEOYCAbiM8pnYsHaveGnUivXDguaSfrN/1Qy
	 8Plrbl4BT/FmpiDg0GT+bnJsRMV9mnedLlrp2WpV3vR9IfsLmuo0Z7HcG8Kgp9Azd0
	 76eX7Rdi4/M2FGFmV9uwqqGJgQGEZSTSHPhNqpmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Zverev <ilya@zverev.info>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 365/772] ASoC: amd: yc: Add a quirk for microfone on Lenovo ThinkPad P14s Gen 5 21MES00B00
Date: Thu, 12 Dec 2024 15:55:10 +0100
Message-ID: <20241212144404.993920878@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 			DMI_MATCH(DMI_PRODUCT_NAME, "82TL"),
 		}
 	},


