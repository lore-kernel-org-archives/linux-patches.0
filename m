Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AFB1DC98B;
	Thu,  3 Jul 2025 14:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554106; cv=none; b=avxLXA/nkEjM2uZVMoJGTXBmrW6RKZB+lOHhqq9XEGGfJVAeYAxQK33WzNqVnBoY1fRxgW4JqtAEUvvdWNzYJ5FHvJWcQ+S/5q2qV2Hohqyo4XXbdNJfyTNKmM5XOFWtDzzCt01jyVlgeFf9n47+erFYlqQq+lkcBY1Ar50HVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554106; c=relaxed/simple;
	bh=NngKOKZJMV5eAFDq+mE+jYhDlAPPXA/vCBq5cOkZkcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zo/9UhuorkAl02hH0wZSDugquxW8tN18wvipL1EMvuXlBO80DhadBpyd7+dP85rCWWXFycJjX3JMA58OczqDK/TX7nOoJOnamj+ev31PUa+rEk6HtCu9nvvqnZNcmkQq8HLBa68al70fQxrxmH3uPjMfGCi4GosPQG6qEidXCUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LcjM2zgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcjM2zgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD366C4CEEE;
	Thu,  3 Jul 2025 14:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554106;
	bh=NngKOKZJMV5eAFDq+mE+jYhDlAPPXA/vCBq5cOkZkcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcjM2zgLFnMokOLaBp8U7ZuKGaPKs/+tfPYHT0ETGB0oRm7E6S5RhHl8qg9tjqBlt
	 pAl9uWxFx7Nm8X9173Nmt5DskJKVduk5wYmlR8WiWVEZ6fv/BXlsHl5vh5RCrEztGD
	 azdEYI89UEzMrXtG4YneVmIC94Q9kRQLOwvCrTas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Schramm <oliver.schramm97@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 082/218] ASoC: amd: yc: Add DMI quirk for Lenovo IdeaPad Slim 5 15
Date: Thu,  3 Jul 2025 16:40:30 +0200
Message-ID: <20250703143959.221726684@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


