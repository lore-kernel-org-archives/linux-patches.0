Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F04B3B27C6;
	Mon, 23 Mar 2026 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278534; cv=none; b=K9/GAlwQ0eHfxSPQoQ6ooat+ZCSa+S5LLRmWPPTEVrrl1jG1vPIaTPEvTR/VAXRvbQgAHjJuHB+PTT485qQoijN7gBEfr6Fj5T3pBR+h7mTjkaoZtJzCKIinPL5s4GT7SvjOtoRKQKDyCAK7uLngsSQNiUruKa7Tu6sfFuvhex8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278534; c=relaxed/simple;
	bh=1d0PGvj2csvT2KI0ZmqJmt9YZq2bu7I7GYLvyK+B71w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOaKa88QIIwQdiWpJlgkLLcQXHao3gRX483cTSk52PELqMTCmiI371eSDzORDpb1E+Fj5owNhmK9XLQLFcP008SR3YrJ/JMdbOPpUtDqwmLguP5NL+BzhpmGXNLdSQphE+BQ+83ZAm6CAgmZ/I4EgO0rEfCx7ymSX1WJO7ReGRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoH2DlRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoH2DlRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AD8C4CEF7;
	Mon, 23 Mar 2026 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278534;
	bh=1d0PGvj2csvT2KI0ZmqJmt9YZq2bu7I7GYLvyK+B71w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoH2DlRARKjBv6r5LfKEBbfiKMu1kmywqqHCet+FQnzM6b4UyDw00sj2wO2cldoDP
	 R/3LTtaGDm0GOJRiYnZdJ/OkvsChuBy9Dzue7NfnOD/T0Kxx52j3gzDNhiWOr3Qa+5
	 jl5THhpfTQtheLlCUijeBrLC48H6yOaOPQVL/J4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 339/567] cifs: make default value of retrans as zero
Date: Mon, 23 Mar 2026 14:44:19 +0100
Message-ID: <20260323134542.223544385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
@@ -1809,7 +1809,7 @@ int smb3_init_fs_context(struct fs_conte
 	ctx->backupuid_specified = false; /* no backup intent for a user */
 	ctx->backupgid_specified = false; /* no backup intent for a group */
 
-	ctx->retrans = 1;
+	ctx->retrans = 0;
 	ctx->reparse_type = CIFS_REPARSE_TYPE_DEFAULT;
 
 /*


