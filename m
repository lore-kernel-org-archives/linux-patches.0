Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6F0217670;
	Thu, 12 Dec 2024 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017379; cv=none; b=rk9bZXuI8hkorw52HnB/DMQ7eSgPow3lpbkCn/XSCE5lV/9UX2fed54Qys79HGvStBkoPTQA/phFvJpVRslK86WOpBz/jj5Ht/qFMBO4cIE8Yc7ILuSeVJARYS66ScsBxX4vzBMJVuIs1ARFxqjrZMVx+O0ZM/D6idtvLQNakEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017379; c=relaxed/simple;
	bh=hogSnZuvq2x9Niqh3QFmTzcJSD9P5W5Evtg+c7wkQG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxyTsIvvrqp1PkRd87qNCGM2sw0EsYA1CObgJ38iXMactVx13kNxW42+z/vnTnn5D8sf6X3bQAuhZfSusvxZPgq9KudRS3FQTpdhsE405cMQcBw+F3hl2Zo2pkkEFQdZxW+H5667DLBUqJS+OfVGbve8krNN0n03WdFhgMPN3mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MevQOjzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MevQOjzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A754BC4CED4;
	Thu, 12 Dec 2024 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017379;
	bh=hogSnZuvq2x9Niqh3QFmTzcJSD9P5W5Evtg+c7wkQG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MevQOjzw13r7K7A1MZFO9pRv/OU4ZbN1Pd2iGcEyV0zNm+RpnNt0ob9Lo2FjWJeSm
	 vXWp74i+5EfAtKlxsY+FuoPvqoPBdwek4TvY4UhtOeuHvELaFufuQ/MMLPU2xrshfN
	 Gvke9FMNS0BGVuvri9bRX90B6l+ij8kHZKR2ULag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	aurabindo.pillai@amd.com,
	hamishclaxton@gmail.com
Subject: [PATCH 6.12 463/466] Revert "drm/amd/display: parse umc_info or vram_info based on ASIC"
Date: Thu, 12 Dec 2024 16:00:32 +0100
Message-ID: <20241212144325.161894777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 3c2296b1eec55b50c64509ba15406142d4a958dc upstream.

This reverts commit 2551b4a321a68134360b860113dd460133e856e5.

This was not the root cause.  Revert.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3678
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: aurabindo.pillai@amd.com
Cc: hamishclaxton@gmail.com
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
 


