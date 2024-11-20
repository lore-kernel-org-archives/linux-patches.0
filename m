Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590951A9B5A;
	Wed, 20 Nov 2024 12:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107559; cv=none; b=nnZ8NAS5qf6VJ+jhh8CyGQ6cCVqixJwp76AElTTkxJ83oSEkZAxe6uc04c32TBgDHwGsjDkRj7HaruXbZ29/nrM76E1BCQlwHmzrSkm1bNPt3LmzFSjmZ0Zioz0AxNOVD0SMLZRlmPuiF04twZTpRko7xA+zskxTz243AKwojiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107559; c=relaxed/simple;
	bh=yjm1v/yAnh6qdh9cOGqmuNsAyU6k2dGw5U/isvmAz6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7r409TgrY/r8g+jwxLFkyjZ1fhF4/kJggPGEc6UH0/AAdXwYL3uUIv8Cd1VLW7JsGoK2K1s/spbTFOOjHYB6c8dMLSSCsk5/IG45q9nrXbFeLlEWTkVBThv/ST7e8wR35uahagBTfnUU3r66Q3XndCmOO6hW9ErcLtaaJARGcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfkpEkmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfkpEkmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31950C4CED6;
	Wed, 20 Nov 2024 12:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107559;
	bh=yjm1v/yAnh6qdh9cOGqmuNsAyU6k2dGw5U/isvmAz6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfkpEkmPYexwSmRGaOsy5bcssh/tbU0a9o3Au5Z7uxkkxJa6bWK9a9s9UP4EsYAfm
	 KDr32Z8yVyaiNMfcSsNWNp23+ZsTv7Bdq8SMYFA2CZYxxPHPRDDStvfPAscZPH06HL
	 gP23Z86KsUeq8SCowfjL2zSqJ0RmkWVS1I54PFWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Hamish Claxton <hamishclaxton@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	aurabindo.pillai@amd.com
Subject: [PATCH 6.11 101/107] drm/amd/display: Fix failure to read vram info due to static BP_RESULT
Date: Wed, 20 Nov 2024 13:57:16 +0100
Message-ID: <20241120125632.010642215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Hamish Claxton <hamishclaxton@gmail.com>

commit 4bb2f52ac01b8d45d64c7c04881207722e5e6fe4 upstream.

The static declaration causes the check to fail.  Remove it.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3678
Fixes: 00c391102abc ("drm/amd/display: Add misc DC changes for DCN401")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Hamish Claxton <hamishclaxton@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: aurabindo.pillai@amd.com
Cc: hamishclaxton@gmail.com
(cherry picked from commit 91314e7dfd83345b8b820b782b2511c9c32866cd)
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -3122,7 +3122,7 @@ static enum bp_result bios_parser_get_vr
 		struct dc_vram_info *info)
 {
 	struct bios_parser *bp = BP_FROM_DCB(dcb);
-	static enum bp_result result = BP_RESULT_BADBIOSTABLE;
+	enum bp_result result = BP_RESULT_BADBIOSTABLE;
 	struct atom_common_table_header *header;
 	struct atom_data_revision revision;
 


