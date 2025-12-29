Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB27B334690;
	Mon, 29 Dec 2025 16:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025927; cv=none; b=avkdNzixuDP2bhherqvDKIC6FLmxoJ10AEk0oys/GSbO5CUYyNZsyJfiA4cyqOgCiSTHT3Qx4d2BYbR9y4UPHaAbs8OfyqJ/OMKYFJsGkt7ueQ/FJB7C6paOcc30ULDI3vo7LJI6gGPQ+q6d2qzEGbRYHB197tHZ2l35wBn+6Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025927; c=relaxed/simple;
	bh=4rGmNwHNHWjDeOfVju/irJtjUZgVY+FuuPV1gnG6/Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5bws6uNy2pFmCzY2XvKzc3ki4kdODcU7Qaa/FajvUbr2hsW1P6OPQtpW2EjxA8UZewvRJJ+akl2LsBFI4g/qX3GjkpDt8dYf8M2cI7Mlqn4Xm/+Eny+e7pxGcwTLVQr8AnMa5wmV4r+gKk8uV1R3/lrlkriENy7+1YK2sX+wbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GME2avgU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GME2avgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57BE5C4CEF7;
	Mon, 29 Dec 2025 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025927;
	bh=4rGmNwHNHWjDeOfVju/irJtjUZgVY+FuuPV1gnG6/Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GME2avgU8up9DVRKJWYDsUPW74lOTT3Q7MXuoUPJUmK/aHgFw9GmJsP5v/BrY49UK
	 5VvvuDJ5whY1+0vWmM3S9wZEYd6vVp+XrCmhGQdx0AVzYGXUfQm6foWhtpGKU4KIb+
	 Kp5kykOErCOP6fcygHbI7iszm5tqf2TQUBwshYjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.18 387/430] drm/amd/display: Fix scratch registers offsets for DCN35
Date: Mon, 29 Dec 2025 17:13:09 +0100
Message-ID: <20251229160738.562247493@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Ray Wu <ray.wu@amd.com>

commit 69741d9ccc7222e6b6f138db67b012ecc0d72542 upstream.

[Why]
Different platforms use differnet NBIO header files,
causing display code to use differnt offset and read
wrong accelerated status.

[How]
- Unified NBIO offset header file across platform.
- Correct scratch registers offsets to proper locations.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4667
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 49a63bc8eda0304ba307f5ba68305f936174f72d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -203,12 +203,12 @@ enum dcn35_clk_src_array_id {
 	NBIO_BASE_INNER(seg)
 
 #define NBIO_SR(reg_name)\
-	REG_STRUCT.reg_name = NBIO_BASE(regBIF_BX2_ ## reg_name ## _BASE_IDX) + \
-				regBIF_BX2_ ## reg_name
+	REG_STRUCT.reg_name = NBIO_BASE(regBIF_BX1_ ## reg_name ## _BASE_IDX) + \
+				regBIF_BX1_ ## reg_name
 
 #define NBIO_SR_ARR(reg_name, id)\
-	REG_STRUCT[id].reg_name = NBIO_BASE(regBIF_BX2_ ## reg_name ## _BASE_IDX) + \
-		regBIF_BX2_ ## reg_name
+	REG_STRUCT[id].reg_name = NBIO_BASE(regBIF_BX1_ ## reg_name ## _BASE_IDX) + \
+		regBIF_BX1_ ## reg_name
 
 #define bios_regs_init() \
 		( \


