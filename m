Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4133F660B;
	Tue, 17 Mar 2026 16:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766770; cv=none; b=MWfE7A3Z0DT9j/izHN0TCS7T3IYvwYaP6mgzsFFgqUv8fWSi1OZMA2lAJHMc84dTjkcVtajRQZHDmfuOoc0a17u5Fc+21dyA0zfq4wNCMiSVQyvNvn53a7FxTJSTfJK56Rw10iWt1wTTOK0y/2f6pl+sTLRRW8DHT/TaxCIhwzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766770; c=relaxed/simple;
	bh=5be8f31PtZlaVt913tEH0w5Gpg+UBBRTmZfCiIHD1Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWB7hrhJIAlauzOoxA0xExjxAhmWTzAvjj5LA28fgZhnt90GEp0DmNDm9BFMbegE7XwVlEQ59Gm/mZMqSx0WFNLekJDgqQRTk5Bkw3uenj2cFfjBIr+2qyawN7yaSZaXJuR8T9GCPdkzXE4ujpMKdB0+Tzz1KIi19RA2AhvdCe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjkLh13+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjkLh13+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC44C4CEF7;
	Tue, 17 Mar 2026 16:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766770;
	bh=5be8f31PtZlaVt913tEH0w5Gpg+UBBRTmZfCiIHD1Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjkLh13+T/YjWpn/aHPDoo/MEvCs1julNnT/I9RG95PGpeyqrsp9hLV+t/otQ7jDH
	 ZIph+AdAzr/iT3NKG9FOtnZMOCTXXSPHQEx7ALEXV63NAgvDx7CmaGGDggEecbbXZh
	 TK7a0GoX/wiXHTmv31q32PqAom7wYdt0ZvUJ3/ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 318/378] cifs: make default value of retrans as zero
Date: Tue, 17 Mar 2026 17:34:35 +0100
Message-ID: <20260317163018.690394075@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1998,7 +1998,7 @@ int smb3_init_fs_context(struct fs_conte
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
-	ctx->retrans = 1;
+	ctx->retrans = 0;
 	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 	ctx->symlink_type = CIFS_SYMLINK_TYPE_DEFAULT;
 	ctx->nonativesocket = 0;


