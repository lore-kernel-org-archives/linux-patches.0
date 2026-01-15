Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E5E3D7D9C;
	Thu, 15 Jan 2026 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499930; cv=none; b=D28qJv429rP8DVtbtV+ewUowrLig7SHuoIvkfXnzBh2eWWPMVTvsetUtfUZrh+gmRLCD9dWXV+5/UMt0ejYzlAu8lmN/0fdZortxOOv9eFu95iBgzft4M1K9xT0/2xt7etELZlFi8H6H20K1R1taCYf2H6GlZ0feuAsgzizvgmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499930; c=relaxed/simple;
	bh=88hUX4zi0o+S5P/rTdDu85kgQ5q52YRYWLee9ofVQhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2PYGatBM6aN+7CP74h3kmMsCEoERka+1RvEVMlHGwTu9a5pbKCpgnDVhr8z6YsgSKsciw/xDuyhG/M/wwTeCRVJDGmm7bdFsDi5kpcXtyS7U8tWmH11HigkZNwBQavntVvCzY8iP3qG8r/QOd4VdIGErdjwvLb/7LsMetmXS6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1G4Lba33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1G4Lba33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBEEC116D0;
	Thu, 15 Jan 2026 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499929;
	bh=88hUX4zi0o+S5P/rTdDu85kgQ5q52YRYWLee9ofVQhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1G4Lba33nCZ4DdneHjyUa7E56L7v+tiBLByO5iOGkH7NokpV7M5L1g4A8G3Qeijp1
	 eqBpdq2TfUML6iJx17ORG4TCBoNB4gE4x6OyzcH71+O8vLmTSvle+ICXXQB9/nvPrj
	 dSV6PdAIF+2HuMuxwttsfRBN6kvA6+vjEdCykj/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 398/451] ovl: Use "buf" flexible array for memcpy() destination
Date: Thu, 15 Jan 2026 17:49:59 +0100
Message-ID: <20260115164245.334518430@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

commit cf8aa9bf97cadf85745506c6a3e244b22c268d63 upstream.

The "buf" flexible array needs to be the memcpy() destination to avoid
false positive run-time warning from the recent FORTIFY_SOURCE
hardening:

  memcpy: detected field-spanning write (size 93) of single field "&fh->fb"
  at fs/overlayfs/export.c:799 (size 21)

Reported-by: syzbot+9d14351a171d0d1c7955@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/000000000000763a6c05e95a5985@google.com/
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Shivani: Modified to apply on 5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/export.c    |    2 +-
 fs/overlayfs/overlayfs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -788,7 +788,7 @@ static struct ovl_fh *ovl_fid_to_fh(stru
 		return ERR_PTR(-ENOMEM);
 
 	/* Copy unaligned inner fh into aligned buffer */
-	memcpy(&fh->fb, fid, buflen - OVL_FH_WIRE_OFFSET);
+	memcpy(fh->buf, fid, buflen - OVL_FH_WIRE_OFFSET);
 	return fh;
 }
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -104,7 +104,7 @@ struct ovl_fh {
 	u8 padding[3];	/* make sure fb.fid is 32bit aligned */
 	union {
 		struct ovl_fb fb;
-		u8 buf[0];
+		DECLARE_FLEX_ARRAY(u8, buf);
 	};
 } __packed;
 


