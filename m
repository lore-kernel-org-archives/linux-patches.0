Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AA53F65E5;
	Tue, 17 Mar 2026 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767601; cv=none; b=cUQQYCKD2TV9sDo7xgtfvfkFJyUsV24n/xqoUALiaR2bP6A/AGz3kHcqdyXAFSwPY5Xlz2kVK/UuQjQ56+rK0j0nnna4tNCdMVIwUH8giiA+Yl1q5OUTJJ8E/Qohj/FJh4BDCKLRbojVd4V0gs9HKQzLXW4sckxKUsTYQ9g6g+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767601; c=relaxed/simple;
	bh=SP4o4BDOZm18koQGUXFJXxfwbQWEiH+TJkXSY8KHzEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIOPsVsedFkQ31ZuURue1AKcNfvUYGgwSN1wFD9jwcoJFmQ0f2UZ3XORmD23eEbUCWA3/uo1VsSkSjTl7mFww1lWLLtUWKd8rctNTY2VhSYkIWfXsV2S1twXQXR6QsJJlKX7hyc1Iqog725VumNdr/GN8p1HeBSY+tZvBSS5+xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dxa9sxbQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dxa9sxbQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E8CC4CEF7;
	Tue, 17 Mar 2026 17:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767600;
	bh=SP4o4BDOZm18koQGUXFJXxfwbQWEiH+TJkXSY8KHzEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dxa9sxbQ/CyrJiMX9PFselp75W23aIzYsRIdqB8GZSLUyv8Ov18mj5FQxGEDRx9MC
	 n3c2RMbxB2j9CdZ7VU8oeC+D2oTu8MZhDTrmJmg46dC/VQL5DbLTof1jY7xTMNTzGM
	 DgrQzkkXwHZP14jmYhHc3YfRcuLM0vQnwGkRgOhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 121/333] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK PM1503CDA
Date: Tue, 17 Mar 2026 17:32:30 +0100
Message-ID: <20260317163003.854560723@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit 325291b20f8a6f14b9c82edbf5d12e4e71f6adaa upstream.

Add a DMI quirk for the ASUS EXPERTBOOK PM1503CDA fixing the
issue where the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221070
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260304063255.139331-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -710,6 +710,13 @@ static const struct dmi_system_id yc_acp
 			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK BM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
+		}
+	},
 	{}
 };
 


