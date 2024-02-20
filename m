Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A431514A4E6;
	Tue, 20 Feb 2024 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464600; cv=none; b=jbUHd8diFJVsI2A1Jf/4w8YiSb3i5Gpm+9lizz0u6HBqauAObLdRb0o1b4gRQfTG+cSijpeGJR7qv8LRHVDxwNctOmiUV+owKNSrPqWUnDLgXdbLBO6U4+4jTYbMJ6B/u/nUOW0vcT1sd70V685I7A0+EnAPFM7D4vL1lEqNwJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464600; c=relaxed/simple;
	bh=gib8IhQA1kusPVqMFr1m4XRFmCZ1ZocXFN/qO3mXZ28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGPEQyY+kv460WMVn+HdinvoKNUARlmRXeOxf/TkDan9Z6CFIiy/Huvs7rTj0UbPgFNLqHu+eSNzRiqNQA315UDR4RN9YKWVALpWRz8oxp2oMX/livxyP/aB3CdDegX+3C5Xl3Kl73quT47sEh6ckxu4+vn4Um+Pyx9UINSnvk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJY9U5Rr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJY9U5Rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B5EC433F1;
	Tue, 20 Feb 2024 21:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464600;
	bh=gib8IhQA1kusPVqMFr1m4XRFmCZ1ZocXFN/qO3mXZ28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJY9U5RrH/RP3IqzFGx59kfqt7BHWq9+ez7qEvHVU6BTON0CJQAGRsibQKvlZ6ndj
	 cJ60x6K6tTid7+l2kCDs16JqPawauwIpQgbRACGH2N3oEuUC7HTFbe41LtLC670Kih
	 ozLb3X9D3gOL3pYFLq78NeieFX4at3ucBJYlSoK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Techno Mooney <techno.mooney@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.7 077/309] ASoC: amd: yc: Add DMI quirk for MSI Bravo 15 C7VF
Date: Tue, 20 Feb 2024 21:53:56 +0100
Message-ID: <20240220205635.614992117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


