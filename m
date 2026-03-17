Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF0F3176FD;
	Tue, 17 Mar 2026 17:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768244; cv=none; b=YWEj4hfuiAp8z/+sJdS/XE61W8utsSZT13ODb9kZBlaLkmhW72rMKkHBwsGfHZmNSoPNdTH1aXeWzYg0CsC7mK815CVRjSE3o3GVAfdmhRB5i/A3PKPzVVhaRBlnx3VYhhBDo4iFUp5DdUWDxAr9e20jIu8hisfvYWd/CJ7F7Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768244; c=relaxed/simple;
	bh=yQTuK8pQLAie59SivYFQQiO8F0ah4i74UiRHYyFosIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFqADiI/+JpeFkri6pjdyigTSkhGbL5vaVPwfnEgOZ4VMaK1ahB4CqAr6c9sJPnsDf+SyED+kbMWaQ2QSZ1eZmLDZIGtxLrkuhi52bcczDzHzJjXcmH/hPE/lgtgvjrotFpFKc+jiP07Vg++Nu4Q3enf8Oq0RnremWrxiTxlW3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ic5Ae1AY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ic5Ae1AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0141FC2BCAF;
	Tue, 17 Mar 2026 17:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768244;
	bh=yQTuK8pQLAie59SivYFQQiO8F0ah4i74UiRHYyFosIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ic5Ae1AYJQD6lXZ+ASkgtH2iQrzPKFWc8yAmxgv8zmkNvjm3sC00lASMOokCL/gm2
	 rSMMSnoZiVkwSV0l+50wwQ6jaZhu+f4LHXo5ANCmDu5ydBGTtEoiLGjGSfyT6CNX8h
	 B3bS0ZTJF8XmptaLB5X5kqZm5aX714P9nW/DmMrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 266/333] cifs: make default value of retrans as zero
Date: Tue, 17 Mar 2026 17:34:55 +0100
Message-ID: <20260317163009.232928521@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

commit e3beefd3af09f8e460ddaf39063d3d7664d7ab59 upstream.

When retrans mount option was introduced, the default value was set
as 1. However, in the light of some bugs that this has exposed recently
we should change it to 0 and retain the old behaviour before this option
was introduced.

Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1920,7 +1920,7 @@ int smb3_init_fs_context(struct fs_conte
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
-	ctx->retrans = 1;
+	ctx->retrans = 0;
 	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 	ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
 	ctx->nonativesocket = 0;


