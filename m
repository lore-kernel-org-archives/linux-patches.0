Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80FC72DE6E9;
	Tue, 12 Aug 2025 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021779; cv=none; b=GdZMGaHVi535mrYzqu4RV+FAw7dxothtXIeOnhOKirQx3V9JjYhDHx1fFpmIbPQk7u/GNMJ8OhNfTDd+9IW1HQB2CUDkasZfYCvYc8bdfDhYbVcdg4FL0DkSF6g/uTuKhXYjW4TG0tG3PSsT59VHDd2H1gV2U6zD1SX9D3Txu+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021779; c=relaxed/simple;
	bh=VBydXkU0cLWe0OdVGRn1Fy+iDoAs+twIeiHyA4vvY4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iszvjSR1+W5Kfc/ItSMRG/NBN6bIGoxEQGlJuSIz8wBdAFiqK+RSMSO21y4fr5G3KcrAa8nBn7ZHNw1/vjLFtjZrmZQv3/Watn66S9VfMCmZ44b6abS4OR9naUDg7wgHZf3p0zO5fSZn1oHFWEV/ZO1Pu6r00IHkoBUmJ1jKOSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/Xg5+cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/Xg5+cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BEDC4CEF7;
	Tue, 12 Aug 2025 18:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021779;
	bh=VBydXkU0cLWe0OdVGRn1Fy+iDoAs+twIeiHyA4vvY4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/Xg5+cxjPZPEd4Nvea6fuAdLaGDgtTvdRwYfQ6uZq9nCwViT/a+O81faFossSv6N
	 +pyRP5itJaWzAfCq3r//Ic4XnYdUTkoi621y1kZ5F0rSucGQrgmODzDCGmXXSuee6Y
	 NQqwevGpnXMkfhrALTv/z/GcMfO/XlAOednLADmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shen Lichuan <shenlichuan@vivo.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/262] smb: client: Use min() macro
Date: Tue, 12 Aug 2025 19:30:09 +0200
Message-ID: <20250812173002.556768354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shen Lichuan <shenlichuan@vivo.com>

[ Upstream commit 25e68c37caf2b87c7dbcd99c54ec3102db7e4296 ]

Use the min() macro to simplify the function and improve
its readability.

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 5349ae5e05fa ("smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsacl.c   | 2 +-
 fs/smb/client/smbdirect.c | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index bf32bc22ebd6..7bd29e827c8f 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -187,7 +187,7 @@ compare_sids(const struct smb_sid *ctsid, const struct smb_sid *cwsid)
 	/* compare all of the subauth values if any */
 	num_sat = ctsid->num_subauth;
 	num_saw = cwsid->num_subauth;
-	num_subauth = num_sat < num_saw ? num_sat : num_saw;
+	num_subauth = min(num_sat, num_saw);
 	if (num_subauth) {
 		for (i = 0; i < num_subauth; ++i) {
 			if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d74e829de51c..c41a44f4fc63 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1585,10 +1585,8 @@ static struct smbd_connection *_smbd_get_connection(
 	conn_param.initiator_depth = 0;
 
 	conn_param.responder_resources =
-		info->id->device->attrs.max_qp_rd_atom
-			< SMBD_CM_RESPONDER_RESOURCES ?
-		info->id->device->attrs.max_qp_rd_atom :
-		SMBD_CM_RESPONDER_RESOURCES;
+		min(info->id->device->attrs.max_qp_rd_atom,
+		    SMBD_CM_RESPONDER_RESOURCES);
 	info->responder_resources = conn_param.responder_resources;
 	log_rdma_mr(INFO, "responder_resources=%d\n",
 		info->responder_resources);
-- 
2.39.5



