Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A12151CD0;
	Tue, 20 Feb 2024 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462893; cv=none; b=ebEhtf+ZFDKqX84IuT4rrG+E0mID5/1GeDzzXYLJKPEJbj893MUWVypxLgOf067epf4HQyAa3csgTtyCKZ/TeiK+vq6V04Sutn9sIU06RmCANHO/4aSubCWGmjntbpqz+Or0uSlVtJx7U7p4OJ980j5bGYygnbnjz6lbH/wF+I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462893; c=relaxed/simple;
	bh=JsMOta0SHBtrBqF28lq8cxwIr8CDXI1q2HrXEOtwzMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juVViLnlYLnHcJeyW1xKFNtkZTC4OTbbB5U2uXTi4OxREb+oG27qsMoZWgp7sY8QhqZdPhz9uycqyjwCulNKyvvZfx1YGpsVhaaEJDjcFRtwkgtvHPdSME6CzB5pe9fvZLOxerI+CkIsS758KtZVhD+7hE4LMtqEDi6X6cdR+mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjNCGVyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjNCGVyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A0DC433F1;
	Tue, 20 Feb 2024 21:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462891;
	bh=JsMOta0SHBtrBqF28lq8cxwIr8CDXI1q2HrXEOtwzMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjNCGVyVtLKAXFZtlJ72VtHC7GSQwrxecOPtGOH6BJsRvqU/hTGdVN2PchFzJ/rfG
	 1egrHSiUKs3VfM3qkfU0GTdJr862m5yWD7NTyLxZo4a+HFwx/pXU/eTLFWyHeGlMmx
	 JsVakeuk2Up3cQauE+NI00K/OqIOimvBCPRoxaso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Techno Mooney <techno.mooney@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 040/197] ASoC: amd: yc: Add DMI quirk for MSI Bravo 15 C7VF
Date: Tue, 20 Feb 2024 21:49:59 +0100
Message-ID: <20240220204842.279279098@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
 			DMI_MATCH(DMI_BOARD_VENDOR, "Razer"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
 		}


