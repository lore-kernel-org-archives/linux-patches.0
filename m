Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4B81AA1C3;
	Wed, 20 Nov 2024 12:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107554; cv=none; b=ZmJ9UYBfWPlk5tIpThz2JtotBohAsNRyZUb/Vwp80TThrqEB3Nlg/+GvwypxLNmFAQ1YMqm7HJTqZiL8fEHIRrSEzb7+AGfwUc0blqksFh1fBHLet+MLS26uegGbLqSr3Y9r0ScG0VRP/M+k7EooL7gmMJutkW5bA8gcaCYzfcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107554; c=relaxed/simple;
	bh=g/HJMmyTWSxwgu4pQTr0UUSeDMvkHpN7ipt+zgzlOS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJipui5npM1ltbOeNDaxnmmB3korZE2fOUbpQD7a7qacaBQDOqQxxTH/mhOuXNh1+L/8ILNWsNofJ6n3kUcueHWrDmRb5LiiUzmc6FVFxyD8PWQhO5HBy/Q5V9Natdxn9t0dbkX6lLsCu59L93M+UI9yl2IdzN407FTZuv26CEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDOcaTGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDOcaTGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDE5C4CECD;
	Wed, 20 Nov 2024 12:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107553;
	bh=g/HJMmyTWSxwgu4pQTr0UUSeDMvkHpN7ipt+zgzlOS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDOcaTGtevJDdeGgYgT2s6ok+I4wQYsG3uYfD2eoHBdBVVieL+m9RG7Amb7pOLgJR
	 Rj2S15bhme2ovmhYvjIgtqdFCwGXJBRz0E/NbbPH4EvmwXCtk1r69Q23qM+A0vexo5
	 chiqAFRROUduT5uVUOt+oqZ4RXYGg8M87nNhuKNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	aurabindo.pillai@amd.com,
	hamishclaxton@gmail.com
Subject: [PATCH 6.11 077/107] Revert "drm/amd/display: parse umc_info or vram_info based on ASIC"
Date: Wed, 20 Nov 2024 13:56:52 +0100
Message-ID: <20241120125631.415135645@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 5f77ee21eb44e37e371bcea195ea9403b95d1399 upstream.

This reverts commit 694c79769cb384bca8b1ec1d1e84156e726bd106.

This was not the root cause.  Revert.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3678
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: aurabindo.pillai@amd.com
Cc: hamishclaxton@gmail.com
(cherry picked from commit 3c2296b1eec55b50c64509ba15406142d4a958dc)
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -3127,9 +3127,7 @@ static enum bp_result bios_parser_get_vr
 	struct atom_data_revision revision;
 
 	// vram info moved to umc_info for DCN4x
-	if (dcb->ctx->dce_version >= DCN_VERSION_4_01 &&
-		dcb->ctx->dce_version < DCN_VERSION_MAX &&
-		info && DATA_TABLES(umc_info)) {
+	if (info && DATA_TABLES(umc_info)) {
 		header = GET_IMAGE(struct atom_common_table_header,
 					DATA_TABLES(umc_info));
 


