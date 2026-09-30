Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED183CC300;
	Wed, 30 Sep 2026 19:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795695; cv=none; b=bUCqsT95Jxz6OHxSICTfNOG2x49oXNDiD18ccE1JfKW0xXNrvcdI+JvQPshI66hFKmtagynuh6AoFdUdqNm4s3JCO3rN+k54was+f3A1uWnBQIjM1XvDv14TlrcdSSc4rNCDDs3c+mrtQn5UFH/ozRxWLkdVFkzFDS1VhtT6xTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795695; c=relaxed/simple;
	bh=zlDEivECqKj0T8vGNK/KUJPkMjR6HFW2ckqOriOhGdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LObRmET4cHMOZfvQiA7aBjdiQfEsqRLDUm98NaztfIGYx7r/Y/qID/h/9Vo8q02v0O9B6O5yaW2yNvU7bONemISG4+JbGUXD1S+SNiWduQB9CKyk6ZxZKMqQd5uLNphRuT936TZ/JjQSKund6D3OkAXRlzDJPhLFpwXx68hi0S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pok4a5f/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pok4a5f/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4F31F000FF;
	Wed, 30 Sep 2026 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795694;
	bh=Zc6XCmdhkbsu0VmFr2+oEdW4g1cfJXI1RWIPeZhbhIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pok4a5f/FMFAeLk4t9geTt725KiY01NjsX3REAmftod14v0GS2JNNX62Q4XBZa0oy
	 VqbQrtPqNODtHxhYgPsJ74Abgg9RG42seaJyhPg/45HylEc4Mnivz7AtKrqlIk/4aw
	 XWw329T+M9bRlIpK3l872lF1HzXD061e6W7R1hWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0650/1193] media: mediatek: vcodec: bound AV1 tile-start copy to the array capacity
Date: Wed, 30 Sep 2026 17:22:14 +0200
Message-ID: <20260930152448.686389206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 37bef2170d4c88fc3d708eecf3ef0f4032bc1372 upstream.

vdec_av1_slice_setup_tile() copies tile_cols + 1 / tile_rows + 1 entries
into mi_col_starts[] / mi_row_starts[] from the bitstream tile_info. Bound
the copy to the array capacity.

Fixes: 0934d3759615 ("media: mediatek: vcodec: separate decoder and encoder")
Assisted-by: Claude:claude-opus-4-8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c       | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
index 2d622e85f827..49d9b4a72387 100644
--- a/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
+++ b/drivers/media/platform/mediatek/vcodec/decoder/vdec/vdec_av1_req_lat_if.c
@@ -1299,11 +1299,12 @@ static void vdec_av1_slice_setup_tile(struct vdec_av1_slice_frame *frame,
 	tile->uniform_tile_spacing_flag =
 		BIT_FLAG(ctrl_tile, V4L2_AV1_TILE_INFO_FLAG_UNIFORM_TILE_SPACING);
 
-	for (i = 0; i < tile->tile_cols + 1; i++)
+	/* Bound the copy to the mi_col_starts[]/mi_row_starts[] capacity. */
+	for (i = 0; i < tile->tile_cols + 1 && i < V4L2_AV1_MAX_TILE_COLS + 1; i++)
 		tile->mi_col_starts[i] =
 			ALIGN(ctrl_tile->mi_col_starts[i], BIT(mib_size_log2)) >> mib_size_log2;
 
-	for (i = 0; i < tile->tile_rows + 1; i++)
+	for (i = 0; i < tile->tile_rows + 1 && i < V4L2_AV1_MAX_TILE_ROWS + 1; i++)
 		tile->mi_row_starts[i] =
 			ALIGN(ctrl_tile->mi_row_starts[i], BIT(mib_size_log2)) >> mib_size_log2;
 }
-- 
2.55.0



