Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061708;
	b=4tTE4EVWLOl6F5JOw8MbEo0oaKyvqoDGqZ0G32GvzTF1zyqw6I/zNW0Kxhw0f04HGwWo
	 4xzwH4ynFUgI5KxaoLC7+3AJXOm6AcAlpRD/BRpTg8jDVFb6RuI6AQAsseV+uljadYPDj
	 wCVDTQdGSY58kUjFCTfpztFtebNVR7C0IyQRT50diwjpp5VC89T5/1uoqx7fdHYupD17f
	 voko2So3niV3eDEwuRqMQKmMKndO9rqWbc0XO38GZMzsaGHZe+0BwKq04W9K6hhQ3aQQZ
	 2zdiKDpaD7lD46xsJ9LPiiRwXWmmiBCWvgLuMFaO2lYdkK1+dckXy9ubJAq2nVE7pPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8C6LOMViokqqxkbf6k48jfZd6tsYQwcv2rYb4u2sPQg=;
	b=0vzD4vDCatn7NftH5vkyD31gxPswzGuYu5G5GJZaaNqrYW4dptqz2TBnrsGxbaK1ZE9X
	 5zNetZGXaMjrFbvSw9CcKO8B8LK9ueaaGQUQgpqZfFA1CnQ3fqp7sIOUW9T53P99DtuG/
	 zPiXeHYcmVf8kGw7gNn2/j1ZvGhmyn+e9cvFdqpgcg+A0qBEu6pITE7BcDbk+ZS41I6Fu
	 SAsngMgvJdN+zmEZ0oOUTFRPe8xN7o22gPmzsYCHVhTgvDYZudX7aFM4hrBJcv85DI29T
	 HQO0JaJRkXLznYbcOAhV+fKjuUtt8NF8GRIPPaic6IXvML08zepFLuMe35KAIoo1Log==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL6KtkFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADB1606A32C;
	Sat,  7 Nov 2026 14:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL6KtkFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A449F1F0089F;
	Sat,  7 Nov 2026 14:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061707;
	bh=8C6LOMViokqqxkbf6k48jfZd6tsYQwcv2rYb4u2sPQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KL6KtkFlnu1XJxOJ+aLb/wNeFacDQVRYulPHe6TOIMjnLpWy0ZruJM1MjWX/+3Kas
	 L5/qKY8Cfu4MQqd3/oNZQBmjn+Ev5kpoRG2mVfaRPC0c8rwIN/d6lwhdj7SBpj7YWG
	 dJ4iAVCZswWNV2a75lEztQp3ufz4CsraQAdqMf20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.12 0756/1536] NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET
Date: Sat,  7 Nov 2026 08:46:12 -0500
Message-ID: <20261107135018.766666579@linuxfoundation.org>
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
@@ -9888,6 +9888,14 @@ nfs4_layoutget_handle_exception(struct r
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
@@ -2319,6 +2319,8 @@ lookup_again:
 			break;
 		case -ENODATA:
 			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+		case -EMSGSIZE:
+			/* The layout exceeded loga_maxcount (NFS4ERR_TOOSMALL) */
 			pnfs_layout_set_fail_bit(
 				lo, pnfs_iomode_to_fail_bit(iomode));
 			lseg = NULL;


