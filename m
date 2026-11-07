Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061749;
	b=FsDWO6E6OJylfzN5lr4KguN2XcUwrMUG6fk2HlQ9cjUFCobexXmilkvzpNpJQu6EOEUt
	 Sh7+HGd38tHOVI9a3zFQ74iKFiGM0iVRjybvhTdPHOe2ge6O8iXhZP+ZwqVZzng8rOBKD
	 coMtaF7KmDfGxlJ9OhjL0WuiRXyXCss+JgvzAaHO7S/EwwVWrR74K/cDJoXB3gy1SFf64
	 pWGWk40W8n2wlk9mxOP8omCDS6jWFJQ6ZiAzuhw4OdM0WfLC78nVt1k2dTc2iJQo04l/t
	 /zsDZIuq+ihUOot7O0gexn7x4dSKP6fTHp95RL+dxPZYGb6B2JiU/BMWfmTYgJ+tgfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=55cMHxmWfkF0/q6DZTUGkpykT3qROTqS12jrqH4TEc0=;
	b=oKHpAgtzpIZVPeMD+GrsPZ2lKCnH0kgdrPeNt4a01uqwg3j+9XaGvG4kWb6QrvY5cGEH
	 stiQxzUG+4gQ+YNSfaYjVOsjYHorrpg3lKrDLKDoaW02qQX1KepvBlecOBRruEuErK2nP
	 YSHSuG6zHIt1jQVhFG3XzQ8Rmz9+1Yz4s7QRJDlnkR3SiiYjGmyv7Img38nJoGtmwlExU
	 3wjW3vANgpbS98D+0H+prCsDYiZdNf30WOKefTglXyHXC6eto+uMKfFmuzM+mMPdczl16
	 9HVZ2P+jbccveMKz1YW1FFavG5iyyxXJ9A4FmtIzKOXIYvTWTVjWPxtBNdV2Rf7NoLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y1HB+7nW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6666D606A32C;
	Sat,  7 Nov 2026 14:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y1HB+7nW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118261F0089F;
	Sat,  7 Nov 2026 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061749;
	bh=55cMHxmWfkF0/q6DZTUGkpykT3qROTqS12jrqH4TEc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1HB+7nWBL/vMsw4A3uokKRuYGa/knydG+qWmg5Iqqp2WeQlsrCnLcR2F9aS5Z3e1
	 HvGNKKt5TJ3tX5VQhbNSi0jX5Qt1nINwqlJI1AZHzEAPXrJhrc3Pe0gDjjY1U/uole
	 YILDgmhp1qVEj8C4QwvA3nadjkgpR53PnpBy5fX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 0750/1536] smb: client: fix fiemap wild read on empty truncated response
Date: Sat,  7 Nov 2026 08:46:06 -0500
Message-ID: <20261107135018.595364825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdifatah Suruur <suruurism@gmail.com>

commit f5baa17a0f316c235d61623ac8e8fb32c2b3c0cc upstream.

smb3_fiemap() treats -E2BIG from SMB2_ioctl() as a truncated range blob
and loops for the next chunk. If the server reports
STATUS_BUFFER_OVERFLOW with OutputCount == 0, SMB2_ioctl() returns
-E2BIG with out_data == NULL and out_data_len == 0, and the existing
length checks accept the empty result. The loop then evaluates

	next = out_data[num - 1].file_offset + ...

with num == 0, reading 16 bytes before NULL.

Reject a truncated range blob that contains no range, so the resume
offset is never computed from an empty response. Also require the last
range in a truncated blob to advance the resume offset without
overflowing, and to stay within the requested range; a malicious or
broken server could otherwise make no progress or underflow len and loop
forever. Free the previous response buffer before retrying.

Reproduced on 6.6.87.2 with a malicious SMB2 server that answers
FSCTL_QUERY_ALLOCATED_RANGES with STATUS_BUFFER_OVERFLOW and
OutputCount == 0; an FS_IOC_FIEMAP ioctl on the mount oopses in
cifs_fiemap() with CR2 = fffffffffffffff8. The code path is unchanged
on mainline.

Fixes: 2f3ebaba13ce ("cifs: add fiemap support")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2ops.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4205,6 +4205,15 @@ static int smb3_fiemap(struct cifs_tcon
 		goto out;
 	}
 
+	/*
+	 * A truncated range blob must contain at least one range, otherwise
+	 * there is no offset to resume from and out_data is NULL.
+	 */
+	if (!last_blob && out_data_len == 0) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	num = out_data_len / sizeof(struct file_allocated_range_buffer);
 	for (i = 0; i < num; i++) {
 		flags = 0;
@@ -4225,10 +4234,25 @@ static int smb3_fiemap(struct cifs_tcon
 	}
 
 	if (!last_blob) {
-		next = le64_to_cpu(out_data[num - 1].file_offset) +
-		  le64_to_cpu(out_data[num - 1].length);
-		len = len - (next - start);
+		u64 last_start, last_len;
+
+		last_start = le64_to_cpu(out_data[num - 1].file_offset);
+		last_len = le64_to_cpu(out_data[num - 1].length);
+
+		if (check_add_overflow(last_start, last_len, &next) ||
+		    next <= start) {
+			rc = -EINVAL;
+			goto out;
+		}
+		if (next - start >= len) {
+			rc = 0;
+			goto out;
+		}
+
+		len -= next - start;
 		start = next;
+		kfree(out_data);
+		out_data = NULL;
 		goto again;
 	}
 


