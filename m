Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A002F2F3C39;
	Thu,  3 Jul 2025 15:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555632; cv=none; b=Ll2Sq2v9e6X5EzmJr/9jBtil3I/GDI1cS16/M8d0CU+LtAT63F5DJ5cu5/WhT9nendqQglt7hfcsArgsSnGkRu08Vk2x6tu4+A0Lb0t/XxhNjiCx4G7z31XomPNb2+1j42aNldFfR5OY44mhl6dNDxB/ij9x1RALyy24P8jbxaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555632; c=relaxed/simple;
	bh=OLtEKR/iZZmc67tCHb3wYuWtMleSowzdVJ+3pR7l2Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+dPGdTICejeE75B7Vp+o6tJbaiOwviP9AZVjPkQBUPl3YpPEvfDceIQb8p4Kn8oE5MF2RRIKVFOvXz8C2H4z0Z7CRWtWvpNq6+IqGTWg0PyKmhwjgxpkYGNRNDvFCBRwJfukJZwe7jjRotZraBCuTzw9/T1JtONHaOy8smZigQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYICHYnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYICHYnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139BEC4CEE3;
	Thu,  3 Jul 2025 15:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555632;
	bh=OLtEKR/iZZmc67tCHb3wYuWtMleSowzdVJ+3pR7l2Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYICHYntXY2lmLvl+3e1GLhyjwOQNCd8lVl2NFFlp3fBemGTu50K7vkf+CPN9t6IG
	 fCpdlxHujfEyCZaGq1t7MFr9LIFBpb7Isy7a0ImdBOrkJl1ka+tt2tjFbjMgR7Zilb
	 ppJvjq6/nhMMel7hXKuG65NvvYOftTivmHCgIDO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Schramm <oliver.schramm97@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 074/139] ASoC: amd: yc: Add DMI quirk for Lenovo IdeaPad Slim 5 15
Date: Thu,  3 Jul 2025 16:42:17 +0200
Message-ID: <20250703143944.065456839@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Schramm <oliver.schramm97@gmail.com>

commit bf39286adc5e10ce3e32eb86ad316ae56f3b52a0 upstream.

It's smaller brother has already received the patch to enable the microphone,
now add it too to the DMI quirk table.

Cc: stable@vger.kernel.org
Signed-off-by: Oliver Schramm <oliver.schramm97@gmail.com>
Link: https://patch.msgid.link/20250621223000.11817-2-oliver.schramm97@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -356,6 +356,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83J3"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}


