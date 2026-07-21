Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE24C415F0C;
	Tue, 21 Jul 2026 22:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674598; cv=none; b=ORnitjCgRjrFIaSIuXVjo0HQLMkc4aopbMHbZKjlTZ1YkqhgdXIRuamDV366dY2st8ANVUiuQssBOPy90A9gSBvRWKIc6A6omC7cYnWNI75foWs2dWXjriVPHxU6oYt1BuDzjmMRYNrJAKt39xfEaCgbsmYxW/8d20YWnN83Z/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674598; c=relaxed/simple;
	bh=NTgVPOwTmpLPxx09Gpy4uKVhAfAtPbqAVNDOdF8WG9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqySIhqZK2ycwIMIiTbQAMMg2kzmIp4QS2bgiiBF7Fb33OJz0jzH5udpze5GShKpyoO/tQQP77wj9RkRc9hG5+lWCwD7azyBpCcKMJ3niJD+o3uvb5wPprO5XrvYxemRGRL4Kh3d+uJXCy1e//92xkiChyNAD0+G/brNhwCOMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bnsw/X3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bnsw/X3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302CB1F000E9;
	Tue, 21 Jul 2026 22:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674596;
	bh=/URrfxq6A6ShPkAxpldcqdQiVmTBEP9yTe58KJSaCKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bnsw/X3whj2SI+XW09K4BzUdY68jtVJGwWtngGmP1ITbUajXLOuLFksU0D8VEpLi6
	 bY2X+BdIVx4VNhkOT8JFdJUzG1guXuMZpkekMpktr3Hwqn5D5PoEnbnvIImAdUHxXB
	 gWRZv3LtTMq9VIASvSdRy8lkcohuoDaKqHLovYnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Srivastava <yashsri421@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 602/699] media: atomisp: replace boolean comparison of values with bool variables
Date: Tue, 21 Jul 2026 17:26:01 +0200
Message-ID: <20260721152409.309800604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Srivastava <yashsri421@gmail.com>

[ Upstream commit c606970d4250dfb95869a563975c08bab148137a ]

There are certain expressions in a condition in atomisp, where a boolean
variable is compared with true/false in forms such as (foo == true)
or (false != bar), which does not comply with the coding style rule by
checkpatch.pl (CHK: BOOL_COMPARISON), according to which the boolean
variables should be themselves used in the condition, rather than
comparing with true or false.

E.g. In drivers/staging/media/atomisp/pci/atomisp_compat_css20.c:

