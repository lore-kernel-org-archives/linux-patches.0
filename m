Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A331BA87C;
	Tue, 27 Aug 2024 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770251; cv=none; b=Y40/jAQUCnC+OW+mfOI6p2s7sjeS0JBrnxWE70BUL9T9IeB/W6NnjzPCsAZQ8KioC8zs+MnoRSLNC1b3kCpc12m/Y0KOWZMzDQ09moVjUOUrKyM0l0POXSx6ze/34qHtM9Fo8r7evw9sJ/+9ZpwtfKGn9o7Nrjpu399bqHRBcmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770251; c=relaxed/simple;
	bh=1CPqs1mdqXc83cI5WwRRHFsBlCmGzUbQIEXfojLKeR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL0tovU3yBZdTPnF7GZaivrrJAFs7xEHn27xPsxDvKS9ZeCLFq3XUbUiYtnb3dhqupKylAXFMAPvgBaPUCW9VV+xRRfjARPl9WCmJIXAVK5kHtZcZahfDS4k1fTWRe5QIr6V3wS4G31khNmzfwbokO3dgJh+DQZBSql5P8xwcoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXtwbq4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXtwbq4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D20C4DDFB;
	Tue, 27 Aug 2024 14:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770251;
	bh=1CPqs1mdqXc83cI5WwRRHFsBlCmGzUbQIEXfojLKeR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXtwbq4xHccCLE8LfbCuocYXCLQwEJ60Ls4xOpt8z4mbU+zMT1FWs6X3jDhzlVtNU
	 /QtE0ckdY+TqtRzdKetjqZRpxS46b35xGdVjW5ApIhft2kxlLqWZtHWv4OAvaMnoBz
	 tnuUnvDxMF24RaD4Ha/yYKrj6h3QjG/xIjdHUYwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Kehat <akehat@habana.ai>,
	Oded Gabbay <ogabbay@kernel.org>,
	Carl Vanderlip <quic_carlv@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/341] accel/habanalabs: fix debugfs files permissions
Date: Tue, 27 Aug 2024 16:36:43 +0200
Message-ID: <20240827143849.959162960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Avri Kehat <akehat@habana.ai>

[ Upstream commit 0b105a2a7225f2736bd07aca0538cd67f09bfa20 ]

debugfs files are created with permissions that don't align
with the access requirements.

Signed-off-by: Avri Kehat <akehat@habana.ai>
Reviewed-by: Oded Gabbay <ogabbay@kernel.org>
Reviewed-by: Carl Vanderlip <quic_carlv@quicinc.com>
Signed-off-by: Oded Gabbay <ogabbay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/common/debugfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/accel/habanalabs/common/debugfs.c b/drivers/accel/habanalabs/common/debugfs.c
index 9e84a47a21dcf..7d733e4d50611 100644
--- a/drivers/accel/habanalabs/common/debugfs.c
+++ b/drivers/accel/habanalabs/common/debugfs.c
@@ -1645,19 +1645,19 @@ static void add_files_to_device(struct hl_device *hdev, struct hl_dbg_device_ent
 				&hl_data64b_fops);
 
 	debugfs_create_file("set_power_state",
-				0200,
+				0644,
 				root,
 				dev_entry,
 				&hl_power_fops);
 
 	debugfs_create_file("device",
-				0200,
+				0644,
 				root,
 				dev_entry,
 				&hl_device_fops);
 
 	debugfs_create_file("clk_gate",
-				0200,
+				0644,
 				root,
 				dev_entry,
 				&hl_clk_gate_fops);
@@ -1669,13 +1669,13 @@ static void add_files_to_device(struct hl_device *hdev, struct hl_dbg_device_ent
 				&hl_stop_on_err_fops);
 
 	debugfs_create_file("dump_security_violations",
-				0644,
+				0400,
 				root,
 				dev_entry,
 				&hl_security_violations_fops);
 
 	debugfs_create_file("dump_razwi_events",
-				0644,
+				0400,
 				root,
 				dev_entry,
 				&hl_razwi_check_fops);
@@ -1708,7 +1708,7 @@ static void add_files_to_device(struct hl_device *hdev, struct hl_dbg_device_ent
 				&hdev->reset_info.skip_reset_on_timeout);
 
 	debugfs_create_file("state_dump",
-				0600,
+				0644,
 				root,
 				dev_entry,
 				&hl_state_dump_fops);
@@ -1726,7 +1726,7 @@ static void add_files_to_device(struct hl_device *hdev, struct hl_dbg_device_ent
 
 	for (i = 0, entry = dev_entry->entry_arr ; i < count ; i++, entry++) {
 		debugfs_create_file(hl_debugfs_list[i].name,
-					0444,
+					0644,
 					root,
 					entry,
 					&hl_debugfs_fops);
-- 
2.43.0



