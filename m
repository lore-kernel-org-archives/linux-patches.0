Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051825;
	b=lbBNCw914aRTihs3AVBrVmEap8sMFnkI1R/DQ7NpGHZfPmuoo01famKEBf2yludB5gvX
	 D97r7/NxvxWR/qBAEQUbY2aSGpporLPpeYMWm5TbjjouHCvav0kzLpu0EXqfSRf61M7d9
	 ILaUn05/Ij3kHShq8i3qVKxbMSUDUO+WFOuMMf3ZiOMN1F8brAKhi5NEZYA4qRKgAAoQR
	 SmB6nP/4faFJopzAIf/XAXLKSt204d0A8jhOdS+oNsQk9lNh7bDeZl7KDyvUAlVDMX+jS
	 FiILRTPxBUxVjAfOppBCDgPwANdamDRuMSkcpT0Ukeqs86Yj+MMxHtrUnqQnzOwFg/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B1bwe9loOJARhdonZ9q8SIrrs4jxxqMEw0fNe6d45WI=;
	b=ktnIwh0MzgGjq5aynnjPd/52+M4uBf2L0HPC/AvxlVxuXs25VMT3YgYIiy41gFCbS3eO
	 o9hycrdSx7ehejVDdnbzPMUf7ICJVW/61WyNuTeIVA9ykpOBKBcpUSaoCUcsW10j6vzo/
	 3QgEFoo189A+G0sWLpIsGaY5HSDLDT8MEOs29TghGh9IqKx4DUWNDBT06BS4MhN4XbZ2m
	 KuY4Y7mO/5RE9I0FdzyiIkcuCALQN6/jwrqsIVB7IK10MX3FytSmSZCISkIyAS83scowi
	 A9lcQX+zU/wtCXoU+zuCMmMUxWfPof706aAQSwE4WZXfZYnUtFNgLuwQAqzcNOC76FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R374xc+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BA1606A335;
	Thu, 19 Nov 2026 01:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R374xc+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992741F000C4;
	Thu, 19 Nov 2026 01:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051825;
	bh=B1bwe9loOJARhdonZ9q8SIrrs4jxxqMEw0fNe6d45WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R374xc+2NYm0kLTzdLVjsil/1ZnyIy7rcBlbx+JlSdNaXhuW/CSlNT+aEWMm0jese
	 9y0DpHrn0vz48AV+uc4sP6Ud0opSDw7umGeh3KLeAGvV80cTJ9Xx4w1naasxUwnIM1
	 W/oU054I6WkMZGNlRsX1VDM1tZYtm4s64iWpfBOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 5.15 0345/2214] NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET
Date: Wed, 18 Nov 2026 15:33:41 +0100
Message-ID: <20261118150024.514043396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9606,6 +9606,14 @@ nfs4_layoutget_handle_exception(struct r
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
@@ -2168,6 +2168,8 @@ lookup_again:
 			break;
 		case -ENODATA:
 			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+		case -EMSGSIZE:
+			/* The layout exceeded loga_maxcount (NFS4ERR_TOOSMALL) */
 			pnfs_layout_set_fail_bit(
 				lo, pnfs_iomode_to_fail_bit(iomode));
 			lseg = NULL;


