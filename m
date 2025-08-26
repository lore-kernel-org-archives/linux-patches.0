Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F231726B747;
	Tue, 26 Aug 2025 11:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207993; cv=none; b=Zol4mcV7qfIExqCkvGx+pORZJa2k1Ifd3kuUDcMxpLlX2d96utRJZPCkTBALD4QfIVa5X3K5CLhtdBmOMRRh/W2GzI0JHFh3+LR7vpsXVP5edNUgyvQF+VihNh9dEMs12bQUsbXLJRt+UjIUyQHrjSeODkyvSrYFENhQ/27MXhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207993; c=relaxed/simple;
	bh=6Dr8fo4Usb522AfGKvurcuuSpUZc6Fl7RbfpqamxiG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mQyAyWN0Po8IOwmiY5feCKSzGkg/p4mAG6mZreeBrE9dpaaMpgyovW9cQsFcxrQx/OGLZ/NI4+NQpZcy1espNuoIyxw4iiTbRdqG9VuJIEStVTYY/QjSt5t1j91FHe4PxKvPCc/2pbIMK1+gRQ7pKCAHYxXIzrVA6HtmvWvE0oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpI2PNlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpI2PNlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285B8C4CEF1;
	Tue, 26 Aug 2025 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207992;
	bh=6Dr8fo4Usb522AfGKvurcuuSpUZc6Fl7RbfpqamxiG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpI2PNlkDwgIFpBthxanwmOdlr6ycmTVtgd6YWd6aclPZ95RoS9mFXQjwvXE8Ai+L
	 Md90qKofR0a0QD8MI5Uw0GsQN5tST8ZbKPy7Nd1SsIEqRt+zRChKHshZ9n6VunJ9kA
	 z1BjlxPTDCVknmqmQpuXJVjZmHDUgsJfXTeFEDM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 397/457] drm/amd/display: Dont print errors for nonexistent connectors
Date: Tue, 26 Aug 2025 13:11:21 +0200
Message-ID: <20250826110947.107348601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit f14ee2e7a86c5e57295b48b8e198cae7189b3b93 ]

When getting the number of connectors, the VBIOS reports
the number of valid indices, but it doesn't say which indices
are valid, and not every valid index has an actual connector.
If we don't find a connector on an index, that is not an error.

Considering these are not actual errors, don't litter the logs.

Fixes: 60df5628144b ("drm/amd/display: handle invalid connector indices")
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 249d4bc5f1935f04bb45b3b63c0f8922565124f7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser.c |  5 +----
 drivers/gpu/drm/amd/display/dc/core/dc.c          | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
index 67f08495b7e6..154fd2c18e88 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser.c
@@ -174,11 +174,8 @@ static struct graphics_object_id bios_parser_get_connector_id(
 		return object_id;
 	}
 
-	if (tbl->ucNumberOfObjects <= i) {
-		dm_error("Can't find connector id %d in connector table of size %d.\n",
-			 i, tbl->ucNumberOfObjects);
+	if (tbl->ucNumberOfObjects <= i)
 		return object_id;
-	}
 
 	id = le16_to_cpu(tbl->asObjects[i].usObjectID);
 	object_id = object_id_from_bios_object_id(id);
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index aab1f8c9d717..eb76611a42a5 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -217,11 +217,24 @@ static bool create_links(
 		connectors_num,
 		num_virtual_links);
 
-	// condition loop on link_count to allow skipping invalid indices
+	/* When getting the number of connectors, the VBIOS reports the number of valid indices,
+	 * but it doesn't say which indices are valid, and not every index has an actual connector.
+	 * So, if we don't find a connector on an index, that is not an error.
+	 *
+	 * - There is no guarantee that the first N indices will be valid
+	 * - VBIOS may report a higher amount of valid indices than there are actual connectors
+	 * - Some VBIOS have valid configurations for more connectors than there actually are
+	 *   on the card. This may be because the manufacturer used the same VBIOS for different
+	 *   variants of the same card.
+	 */
 	for (i = 0; dc->link_count < connectors_num && i < MAX_LINKS; i++) {
+		struct graphics_object_id connector_id = bios->funcs->get_connector_id(bios, i);
 		struct link_init_data link_init_params = {0};
 		struct dc_link *link;
 
+		if (connector_id.id == CONNECTOR_ID_UNKNOWN)
+			continue;
+
 		DC_LOG_DC("BIOS object table - printing link object info for connector number: %d, link_index: %d", i, dc->link_count);
 
 		link_init_params.ctx = dc->ctx;
-- 
2.50.1



