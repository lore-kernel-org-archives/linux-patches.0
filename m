Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E681C1E51EB;
	Thu,  3 Jul 2025 15:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556094; cv=none; b=Rt4iVN9b+YiP0qf8yHmR+M3vNDH8NJlYLPWDJ/cV58yKEdUbe8s3Hxe2xmaWk35gOQ3o/lz2XyHIbxM6rJPLf7Vi69vlNOlJJkBpYSjtKjdjtTSMAqeGnfl0LqRVb7m2ATfj7xMRyAMi55COWBdQkqJ0N6GqL8+DzWbmF8aPCfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556094; c=relaxed/simple;
	bh=gYGg1WXG78plSRjSQ2+uuwBOkF+7XV8lsmdoUixXTeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STw7pLXTqd41RhmPNizzhBja5K/dwUPgp9+xXswjXGNAjptO/dcUp9bXw7Zem9gucHDg8yzCAIrZjffAmW2Fd/1b0kp6pbCHBb8BULYeMUL4VtSPhhfZ4IFwcWxwQGnSs0vizBl/2lDu8mmI0Yq0cfnsjq57lAZaNVHNLtTGjLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwV3RHo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwV3RHo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCF9C4CEEE;
	Thu,  3 Jul 2025 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556093;
	bh=gYGg1WXG78plSRjSQ2+uuwBOkF+7XV8lsmdoUixXTeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwV3RHo4pT2E28+5PLuLuYW5ezWPrt4al6/d0HZ3eg+vhaaEqQsNg3bh6eLx151s0
	 vZ3asRIMqcRL60O/0AZh6Elf4yWLjPnofTJ3KXYP5Egw2BqGA57QFjvxEzNk1v1kS9
	 D77f9B/exy1T/NW/XvxfmqjRKaKOmKYc4mI9pVRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Schramm <oliver.schramm97@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 073/132] ASoC: amd: yc: Add DMI quirk for Lenovo IdeaPad Slim 5 15
Date: Thu,  3 Jul 2025 16:42:42 +0200
Message-ID: <20250703143942.285465044@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -370,6 +370,13 @@ static const struct dmi_system_id yc_acp
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
 			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}


