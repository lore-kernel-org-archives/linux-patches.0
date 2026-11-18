Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057875;
	b=1v+hzNeg2lbtl4YAlUGwTGGhAvmwQENrD0aqZswIrP23gPndMkYAZ6n6g6ZiZ09D8Weg
	 fk2REvmuayk5VOn4fBMruayflP4kaEs8Sm/zZQSpZppSdNSOAD4Sb8Y9vPsEJh5c2Uol+
	 Z+HitYaT0OERM8UWYHCQHZhqa6bYCMuEzbhs5Mk06R8nidxwXX6ReIjloKs6HiEBWRZZj
	 pPFwRHSEy8nAlgY2w6HXc3YshABxp7gzQ9DAPmpXHADvY1y+lDOuodmvKZdnKYkH0yyrL
	 wip/UTy2SmO8ylrYrUjh10Yj6zG1Vk1GL+tKDXVtdr5V0kF/xhjKDXMf+SDd46uTDcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057875;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B2OoCdvXW05QB05WtCBAXKrVn7ciCeqj1CP0Nw/ANdU=;
	b=VNh5NXV4swYmX2Jo1r92fgHPuT92qy1kM2ZCQ39gnDCwkWML3LE/JpP3Dm+pEW5uaUJm
	 /pZM/0vQya4QBxQtJeoP+yShLcQbg3t2ESpsbIPbmEM1DIsf3J90Z+2uP7tQ3zO4wHbg4
	 LbFhMAK1nqP4mur4o8YtIAewSE/ThT6+xXbB/4cWhcTlHqj2eKyicgiO5AHoTc+Xf8rRK
	 SPIfxgW1YghMQr8EiXmPhtYAmj9S7I1jKQu48Syj/gdNIy03xKTH/BJShnjP7cTWkGhWG
	 tXm41fl1jhvPYT+Ts1imM0VfhMN+/TCLFTT/6/+0HAILzuJWkU0cEsbTINv21vBKoLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVYj0XbX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9A3606A31C;
	Thu, 19 Nov 2026 03:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JVYj0XbX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8506F1F000C4;
	Thu, 19 Nov 2026 03:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057875;
	bh=B2OoCdvXW05QB05WtCBAXKrVn7ciCeqj1CP0Nw/ANdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVYj0XbXa5Fki+x1GyHRvTxtfeHYlb6QiXUoQosC9WWV2yYxapdBZC836f2vRqDR7
	 wWn8sxAxAblW8FsiaKIzsDPDAeibiM4nqGzvKR3K0aRInKM4VxSQjN6YrK5wi9qHWx
	 JUtv+c8J7hlwbwkR/QAewD/SIK6Lvmu05c7L995c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.10 0285/1848] NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET
Date: Wed, 18 Nov 2026 15:38:43 +0100
Message-ID: <20261118145924.096240826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <ben.coddington@hammerspace.com>

commit 28c950413605fb5b6cb3863c5e3274ea69701097 upstream.

If the layout for the requested range is larger than the size the
client advertised in loga_maxcount, RFC 8881 Section 18.43.3 has the
metadata server return NFS4ERR_TOOSMALL.  The client caps
loga_maxcount at a single page, so a flexfiles server that stripes a
layout segment across several dozen data servers produces this error
today.

The client has no handling for it: nfs4_stat_to_errno() maps the
error to -ETOOSMALL during decode, which nothing in the layoutget
path recognizes and nfs_error_is_fatal() does not consider fatal, so
pnfs_update_layout() clears the layout fail bit and returns no
segment.  The I/O falls back to the MDS, but because no fail bit was
set, every subsequent pageio attempt sends another LAYOUTGET that is
doomed to the same NFS4ERR_TOOSMALL.  Files whose layouts do not fit
the reply buffer never use pNFS and pay an extra round trip on every
pageio.

Map -ETOOSMALL to -EMSGSIZE in the layoutget exception handler and
have pnfs_update_layout() treat it like NFS4ERR_LAYOUTUNAVAILABLE:
mark the layout mode as failed and fall back to I/O through the MDS.

Fixes: d600ad1f2bdb ("NFS41: pop some layoutget errors to application")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Benjamin Coddington <bcodding@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    8 ++++++++
 fs/nfs/pnfs.c     |    2 ++
 2 files changed, 10 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9452,6 +9452,14 @@ nfs4_layoutget_handle_exception(struct r
 		status = -EOVERFLOW;
 		goto out;
 	/*
+	 * NFS4ERR_TOOSMALL means the layout for the requested range
+	 * exceeds what the client advertised in loga_maxcount (see
+	 * RFC8881 section 18.43.3).
+	 */
+	case -ETOOSMALL:
+		status = -EMSGSIZE;
+		goto out;
+	/*
 	 * NFS4ERR_LAYOUTTRYLATER is a conflict with another client
 	 * (or clients) writing to the same RAID stripe except when
 	 * the minlength argument is 0 (see RFC5661 section 18.43.3).
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2174,6 +2174,8 @@ lookup_again:
 			break;
 		case -ENODATA:
 			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+		case -EMSGSIZE:
+			/* The layout exceeded loga_maxcount (NFS4ERR_TOOSMALL) */
 			pnfs_layout_set_fail_bit(
 				lo, pnfs_iomode_to_fail_bit(iomode));
 			lseg = NULL;


