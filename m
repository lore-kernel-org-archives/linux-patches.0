Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21047142903;
	Mon, 16 Sep 2024 12:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488738; cv=none; b=TfvJqtg00nVYKNrNicIkWxhg2GlGEKTjRuy/Pzg5+7bsLZtpP3OTtSytajAb4QmSDx68pC9hYJ0tyi4d6733E7JkR/eluagZ+3d2piZdDrQULf8SIXC+scPTlWv350z7DCV0i6gj93F/W4JOaW5ZfF4i6WeYZX4S+/oDAfjdzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488738; c=relaxed/simple;
	bh=FrxdF5Cg1kAzjLx9r7IJlphiN1Tihbuc4Nq82eNcMCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TFqP7OdYzcO5967zfEpya7nC6Ac4dX9SYUubWwd6J9UOniLe0S71W7MbMr6Ku7fA4B+aiwr0G0UcJJLx1t9dccrVNrpFT7GfxGbLZDfPfssaKHUTBn4jO/fXxmD4NHjWwEsGH8wkHug+I1oszR2waluj7geKZkG5aoD0QYCYoeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGwK1Tga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGwK1Tga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01B3C4CEC4;
	Mon, 16 Sep 2024 12:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488738;
	bh=FrxdF5Cg1kAzjLx9r7IJlphiN1Tihbuc4Nq82eNcMCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGwK1TgahnkIJhQrTE3i33jlUVRvok+f3OGMv6Oi8541lF+1uHrm2O0pjF5pC7t6h
	 LK7kmHKqLJbUBCrnNWZm5KgYz/WlCHVdzPS7PGo7nL/JEB6wQDqedv0LNg6FR/MFRI
	 p8YTy/Q59sFEh4nOdr508NhcZq4LTiExfjyTOgVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 82/91] drm/amdgpu/atomfirmware: Silence UBSAN warning
Date: Mon, 16 Sep 2024 13:44:58 +0200
Message-ID: <20240916114227.158237477@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

commit 17ea4383649fdeaff3181ddcf1ff03350d42e591 upstream.

Per the comments, these are variable sized arrays.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3613
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 81f7804ba84ee617ed594de934ed87bcc4f83531)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/atomfirmware.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -1006,7 +1006,7 @@ struct display_object_info_table_v1_4
   uint16_t  supporteddevices;
   uint8_t   number_of_path;
   uint8_t   reserved;
-  struct    atom_display_object_path_v2 display_path[8];   //the real number of this included in the structure is calculated by using the (whole structure size - the header size- number_of_path)/size of atom_display_object_path
+  struct    atom_display_object_path_v2 display_path[];   //the real number of this included in the structure is calculated by using the (whole structure size - the header size- number_of_path)/size of atom_display_object_path
 };
 
 struct display_object_info_table_v1_5 {
@@ -1016,7 +1016,7 @@ struct display_object_info_table_v1_5 {
 	uint8_t reserved;
 	// the real number of this included in the structure is calculated by using the
 	// (whole structure size - the header size- number_of_path)/size of atom_display_object_path
-	struct atom_display_object_path_v3 display_path[8];
+	struct atom_display_object_path_v3 display_path[];
 };
 
 /* 


