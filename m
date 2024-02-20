Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A9614AD12;
	Tue, 20 Feb 2024 21:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463514; cv=none; b=jO/sg/ClowL2H+XkfcHiXzrsY5W3iNdi+JV6ur6Nzy9PgIRjPXG2weytQ3ffy8aIJ/FH3KeKDnrqkJfv8XPuwukK4toSeDDhXGDFRxZfSQvf0bWWbfLirfutcW5B/fO6SG8Ruau3xBNG/+mQNd74t4UIFtO5PqlKdYt1l7pf/WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463514; c=relaxed/simple;
	bh=jLD71/wMuRLTvuCC/8LXTtPyrUjPnyioMcwrRrc/xv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9AxBmimFjhwovuYxVweewVLJVUBM7z4zjSAO+EA5LUbzGVd26+tkh+yNUMzrctHtyy7uEVGL536qSGjk0+rEqsWI4uswpcT+64U5nKPJI2ylsOmdzOIBNYzp9NrMMHWUpJ2g2Y241QH7xW6m9iay57pCVejJbDBzCdRohXiR+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJHnS5/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJHnS5/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E16C433C7;
	Tue, 20 Feb 2024 21:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463514;
	bh=jLD71/wMuRLTvuCC/8LXTtPyrUjPnyioMcwrRrc/xv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJHnS5/GrQ7WzeFerEPpTbK18oF7DsNouqQXZ4mdQj5Zc288idhoR+J24Wj678eXy
	 AVdxa/k6QIbDRxvECSIth4krq49Kkbfo+5JA0JB8UzjuPACsiz25/V/mgsrqsV4uwM
	 gXtHWFziV81WWv/xf0/IQIczuwX/mAXv65c4wB/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Techno Mooney <techno.mooney@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 067/331] ASoC: amd: yc: Add DMI quirk for MSI Bravo 15 C7VF
Date: Tue, 20 Feb 2024 21:53:03 +0100
Message-ID: <20240220205639.690042766@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Techno Mooney <techno.mooney@gmail.com>

commit c6dce23ec993f7da7790a9eadb36864ceb60e942 upstream.

The laptop requires a quirk ID to enable its internal microphone. Add
it to the DMI quirk table.

Reported-by: Techno Mooney <techno.mooney@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218402
Cc: stable@vger.kernel.org
Signed-off-by: Techno Mooney <techno.mooney@gmail.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Link: https://msgid.link/r/20240129081148.1044891-1-bagasdotme@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -300,6 +300,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7VF"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
 		}


