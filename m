Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8F73B19A3;
	Wed,  8 Apr 2026 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673580; cv=none; b=UMh4AhA6JYYlrvtNl57c2rs57GTN3bz5ha94FCNRTfFHkuflVXL/Ri1y1sGywviSpUQnT5a2RDyeekeKsiXUDlgkl1xVCbAm1VJ2xRhLPhdl8ABi0LwirAPhP5bhS6iRhnvztrA7swR0ox+6Cf5c11mWzAh9OWC96tuJ+qGeeQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673580; c=relaxed/simple;
	bh=4b1CPu98VSplhXE9btOtRDwRpp703E+dZFsxxSWTITU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmQ0mITFxn6p3j7xnU0/z0+4CvH78KLl+TPZ9pesmfWEyaAr+LLEJgHe2Eu5wd3D9WKVOft3/RPTfWnyzyRuSqyQpbrqZMRXxeWzDEoMZHW+q5jpEzparUUxDzJXYwFPGr4c7XA3f2EOKm/BF5ATEUhvsN1AlK1tIaKv156Diyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXJYHBBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXJYHBBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD49C19421;
	Wed,  8 Apr 2026 18:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673580;
	bh=4b1CPu98VSplhXE9btOtRDwRpp703E+dZFsxxSWTITU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXJYHBBGf6WzVn27iTON108PEyym5T5pBWlhyAthoGS0+CR4rlaBMhhxF7/1OnW0I
	 nd1Jrvshvj71WarsJDrhfb7AjLb/KBXLDFMCxzDrhRt3oK7nrIU3trtx03C3lhGX+J
	 JyWAy4v3azAx7yApcOn4d1Wplcb320VHxomrnorM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 010/242] io_uring/net: clarify io_recv_buf_select() return value
Date: Wed,  8 Apr 2026 20:00:50 +0200
Message-ID: <20260408175927.458274341@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit b22743f29b7d3dc68c68f9bd39a1b2600ec6434e upstream.

It returns 0 on success, less than zero on error.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1192,7 +1192,7 @@ int io_recv(struct io_kiocb *req, unsign
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		ret = io_recv_buf_select(req, kmsg, &len, issue_flags);
-		if (unlikely(ret)) {
+		if (unlikely(ret < 0)) {
 			kmsg->msg.msg_inq = -1;
 			goto out_free;
 		}


