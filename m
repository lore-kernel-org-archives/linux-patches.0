Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035385;
	b=Zxe5vk6qW5/fTBfsuJ9NEvUQl8NNxYiuTFncOdgw5JSd+ZrQN597tJ10rKmhQaJFJ8SK
	 VFS4Nod7EuEaJQa5olNOF5HHl6JvL1CVQxDjO8A1mvKiShDFTGwKsu5akR30CVOdfFESc
	 IZkVcKMWCmk65ZQ0DbZgHAlyCs6VGDcx6Mu59KOtSGLrH5ajc5ucCrayYCvcc66eARdHR
	 GnXvgVYaBNf2Qq4nHFr2+yYOSrROM8wZ0NPfwBwEahbtSsAmy1HWC/RUylk0xayNBn1Jl
	 yh0Slb/JrmjE6oPXW2Umo5qXRSVuJVltJkhc1IE+fg89sfzbT+Q5HUDQhgJ26FS38nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FgaMwjYStLQ4ITqHZbMLCMpzT1qkhntNmrwjVgnaOzo=;
	b=hWQ1Mr6A90eXespBoV8qci7RQdFT4YVdBec9qLQYwAs0Ds9wIMvO9pCEBuo/SrRcUHsM
	 3gRI6FdPDlTJHEAmcWUhX3nQlzhOsD6H/W0i2yTMDX8y2H9Do5yoVBPRwERIWfKMoI9CI
	 3k6Eioe9iAALZRSde0P8t/QV2kihCngI8eWbEIkdgkQT+4qJK/ArC5BgGWGkD7YPZvxYu
	 EIeQoC+pYDuQosVzZg3yDTsDTEeZsFfZa2gl3XpP84Nv4NvAaOO0twQ9wggKy4vzPetjd
	 Sp6p/zOJaDZ1i4uPZUCi0aUH5F887cIMX85B1DOBnTOIeEHRCWsh3ScbCcyOPB6MLpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OInBvYp3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A7606A332;
	Wed, 18 Nov 2026 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OInBvYp3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480731F000C5;
	Wed, 18 Nov 2026 20:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035384;
	bh=FgaMwjYStLQ4ITqHZbMLCMpzT1qkhntNmrwjVgnaOzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OInBvYp3Y91ECOs1BrxSo+ZB1gsLMEN8x73j/6006Ur7B9Zmy7Xb/giY2Wsp4O//G
	 BLbvDz1V+m/iPgly0085yXWvxh33swH3frQNtLhW6+wphndAody5wuftfoEEbmbac1
	 GXHdx1pofQTFPDq30oq5equf8m8l3cEaLhY448vQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.6 0683/3318] NFSv4.1/pnfs: suspend pNFS on NFS4ERR_TOOSMALL from LAYOUTGET
Date: Wed, 18 Nov 2026 15:21:45 +0100
Message-ID: <20261118150338.695940965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9706,6 +9706,14 @@ nfs4_layoutget_handle_exception(struct r
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
@@ -2195,6 +2195,8 @@ lookup_again:
 			break;
 		case -ENODATA:
 			/* The server returned NFS4ERR_LAYOUTUNAVAILABLE */
+		case -EMSGSIZE:
+			/* The layout exceeded loga_maxcount (NFS4ERR_TOOSMALL) */
 			pnfs_layout_set_fail_bit(
 				lo, pnfs_iomode_to_fail_bit(iomode));
 			lseg = NULL;


