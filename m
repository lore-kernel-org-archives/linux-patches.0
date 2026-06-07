Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1281C5F27;
	Sun,  7 Jun 2026 10:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828022; cv=none; b=TUSBYjpw7PgI8yzJ2Mync+NMYz91+tN3n0sK1n0T8XkC2IO6M9z6n1Pg05cxw3x99GC8KLqHEvaamw+cOe/ra6wxZuScLLU+xAq7ZkFDF1b83qdJhueDm1fg2u+Nvlumz2/uBf1Uwr9mNs/ze55OWMcwmX0c3iqiyhCZjWOxo2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828022; c=relaxed/simple;
	bh=Kqyflr8/jFNEqkTk5fQq58y7DvsFHqBI7zApR2R4Vzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBYo7eXteREBILFJVJQP4MM+e5gIpGEsY6nJDPBx6mWmJiQY6RhLSzap5sM4E7ixIGx+0BC16nhLKxZ7jwRHJPNtQUttIAHDjqknlS2EEDG6rXrtpiAODLmuoHusmWo8lw30RArYT1ue9zatcCsy4dKU9z1egbsQPIxhVhNFUVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szn5jMIf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szn5jMIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A665E1F00893;
	Sun,  7 Jun 2026 10:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828021;
	bh=0x3FTLa5hwW4NRdzoRVixqD51AJMmkiDc5prfAf5j60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=szn5jMIf+DZxsxE+azQbjx0BdJqauFDwJIJozt2Nd30qyAjL3sMtTxQ15WGcer7rF
	 qQtPBMt75XEK/IOyK9xWw9LmiW342mqgpSwneuTT0CYUoOa4H+qY/YthhoBw60rNhs
	 U9hvFAEOLnrNKjOLdSRSl13fc06FeJ84EiWiseV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 145/332] smb: client: fix uninitialized variable in smb2_writev_callback
Date: Sun,  7 Jun 2026 11:58:34 +0200
Message-ID: <20260607095733.424676080@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

commit 9d2491197a00acf8c423512078458c2855102b66 upstream.

compiling with W=2 pointed out that "written may be used uninitialized"

Fixes: 20d72b00ca81 ("netfs: Fix the request's work item to not require a ref")
Cc: stable@vger.kernel.org
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4943,7 +4943,7 @@ smb2_writev_callback(struct TCP_Server_I
 	unsigned int rreq_debug_id = wdata->rreq->debug_id;
 	unsigned int subreq_debug_index = wdata->subreq.debug_index;
 	ssize_t result = 0;
-	size_t written;
+	size_t written = 0;
 
 	WARN_ONCE(wdata->server != server,
 		  "wdata server %p != mid server %p",


