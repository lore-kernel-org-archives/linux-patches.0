Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EF3154BF5;
	Fri,  6 Dec 2024 15:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498053; cv=none; b=SXmpQYLsrEOhQ7kK03w4ujppbA+gpC4kE2+De77ynDEEVSeAqALHBnL8D7lAje7TStrRgQDHFgp2ZGGbxSa9E7ytYRWvfaaGKnuS4NHa3YBGKY21OYLrLRr5EFEeuo84hfucq8x8Is19HXH0WCjqaRimN+gHK1Su1dUWn5xJWfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498053; c=relaxed/simple;
	bh=lmRtDeRRQfzzrwdzyPluQSat+rEI8G1fIlIMOpz+nSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nqfhmMsci2DFS/a8A7OcpjPl+3goer1RzEMFlPIH1nFwILdOS+NPS2Pb2ImEJkhc6WH90dW/4jkpKKhiJJE1jHoQENYH9dpUPuerq6dytWYGDpwpMtCN3tW1i9FbnQ7S5SID/xC+vROu6ShuuqU4SV8m6EcBWGIUXxjiZSAHK0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFjTpBp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFjTpBp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA81C4CED1;
	Fri,  6 Dec 2024 15:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498052;
	bh=lmRtDeRRQfzzrwdzyPluQSat+rEI8G1fIlIMOpz+nSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFjTpBp+ZsTkk1sqH3yMBSVIJSQS4IIw2UtMJRf2IOiONZ1HDdna0O00nFYsRc5G7
	 cwBEMcay4XTVn0uxEuzIv2BD6B0tm6b/HMEbKxzMu6DLHRZq6Uh5PTzsgzVbhTXVn+
	 zR9IErBQvn/4IWtVwUf9d2RFObwhumlpb9J1TbOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Zverev <ilya@zverev.info>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 472/676] ASoC: amd: yc: Add a quirk for microfone on Lenovo ThinkPad P14s Gen 5 21MES00B00
Date: Fri,  6 Dec 2024 15:34:51 +0100
Message-ID: <20241206143711.804224553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


