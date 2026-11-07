Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061668;
	b=F6oJkpi/E0ftJpJ1ZaFVY59AViph0vDoAB6PqKCnFkmIM3ox8reyvIuVGqcqhEVgshm8
	 GflCcEYKhS9rSRvX6MfYo0JZbHPEjsG4ZFPsbgUrn0e4xu3v9DWSnKuak48Ga3yjSwEVz
	 YBit2LGaHAYzlH1wUtYvsVaCV/AK0aGF6eKzx6UyqTkedpCy6DsbIkRCezE0VPzXfcbM0
	 VpqJz3WoVwj/RhHrYcT8P9AtZdEur3+6clsqEfXfFA9wsRvNEtfIGBCUXUF5PGcHG5Y8z
	 LoYsS+Wcha99eNnF/BMzJR/LVmP8fkwLgyb+ZEvwQlT3txiPttxAqjbZq91lw/5lOIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EC1+XZz98YkggtlLmVZhRuKLIk4yqoOpf8KBYbv4H+o=;
	b=fWEOI17qLPQcYgBICXZDf8xtEB4R8zd/zCh7GkefkxuVdHPlNBLuGD6brNzmgXQ10IFA
	 FU49e0dd0hS8T48/nOtge4ogZ9zJZxne+iq0yVLidhzViPW6Cy7KPqQNX7tgx2FTw5ZZR
	 K5PeTxYRucO7HqImEsCmXAvCYMu52CMTTlFsZ5a6XVo0JbQs1VYMSZAndbcKVyK6U932g
	 jWozwesEWnx9Vl8OIN1BwsadedP+Mi+wNhovM/2eS3jh+2G2piogkN9ptvWFlfyLWAi/k
	 c4VCMHddfEEnpGo2A7xAXr8gYjJSS58l/X9euxnmW8eVDzZPROCvVCBnEDXlWPvxhqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfNhDqEl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F9606A32E;
	Sat,  7 Nov 2026 14:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfNhDqEl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED251F0089F;
	Sat,  7 Nov 2026 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061668;
	bh=EC1+XZz98YkggtlLmVZhRuKLIk4yqoOpf8KBYbv4H+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfNhDqEl32HZLcYxTctR/29tloIIeaRFFwrdwc+wJSX4dM1rBPWKYMR88iPyfunhG
	 P8CI3wdHYsf1/zH/HRb/nUXUYkgUHvt/pLQ6vAF5m7G7XcPG86y62cQNePTeCxqQPs
	 8/HcmwTa/YnNwaIk7psCLk+o68NIHo3rMTtJKWA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0723/1536] xfs: reject out-of-range attribute value lengths in xfs_attr_copy_value
Date: Sat,  7 Nov 2026 08:45:39 -0500
Message-ID: <20261107135017.805268730@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 0643549ffecaeb716c0b75590a9b76dfa5eb35b3 upstream.

xfs_attr_copy_value() takes the value length as a signed int and, for a
remote xattr, is handed args->rmtvaluelen.  That field is filled from the
on-disk __be32 xfs_attr_leaf_name_remote.valuelen in
xfs_attr3_leaf_getvalue(), so a crafted length such as 0x80000000 is
stored into the signed rmtvaluelen as a negative number.

The "buffer too small" guard in xfs_attr_copy_value() is a signed
comparison:

	if (args->valuelen < valuelen)
		return -ERANGE;

A negative valuelen therefore compares as smaller than the caller's
buffer size, skips the -ERANGE path, and is then used as a copy length,
leading to an out-of-bounds copy of a full remote block into a small
getxattr(2) buffer on a mounted crafted image.

Reject a value length that is negative or larger than the maximum xattr
size before it is used, so a bogus on-disk length can no longer slip
through the value copier.

Fixes: 9df243a1a9e6 ("xfs: consolidate attribute value copying")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -582,6 +582,17 @@ xfs_attr_copy_value(
 	int			valuelen)
 {
 	/*
+	 * A value length that is negative or larger than the maximum xattr
+	 * size is on-disk corruption.  The remote value length is an on-disk
+	 * __be32 stored into the signed args->rmtvaluelen, so a crafted value
+	 * such as 0x80000000 becomes negative and would slip past the
+	 * "args->valuelen < valuelen" check below and be used as a copy
+	 * length.  Reject it before that can happen.
+	 */
+	if (valuelen < 0 || valuelen > XFS_XATTR_SIZE_MAX)
+		return -EFSCORRUPTED;
+
+	/*
 	 * Parent pointer lookups require the caller to specify the name and
 	 * value, so don't copy anything.
 	 */