if (asd->stream_prepared == false) {

Can be replaced with:
if (!asd->stream_prepared) {

Replace such expressions with boolean variables appropriately.

Link: https://lore.kernel.org/linux-media/20201214132716.28157-1-yashsri421@gmail.com
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f4d51e55dd47 ("staging: media: atomisp: reduce load_primary_binaries() stack usage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp_compat_css20.c          |    2 -
 drivers/staging/media/atomisp/pci/runtime/isys/src/virtual_isys.c |   12 +++++-----
 drivers/staging/media/atomisp/pci/sh_css.c                        |   12 +++++-----
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/staging/media/atomisp/pci/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_compat_css20.c
@@ -1142,7 +1142,7 @@ int atomisp_css_start(struct atomisp_sub
 	 * Thus the stream created in set_fmt get destroyed and need to be
 	 * recreated in the next stream on.
 	 */
-	if (asd->stream_prepared == false) {
+	if (!asd->stream_prepared) {
 		if (__create_pipes(asd)) {
 			dev_err(isp->dev, "create pipe error.\n");
 			return -EINVAL;
--- a/drivers/staging/media/atomisp/pci/runtime/isys/src/virtual_isys.c
+++ b/drivers/staging/media/atomisp/pci/runtime/isys/src/virtual_isys.c
@@ -179,12 +179,12 @@ ia_css_isys_error_t ia_css_isys_stream_c
 	isys_stream->linked_isys_stream_id = isys_stream_descr->linked_isys_stream_id;
 	rc = create_input_system_input_port(isys_stream_descr,
 					    &isys_stream->input_port);
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	rc = create_input_system_channel(isys_stream_descr, false,
 					 &isys_stream->channel);
-	if (rc == false) {
+	if (!rc) {
 		destroy_input_system_input_port(&isys_stream->input_port);
 		return false;
 	}
@@ -204,7 +204,7 @@ ia_css_isys_error_t ia_css_isys_stream_c
 	if (isys_stream_descr->metadata.enable) {
 		rc = create_input_system_channel(isys_stream_descr, true,
 						 &isys_stream->md_channel);
-		if (rc == false) {
+		if (!rc) {
 			destroy_input_system_input_port(&isys_stream->input_port);
 			destroy_input_system_channel(&isys_stream->channel);
 			return false;
@@ -248,7 +248,7 @@ ia_css_isys_error_t ia_css_isys_stream_c
 		  isys_stream_descr,
 		  &isys_stream_cfg->channel_cfg,
 		  false);
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	/* configure metadata channel */
@@ -260,7 +260,7 @@ ia_css_isys_error_t ia_css_isys_stream_c
 			  isys_stream_descr,
 			  &isys_stream_cfg->md_channel_cfg,
 			  true);
-		if (rc == false)
+		if (!rc)
 			return false;
 	}
 
@@ -269,7 +269,7 @@ ia_css_isys_error_t ia_css_isys_stream_c
 		 &isys_stream->input_port,
 		 isys_stream_descr,
 		 &isys_stream_cfg->input_port_cfg);
-	if (rc == false)
+	if (!rc)
 		return false;
 
 	isys_stream->valid = 1;
--- a/drivers/staging/media/atomisp/pci/sh_css.c
+++ b/drivers/staging/media/atomisp/pci/sh_css.c
@@ -1058,7 +1058,7 @@ sh_css_config_input_network(struct ia_cs
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE_PRIVATE,
 			    "sh_css_config_input_network() enter 0x%p:\n", stream);
 
-	if (stream->config.continuous == true)
+	if (stream->config.continuous)
 	{
 		if (stream->last_pipe->config.mode == IA_CSS_PIPE_MODE_CAPTURE) {
 			pipe = stream->last_pipe;
@@ -5622,7 +5622,7 @@ static int load_video_binaries(struct ia
 		} else {
 			/* output from main binary is not yuv line. currently this is
 			 * possible only when bci is enabled on vfpp output */
-			assert(pipe->config.enable_vfpp_bci == true);
+			assert(pipe->config.enable_vfpp_bci);
 			ia_css_pipe_get_yuvscaler_binarydesc(pipe, &vf_pp_descr,
 							     &mycs->video_binary.vf_frame_info,
 							     pipe_vf_out_info, NULL, NULL);
@@ -8068,7 +8068,7 @@ create_host_regular_capture_pipeline(str
 		struct ia_css_frame *tmp_out_frame = NULL;
 
 		for (i = 0; i < num_yuv_scaler; i++) {
-			if (is_output_stage[i] == true)
+			if (is_output_stage[i])
 				tmp_out_frame = out_frame;
 			else
 				tmp_out_frame = NULL;
@@ -8460,7 +8460,7 @@ sh_css_pipeline_add_acc_stage(struct ia_
 	/* In QoS case, load_extension already called, so skipping */
 	int	err = 0;
 
-	if (fw->loaded == false)
+	if (!fw->loaded)
 		err = acc_load_extension(fw);
 
 	ia_css_debug_dtrace(IA_CSS_DEBUG_TRACE,
@@ -9697,8 +9697,8 @@ ia_css_stream_destroy(struct ia_css_stre
 			assert(entry);
 			if (entry) {
 				/* get the SP thread id */
-				if (ia_css_pipeline_get_sp_thread_id(
-					ia_css_pipe_get_pipe_num(entry), &sp_thread_id) != true)
+				if (!ia_css_pipeline_get_sp_thread_id(
+					ia_css_pipe_get_pipe_num(entry), &sp_thread_id))
 					return -EINVAL;
 				/* get the target input terminal */
 				sp_pipeline_input_terminal =


