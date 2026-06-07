Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57AF2F8E97;
	Sun,  7 Jun 2026 10:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828095; cv=none; b=TnJ7MVrSUpuIShpZ0MDnqziLOdCGty10fK9JgG+bkIAeYMhvrHzeLba34YGTdezeKnmnZcSr6HH+QenPMhjLJ7hF9aEv/XuVz5rMAMSrPHz4M98dwx8VC9t14pSdNE1vpF6PF1xVGrCbS651TnnyTUTHKutzAqkDuQAnjJOwPgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828095; c=relaxed/simple;
	bh=dxXCnMzsgdCEKDljk5IpZRMAnrfvBWXUCnLe8AQEHtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqqbvRkHWkrWZhuf5qhTTT/J+ZzuNroJI9DbmZgCJOrSAVFbfV7Ko8Z6hSBl1HyYQpZiy+VkfMsL+upGudLN7/CyCzLE4D/Mv/zdETIbaN9YlJWgSw4Zq0GrLYCBtBI4iIYWPaL/vm8OklqkwIKEqYhSBC9UWPpb+y5OsAfYCNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6UqwEt5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6UqwEt5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21E31F00893;
	Sun,  7 Jun 2026 10:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828094;
	bh=q5B8cedxACYDKBBkQkJU+kx6XC2rH1uMQrA84HfeZrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6UqwEt5ZaS1iiEiHzoNTNYDRimowyAzEQuAnbw/rYMaswAWmNarEVW80Ap9nDBjC
	 eSjTPpbXWmJjL+lgsp+Tr10ytJaiUgHgzO5ejbu98uLDjczAxg82V921MFSjKbEbV7
	 1lQk9c66pnWbkWMnSGdATAd9uWP6NmH5c9WcstIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 127/315] smb: client: fix uninitialized variable in smb2_writev_callback
Date: Sun,  7 Jun 2026 11:58:34 +0200
Message-ID: <20260607095732.289062336@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -4837,7 +4837,7 @@ smb2_writev_callback(struct mid_q_entry
 	unsigned int rreq_debug_id = wdata->rreq->debug_id;
 	unsigned int subreq_debug_index = wdata->subreq.debug_index;
 	ssize_t result = 0;
-	size_t written;
+	size_t written = 0;
 
 	WARN_ONCE(wdata->server != mid->server,
 		  "wdata server %p != mid server %p",


